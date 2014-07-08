;; Automatically delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Link kill buffer and osx clipboard
(require 'pbcopy)
(turn-on-pbcopy)

;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Alternate between beginning of line and text
(defun smart-move-beginning-of-line ()
  (interactive)
  (let ((pt (point)))
    (beginning-of-line)
    (when (eq pt (point))
      (beginning-of-line-text))))
(global-set-key "\C-a" 'smart-move-beginning-of-line)

;; Appearance
(add-hook 'find-file-hook 'linum-mode)
(load "modeline")
(global-hl-line-mode)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode -1)

;; Themes
;(load-theme 'darkburn t)
;;(load-theme 'cyberpunk t)
;;(load-theme 'ample t)
;;(load-theme 'django t)
(load-theme 'afternoon t)
