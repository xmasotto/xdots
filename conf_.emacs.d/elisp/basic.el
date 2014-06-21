; Syncs the clipboard and the emacs kill-ring
(global-set-key "\C-w" 'custom-kill-region)
(global-set-key "\M-w" 'custom-kill-ring-save)
(global-set-key "\C-y" 'clipboard-yank)
 
(defun custom-kill-region ()
  (interactive)
  (let ((start (region-beginning))
	(end (region-end)))
    (shell-command-on-region start end "pbcopy")
    (clipboard-kill-region start end)
    (message "cut selection!")))
 
(defun custom-kill-ring-save ()
  (interactive)
  (let ((start (region-beginning))
	(end (region-end)))
    (shell-command-on-region start end "pbcopy")
    (clipboard-kill-ring-save start end)
    (message "copied selection!")))

; Alternate between beginning of line and text
(defun smart-move-beginning-of-line ()
  (interactive)
  (let ((pt (point)))
    (beginning-of-line)
    (when (eq pt (point))
      (beginning-of-line-text))))
(global-set-key "\C-a" 'smart-move-beginning-of-line)

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

; code browsing
(global-set-key (kbd "C-M-J") 
		(lambda () (interactive) (next-line 8) (recenter)))
(global-set-key (kbd "C-M-K") 
		(lambda () (interactive) (previous-line 8) (recenter)))

		
