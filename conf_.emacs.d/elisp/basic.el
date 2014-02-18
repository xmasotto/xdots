; Syncs the clipboard and the emacs kill-ring
(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-y" 'clipboard-yank)

; Window sizing
(defun set-window-width (width)
  (if (< (window-width) width)
      (enlarge-window-horizontally (- width (window-width))))
  (if (> (window-width) width)
      (shrink-window-horizontally (- (window-width) width))))
(defun toggle-window-width ()
  (interactive)
  (cond
   ((= (window-width) 81) (set-window-width 101))
   ((= (window-width) 101) (set-window-width 121))
   (t (set-window-width 81))))
(global-set-key (kbd "M--") 'toggle-window-width)
(global-set-key (kbd "M-0") 'balance-windows)
(global-set-key (kbd "C-M--") 'toggle-window-width)
(global-set-key (kbd "C-M-0") 'balance-windows)

; Automatically set certain bookmarks
(defun auto-set-bookmark (name filename)
  (let ((buffer (find-file filename)))
	(with-current-buffer buffer (bookmark-set name))
	(kill-buffer buffer)))
(auto-set-bookmark "_bashrc.d" "~/.bashrc.d")
(auto-set-bookmark "_elisp" "~/.emacs.d/elisp")
(auto-set-bookmark "_scripts" "~/.scripts")
(auto-set-bookmark "_xmonad" "~/.xmonad")
(auto-set-bookmark "_latex" "~/texmf/tex/latex")
(auto-set-bookmark "_snippets" "~/snippets")
(bookmark-save)
