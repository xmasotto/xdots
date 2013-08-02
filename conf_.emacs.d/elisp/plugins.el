; C++ Mode
(add-to-list 'auto-mode-alist '("\\.cu" . c++-mode)) ; Cuda C files
(add-to-list 'auto-mode-alist '("\\.h" . c++-mode)) ; C++ header files
(setq c-default-style "linux"
      c-basic-offset 4)

; Dired Mode
(setq dired-listing-switches "-alh")

; Go Mode
(load "go-mode.el")

; Haskell Mode
(load-library "haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
; Uncomment the preferred haskell indent mode
;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

; Latex Mode
(add-to-list 'load-path "~/.emacs.d/lib/auctex")
(add-to-list 'load-path "~/.emacs.d/lib/auctex/preview")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
;(setq TeX-auto-save t)
;(setq TeX-parse-self t)
;(setq TeX-save-query nil)

; Octave Mode
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

; PHP Mode
(load-library "php-mode")

; R Mode
(load "ess/lisp/ess-site")

; Scala Mode
(add-to-list 'load-path "~/.emacs.d/lib/scala-mode")
(require 'scala-mode)

; Top Mode
(require 'top-mode)

; Tramp
(add-to-list 'load-path "~/.emacs.d/lib/tramp")
(require 'tramp)

; Winner Mode
; undo window configuration changes.
(winner-mode 1)
(global-set-key (kbd "<C-M-left>") 'winner-undo)
(global-set-key (kbd "<C-M-right>") 'winner-redo)
