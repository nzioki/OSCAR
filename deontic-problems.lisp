;;; Legal reasoning problems(in-package "OSCAR")(defvar *deontic-problems*)(setq *deontic-problems*  (make-problem-list "Problem #1(Forb A) entails (Perm ~A)Given premises:     (Forb A)    justification = 1.0Ultimate epistemic interests:     (Perm ~A)    interest = 1.0Problem #2Permission Does Not Entail FacultativenessGiven premises:     (Perm A)    justification = 1.0Ultimate epistemic interests:     (Fault A)    interest = 1.0Problem #3Facultativeness Entail PermissionGiven premises:     (Fault A)    justification = 1.0Ultimate epistemic interests:     (Perm A)    interest = 1.0Problem #4OG-obligation generic-makingGiven premises:     (A -> B)   justification = 1.0     (Obl A)    justification = 1.0Ultimate epistemic interests:     (Obl B)    interest = 1.0Problem #5The Definition of PermissionGiven premises:Ultimate epistemic interests:     (all A)((Perm (Does A)) <-> ~(Forb (Does A)))    interest = 1.0Problem #6The Alternative Definition of PermissionGiven premises:Ultimate epistemic interests:     (all A)((Perm (Does A)) <-> ~(Obl ~(Does A)))    interest = 1.0"))