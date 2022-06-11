(provide 'dgg-xah-toggle-letter-case)

(defun trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10).

URL `http://xahlee.info/emacs/emacs/modernization_elisp_lib_problem.html'
"
(replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string)))

(defun dgg-add-possessive-append ($p1 $p2 &optional $suffix)
  "DOCSTRING"
  (interactive "r")
  (unless $suffix (setq $suffix "'s"))

  (let (($my-str (trim-string  (buffer-substring $p1 $p2))))
    (save-restriction
      (narrow-to-region $p1 $p2)
      (goto-char (point-min))
      (while (search-forward $my-str nil t)
	(replace-match (concat $my-str  $suffix) )))))

(defun dgg-xah-toggle-letter-case ()
  "Toggle the letter case of current word or selection.
Always cycle in this order: Init Caps, ALL CAPS, all lower.

URL `http://xahlee.info/emacs/emacs/modernization_upcase-word.html'
Version: 2020-06-26"
  (interactive)
  (let ( (deactivate-mark nil) $p1 $p2)
    (if (region-active-p)
        (setq $p1 (region-beginning) $p2 (region-end))
      (save-excursion
        (skip-chars-backward "[:alpha:]")
        (setq $p1 (point))
        (skip-chars-forward "[:alpha:]")
        (setq $p2 (point))))
    (when (not (eq last-command this-command))
      (put this-command 'state 0))
    (cond
     ((equal 0 (get this-command 'state))
      (when (eq last-command this-command)
	(delete-char -2)
	(setq $p1 (mark))
	(setq $p2 (point)))
      (dgg-add-possessive-append $p1 $p2 "s")
      (put this-command 'state 1))
     ((equal 1 (get this-command 'state))
      (delete-char -1)
      (setq $p1 (mark))
      (setq $p2 (point))
      (dgg-add-possessive-append $p1 $p2 "ing")
      (put this-command 'state 2))
     ((equal 2 (get this-command 'state))
      (delete-char -3)
      (setq $p1 (mark))
      (setq $p2 (point))      
      (dgg-add-possessive-append $p1 $p2 "ed")
      (put this-command 'state 3))
     ((equal 3 (get this-command 'state))
      (delete-char -2)
      (setq $p1 (mark))
      (setq $p2 (point))
      (dgg-add-possessive-append $p1 $p2 "'s")
      (put this-command 'state 0)))))


(define-key xah-fly-command-map (kbd "o") 'dgg-xah-toggle-letter-case)


