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
