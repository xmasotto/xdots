(defun switch-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(global-set-key (kbd "M-`") 'switch-scratch)
(setq initial-scratch-message "")
(setq initial-major-mode 'text-mode)
