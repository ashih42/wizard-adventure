;;;; Land of Lisp, Chapter 06
;;;; GAME REPL for WIZARD ADVENTURE

(defparameter *allowed-commands* '(look walk pickup inventory))

(defun game-repl ()
    (let ((cmd (game-read)))
        (unless (eq (car cmd) 'quit)
            (game-print (game-eval cmd))
            (game-repl))))

(defun game-read ()
    (terpri)
    (princ "Enter command ")
    (princ *allowed-commands*)
    (princ ": ")
    (finish-output)
    (let ((cmd (read-from-string
                    (concatenate 'string "(" (read-line) ")"))))
        (flet ((quote-it (x)
                        (list 'quote x)))
            (cons (car cmd) (mapcar #'quote-it (cdr cmd))))))

(defun game-eval (sexp)
    (if (member (car sexp) *allowed-commands*)
        (eval sexp)
        '(I do not know that command.)))

;; Set each character to upper-case, lower-case, or unchanged
(defun tweak-text (lst caps lit)
    (when lst
    (let ((item (car lst))
          (rest (cdr lst)))
    (cond ((eql item #\space) (cons item (tweak-text rest caps lit)))
          ((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))
          ((eql item #\") (tweak-text rest caps (not lit)))
          (lit (cons item (tweak-text rest nil lit)))
          (caps (cons (char-upcase item) (tweak-text rest nil lit)))
          (t (cons (char-downcase item) (tweak-text rest nil nil)))))))

(defun game-print (lst)
    (princ (coerce (tweak-text (coerce (string-trim "() "
                                                    (prin1-to-string lst))
                                        'list)
                                t
                                nil)
                    'string))
    (fresh-line))
