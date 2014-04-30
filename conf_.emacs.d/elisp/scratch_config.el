(defun switch-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(global-set-key (kbd "C-`") 'switch-scratch)
(setq initial-scratch-message "")
(setq initial-major-mode 'text-mode)
