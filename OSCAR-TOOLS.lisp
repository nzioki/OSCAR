;
;;                                                                    *** TOOLS.LISP ***

(in-package "OSCAR")

(proclaim
  '(special pause-flag *metered-calls* *callees* *blank-line* *line-columns* *uncalled-callers*))

(defvar *old-definitions* nil)

;                                                           *MACROS*

(defmacro mem1 (x) `(car ,x))
(defmacro mem2 (x) `(cadr ,x))
(defmacro mem3 (x) `(nth 2 ,x))
(defmacro mem4 (x) `(nth 3 ,x))
(defmacro mem5 (x) `(nth 4 ,x))
(defmacro mem6 (x) `(nth 5 ,x))
(defmacro mem7 (x) `(nth 6 ,x))
(defmacro mem8 (x) `(nth 7 ,x))
(defmacro mem9 (x) `(nth 8 ,x))
(defmacro mem10 (x) `(nth 9 ,x))
(defmacro mem11 (x) `(nth 10 ,x))
(defmacro mem12 (x) `(nth 11 ,x))
(defmacro mem13 (x) `(nth 12 ,x))
(defmacro mem14 (x) `(nth 13 ,x))
(defmacro mem15 (x) `(nth 14 ,x))
(defmacro mem16 (x) `(nth 15 ,x))
(defmacro mem17 (x) `(nth 16 ,x))
(defmacro mem18 (x) `(nth 17 ,x))

;nth element of sequence x:
(defmacro element (n x) `(nth ,n ,x))

(defmacro lastmember (x) `(car (last ,x)))

(defmacro for-all (x f) (list 'mapc f x))

(defmacro do-until (P Q)
   (list 'loop Q (list 'if P '(return))))

;pretty print function definition (takes unquoted argument):
(defmacro pp (f) `(let ((pv *print-level*)
                                    (pl *print-length*))
                              (setq *print-level* nil)
                              (setq *print-length* nil)
                              (pprint (symbol-function ,f))
                              (setq *print-level* pv)
                              (setq *print-length* pl)))

;to test the efficiency of different values of the parameter param in
;the list A.  Takes unquoted arguments for param and prog:
(defmacro parameter-test (A param prog)
   `(progn (o-terpri) (gc)
                (for-all ,A #'(lambda (n)
                                      (setq ,param n)
                                      (o-princ "for ") (o-prin1 ',param)
                                      (o-princ " = ") (o-prin1 n) (o-princ ":")
                                      (time ,prog)
                                      (gc)))))

(defmacro image (K f)
   `(mapcar ,f ,K))

(defmacro unionimage (K f)
   `(genunion (mapcar ,f ,K)))

#| The following is unnecessary, because genunion already deletes duplicates. |#
(defmacro unionimage+ (K f)
   `(remove-duplicates (genunion (mapcar ,f ,K)) :test 'equal))

;This puts something at the front of a queue with index 0:
(defmacro 0-insert (F x A)
   `(setf (,F ,A) (cons 0 (cons (cons 0 ,x) (cadr (,F ,A))))))

(defmacro pull (x s)
   `(setf ,s (remove-if-equal ,x ,s)))

#| This redefines a constant defined by defconstant. |#
(defmacro redefine-constant (x val)
    `(progn
         (makunbound ',x)
         (defconstant ,x ,val)))

(defmacro unionmapcar (f A) `(apply 'append (mapcar, f ,A)))

;This removes duplicates with test eq.
(defmacro unionmapcar+ (f X)
    `(let ((U nil))
       (dolist (y ,X)
           (dolist (z (funcall ,f y))
               (pushnew z U)))
       U))

;This removes duplicates with test equal.
(defmacro unionmapcar= (f X)
    `(let ((U nil))
       (dolist (y ,X)
           (dolist (z (funcall ,f y))
               (pushnew z U :test 'equal)))
       U))

;This removes duplicates with test equal.
(defmacro unionmapcar2= (f X Y)
    `(let ((U nil)
            (X* ,X)
            (Y* ,Y))
       (loop
          (when (null X*) (return U))
          (dolist (z (funcall ,f (mem1 X*) (mem1 Y*)))
              (pushnew z U :test 'equal))
          (setf X* (cdr X*))
          (setf Y* (cdr Y*)))))

(defmacro unionmapcar- (f X &key (test 'eq))
    `(let ((U nil))
       (dolist (y ,X)
           (dolist (z (funcall ,f y))
               (pushnew z U :test ,test)))
       U))

(when (not (boundp '*old-definitions*))
     (proclaim '(special *old-definitions*))
     (setf *old-definitions* nil))

;; This gives a horizontally compact display.
(defmacro stepper (form)
    `(progn
         (setf *print-pretty* nil)
         (setf *print-right-margin* nil)
         (unwind-protect (step ,form)
             (setf *print-right-margin* 250)
             (setf *print-pretty* t))))

#| This defines a function in the ordinary way, but also keeps a record of
its arglist and definition on the property list of the function name.  When
definitions are changed, a record of the changes is kept in *old-definitions*. 
(defmacro defunction (fun arg &rest body)
  `(progn
     (when (and (get (quote ,fun) 'definition)
		(not (equal (get (quote ,fun) 'definition) (quote ,body))))
       (push (cons (quote ,fun)
		   (list (append (list 'defun (quote ,fun) (get (quote ,fun) 'arglist))
				 (get (quote ,fun) 'definition))
			 (multiple-value-list (get-decoded-time))))
	     *old-definitions*))
     (setf (get (quote ,fun) 'arglist) (quote ,arg))
     (setf (get (quote ,fun) 'definition) (quote ,body))
     (defun ,fun ,arg ,@body)))
|#

#| This defines a function in the ordinary way, but also keeps a record of
its arglist and definition on the property list of the function name.  When
definitions are changed, a record of the changes is kept in *old-definitions*.
Definitions created by defunction are saved in the file "Definitions History"
in the OSCAR Folder. The first time a function is defined in a session, the
definition is not saved in "Definitions History".|#
(defmacro defunction (fun arg &rest body)
  `(progn
     (defun ,fun ,arg ,@body)
     (when (and (get (quote ,fun) 'definition)
		(not (equal (get (quote ,fun) 'definition) (quote ,body))))
       (let ((def (append (list 'defun (quote ,fun) (get (quote ,fun) 'arglist))
			  (get (quote ,fun) 'definition))))
	 (push (cons (quote ,fun)
		     (list def (multiple-value-list (get-decoded-time))))
	       *old-definitions*)
	 #+MCL ; enabled for MCL only
	 (with-open-file
	     (stream (make-pathname :name "Definitions History" :type "lisp"
				    :defaults oscar-pathname)
		     :direction :output :if-exists :append)
	   (terpri stream) (princ "==============================================" stream)
	   (terpri stream)
	   (multiple-value-bind
	       (seconds minutes hour day month year)
	       (get-decoded-time)
	     (princ "Definition overwritten " stream) (princ month stream) (princ "/" stream)
	     (princ day stream) (princ "/" stream) (princ year stream)
	     (princ "     " stream) (princ hour stream) (princ ":" stream)
	     (princ minutes stream) (princ ":" stream) (princ seconds stream) (terpri stream))
	   (princ "--------------------------------------------------------------------------------" stream)
	   (terpri stream)
	   (print-pretty def stream) (terpri stream)
	   )))
     (setf (get (quote ,fun) 'arglist) (quote ,arg))
     (setf (get (quote ,fun) 'definition) (quote ,body))
     (quote ,fun)))

#| This returns and displays the definition history of fun. |#
(defun def-history (fun &optional do-not-print)
  (let ((definitions nil))
    (dolist (d *old-definitions*)
      (when (equal (car d) fun) (push (cdr d) definitions)))
    (setf definitions (reverse definitions))
    (when (null do-not-print)
      (princ "-----------------------------------------") (terpri)
      (princ "Definition history for ") (princ fun)
      (princ " (most recent definitions first):") (terpri) (terpri)
      (dolist (d definitions)
	(let ((time (mem2 d)))
	  (cond (time
		 (princ "Definition overwritten at ")
		 (princ (mem5 time)) (princ "/") (princ (mem4 time)) (princ "/")
		 (princ (mem6 time)) (princ "    ") (princ (mem3 time))
		 (princ ":") (if (< (mem2 time) 10) (princ "0")) (princ (mem2 time))
		 (princ ":") (if (< (mem2 time) 10) (princ "0")) (princ (mem1 time))
		 (terpri) (print-pretty (mem1 d)) (terpri) (terpri))
		(t
		 (print-pretty d) (terpri) (terpri)))))
      (terpri))))
      ; definitions))

(defun decode-time (time)
  (multiple-value-bind (second minute hour)
      (decode-universal-time time)
    (list hour minute second)))

(defun print-pretty (x &optional stream)
  (let ((pp *print-pretty*))
    (setf *print-pretty* t)
    (prin1 x stream)
    (setf *print-pretty* pp)))

#| This returns and displays a list of functions whose definitions have changed. |#
(defun changed-defs (&optional do-not-print-changes)
    (let ((changes nil))
       (dolist (d *old-definitions*)
           (pushnew (list (car d) (mem3 d)) changes))
      ; (setf changes (order changes #'lessp))
       (cond ((null do-not-print-changes)
                    (princ "CHANGED DEFINITIONS, MOST RECENT LISTED FIRST:") (terpri)
                    (dolist (c (reverse changes))
                        (let ((time (mem2 c)))
                           (princ (mem1 c))
                           (when time
                                (princ "    Definition overwritten at ")
                                (princ (mem5 time)) (princ "/") (princ (mem4 time)) (princ "/")
                                (princ (mem6 time)) (princ "    ") (princ (mem3 time))
                                (princ ":") (if (< (mem2 time) 10) (princ "0")) (princ (mem2 time))
                                (princ ":") (if (< (mem2 time) 10) (princ "0")) (princ (mem1 time))
                                (terpri)))))
                   (t changes))))

#| This displays the entire history of definition changes during the current session. |#
(defun show-history (&optional fun)
    (let ((changed-defs (if fun (list fun) (changed-defs t))))
       (dolist (c changed-defs)
           (def-history c))
       nil))

(defunction compare-trees (tree1 tree2)
    (cond ((equal tree1 tree2) (princ "The trees are identical.") (terpri))
                (t (princ "The following is the initial part of the trees on which they agree.")
                    (terpri)
                    (prin1 (tree-agreement tree1 tree2)))))

(defunction compare-last-def (fun)
    (let ((def1 (definition fun))
            (def2 (car (e-assoc fun *old-definitions*))))
       (cond ((equal def1 def2)  (princ "The definitions are identical.") (terpri))
                   (t (princ "The following is the initial part of the definitions on which they agree.")
                       (terpri)
                       (prin1 (tree-agreement def1 def2))))))
    
#| This returns the initial agreeing part of two trees that are in partial agreement. |#
(defunction tree-agreement (t1 t2)
    (cond ((symbolp t1) (if (equal t1 t2) t1))
                ((listp t1)
                  (cond ((equal (car t1) (car t2))
                               (cons (car t1) (tree-agreement (cdr t1) (cdr t2))))
                              (t (list (tree-agreement (car t1) (car t2))))))))

;This is fast, but does not subtract time spent garbage collecting:
(defmacro elapsed-time (form time &optional increment-flag)
  `(let* ((t0 (get-internal-run-time))
            (val ,form))
     (let ((t1 (- (get-internal-run-time) t0)))
     (cond (,increment-flag
                (setq ,time (+ t1 ,time)))
               (t (setq ,time t1))))
     val))

;This returns the length of a string representation of the tree s:
(defunction string-length (s)
   (cond ((and s (listp s)) (+ 1 (length s) (apply #'+ (mapcar #'string-length s))))
             ((numberp s) (length (string-rep s)))
             (t (length (string s)))))

;This takes unquoted arguments, and saves the number of calls and the
;elapsed time on the a-list *metered-calls*, associated with X.
(defmacro metered-call (fun def)
    ` (let* ((time 0)
                (value nil)
                (reading (assoc ,fun *metered-calls* :test 'equal))
                (d-reading (mem2 reading)))
        (when reading (setf (cdr reading) (cddr reading)))
        (unwind-protect
            (setf value (elapsed-time (progn ,def) time t)))
        (let ((reading (assoc ,fun *metered-calls* :test 'equal)))
          (cond (d-reading
                      (setf (mem1 d-reading) (1+ (mem1 d-reading)))
                      (setf (mem2 d-reading) (+ (mem2 d-reading) time))
                      (setf (cdr reading) (cons d-reading (cdr reading))))
                    (reading (push (list 1 time) (cdr reading)))
                    (t (push (list ,fun (list 1 time)) *metered-calls*))))
        value))

#| This displays the values of a function for a specified range of values of the arguments. 
Ranges is a list of individual values and lists (start end increment) or (start end). If increment is not given, 
it is set to 1. The list of values is returned.|#
(defunction display-values (fun &rest ranges)
    (terpri)
    (setf ranges
             (mapcar #'(lambda (R)
                                  (cond ((listp R)
                                              (let ((range (list (car R)))
                                                      (value (car R))
                                                      (increment (or (mem3 R) 1)))
                                                (loop
                                                  (when (>= value (mem2 R)) (return range))
                                                  (setf value (+ value increment))
                                                  (push value range))))
                                            (t (list R))))
                            ranges))
    (let ((value-list (gencrossproduct (mapcar #'reverse ranges)))
            (fun-values nil))
      (dolist (values value-list)
          (princ "(") (princ fun) (dolist (x values) (princ " ") (princ x)) (princ ") = ")
          (let ((value (apply fun values)))
            (push value fun-values)
            (princ (apply fun values)) (terpri)))
      (reverse fun-values)))
 
;;                        * LIST FUNCTIONS *
;
;
;(defun cadadr (x) (cadr (cadr x)))
;(defun cddddr (x) (cdr (cdddr x)))
(defun cdddddr (x) (cdr (cddddr x)))
(defun caddddr (x) (car (cddddr x)))
(defun cadddddr (x) (car (cdddddr x)))
(defun cddddddr (x) (cdr (cdddddr x)))
(defun caddddddr (x) (car (cddddddr x)))
(defun member1 (x) (car x))
(defun member2 (x) (cadr x))
(defun member3 (x) (nth 2 x))
(defun member4 (x) (nth 3 x))
(defun member5 (x) (nth 4 x))
(defun member6 (x) (nth 5 x))
(defun member7 (x) (nth 6 x))
(defun member8 (x) (nth 7 x))
(defun member9 (x) (nth 8 x))
(defun member10 (x) (nth 9 x))
(defun member11 (x) (nth 10 x))
(defun member12 (x) (nth 11 x))
(defun member13 (x) (nth 12 x))
(defun member14 (x) (nth 13 x))
(defun member15 (x) (nth 14 x))
(defun member16 (x) (nth 15 x))
(defun member17 (x) (nth 16 x))
(defun member18 (x) (nth 17 x))

;list of first n members of s:
(defun first-n (n s)
   (subseq s 0 n))

;This returns the (max m n) if both are non-null:
(defunction max+ (m n)
   (if m
     (if n (max m n) m)
     n))

#|  This returns the maximum of an nonempty set of numbers.  |#
(defun maximum (X) (apply #'max X))

#|  This returns the maximum of an nonempty set of numbers.  |#
(defun minimum (X) (apply #'min X))

#|  This returns 0.0 if X is empty, otherwise the maximum of X.  |#
(defun maximum0 (X) (if X (apply #'max X) 0.0))

#|  This returns 0.0 if X is empty, otherwise the minimum of X.  |#
(defun minimum0 (X) (if X (apply #'min X) 0.0))

#| This returns T if F is nil, otherwise it funcalls F. |#

(defun funcall* (f x) (or (null f) (funcall f x)))

(defmacro funcall+ (F &rest x)
    `(or (null ,F) (funcall ,F ,@x)))

;Given a list of lists, this returns the (or a) longest member:
(defun longest (s) (prog (m n rest)
                                (setq rest (cdr s))
                                (setq m (car s))
                                (setq n (length m))
                                loop
                                (cond ((null rest) (return m)))
                                (cond ((> (length (car rest)) n)
                                           (setq m (car rest)) (setq n (length m))))
                                (setq rest (cdr rest))
                                (go loop)))

;first member of sequence x having property p, or "none" if there is none:
(defun first-p (x P) (cond ((null x) "none")
                                         ((funcall P (car x)) (car x))
                                         (t (first-p (cdr x) P))))

;R-first member of sequence x, or "none" if x is nil:
(defun r-first (x R)
   (cond ((null x) "none")
             (t
              (do ((rest (cdr x) (cdr rest))
                     (first (car x) (cond
                                           ((funcall R first (car rest)) first)
                                           (t (car rest)))))
                    ((null rest) first)))))

(defun order (X R)
   (let ((X* (copy-list X)))
     (sort X* R)))

#| This returns the set of non-repeating subsets of length i of X. |#
(defun fixed-length-subsets (n set)
    (cond  ((> n (length set)) nil)
                 ((zerop n) (list nil))
                 ((= n 1) (mapcar #'list set))
                 (t  (append (mapcar #'(lambda (a) (cons (car set) a))
                                                      (fixed-length-subsets (- n 1) (cdr set)))
                                      (fixed-length-subsets n (cdr set))))))

#| This returns the set of all minimal subsets of X that have the property P. |#
(defunction minimal-subsets (X P)
    (cond ((funcall P nil) (list nil))
                (t 
                  (let ((S nil))
                     (dotimes (i (length X))
                         (let ((candidates
                                   (subset #'(lambda (fs)
                                                       (every #'(lambda (s*) (not (subsetp= s* fs))) S))
                                                  (fixed-length-subsets (1+ i) X))))
                            (when (null candidates) (return S))
                            (dolist (y candidates)
                                (when (funcall P y) (push y S)))))
                     S))))

#| This returns the set of all maximal subsets of X that have the property P. |#
(defunction maximal-subsets (X P)
    (cond ((funcall P X) (list X))
                (t
                  (let ((S nil))
                     (dotimes (i (length X))
                         (let ((candidates
                                   (subset #'(lambda (fs)
                                                       (every #'(lambda (s*) (disjoint s* fs)) S))
                                                  (fixed-length-subsets (1+ i) X))))
                            (when (null candidates) (return S))
                            (dolist (y candidates)
                                (let ((y* (setdifference X y)))
                                   (when (funcall P y*) (push y* S))))))
                     S))))

(defun ordered-insert (x queue R)
   "queue is a list ordered by R, and x is a new member to be inserted
     into the right position in the ordering.  This returns the new ordered list."
   (let ((head nil)
           (tail queue))
     (loop
       (when (null tail) (return (reverse (cons x head))))
       (let ((y (mem1 tail)))
         (cond ((funcall R y x)
                    (push y head)
                    (setf tail (cdr tail)))
                   (t
                    (push x tail)
                    (dolist (z head) (push z tail))
                    (return tail)))))))

;depth of a list:
(defun depth (s)
   (cond ((atom s) 1)
             (t (max (1+ (depth (car s))) (depth (cdr s))))))

(defunction occur (x s &key (test 'eq))
    (and s (listp s)
              (or (funcall test (car s) x)
                    (occur x (car s) :test test)
                    (occur x (cdr s) :test test))))

(defun occur* (x s &key (test 'eq))
   (or (funcall test x s) (occur x s :test test)))

#| x occurs as a function-call in x. |#
(defunction occur1 (x s &key (test 'eq))
    (and s (listp s) (not (eq (car s) 'quote))
             (cond ((eq (car s) 'dolist)
                         (occur1 x (cddr s)))
                       ((or (eq (car s) 'let) (eq (car s) 'let*))
                         (or (occur1 x (cddr s))
                               (some #'(lambda (y) (occur1 x (mem2 y))) (cadr s))))
                       (t
             (or (funcall test (car s) x)
                   (occur1 x (car s))
                   (and (listp (cdr s))
                            (some #'(lambda (y) (occur1 x y :test test)) (cdr s))))))))

;; the number of occurrences of x in s
(defunction number-of-occurrences (x s)
    (cond ((atom s) (if (equal x s) 1 0))
              ((null s) 0)
              ((listp s) (+ (number-of-occurrences x (car s)) (number-of-occurrences x (cdr s))))))

(defun substructures (s)
   (cond ((atom s) nil)
             (t (cons s (unionmapcar #'substructures s)))))

;find substructures of s containing x:
(defun s-find (x s)
   (subset #'(lambda (y) (mem x y)) (substructures s)))

;substitution of one subsequence for another in a sequence:
(defun seq-subst (new old s)
   (declare (inline first-n))
   (cond ((< (length s) (length old)) s)
             ((equal old (first-n (length old) s))
              (append new (seq-subst new old (nthcdr (length old) s))))
             (t (cons (car s) (seq-subst new old (cdr s))))))

(defun =subst (a b c)
   (cond ((equal b c) a)
             ((listp c) (subst a b c :test 'equal))
             (t c)))

(defun subst* (a b c &key (test 'eq))
    (cond ((atom c) (if (funcall test b c) a c))
                (t (subst a b c :test test))))

(defun sublis= (m x)
   (cond ((listp x) (sublis m x :test 'equal))
             (t (car (sublis m (list x) :test 'equal)))))


;                  * INSERTION AND DELETION *

;remove uses 'eql'.  This uses 'equal':
(defun remove-if-equal (x y)
   (remove-if #'(lambda (z) (equal z x)) y))

#| replace first occurrence of x by y in S. |#
(defunction replace-item-in-list (x y S)
    (let ((S0 S)
            (S* nil))
       (loop
          (when (equal x (car S0)) (return (append (reverse S*) (cons y (cdr S0)))))
          (push (car S0) S*)
          (setf S0 (cdr S0))
          (when (null S0) (return S)))))

;nondestructively delete nth member of y:
(defun delete-n (n y)
   (cond ((equal n (length y)) (first-n (1- n) y))
             ((> n (length y)) y)
             (t (append (first-n (1- n) y) (nthcdr n y)))))

;nondestructively splice x into y at the nth place:
(defun splice (x n y)
   (cond ((> n (length y)) (append y (list x)))
             (t (append (first-n (1- n) y) (list x) (nthcdr (1- n) y)))))

;This inserts x into its appropriate place in A where A is ordered by R.  If R
;is a < relation, this puts x at the end of the sublist of equivalent items, and if 
;R is a <= relation, this puts it at the start of the sublist.
(defunction insert (x A R)
   (let ((head nil)
          (tail A))
     (loop
       (cond ((null tail) (setq tail (list x)) (return))
                 ((funcall R x (mem1 tail))
                  (setq tail (cons x tail)) (return))
                 (t (setq head (cons (mem1 tail) head))
                    (setq tail (cdr tail)))))
     (loop
       (cond ((null head) (return))
                 (t (setq tail (cons (mem1 head) tail))
                    (setq head (cdr head)))))
     tail))


;                        * SET FUNCTIONS *

(defun mem (element  set)
   (member element set :test 'equal))

;set-equality:
(defunction == (x y)
    (or (eq x y)
          (and (listp x) (listp y)
                     (subsetp x y :test 'equal)
                     (subsetp y x :test 'equal))))

;; this returns three values: (union x y), (setdifference x y), and (setdifference y x),
;; but if a symbol occurs multiple times in x or y, they are treated as different smbols.
(defunction compare-lists (x y &key (test #'eq))
    (let ((xy nil))
       (dolist (z x)
           (block x+
               (dolist (w y)
                   (cond ((funcall test z w) 
                                (setf x (remove z x :count 1 :test test))
                                (setf y (remove z y :count 1 :test test))
                                (push z xy) (return-from x+ nil))))))
       (values xy x y)))

#| 
(compare-lists '(a a b c) '(a b c d)) returns
(c b a)
(a)
(d)
|#

(defunction === (x y &key (test 'equal))
    (or (eq x y)
          (and (listp x) (listp y)
                    (multiple-value-bind
                         (u d1 d2)
                         (compare-lists x y :test test)
                         (declare (ignore u))
                         (and (null d1) (null d2))))))

(defunction << (x y) (< (round (* 10000 x)) (round (* 10000 y))))

(defunction >> (x y) (> (round (* 10000 x)) (round (* 10000 y))))

(defunction <<= (x y)
    (or (eql x y) (<= (round (* 10000 x)) (round (* 10000 y)))))

(defunction >>= (x y)
    (or (eql x y) (>= (round (* 10000 x)) (round (* 10000 y)))))

(defunction >< (x y)
    (or (eql x y) (eql (round (* 10000 x)) (round (* 10000 y)))))

(defun union= (x y) (union x y :test 'equal))

(defun adjoin= (x y) (adjoin x y :test 'equal))

(defunction remove-duplicates= (x)
   (remove-duplicates x :test 'equal))

(defun subset (f l)
   (remove-if-not f l))

(defun subsetp= (X Y)
   (subsetp X Y :test 'equal))

(defun proper-subset (X Y)
    (and (subsetp= X Y) (not (subsetp= Y X))))

;x and y are disjoint, with test 'equal:
(defun disjoint (x y)
    (not (some #'(lambda (z) (mem z y)) x)))

;x and y are disjoint, with test 'eq:
(defun disjointp (x y)
    (not (some #'(lambda (z) (member z y)) x)))

(defun crossproduct (A B)
    (let ((U nil))
       (dolist (x A)
           (dolist (y B)
               (push (list x y) U)))
       U))

(defun dot-product (x y)
   (unionmapcar #'(lambda (w) (mapcar #'(lambda (z) (cons w z)) y)) x))

;domain, range, and inverse of a set of ordered pairs:
(defun domain (x) (remove-duplicates (mapcar #'car x) :test 'equal))

(defun range (x) (remove-duplicates (mapcar #'cadr x) :test 'equal))

;range of an association list:
(defun a-range (x) (remove-duplicates (mapcar #'cdr x) :test 'equal))

(defun inverse (R) (mapcar #'reverse R))

;(defunction genunion (x) (apply 'append x))
#| The following removes duplicates too. |#
(defunction genunion (x)
    (let ((union nil))
       (dolist (y x)
           (dolist (z y)
               (when (not (mem z union)) (push z union))))
       union))

(defunction genunion+ (x)
    (let ((union nil))
       (dolist (y x) (dolist (z y) (pushnew z union)))
       union))

(defunction gen-intersection (x)
   (cond ((null x) nil)
             ((equal (length x) 1) (mem1 x))
             (t (=intersection (mem1 x) (gen-intersection (cdr x))))))

(defun gencrossproduct (A)
    (let ((U nil))
       (cond ((cddr A)
                    (dolist (x (car A))
                        (dolist (y (gencrossproduct (cdr A)))
                            (push (cons x y) U)))
                    U)
                   ((cdr A) (crossproduct (car A) (cadr A)))
                   (t A))))

(defun powerset (X)
   (cond ((null X) (list nil))
             (t (let ((p (powerset (cdr X))))
                  (union= p (mapcar #'(lambda (Y) (cons (car X) Y)) p))))))

(defun setdifference (x y) (set-difference x y :test 'equal))

(defun =intersection (x y) (intersection x y :test 'equal))

(defun list-complexity (x)
   (cond ((null X) 0)
             ((stringp x) 1)
             ((atom x) 1)
             ((listp x) (apply #'+ (mapcar #'list-complexity x)))))


;                        * QUANTIFICATION *
#|
(defun unionmapcar (f A) (apply 'append (mapcar f A)))

;This removes duplicates with test eq.
(defun unionmapcar+ (f X)
    (let ((U nil))
       (dolist (y X)
           (dolist (z (funcall f y))
               (pushnew z U)))
       U))

;This removes duplicates with test equal.
(defun unionmapcar= (f X)
    (let ((U nil))
       (dolist (y X)
           (dolist (z (funcall f y))
               (pushnew z U :test 'equal)))
       U))

;This removes duplicates with test equal.
(defun unionmapcar2= (f X Y)
    (let ((U nil)
            (X* X)
            (Y* Y))
       (loop
          (when (null X*) (return U))
          (dolist (z (funcall f (mem1 X*) (mem1 Y*)))
              (pushnew z U :test 'equal))
          (setf X* (cdr X*))
          (setf Y* (cdr Y*)))))
|#
;an assignment is a function in extension.  The following checks to see
;whether a putative assignment is consistent, in the sense of assigning
;only one object to each element of the domain:

(defun consistent-assignment (s)
   (equal (length s) (length (domain s))))

;this returns the value of assignment for object obj:
(defun value (assignment obj)
   (declare (inline subset))
   (cadr (apply #'append
                        (subset #'(lambda (val-arg) (equal (car val-arg) obj))
                                    assignment))))

;This maps a binary function f onto a set x, holding y fixed:
(defun mapcar1 (f x y) (mapcar #'(lambda (z) (apply f (list z y))) x))


;                        * STRINGS *

(defun explode (s)
   (mapcar #'string (coerce s 'list)))

(defun char-list (x)
   (declare (inline explode))
   (cond ((numberp x) (list (string (code-char (+ 48 x)))))
         ((characterp x) (list x))
         ((atom x) (explode (string x)))
         ((stringp x) (explode x))))

(defun char-num (x)
   (mapcar
    #'(lambda (i) (char x i))
    (mapcar #'1- (nseq (length x)))))

(defunction implode (x)
   "where x is a list of strings, this concatenates them into a single string"
   (if (null x) nil
        (concatenate 'string (car x) (implode (cdr x)))))

(defun imp (s)
   (cond ((symbolp s) (string s))
             ((numberp s) (string-rep s))
             (t (coerce (mapcan #'char-num
                                            (mapcan #'char-list s)) 'string))))

(defun string-rep (n) (write-to-string n))

;this returns the integer named by a string:
(defun named-integer (s)
    (read-from-string s))

;this returns the decimal-number named by a string:
(defun named-decimal-number (string)
    (float (read-from-string string)))

;concatenate two strings:
(defun cat (x y)
    (concatenate 'string x y))

;(defun cat (x y)
;   (imp (append (explode x) (explode y))))

;concatenate a list of strings:
(defun cat-list (s)
   (cond ((null s) nil)
             (t (cat (mem1 s) (cat-list (cdr s))))))

;;This returns the substring of s from n through m inclusive.  If m is
;;omitted, it is set to the length of the string.
(defun substring (s n &optional (m))
  (subseq s n m))

#| This returns the word-strings in a string with spaces. |#
(defun word-list (string)
    (let ((letters (explode string))  ;; strings of length 1
            (words nil)
            (word nil))
      (dolist (letter letters)
          (cond ((equal letter " ")
                      (push (implode (reverse word)) words)
                      (setf word nil))
                    (t (push letter word))))
      (if word (push (implode (reverse word)) words))
      (reverse words)))

#| example:
? (word-list "Who is Henry's father")
("Who" "is" "Henry's" "father")
|#

#| This turns a list of strings into a string with spaces. |#
(defun concatenate-words (word-list)
    (cond ((cdr word-list)
                (cat (car word-list)
                        (cat " " (concatenate-words (cdr word-list)))))
              (t (car word-list))))

#| example:
? (concatenate-words '("Who" "is" "Henry's" "father"))
"Who is Henry's father"
|#

;	** MATCHING **

(defun match (pat exp var)
    (labels ((match* (pat exp var bindings)
                      (cond ((atom pat)
                                  (cond ((mem pat var)
                                              (let ((assoc (assoc pat bindings :test 'equal)))
                                                (cond (assoc (equal exp (cdr assoc)))
                                                          (t (list (cons pat exp))))))
                                            (t (equal pat exp))))
                                ((listp pat)
                         (when (listp exp)
                                       (let ((m (match* (car pat) (car exp) var bindings)))
                                         (cond ((eq m t) (match* (cdr pat) (cdr exp) var bindings))
                                                   (m (let ((m* (match* (cdr pat) (cdr exp) var (append m bindings))))
                                                           (cond ((eq m* t) m)
                                                                     (m* (union= m m*))))))))))))
      (match* pat exp var nil)))

;this returns the association list of a match of variables to elements
;of s which, when substituted in l yields s.  So l is the pattern and s
;is the target.  If X is given, the match must be to members of X.
; This assumes that members of var do not occur in s.
;(defunction match (pattern expression var &optional X)
;   (catch 'match (pattern-match pattern expression var X)))
;
;(defun pattern-match (l s var &optional X)
;   (cond ((equal l s) t)
;             ((atom l)
;              (cond ((and (mem l var)
;                                 (if X (mem s X) t))
;                         (list (cons l s)))
;                        (t (throw 'match nil))))
;             ((listp l)
;              (cond ((not (listp s)) (throw 'match nil))
;                        ((not (eq (length l) (length s))) (throw 'match nil))
;                        ((eql (length l) 1) (pattern-match (car l) (car s) var X))
;                        (t (let ((m (pattern-match (car l) (car s) var X)))
;                             (cond ((null m) (throw 'match nil)))
;                             (let ((l* (cond ((eq m t) (cdr l))
;                                                   (t (sublis= m (cdr l))))))
;                                 (cond ((eq m t) (pattern-match l* (cdr s) var X))
;                                           (t (let ((m* (pattern-match l* (cdr s)
;                                                      (setdifference var (domain m)) X)))
;                                                (cond ((eq m* t) m)
;                                                          (t (append m m*)))))))))))))

(defun merge-matches (m m*)
   (cond ((equal m t) m*)
             ((equal m* t) m)
             (t (union= m m*))))

(defun nseq< (n)
   (do ((i 0 (1+ i))
          (s nil (cons i s)))
         ((>= i n) (reverse s))))

;this substitutes in accordance with a match m:
(defun match-sublis (m x &key (test 'eq))
   (cond ((eq m t) x)
             (t (sublis m x :test test))))

(defun match-domain (m)
   (if (equal m t) nil (domain m)))

(defun consistent-match (p1 p2)
   (not (some #'(lambda (s)
                          (some #'(lambda (v) (and (equal (car s) (car v))
                                                                   (not (equal (cdr s) (cdr v)))))
                                    p2)) p1)))

#| (set-match patterns data vars) returns the set of pairs (X m) where m is an a-list of
substitutions for members of vars and X is (mapcar #'(lambda (p) (match-sublis m p))
patterns), and X is a subset of data.  This asssumes that vars do not occur in data. |#
;(defunction set-match (patterns data vars)
;   (catch 'match (set-match-no-catch patterns data vars)))
;
;(defunction set-match-no-catch (patterns data vars)
;   (let ((matches nil)
;           (open nil)
;           (closed nil))
;     (dolist (P patterns)
;        (if (some #'(lambda (v) (occur v P)) vars)
;          (push P open)
;          (if (mem P data)
;            (push P closed)
;            (throw 'match nil))))
;     (cond (open
;                 (let ((P (mem1 open)))
;                   (dolist (Q data)
;                      (let ((m (match P Q vars)))
;                        (when m
;                            (dolist (sm (set-match-no-catch
;                                                 (match-sublis m (cdr open))
;                                                 data
;                                                 (setdifference vars (match-domain m))))
;                               (push (list (adjoin= Q (union= closed (mem1 sm)))
;                                                 (merge-matches m (mem2 sm)))
;                                          matches)))))))
;                (t (setf matches (list (list closed T)))))
;     (when (null matches) (throw 'match nil))
;     matches))

(defunction set-match (patterns data vars)
    (catch 'match
       (let ((matches nil)
               (open nil)
               (closed nil))
         (dolist (P patterns)
             (if (some #'(lambda (v) (occur v P)) vars)
               (push P open)
               (if (mem P data)
                 (push P closed)
                 (throw 'match nil))))
         (cond (open
                     (let ((P (mem1 open)))
                       (dolist (Q data)
                           (let ((m (match P Q vars)))
                             (when m
                                  (dolist (sm (set-match
                                                      (match-sublis m (cdr open))
                                                      data
                                                      (setdifference vars (match-domain m))))
                                      (push (list (adjoin= Q (union= closed (mem1 sm)))
                                                       (merge-matches m (mem2 sm)))
                                                matches)))))))
                   (t (setf matches (list (list closed T)))))
         (when (null matches) (throw 'match nil))
         matches)))

;                        * MISCELLANEOUS *

(defun e-assoc (x l)
   (cdr (assoc x l :test #'equal)))

;; The number of members of X satisfying F.
(defunction number-of (X F)
    (cond ((null X) 0)
              ((funcall F (car x)) (1+ (number-of (cdr X) F)))
              (t (number-of (cdr X) F))))

;this returns the difference between two times t1 and t2 presented in
;the format of (multiple-value-list (get-decoded-time)):
(defun time-dif (t1 t2)
   (let ((X t1))
     (cond ((<= (car t2) (car t1))
                (setq X (list (- (car t1) (car t2)) (cadr X) (mem3 X))))
               (t (setq X (list (+ 60 (- (car X) (car t2))) (1- (cadr X))
                                     (mem3 X)))))
     (cond ((<= (cadr t2) (cadr X))
                (setq X (list (car X) (- (cadr X) (cadr t2))
                                   (mem3 X))))
               (t (setq X (list (car X) (+ 60 (- (cadr X) (cadr t2)))
                                     (1- (mem3 X))))))
     (cond ((<= (mem3 t2) (mem3 X))
                (setq X (list (car X) (cadr X) (- (mem3 X) (mem3 t2)))))
               (t (setq X (list (car X) (cadr X)
                                     (+ 24 (- (mem3 X) (mem3 t2)))))))))

(defun nseq (n)
   (do ((i 1 (1+ i))
          (s nil (cons i s)))
         ((> i n) (reverse s))))

(defun gdisc (f)
   (cond ((macro-function f) 'macro)
         ((special-operator-p f) 'nlambda)
         ((functionp f) 'lambda)
         (t f)))

(defun pl ()
   (if (null *print-level*) (setq *print-level* 4) (setq *print-level* nil)))

(defun unboundp (x) (not (boundp x)))


;                        * CONFIGURATION *

(defun verbose-on ()
   (setq *load-verbose* t *verbose-eval-selection* t))

(defun verbose-off ()
   (setq *load-verbose* nil *verbose-eval-selection* nil))

(defun warn-on ()
   (setq *warn-if-redefine* t))

(defun warn-off ()
   (setq *warn-if-redefine* nil))

(defun lessp (x y)
   (cond ((characterp x)
               (cond ((characterp y) (char< x y))
                          (t t)))
              ((stringp x) 
               (cond ((stringp y) (string< x y))
                          (t t)))
              ((symbolp x)
               (cond ((equal x y) nil)
                          ((symbolp y)
                           (string<  (string x) (string y)))
                          ((listp y) t)
                          (t nil)))
              ((and (listp x) (listp y))
               (cond ((equal x y) nil)
                          ((lessp (car x) (car y)) t)
                          ((lessp (car y) (car x)) nil)
                          (t (lessp (cdr x) (cdr y)))))))

;This takes quoted arguments:
(defun gfunc (f)
   (eval (list 'function f)))

(setq *print-level* nil)

(defun factorial (n)
   (cond ((zerop n) 1)
             (t (* n (factorial (1- n))))))

;(setq param-list '(1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0))

(defun pause ()
   (when (and (equal pause-flag t) (equal (read-char) 98)) (break)))

(defun pause-flag-on (&optional x)
   (cond (x (setq pause-flag x))
             (t (setq pause-flag t))))

(defun pause-flag-off () (setq pause-flag nil))

;print members of a sequence on consecutive lines:
(defun p-print (x)
   (terpri)
   (mapc #'(lambda (l) (prin1 l) (terpri)) x)
   nil)

(defun p-princ (x)
   (mapc #'(lambda (l) (princ l) (terpri)) x)
   nil)

#| This prints a list, putting at most n items on a line. |#
(defun print-list (L &optional (n 1) (indent-depth 0) stream)
    (indent indent-depth stream)
    (princ "(" stream)
    (let ((i 1)
            (to-print L))
       (dolist (y L)
           (princ y stream)
           (setf to-print (cdr to-print))
           (cond ((eql i n)
                        (setf i 1)
                        (when (not (null to-print)) (terpri stream) (indent indent-depth stream)
                                     (princ "  " stream)))
                       ((not (null to-print))
                         (incf i)
                         (princ " " stream))))
       (princ ")" stream)
      ; (terpri)
       ))

(defun princ-list (L)
    (princ (car L))
    (when (cdr L)
         (dolist (x (cdr L))
             (princ ", ") (princ x))))

(defun p-print-list (L &optional (n 1) (indent-depth 0))
    (indent indent-depth)
    (princ "(") (terpri)
    (dolist (X L)
        (cond ((listp L) (print-list X n (1+ indent-depth)) (terpri))
                    (t (princ X) (terpri))))
    (indent indent-depth)
    (princ ")") (terpri))

(defun indent (depth &optional stream)
    (dotimes (i depth) (princ ". " stream)))

(defun bar-indent (depth)
    (dotimes (i depth)
        (if (zerop (rem i 4)) (princ "|") (princ ". "))))

(defunction prinp (P &optional stream)
   "pretty-print a putative formula"
   (princ (pretty P) stream))

(defunction set-prinp (X &optional stream)
   "pretty-print a set of formulas"
   (princ "{ " stream)
   (when X
       (prinp (mem1 X) stream)
       (for-all (cdr X) #'(lambda (Q) (princ " , " stream) (prinp Q stream))))
   (princ " }" stream))

(defunction prinp-sequent (X &optional stream)
   "pretty-print a sequent"
   (prinp (sequent-formula X) stream)
   (when (sequent-supposition X)
        (princ " supposing " stream)
        (set-prinp (sequent-supposition X) stream))
   X)

(defun princ-set (X &optional stream)
   "pretty-print a set"
   (princ "{ " stream)
   (when X
       (princ (mem1 X) stream)
       (for-all (cdr X) #'(lambda (Q) (princ " , " stream) (princ Q stream))))
   (princ " }" stream))

;pretty print a set of sequents
(defun princ-sequent-set (X &optional stream)
   (princ "{ " stream)
   (when X
       (prinp-sequent (mem1 X) stream)
       (for-all (cdr X) #'(lambda (Q) (princ " , " stream) (prinp-sequent Q stream))))
   (princ " }" stream))


;;;;;                                       METERING


(defun definition (fun)
  (let ((def (get fun 'definition)))
    (if def (append (list 'defun fun (get fun 'arglist)) def)
            "No definition is recorded")))

(defun turn-on-metering (fun)
  (let ((arglist (get fun 'arglist))
	(definition (cdddr (definition fun))))
    (cond ((equal arglist "No arglist is recorded") arglist)
	  ((equal definition "No definition is recorded") definition)
	  (t (when (unboundp '*metered-calls*) (setq *metered-calls* nil))
	     (when (assoc fun *metered-calls*)
	       (princ fun) (princ " already has a metering record.") (terpri))
	     (setf definition
		   (cons 'progn 
			 (if (equal (mem1 (mem1 definition)) 'declare)
			     (cdr definition)
			   definition)))
	     (eval (list 'defun fun arglist (list 'metered-call (list 'quote fun) definition)))))))

(defun meter (&rest funs)
   (cond ((null funs)
              (cond ((or (unboundp '*metered-calls*) 
                               (null *metered-calls*))
                         (princ "No functions are being metered") (terpri))
                        (t (terpri) (princ "The following functions are being metered:")
                           (for-all *metered-calls* #'(lambda (x) (print (car x))))
                           (terpri) (terpri))
                        (for-all funs #'(lambda (f) (turn-on-metering f)))))
             (t (for-all funs #'turn-on-metering)
                (setq *metered-calls* (sort *metered-calls* 'lessp)))))

;This meters all functions defined by 'defunction' in the current package:
(defun meter-all ()
   (princ "Turning on metering for these functions:") (terpri)
   (for-all (package-symbols)
	    #'(lambda (f)
		(cond ((not (equal (get f 'arglist) "No arglist is recorded"))
		       (princ f) (terpri) (turn-on-metering f)))))
   nil)

(defun unmeter (&rest funs)
   (cond ((null funs) (setq funs (mapcar #'car *metered-calls*))))
   (terpri) (princ "Unmetering these functions:") (terpri)
   (for-all funs
                #'(lambda (f)
                     (prin1 f) (terpri)
                     (eval (definition f))))
   (apply #'clear-meter funs)
   nil)

(defun clear-meter (&rest funs)
   (cond ((null funs) (setq *metered-calls* nil))
             (t (for-all funs
                             #'(lambda (f)
                                  (setq *metered-calls*
                                           (remove-if-equal
                                            (assoc f *metered-calls* :test 'equal)
                                            *metered-calls*)))))))

(defun reset-meter-entry (fun)
   (setq *metered-calls*
            (cons (cons fun (list 0 0))
                     (remove (assoc fun *metered-calls* :test 'equal) *metered-calls*))))

(defun reset-meter (&rest funs)
   (cond ((null funs)
              (setq *metered-calls*
                       (mapcar #'(lambda (x) (cons (car x) (list 0 0)))
                                     *metered-calls*)))
             (t (for-all funs #'reset-meter-entry))))

(defun show-meter-entry (fun count time avg)
     (princ fun) (princ ": ") (princ count) (princ " calls in ")
     (display-run-time-in-seconds time)
     (cond (avg (princ "  avg ")
                       (display-run-time-in-seconds avg)))
     (terpri))

;This compares two meter records:
(defun compare-meters (meter1 meter2)
   (terpri)
   (for-all meter1
                #'(lambda (s)
                     (let ((s* (e-assoc (car s) meter2)))
                       (princ (car s)) (princ " . ")  (princ (mem1 (cdr s)))
                       (princ " calls in ")
                       (display-run-time-in-seconds (mem2 (cdr s)))
                       (princ "  avg ") 
                       (display-run-time-in-seconds
                        (round (/ (mem1 (cdr s)) (mem2 (cdr s)))))
                       (princ " . ")  (princ (mem1 (cdr s*)))
                       (princ " calls in ")
                       (display-run-time-in-seconds (mem2 (cdr s*)))
                       (princ "  avg ") 
                       (display-run-time-in-seconds
                        (round (/ (mem1 (cdr s*)) (mem2 (cdr s*)))))
                       (princ " . ") (princ "DIFFERENCE: ")
                       (princ (- (mem1 (cdr s)) (mem1 (cdr s*))))
                       (princ " calls in ")
                       (display-run-time-in-seconds
                        (- (mem2 (cdr s)) (mem2 (cdr s*))))
                       (princ "  ratio of avgs ")
                       (princ (round (/ (* (mem1 (cdr s)) (mem2 (cdr s*)))
                                                  (* (mem1 (cdr s*)) (mem2 (cdr s))))))
                       (terpri)))))

(defun display-run-time-in-seconds (time)
   (let* ((sec (truncate (/ time internal-time-units-per-second)))
            (thousandths
             (round (/ (* 1000 (- time (* internal-time-units-per-second sec)))
                             internal-time-units-per-second))))
      (when (eql thousandths 1000)
           (incf sec)
           (setf thousandths 0))
     (princ sec) (princ ".")
     (cond ((< thousandths 10) (princ "00"))
               ((< thousandths 100) (princ "0")))
     (princ thousandths) (princ " sec")))

(defun show-all-meter ()
    (terpri)
    (dolist (reading *metered-calls*)
        (let ((fun (car reading))
                (indent 0)
                (calls 0)
                (total-time 0))
          (princ "Nested Calls:") (terpri)
          (dolist (d-reading (cdr reading))
              (let ((count (mem1 d-reading))
                      (time (mem2 d-reading)))
                (setf calls (+ calls count))
                (setf total-time (+ total-time time))
                (indent indent) (princ fun) (princ ": ") (princ count)
                (princ " calls in ") (display-run-time-in-seconds time)
                (princ "  avg ") (display-run-time-in-seconds (round (/ time count)))
                (terpri)
                (incf indent)))
          (princ "Total Calls: ") (princ calls) (princ " in ") (display-run-time-in-seconds total-time)
          (princ "  avg ") (display-run-time-in-seconds (round (/ total-time calls))) (terpri))))

(defun order-1 (x y) (< (mem1 x) (mem1 y)))

(defun order-2 (x y) (< (mem2 x) (mem2 y)))

(defun order-3 (x y) (< (mem3 x) (mem3 y)))

(defun order-4 (x y) (< (mem4 x) (mem4 y)))

;This returns the ratio of m and n as a real number, to two decimal places:
(defunction real-ratio (m n)
   (cond ((zerop n) nil)
             (t (/ (coerce (round (coerce (* 100 (/ m n)) 'float)) 'float) 100))))

;This returns (expt m (/ 1 n)) as a real number, to two decimal places:
(defunction real-root (m n)
   (cond ((zerop n) nil)
             (t (/ (coerce (round (coerce (* 100 (expt m (/ 1 n))) 'float)) 'float) 100))))


;List all callers of f in current package:
(defun who-calls (f)
  (terpri) (princ "The following functions call ") (princ f) (princ ":") (terpri)
  (let* ((callers 
	  (remove nil
		  (mapcar 
		   #'(lambda (x)
		       (cond ((occur f (if (not (stringp (definition x))) (cddr (definition x))))
			      (list x (get-source-files x)))))
		   (package-symbols))))
	 (files (remove-duplicates (unionmapcar #'cadr callers))))
    (for-all files
	     #'(lambda (f)
                 (princ "Defined in ") (prin1 f) (princ ":") (terpri)
                 (for-all callers
                          #'(lambda (x)
			      (cond ((mem f (mem2 x))
				     (princ "     ") (prin1 (mem1 x))
				     (terpri))))))))
  (terpri))

(defunction show-callers (f &optional (max-depth 5))
    (callers f nil 0 nil max-depth))

(defun callers (f &optional listees depth functions max-depth)
   (when (<= depth max-depth)
        (when (zerop depth)
             (princ "Calling history for ") (princ f) (terpri)
             (setf depth 0) (setf listees nil)
             (setf functions (subset #'definition (package-symbols))))
        (let ((direct-callers
                  (subset #'(lambda (x)
                                     (and (listp (definition x))
                                              (occur1 f (cdddr (definition x))))) functions)))
           (dolist (c direct-callers)
               (bar-indent depth)
               (princ c)
               (cond ((mem c listees)
                           (princ " .....") (terpri))
                          (t
                            (terpri)
                            (push c listees)
                            (setf listees (callers c listees (1+ depth) functions max-depth)))))
           (when (not (zerop depth)) listees))))

#| This lists all calling paths from f to g: |#
(defun paths-from (f g &optional functions path paths)
    (when (null path)
         (setf path (list g))
         (princ "Calling paths from ") (princ f) (princ " to ") (princ g) (terpri)
         (setf functions (subset #'definition (package-symbols))))
    (let ((direct-callers (subset #'(lambda (x) (occur g (definition x))) functions)))
       (dolist (c direct-callers)
           (when (not (mem c path))
                (let ((path* (cons c path)))
                   (when (not (mem path* paths))
                        (push path* paths)
                        (cond ((equal c f)
                                     (let ((i 0))
                                        (dolist (p path*)
                                            (indent (incf i))
                                            (princ p) (terpri))))
                                    (t
                                      (setf paths (paths-from f c functions path* paths))))))))
       paths))

;This prints the bindings of all bound symbols ownded by pkg.
(defun show-symbol-bindings (&optional pkg)
   (cond ((null pkg) (setq pkg *package*)))
   (for-all (package-symbols pkg)
                #'(lambda (x)
                     (cond ((and (boundp x)
                                        (not (equal x '*KILLED-STRINGS*)))
                                (prin1 x) (princ " : ") (prin1 (eval x)) (terpri))))))

#|This returns a list of functions defined by 'defunction' that are called by fun, 
provided fun is defined by 'defunction'. |#
(defun direct-callees (fun &optional symbols)
    (when (listp (definition fun)) (def-symbols (cdddr (definition fun)) symbols)))

#| This returns the list of symbols occurring in X that are defined by 'defunction'. |#
(defun def-symbols (X symbols)
    (cond
      ((null X) nil)
      ((listp (car X)) (union= (def-symbols (car X) symbols) (def-symbols (cdr X) symbols)))
      ((stringp (car X)) (def-symbols (cdr X) symbols))
      ((and (symbolp (car x)) (listp (definition (car X))) (or (null symbols) (mem (car X) symbols)))
        (cons (car X) (def-symbols (cdr X) symbols)))
      (t (def-symbols (cdr X) symbols))))

;This returns a list of direct-callees, and their direct-callees, etc.  The keywords
;determine whether a pretty display is printed to the screen, and whether the
;output is aphabetically ordered.  The results are saved in *callees*.
(defun callees (fun &key print order)
   (setq *callees* (direct-callees fun))
   (loop
     (let* ((Y (remove-duplicates (unionmapcar #'direct-callees *callees*)))
              (Z (setdifference Y *callees*)))
       (cond (Z (setq *callees* (union Z *callees*)))
                 (t (cond (order (setq *callees* (sort *callees* 'lessp))))
                    (cond (print (terpri) (princ "The callees of ") (prin1 fun)
                                        (princ " are:") (terpri) (p-print *callees*) (terpri)))
                    (return *callees*))))))

(defun display-callees (f &key repeat  (depth 64) symbols)
    (princ "Calling history for ") (princ f) (terpri) (terpri)
    (setf *callees* nil)
    (setf *blank-line* nil)
    (setf *line-columns* nil)
    (display-callees* f (not repeat) depth symbols nil 0 t)
   ; (when *callees*
   ;      (terpri) (princ "The following defunctions are called, directly or indirectly, by ")
   ;      (princ f) (princ ":") (terpri) (princ *callees*) (terpri) (terpri))
    nil)

(defun display-callees*
             (f donot-repeat max-depth symbols &optional listees depth last?)
    ; (when (equal f 'discharge-link)
    ;      (setf f* f do donot-repeat m max-depth s symbols l listees d depth l* last? ia indented-already?) (break))
    ;; (step (display-callees* f* do m s l d l* ia))
    (when (null depth)
         (setf depth 0) (setf listees nil))
    ;  (bar-indent depth) (princ f) (princ "   ") (princ listees) (princ "   ") (princ last?) (princ "   ")
    ;  (princ indented-already?) (terpri)
    (when (or (null max-depth) (<= depth max-depth))
         (cond ((or (mem f listees) (mem f *callees*))
                      (line-indent depth)
                      (when (not (mem depth *line-columns*)) (princ "|"))
                      (princ "--") (princ f) (princ " .....") (terpri)
                      (setf *blank-line* nil)
                      (cond (last? (pull depth *line-columns*))
                                  (t (pushnew depth *line-columns* :test 'eql))))
                     (t
                       (let* ((direct-callees (direct-callees f symbols))
                                 (DC direct-callees)
                                 (number (length direct-callees))
                                 (number* (round (/ number 2)))
                                 (draw-line?
                                   (or (mem f listees)
                                         (mem f *callees*)
                                         (some #'(lambda (C) (not (mem c listees))) direct-callees))))
                          (pushnew f listees :test 'equal)
                          (when donot-repeat (pushnew f *callees* :test 'equal))
                          (when (and (not *blank-line*) (< depth max-depth) (> number* 0))
                               (line-indent depth) (terpri) (setf *blank-line* t))
                          (dotimes (n number*)
                              (let ((c (mem1 DC)))
                                 (cond
                                   ((zerop n)
                                     (display-callees*
                                       c donot-repeat max-depth symbols listees (1+ depth) nil))
                                   ((cdr DC) (display-callees*
                                        c donot-repeat max-depth symbols listees (1+ depth) nil))
                                   (t (display-callees*
                                        c donot-repeat max-depth symbols listees (1+ depth) t))))
                              (setf DC (cdr DC)))
                          (pushnew depth *line-columns* :test 'eql)
                          (line-indent depth) (princ "--") (princ f) (princ "   ") (terpri)
                          (setf *blank-line* nil)
                          (when last? (pull depth *line-columns*))
                          (when (> number 0) (pushnew (1+ depth) *line-columns* :test 'eql))
                          (dolist (c DC)
                              (cond
                                ((cdr DC)
                                  (display-callees*
                                    c donot-repeat max-depth symbols listees (1+ depth) nil))
                                (t (display-callees*
                                     c donot-repeat max-depth symbols listees (1+ depth) t)))
                              (setf DC (cdr DC)))
                          (when
                               (and (not *blank-line*) draw-line? (< depth max-depth))
                               (line-indent depth) (terpri) (setf *blank-line* t))
                          )))))

(defunction line-indent (n)
    (dotimes (x n)
        (princ "	") (when (mem (1+ x) *line-columns*) (princ "|"))))

;This returns a list of all functions owned by the current package
;that are not called by functions on function-list.  Function-list
;can be either a list of functions or the name of a single function.  This takes
;a long time to run.  The results are saved in *uncalled-callers*.
(defun uncalled-callers (function-list &key print order)
   (terpri) (princ "Computing callees.  Please wait (this is slow).") (terpri)
   (princ "You might want to have a cup of coffee.") (terpri) (terpri)
   (setq *callees*
            (if (listp function-list)
              (unionmapcar #'callees function-list)
              (callees function-list)))
   (princ "Never fear -- I am making progress!  I am now surveying symbols.")
   (terpri)  (princ "Was the coffee good?")  (terpri)
   (setq *uncalled-callers*
            (subset #'(lambda (f) (and (not (mem f *callees*))
                                                      (fbound-current f)))
                        (package-symbols)))
   (cond (order  (terpri)
                          (princ "By  the way, how's your sex life these days?") (terpri)
                          (setq *uncalled-callers* (sort *uncalled-callers* 'lessp))))
   (cond (print 
              (terpri) (princ "The following functions are not called:") (terpri)
              (p-print *uncalled-callers*) (terpri))
             (t (princ "Done at last!")))
   (princ "This list is saved in *uncalled-callers*") (terpri))

;This tests to see whether fun is fbound in the current package and owned
;by it:
(defun fbound-current (fun)
   (and (fboundp fun)
           (equal (symbol-package fun) *package*)))

;This lists all the symbols owned by a package:
(defun package-symbols (&optional pkg)
   (cond ((null pkg) (setq pkg *package*)))
   (let ((X nil))
     (do-symbols (y pkg)
        (cond ((equal (symbol-package y) *package*)
                   (setq X (cons y X)))))
     X))

(defun export-all (&optional pkg)
   (cond ((null pkg) (setq pkg *package*)))
   (mapcar #'export (package-symbols pkg)))

(defun remove-package (&optional pkg)
   (if (null pkg) (setq pkg *package*))
   (for-all (package-symbols pkg) #'unintern) nil)


(defvar *tools-loaded* t)
