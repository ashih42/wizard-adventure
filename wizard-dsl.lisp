;;;; Land of Lisp, Chapter 17
;;;; DOMAIN-SPECIFIC LANGUAGE for WIZARD ADVENTURE

(defun have (object)
    (member object (cdr (inventory))))

(defmacro game-action (command subj obj place &body body)
    `(progn (defun ,command (subject object)
                (if (and (eq *location* ',place)
                         (eq subject ',subj)
                         (eq object ',obj)
                         (have ',subj))
                    ,@body
                    '(i cant ,command like that.)))
            (pushnew ',command *allowed-commands*)))

;;; WELD

(defparameter *chain-welded* nil)

(game-action weld chain bucket attic
    (cond ((not (have 'bucket)) '(you do not have a bucket.))
          (*chain-welded* '(you have already welded the chain to the bucket.))
          (t (progn (setf *chain-welded* t)
                    '(the chain is now securely welded to the bucket.)))))

;;; DUNK

(defparameter *bucket-filled* nil)

(game-action dunk bucket well garden
    (if *chain-welded*
        (progn (setf *bucket-filled* t)
               '(the bucket is now full of water.))
        '(the water level is too low to reach.)))

;;; SPLASH

(game-action splash bucket wizard living-room
    (cond ((not *bucket-filled*) '(the bucket has nothing in it.))
          ((have 'frog) '(the wizard awakens and sees that you stole his frog.
                          he is so upset he banishes you to the
                          netherworlds- you lose! the end.))
          (t '(the wizard awakens from his slumber and greets you warmly.
               he hands you the magic low-carb donut- you win! the end.))))
