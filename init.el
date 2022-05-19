; Install msys64 and install aspell tools inside
; Steps of installation: https://www.msys2.org/
(setq-default ispell-program-name "C:/msys64/mingw64/bin/aspell.exe")
(tool-bar-mode -1)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/expand-region")

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

(require 'expand-region)
(global-set-key (kbd "<f7>") 'er/expand-region)

;; https://pragmaticemacs.wordpress.com/2015/05/11/move-to-startend-of-line-or-sentence/
(setq sentence-end-double-space nil)

;; keybindings
(define-key xah-fly-command-map (kbd "<kp-8>") 'org-previous-item)
(define-key xah-fly-command-map (kbd "<kp-5>") 'org-next-item)
(define-key xah-fly-command-map (kbd "<kp-7>") 'org-previous-visible-heading)
(define-key xah-fly-command-map (kbd "<kp-4>") 'org-next-visible-heading)
(define-key xah-fly-insert-map (kbd "\\") 'xah-fly-command-mode-activate)
(define-key xah-fly-command-map (kbd "z") 'make-frame-command)
(define-key xah-fly-command-map (kbd "<kp-0>") 'delete-frame)
(global-set-key (kbd "<f8>") 'flyspell-correct-word-before-point)
(define-key xah-fly-command-map (kbd "<kp-3>") 'xah-pop-local-mark-ring)

(define-key key-translation-map (kbd "<apps>") (kbd "<menu>"))
(define-key xah-fly-command-map (kbd "<menu>") 'org-edit-src-exit)

(define-key xah-fly-command-map (kbd "<kp-1>") 'xah-new-empty-buffer)
(define-key xah-fly-command-map (kbd "<kp-2>") 'xah-cycle-hyphen-lowline-space)

(define-key xah-fly-command-map (kbd "<kp-9>") 'org-backward-heading-same-level)
(define-key xah-fly-command-map (kbd "<kp-6>") 'org-forward-heading-same-level)

(define-key org-mode-map (kbd "<f2>") 'org-export-dispatch)

(global-set-key (kbd "<f5>") 'backward-sentence)
(global-set-key (kbd "<f6>") 'forward-sentence)

(define-key global-map (kbd "M-'") 'xah-comment-dwim)

;; (define-key c++-mode-map (kbd "<down>") 'c-end-of-defun)
;; (define-key c++-mode-map (kbd "<up>") 'c-beginning-of-defun)

(define-key global-map (kbd "<down>") 'end-of-defun)
(define-key global-map (kbd "<up>") 'beginning-of-defun)
(global-set-key (kbd "<insert>") 'keyboard-quit)

(setq visible-bell 1)

;; (define-key xah-fly-command-map (kbd "<f8>") 'backward-sentence)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(blink-cursor-mode nil)
 '(custom-enabled-themes '(leuven))
 '(tool-bar-mode nil)
 '(visible-cursor nil)
 '(xah-fly-keys t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
(put 'narrow-to-region 'disabled nil
)
