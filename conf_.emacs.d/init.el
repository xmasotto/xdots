; Emacs load path
(add-to-list 'load-path "~/.emacs.d/lib")
(add-to-list 'load-path "~/.emacs.d/elisp")

; ElScreen (Must be loaded early to work)
(add-to-list 'load-path "~/.emacs.d/lib/elscreen")
(load "elscreen")
(elscreen-start)
(elscreen-toggle-display-tab)

; Run every .el file in the elisp directory
(setq elisp-files (directory-files "~/.emacs.d/elisp"))
(while elisp-files
  (setq f (car elisp-files))
  (when (string-match "\\.el$" f) (load f))
  (setq elisp-files (cdr elisp-files)))

; Accept incoming emacsclients
(server-start)

; Hide away backup and autosave files
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
(make-directory "~/.emacs.d/autosaves" t)
