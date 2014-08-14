;; Add additional package repositories
(require 'package)
(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Accept incoming emacsclients
(setq server-socket-dir (format "/tmp/emacs%d" (user-uid)))
(server-start)

; Cygwin
(when (string= system-type "windows-nt")
  (add-hook
   'find-file-hook
   (lambda ()
     (interactive)
     (set-buffer-file-coding-system 'iso-latin-1-unix t)))
  (load "~/.emacs.d/lib/cygwin-mount")
  (setq explicit-shell-file-name "C:/cygwin/Cygwin.bat")
  (setq shell-file-name explicit-shell-file-name)
  (add-to-list 'exec-path "C:/cygwin/bin"))

; Initialize Cask
(require 'cask)
(cask-initialize)
(require 'pallet)

; Run every .el file in the elisp directory
(add-to-list 'load-path "~/.emacs.d/lib")
(mapc
 (lambda (f) (delete-other-windows) (load-file f))
 (directory-files "~/.emacs.d/elisp" t "\\.el$"))

; Hide away backup and autosave files
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
(make-directory "~/.emacs.d/autosaves" t)
