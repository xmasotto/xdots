; Resolve merge conflicts with emerge.
; When editing a merge conflict file, just type M-x resolve.

(defun resolve ()
  (interactive)
  (if buffer-file-name
      (let ((yours (filename-between buffer-file-name "#yours#"))
	    (theirs (filename-between buffer-file-name "#theirs#")))

	(shell-command (format "conflict_split_files create %s"
			       buffer-file-name))
	(window-configuration-to-register 10 nil)
	(setq resolve-original-buffer (current-buffer))
	(sit-for 1)

	(if (file-exists-p yours)
	    (emerge-files nil yours theirs nil nil 'resolve-cleanup)
	  (message "Couldn't Merge")))
    (message "Buffer does not contain file")))

(defun filename-between (filename text)
     (let ((file-base (file-name-sans-extension filename))
           (file-extension (file-name-extension filename)))
       (concat file-base text
               (if file-extension "." "") file-extension)))

(defun resolve-cleanup ()
  (copy-to-buffer resolve-original-buffer (point-min) (point-max))
  (delete-other-windows)
  (kill-buffer (buffer-name)) ; merged buffer
  (kill-buffer (buffer-name)) ; theirs buffer
  (kill-buffer (buffer-name)) ; yours buffer
  (shell-command (format "conflict_split_files delete %s"
                         buffer-file-name))
  (jump-to-register 10 nil))
