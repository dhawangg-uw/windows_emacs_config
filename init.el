; Install msys64 and install aspell tools inside
; https://www.msys2.org/
(setq-default ispell-program-name "C:/msys64/mingw64/bin/aspell.exe")
(tool-bar-mode -1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

(require 'which-key)
(which-key-mode 1)

(require 'xah-elisp-mode)

(require 'xah-fly-keys)
(xah-fly-keys-set-layout "qwerty") ; required
(xah-fly-keys 1)

(require 'recentf)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 15)
(recentf-mode)

;; keybindings
(define-key xah-fly-command-map (kbd "<kp-8>") 'org-previous-item)
(define-key xah-fly-command-map (kbd "<kp-5>") 'org-next-item)
(define-key xah-fly-command-map (kbd "<kp-7>") 'org-previous-visible-heading)
(define-key xah-fly-command-map (kbd "<kp-4>") 'org-next-visible-heading)
(define-key xah-fly-insert-map (kbd "\\") 'xah-fly-command-mode-activate)
(define-key xah-fly-command-map (kbd "z") 'make-frame-command)
(define-key xah-fly-command-map (kbd "<kp-2>") 'delete-frame)

(define-key key-translation-map (kbd "<apps>") (kbd "<menu>"))
(define-key xah-fly-command-map (kbd "<menu>") 'org-edit-src-exit)
(define-key xah-fly-command-map (kbd "<kp-1>") 'xah-new-empty-buffer)

(define-key xah-fly-command-map (kbd "<kp-9>") 'org-backward-heading-same-level)
(define-key xah-fly-command-map (kbd "<kp-6>") 'org-forward-heading-same-level)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(blink-cursor-mode nil)
 '(custom-enabled-themes '(wombat))
 '(visible-cursor nil)
 '(xah-fly-keys nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
