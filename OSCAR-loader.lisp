#| IMPORTANT!  You must edit thefollowing definition to replacethe string (enclosed in quotationmarks) by the pathnameof the folder in which you haveplaced the OSCAR files. |#(setf oscar-pathname #p"")#|(ed #p"Macintosh HD:Users:binghe:Lisp:OSCAR-Lisp:OSCAR-loader.lisp")|#(setf oscar-pathname #p"Macintosh HD:Users:binghe:Lisp:OSCAR-Lisp:")(load (merge-pathnames oscar-pathname "package.lisp"))(load (merge-pathnames oscar-pathname "OSCAR-TOOLS.lisp"))(load (merge-pathnames oscar-pathname "Syntax_3.lisp"))(load (merge-pathnames oscar-pathname "base.lisp"))(load (merge-pathnames oscar-pathname "Assignment-trees_3-26.lisp"))(load (merge-pathnames oscar-pathname "OSCAR_3-31.lisp"));=====================================================================(when (equal (lisp-implementation-type) "Macintosh Common Lisp")  (load (merge-pathnames oscar-pathname "oscar-graphics17.lisp")));=====================================================================(defvar *prob-compiler-loaded* nil)(when (null *prob-compiler-loaded*)  (load (merge-pathnames oscar-pathname "Reason-macros_3-31.lisp"))  (load (merge-pathnames oscar-pathname "Prob-compiler_3-24.lisp"))  (setf *prob-compiler-loaded* t))(defvar *problems-loaded* nil)(when (null *problems-loaded*)  (load (merge-pathnames oscar-pathname "Rules_3-30.lisp"))  ;; combined sentential, defeasible, and first-order problems  (load (merge-pathnames oscar-pathname "Combined-problems.lisp"))  (load (merge-pathnames oscar-pathname "Agent-arguments5.lisp"))  (setf *problems-loaded* t))