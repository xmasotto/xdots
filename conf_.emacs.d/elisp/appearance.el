;; Kickass Mode Line
(load-library "modeline")            
				
;; Get rid of shitty UI
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode -1)

;; When an emacs client is started, bump to the home screen
;; instead of the scratch buffer.
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

;; Called when emacs starts up. 
;; Use to modify the background and cursor colors.
(defun init-emacs-client-appearance ()
  (set-face-attribute 'default nil
		      :foreground "white"
		      :background "black")
  (set-cursor-color "white"))
