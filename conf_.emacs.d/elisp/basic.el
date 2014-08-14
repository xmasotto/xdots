;; Automatically delete trailing whitespace and tabs
(add-hook
 'before-save-hook
 (lambda ()
   (delete-trailing-whitespace)))

(setq-default tab-width 4)

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

;; Line Numbering
(defvar linum-modes nil)
(add-hook 'find-file-hook 'linum-mode)
(add-hook
 'after-change-major-mode-hook
 (lambda ()
   (when (or buffer-file-name
             (-contains? linum-modes major-mode))
     (linum-mode))))

;; Modes that should have line numbers
(add-to-list 'linum-modes 'dired-mode)
(add-to-list 'linum-modes 'Man-mode)
(add-to-list 'linum-modes 'shell-mode)

;; Appearance
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
;;(load-theme 'solarized-dark t)
(load-theme 'afternoon t)

;; Helm
(helm-mode 1)
(global-set-key (kbd "M-SPC") 'helm-mini)

;; Disable Pop-ups
(defadvice yes-or-no-p (around prevent-dialog activate)
  "Prevent yes-or-no-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))
(defadvice y-or-n-p (around prevent-dialog-yorn activate)
  "Prevent y-or-n-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))
