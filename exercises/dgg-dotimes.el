(defun dgg-vector (N)
  "This function creates a list and 
loads it up. 
N is a number which is a constructor."
  (interactive)
  (let ((res ()))
    (dotimes (i N)
      (setq res (cons '-1 res)))
    res))


(message "%d" (length (dgg-vector 19)))
