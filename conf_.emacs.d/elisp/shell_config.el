; Setup DirTrack n- to make sure emacs knows the working directory of
; each shell, regardless of how many are simultaneously open.
(require 'dirtrack)
(add-hook 'shell-mode-hook
          (lambda ()
            (dirtrack-mode 1)
            (setq dirtrack-list '("^|PROMPT|\\([^|]*\\)|" 1 nil))
            (add-hook 'comint-preoutput-filter-functions
                      'dirtrack-filter-out-pwd-prompt t t)))
(defun dirtrack-filter-out-pwd-prompt (string)
  (if (and (stringp string) (string-match (first dirtrack-list) string))
      (replace-match "" t t string 0)
    string))

; Extended Bash Completion
(add-to-list 'load-path "~/.emacs.d/lib/bash-completion")
(require 'bash-completion)
(bash-completion-setup)

; Delete the Bash Completion window when a command is entered.
; If a new window was created, delete the window.
(setq completion-buffer-names
      '("*Completions*" "*IPython Completions*"))
(defun completion-buffer-setup ()
  (when (member (buffer-name) completion-buffer-names)
    ;; This is a completion buffer.
    ;; Keep track of the number of window before
    ;; the temporary completion buffer is shown.
    (setq completion-setup-num-windows
	  (length (window-list)))

    ;; Whether a completion buffer is being reused.
    (setq completion-same nil)
    (dolist (win (window-list))
      (when (string= (buffer-name) (buffer-name (window-buffer win)))
	(setq completion-same t)))))
(defun completion-buffer-show ()
  (setq completion-setup-window (buffer-name))
  ;; 'completion-window-created is true if the completion buffer
  ;; replaced an old buffer or created a new window.
  ;; leave the value the same if it was a repeated command
  (when (not completion-same)
    (setq completion-window-created
	  (> (length (window-list)) completion-setup-num-windows))))
(defun delete-completion-window-buffer (&optional output)
  (interactive)
  (dolist (win (window-list))
    (let ((name (buffer-name (window-buffer win))))
      (when (and (member name completion-buffer-names)
		 (string= name completion-setup-window))
	(kill-buffer name)
	(if completion-window-created
	    (delete-window win)))))
  output)
(add-hook 'temp-buffer-setup-hook 'completion-buffer-setup)
(add-hook 'temp-buffer-show-hook 'completion-buffer-show)
(add-hook 'comint-input-filter-functions 'delete-completion-window-buffer)

; View the command output in a compilation-mode buffer
(defun view-compile-out ()
  (interactive)
  (let ((original-point (point))
        (buffer-name (format "*%s-shell-compilation*" (buffer-name))))
    (comint-previous-prompt 1)
    (let ((begin (point)))
      (comint-next-prompt 1)
      (previous-line)
      (move-end-of-line 1)
      (if (get-buffer buffer-name)
          (kill-buffer buffer-name))
      (copy-to-buffer buffer-name begin (point)))
    (goto-char original-point)
    (switch-to-buffer buffer-name)
    (compilation-mode)))
(global-set-key (kbd "C-c v") 'view-compile-out)
(global-set-key (kbd "C-c C-v") 'view-compile-out)

; Select the previous command's output.
(defun mark-previous-command-out ()
    (comint-previous-prompt 1)
    (move-end-of-line 1)
    (forward-char)
    (set-mark (point))
    (comint-next-prompt 1)
    (previous-line)
    (move-end-of-line 1)
    (forward-char))

; Copy the previous command output to the kill ring.
(defun save-command-out-to-kill-ring ()
  (interactive)
  (let ((original-point (point)))
    (mark-previous-command-out)
    (sit-for 0.1)
    (call-interactively 'custom-kill-ring-save)
    (goto-char original-point)))
(global-set-key (kbd "C-c M-w") 'save-command-out-to-kill-ring)

; Run a unix command on the command output
(defun run-command-on-out ()
  (interactive)
  (let ((original-point (point)))
    (mark-previous-command-out)
    (setq current-prefix-arg '(4))
    (call-interactively 'shell-command-on-region)
    (goto-char original-point)))
(global-set-key (kbd "C-c |") 'run-command-on-out)

(defmacro make-command-on-out (command-prompt command-func)
  (list 'lambda '(command) (list 'interactive (concat "s" command-prompt))
	(list 'let '((original-point (point)))
	      '(when (not mark-active) (mark-previous-command-out))
	      (list 'shell-command-on-region '(mark) '(point)
		    (list 'funcall command-func 'command) nil t)
	      '(setq mark-active nil)
	      '(goto-char original-point))))

(defmacro get-command-auto-quote (command-name)
  (list 'lambda '(args)
	(list 'if '(string-match-p (regexp-quote "'") args)
	      (list 'concat command-name " " 'args)
	      (list 'concat command-name " '" 'args "'"))))
  
(global-set-key (kbd "C-c A") 
		(make-command-on-out "awk " (get-command-auto-quote "awk")))
(global-set-key (kbd "C-c S")
		(make-command-on-out "sed " (get-command-auto-quote "sed")))
(global-set-key (kbd "C-c G")
		(make-command-on-out "grep " (get-command-auto-quote "grep")))

; Returns a string of all the emacs command history.
(defun minibuffer-shell-history ()
  (interactive)
  (setq result nil)
  (dolist (command (reverse shell-command-history))
    (when command
      (if result
	  (setq result (concat result "\n" command))
	(setq result command))))
  result)

; Clears the shell log
(defun clear-shell ()
  (interactive)
  (erase-buffer)
  (comint-send-input)
  (beginning-of-buffer)
  (kill-line)
  (end-of-buffer))
(global-set-key (kbd "M-l") 'clear-shell)

(defun change-shell (name)
  (let ((buf (get-buffer name)))
    (if buf (switch-to-buffer buf) (shell name))
    (if (not (get-buffer-process (current-buffer)))
	(shell name))))

(defun dired-change-shell (shellname)
  (let ((dirname 
	 (cond 
	  (dired-directory dired-directory)
	  (buffer-file-name 
	   (file-name-directory (buffer-file-name)))
	  (t nil))))
    (when dirname
      (change-shell shellname)
      (end-of-buffer)
      (comint-previous-prompt 1)
      (comint-next-prompt 1)
      (move-beginning-of-line 1)
      ;; Check to see if the shell is prompting the user.
      (when (eq (char-after (- (point) 2)) ?$)
	(kill-line 0)
	(insert "cd " dirname)
	(comint-send-input)))))

; Define M-n from n = 1 to 9 to spawn/switch to a corresponding shell.
; Define C-c M-n spawn/switch to a shell in the same directory.
(defmacro bind-shell (num)
  (list 'progn
	(list 'global-set-key
	      (list 'kbd (format "M-%d" num))
	      (list 'lambda () '(interactive)
		    (list 'change-shell (format "t%d" num))))
	(list 'global-set-key
	      (list 'kbd (format "C-c M-%d" num))
	      (list 'lambda () '(interactive)
		    (list 'dired-change-shell (format "t%d" num))))))

(bind-shell 1)
(bind-shell 2)
(bind-shell 3)
(bind-shell 4)
(bind-shell 5)
(bind-shell 6)
(bind-shell 7)
(bind-shell 8)
(bind-shell 9)

; Create an interactive function t1, t2, ... t9 to spawn/switch to
; a corresponding shell
(defmacro bind-shell-command (tname num)
  (list 'defun tname () '(interactive)
        (list 'change-shell (format "t%d" num))))
(bind-shell-command t1 1)
(bind-shell-command t2 2)
(bind-shell-command t3 3)
(bind-shell-command t4 4)
(bind-shell-command t5 5)
(bind-shell-command t6 6)
(bind-shell-command t7 7)
(bind-shell-command t8 8)
(bind-shell-command t9 9)

; Automatically start shells for convenience
(defun setup-shells ()
  (t1) (delete-other-windows)
  (t2) (delete-other-windows)
  (t3) (delete-other-windows)
  (t4) (delete-other-windows)
  (t5) (delete-other-windows)
  (t6) (delete-other-windows)
  (t7) (delete-other-windows)
  (t8) (delete-other-windows)
  (t9) (delete-other-windows)
  (switch-to-buffer "*GNU Emacs*")
  (save-buffers-kill-terminal))
