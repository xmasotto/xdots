(require 's)

(defun jump-bookmark (str)
  (move-end-of-line nil)
  (re-search-forward str)
  (move-beginning-of-line nil))

(defmacro bookmark-bind-shell (num)
  (list 'local-set-key (list 'kbd (format "M-%d" num))
	(list 'lambda '() '(interactive)
	      '(bookmark-bmenu-this-window)
	      (list 'dired-change-shell
		    (format "t%d" num)))))

(add-hook
 'bookmark-bmenu-mode-hook
 (lambda ()
   (local-set-key (kbd "c") (lambda () (interactive) (jump-bookmark "|c|_")))
   (local-set-key (kbd "z") (lambda () (interactive) (jump-bookmark "|z|_")))
   (bookmark-bind-shell 0)
   (bookmark-bind-shell 1)
   (bookmark-bind-shell 2)
   (bookmark-bind-shell 3)
   (bookmark-bind-shell 4)
   (bookmark-bind-shell 5)
   (bookmark-bind-shell 6)
   (bookmark-bind-shell 7)
   (bookmark-bind-shell 8)
   (bookmark-bind-shell 9)))

; Delete all bookmarks with underscores
(bookmark-bmenu-list)
(shell-command-on-region (point-min) (point-max)
			 "awk '/\\|c|z\\|_/{print $1}'" "bookmarks_temp")
(with-current-buffer "bookmarks_temp"
  (unless (s-blank? (buffer-string))
    (mapc 'bookmark-delete (split-string (buffer-string)))))

; Automatically set xdots bookmarks
(defun auto-set-bookmark (name filename)
  (with-current-buffer (find-file filename)
    (bookmark-set name)
    (kill-buffer)))

(auto-set-bookmark "|z|_bashrc.d" "~/.bashrc.d")
(auto-set-bookmark "|z|_elisp" "~/.emacs.d/elisp")
(auto-set-bookmark "|z|_scripts" "~/.scripts")
(auto-set-bookmark "|z|_latex" "~/texmf/tex/latex")

; Automatically set bookmarks to directories within ~/coding
(when (file-exists-p "~/coding")
  (mapc
   (lambda (filename)
     (when (file-accessible-directory-p filename)
       (auto-set-bookmark
	(concat "|c|_" (file-name-nondirectory filename) )
	filename)))
   (directory-files "~/coding" t "^[^.]")))

(bookmark-save)
