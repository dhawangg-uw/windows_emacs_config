(defun _6_function ()
  "DOCSTRING"
  ;; (interactive "*bInsert buffer:")
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (let (($end (min (1- (point-max)) 60)))
	(message "%s"  (buffer-substring-no-properties 1 $end))))))
