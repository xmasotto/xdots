; disable home page
;(when (> (length command-line-args) 1)
;  (setq inhibit-splash-screen t))

; Kickass Mode Line
(load-library "modeline")

; Get rid of shitty UI
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode -1)

(defun init-emacs-client-appearance ()
  (set-cursor-color "#ffffff")
  (set-background-color "#111111"))

;  (when (eq window-system 'x)
;    (invert-face 'default)
;    (set-cursor-color "#ffffff")))

; When an emacs client is started, bump to the home screen
; instead of the scratch buffer.
(defun init-emacs-client ()
  (when (get-buffer "*GNU Emacs*")
    (kill-buffer "*GNU Emacs*"))
  (if (eq window-system 'x)
      (fancy-startup-screen)
    (display-startup-screen))
  (switch-to-buffer
   (get-buffer "*scratch*"))
  (switch-to-buffer
   (get-buffer "*GNU Emacs*"))
  (init-emacs-client-appearance)
  "All your emacs are belong to us.")
