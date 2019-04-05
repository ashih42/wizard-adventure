;;;; MAIN for WIZARD ADVENTURE

(load "wizard-adventure.lisp")
(load "game-repl.lisp")
(load "wizard-dsl.lisp")

;;; Compile with SBCL
;;; sbcl --script main.lisp
(sb-ext:save-lisp-and-die "wizard-adventure"
    :toplevel #'game-repl
    :executable t)
