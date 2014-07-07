;; Accept incoming emacsclients
(setq server-socket-dir (format "/tmp/emacs%d" (user-uid)))
(server-start)

; Initialize Cask
(require 'cask)
(cask-initialize)
(require 'pallet)

; Run every .el file in the elisp directory
(add-to-list 'load-path "~/.emacs.d/lib")
(mapc
 (lambda (f) (delete-other-windows) (load-file f))
 (directory-files "~/.emacs.d/elisp" t "\\.el$"))

; Hide away backup and autosave files
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
(make-directory "~/.emacs.d/autosaves" t)

;; When an emacs client is started, bump to the home screen
;; instead of the scratch buffer.
(defun init-emacs-client ()
  (when (get-buffer "*GNU Emacs*")
    (kill-buffer "*GNU Emacs*"))
  (if (eq window-system 'x)
      (fancy-startup-screen)
    (display-startup-screen))
  (switch-to-buffer
   (get-buffer "*scratch*"))
  (switch-to-buffer
   (get-buffer "*GNU Emacs*"))
  "All your emacs are belong to us.")
