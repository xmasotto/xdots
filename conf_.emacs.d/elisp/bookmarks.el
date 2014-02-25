; Get all bookmarks starting with underscores
(bookmark-bmenu-list)
(shell-command-on-region (point-min) (point-max) 
			 "awk '/ _/{print $1}'" "bookmarks_temp")
(setq generated-bookmarks
      (split-string
       (with-current-buffer (get-buffer "bookmarks_temp") (buffer-string))
       "\n"))
(kill-buffer "bookmarks_temp")

; Delete them before we regenerate them
(defun delete-gen-bookmark (bookmark)
  (when (not (string= bookmark ""))
    (bookmark-delete bookmark)))
(mapcar 'delete-gen-bookmark generated-bookmarks)

; Automatically set xdots bookmarks
(defun auto-set-bookmark (name filename)
  (let ((buffer (find-file filename)))
	(with-current-buffer buffer (bookmark-set name))
	(kill-buffer buffer)))
(auto-set-bookmark "__bashrc.d" "~/.bashrc.d")
(auto-set-bookmark "__elisp" "~/.emacs.d/elisp")
(auto-set-bookmark "__scripts" "~/.scripts")
(auto-set-bookmark "__latex" "~/texmf/tex/latex")
(auto-set-bookmark "__snippets" "~/snippets")

; Automatically set bookmarks to directories within ~/coding
(setq coding-files (directory-files "~/coding"))
(while coding-files
  (let ((f (car coding-files)))
    (when (and (not (string= f ".")) (not (string= f ".."))
	     (file-accessible-directory-p (concat "~/coding/" f)))
      (auto-set-bookmark (concat "_" f) (concat "~/coding/" f))))
  (setq coding-files (cdr coding-files)))

(bookmark-save)
