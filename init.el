  ; Install msys64 and install aspell tools inside
  ; Steps of installation: https://www.msys2.org/
(setq-default ispell-program-name "C:/msys64/mingw64/bin/aspell.exe")
(tool-bar-mode -1)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/expand-region")
(add-to-list 'load-path "~/.emacs.d/lisp/xah-get-thing")

(require 'which-key)
(which-key-mode 1)

(require 'xah-elisp-mode)

(require 'xah-get-thing)

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
;; (define-key xah-fly-insert-map (kbd "\\") 'xah-fly-command-mode-activate)
(define-key xah-fly-command-map (kbd "z") 'make-frame-command)
(define-key xah-fly-command-map (kbd "<kp-0>") 'delete-frame)
;; (global-set-key (kbd "<f8>") 'flyspell-correct-word-before-point)
(define-key xah-fly-command-map (kbd "<kp-3>") 'xah-pop-local-mark-ring)

(define-key key-translation-map (kbd "<apps>") (kbd "<menu>"))
(define-key xah-fly-command-map (kbd "<menu>") 'org-edit-src-exit)

(define-key xah-fly-command-map (kbd "<kp-1>") 'xah-new-empty-buffer)
(define-key xah-fly-command-map (kbd "<kp-2>") 'xah-cycle-hyphen-lowline-space)

(define-key xah-fly-command-map (kbd "<kp-9>") 'org-backward-heading-same-level)
(define-key xah-fly-command-map (kbd "<kp-6>") 'org-forward-heading-same-level)

(define-key xah-fly-command-map (kbd "<f10>") 'flyspell-correct-word-before-point)

;; required as org not evaluated immediately
;; https://list.orgmode.org/87zk9aj6y7@ch.ristopher.com/T/
;; https://emacs.stackexchange.com/questions/12487/when should i use with eval after load in my configuration files
(require 'org-install)
(with-eval-after-load 'org
  (defun zp/org-fold (&optional keep-position)
    (let ((indirectp (not (buffer-file-name)))
          (org-startup-folded 'overview))
      ;; Fold drawers
      (org-set-startup-visibility)
      ;; Fold trees
      (org-overview)
      (unless keep-position
	(goto-char (point-min)))
      (recenter)
      (save-excursion
	(goto-char (point-min))
	(org-show-entry)
	(when (org-at-heading-p)
          (org-show-children)))))

  (defun zp/org-narrow-previous-heading (arg)
    "Move to the previously narrowed tree, and narrow the buffer to it."
    (interactive "p")
    (if (bound-and-true-p zp/org-narrow-previous-position)
	(let ((pos-before zp/org-narrow-previous-position))
          (goto-char zp/org-narrow-previous-position)
          (org-reveal)
          (org-cycle)
          (org-narrow-to-subtree)
          (setq zp/org-narrow-previous-position nil)
          (message "Narrowing to previously narrowed tree."))
      (message "Couldn’t find a previous position.")))

  (defun zp/org-narrow-to-subtree ()
    "Move to the next subtree at same level, and narrow the buffer to it."
    (interactive)
    (org-narrow-to-subtree)
    (zp/org-fold nil)
    (when (called-interactively-p 'any)
      (message "Narrowing to tree at point.")
      (run-hooks 'zp/org-after-view-change-hook)))

  (defun zp/org-widen ()
    "Move to the next subtree at same level, and narrow the buffer to it."
    (interactive)
    (let ((pos-before (point)))
      (setq-local zp/org-narrow-previous-position pos-before))
    (widen)
    (when (called-interactively-p 'any)
      (message "Removing narrowing.")
      (run-hooks 'zp/org-after-view-change-hook)))

  (defvar zp/presentation-mode nil)

  (defun zp/org-narrow-forwards ()
    "Move to the next subtree at same level, and narrow the buffer to it."
    (interactive)
    (widen)
    (org-forward-heading-same-level 1)
    (org-narrow-to-subtree)
    (unless zp/presentation-mode
      (zp/org-fold nil))
    (when (called-interactively-p 'any)
      (message "Narrowing to next tree.")
      (run-hooks 'zp/org-after-view-change-hook)))

  (defun zp/org-narrow-backwards ()
    "Move to the next subtree at same level, and narrow the buffer to it."
    (interactive)
    (widen)
    (org-backward-heading-same-level 1)
    (org-narrow-to-subtree)
    (unless zp/presentation-mode
      (zp/org-fold nil))
    (when (called-interactively-p 'any)
      (message "Narrowing to previous tree.")
      (run-hooks 'zp/org-after-view-change-hook)))

  (defun zp/org-narrow-up-heading (&optional arg keep-position)
    "Move to the upper subtree, and narrow the buffer to it."
    (interactive "p")
    (unless (buffer-narrowed-p)
      (user-error "No narrowing"))
    (let ((pos-before (point)))
      (setq-local zp/org-narrow-previous-position pos-before)
      (widen)
      (org-reveal)
      (outline-up-heading 1)
      (org-narrow-to-subtree)
      (when (or (eq arg 4)
		keep-position)
	(goto-char pos-before)
	(recenter-top-bottom))
      (zp/org-fold (or (eq arg 4)
                       keep-position))
      (when arg
	(message "Narrowing to tree above.")
	(run-hooks 'zp/org-after-view-change-hook))))

  (defun zp/org-narrow-up-heading-dwim (arg)
    "Narrow to the upper subtree, and narrow the buffer to it.
If the buffer is already narrowed to level-1 heading, overview
the entire buffer."
    (interactive "p")
    (if (save-excursion
          ;; Narrowed to a level-1 heading?
          (goto-char (point-min))
          (and (buffer-narrowed-p)
               (equal (org-outline-level) 1)))
	(zp/org-overview arg)
      (zp/org-narrow-up-heading arg)))

  (defun zp/org-narrow-previous-heading (arg)
    "Move to the previously narrowed tree, and narrow the buffer to it."
    (interactive "p")
    (if (bound-and-true-p zp/org-narrow-previous-position)
	(let ((pos-before zp/org-narrow-previous-position))
          (goto-char zp/org-narrow-previous-position)
          (org-reveal)
          (org-cycle)
          (org-narrow-to-subtree)
          (setq zp/org-narrow-previous-position nil)
          (message "Narrowing to previously narrowed tree."))
      (message "Couldn’t find a previous position.")))

  ;; Toggle fontifications
  (defun zp/org-toggle-emphasis-markers (&optional arg)
    "Toggle emphasis markers."
    (interactive "p")
    (let ((markers org-hide-emphasis-markers))
      (if markers
          (setq-local org-hide-emphasis-markers nil)
	(setq-local org-hide-emphasis-markers t))
      (when arg
	(font-lock-fontify-buffer))))



  
  (define-key org-mode-map (kbd "<f2>") 'org-export-dispatch)
  (define-key org-mode-map (kbd "<kp-subtract>") 'org-insert-structure-template)
  (define-key org-mode-map (kbd "<f10>") 'org-edit-special)
  (define-key org-mode-map (kbd "<next>") 'org-next-block)
  (define-key org-mode-map (kbd "<prior>") 'org-previous-block)

  (define-key org-mode-map (kbd "<f9>") 'zp/org-narrow-backwards)
  (define-key org-mode-map (kbd "<f8>") 'zp/org-narrow-forwards)
  (define-key org-mode-map (kbd "<f12>") 'zp/org-narrow-up-heading))

(global-set-key (kbd "<f5>") 'backward-sentence)
(global-set-key (kbd "<f6>") 'forward-sentence)

(define-key global-map (kbd "M-'") 'xah-comment-dwim)

(defun dgg-escape-quotes ($var)
  "DOCSTRING"
  (interactive)
  (setq $var (concat "'" (mapconcat 'identity (mapcar 
					       (lambda (x)
						 (if (string-match "\\ " x)
						     (concat "\"" x "\"")
						   x))
					       (split-string test "/")) "/") "'")))

(defun xah-html-open-in-chrome-browser ()
  "Open the current file or `dired' marked files in Google Chrome browser.
Work in Windows, macOS, linux.
URL `http://xahlee.info/emacs/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2019-11-10"
  (interactive)
  (let* (
         ($file-list
          (if (string-equal major-mode "dired-mode")
              (dired-get-marked-files)
            (list (buffer-file-name))))
         ($do-it-p (if (<= (length $file-list) 5)
                       t
                     (y-or-n-p "Open more than 5 files? "))))
    (when $do-it-p
      (cond
       ((string-equal system-type "darwin")
        (mapc
         (lambda ($fpath)
           (shell-command
            (format "open -a /Applications/Google\\ Chrome.app \"%s\"" (dgg-escape-quotes $fpath))))
         $file-list))
       ((string-equal system-type "windows-nt")
        ;; "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 2019-11-09
        (let ((process-connection-type nil))
          (mapc
           (lambda ($fpath)
             (start-process "" nil "powershell" "start-process" "chrome" (dgg-escape-quotes $fpath) ))
           $file-list)))
       ((string-equal system-type "gnu/linux")
        (mapc
         (lambda ($fpath)
           (shell-command (format "google-chrome-stable \"%s\"" $fpath)))
         $file-list))))))



(define-key global-map (kbd "<C-return>") 'xah-html-open-in-chrome-browser)

;; (define-key c++-mode-map (kbd "<down>") 'c-end-of-defun)
;; (define-key c++-mode-map (kbd "<up>") 'c-beginning-of-defun)

(define-key global-map (kbd "<down>") 'end-of-defun)
(define-key global-map (kbd "<up>") 'beginning-of-defun)
(global-set-key (kbd "<insert>") 'keyboard-escape-quit)
;; (global-set-key (kbd "<pause>") 'keyboard-escape-quit)

;; (define-key xah-fly-insert-map (kbd "\\") 'xah-fly-command-mode-activate)
(global-set-key (kbd "\\") 'dabbrev-expand)

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
 '(custom-enabled-themes '(wombat))
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
(put 'erase-buffer 'disabled nil)
