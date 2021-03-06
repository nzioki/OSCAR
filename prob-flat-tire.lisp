;; FLAT TIRE PROBLEM

(in-package "OSCAR")

(SOLVE-PLANNING-PROBLEM)

(make-planning-problem
    :number 1
    :message "Flat tire problem with types for planner 41 using relativized quantifiers"
    :goal  

       ;  "(& ( on wheel2 hub)
       ;        ( tight nuts hub))"

         "(& ~( is-open boot)
               ( in jack boot)
               ( in pump boot)
               ( in wheel1 boot)
               ( in wrench boot)
               ( tight nuts hub)
               ( inflated wheel2)
               ( on wheel2 hub))"

    :reasons
    protoplan
    null-plan
    goal-regression
    split-conjunctive-goal
    relativized-UI
    REUSE-NODES
    REUSE-NODE
    protoplan-for-goal
    REUSE-PLANS
    simplify-=>
    =>-adjunction
    =>-neg1
    =>-neg2
    undermine-causal-links
    undermine-embedded-causal-links
    plan-undermines-first-causal-link
    plan-undermines-another-causal-link
    plan-undermines-causal-link
    embellished-protoplan-for-goal
    embellished-protoplan
    embedded-null-plan
    split-embedded-conjunctive-goal
    embedded-goal-regression 
    add-ordering-constraints
    add-embedded-ordering-constraints
    confrontation
    embedded-confrontation
    :premises
          ("(:type wheel1 wheel)" .99 nil t)
          ("(:type wheel2 wheel)" .99 nil t)
          ("(:type hub isa-hub)" .99 nil t)
          ("(:type nuts are-nuts)" .99 nil t)
          ("(:type boot container)" .99 nil t)
          ("( intact wheel2)" .99 nil t)
          ("( in jack boot)" .99 nil t)
          ("( in pump boot)" .99 nil t)
          ("( in wheel2 boot)" .99 nil t)
          ("( in wrench boot)" .99 nil t)
          ("( on wheel1 hub)" .99 nil t)
          ("( on-ground hub)" .99 nil t)
          ("( tight nuts hub)" .99 nil t)
          ("~( locked boot)" .99 nil t)
          ("~( is-open boot)" .99 nil t)
          ("~( inflated wheel2)" .99 nil t)
          ("~( unfastened hub)" .99 nil t)
          ("(all x :type container)( ((~( locked x) & ~( is-open x)) & ( open-up x)) => ( is-open x))" .99 nil t)
          ("(all x :type container)( (( is-open x) & ( close x)) => ~( is-open x))" .99 nil t)
          ("(all x)(all y :type container)( ((( in x y) & ( is-open y)) & ( fetch x y)) => (( have x) & ~( in x y)))" .99 nil t)
          ("(all x)(all y :type container)( ((( have x) & ( is-open y)) & ( put-away x y)) => (~( have x) & ( in x y)))" .99 nil t)
          ("(all x :type are-nuts)(all y :type isa-hub)( ((( have wrench) & (( tight x y) & ( on-ground y))) & ( loosen x y)) => (( loose x y) & ~( tight x y)))" .99 nil t)
          ("(all x :type are-nuts)(all y :type isa-hub)( ((( have wrench) & (( loose x y) & ( on-ground y))) & ( tighten x y)) => (( tight x y) & ~( loose x y)))" .99 nil t)
          ("(all x :type isa-hub)( ((( on-ground x) & ( have jack)) & ( jack-up x)) => (~( on-ground x) & ~( have jack)))" .99 nil t)
          ("(all x :type isa-hub)( (~( on-ground x) & ( jack-down x)) => (( on-ground x) & ( have jack)))" .99 nil t)
          ("(all x :type are-nuts)(all y :type isa-hub)( ((~( on-ground y) & (~( unfastened y) & (( have wrench) & ( loose x y)))) & ( undo x y)) => (( have x) & (( unfastened y) & (~( on x y) & ~( loose x y)))))" .99 nil t)
          ("(all x :type are-nuts)(all y :type isa-hub)( ((~( on-ground y) & (( unfastened y) & (( have wrench) & ( have x)))) & ( do-up x y)) => (( loose x y) & (~( unfastened y) & ~( have x))))" .99 nil t)
          ("(all x :type wheel)(all y :type isa-hub)( ((~( on-ground y) & (( on x y) & ( unfastened y))) & ( remove-wheel x y)) => (( have x) & (( wheeless y) & ~( on x y))))" .99 nil t)
          ("(all x :type wheel)(all y :type isa-hub)( ((( have x) & (( wheeless y) & (( unfastened y) & ~( on-ground y)))) & ( put-on-wheel x y)) => (( on x y) & (~( have x) & ~( wheeless y))))" .99 nil t)
          ("(all x :type wheel)( ((( have pump) & (~( inflated x) & ( intact x))) & ( inflate x)) => ( inflated x))" .99 nil t)
    )

(SOLVE-PLANNING-PROBLEM)

(make-planning-problem
    :number 1
    :message "Flat tire problem with types for planner 41"
    :goal  

        ; "(& ( on wheel2 hub)
        ;       ( tight nuts hub)
        ;       ( in wrench boot))"

         "(& ( on wheel2 hub)
               ( tight nuts hub))"

       ;  "(& ~( is-open boot)
       ;        ( in jack boot)
       ;        ( in pump boot)
       ;        ( in wheel1 boot)
       ;        ( in wrench boot)
       ;        ( tight nuts hub)
       ;        ( inflated wheel2)
       ;        ( on wheel2 hub))"

       ;  "(& ( on wheel2 hub)
       ;        ( tight nuts hub)
       ;         ~( is-open boot)
       ;        ( in jack boot)
       ;        ( in pump boot)
       ;        ( in wheel1 boot)
       ;        ( inflated wheel2)
       ;       )"
       ;      ;  ( in wrench boot)
       ;     ;   ( inflated wheel2)
       ;     ; )"

    :reasons
    protoplan
    null-plan
    goal-regression
    split-conjunctive-goal
    type-instantiation
    REUSE-NODES
    REUSE-NODE
    protoplan-for-goal
    REUSE-PLANS
    simplify-=>
    =>-adjunction
    =>-neg1
    =>-neg2
    undermine-causal-links
    undermine-embedded-causal-links
    plan-undermines-first-causal-link
    plan-undermines-another-causal-link
    plan-undermines-causal-link
    embellished-protoplan-for-goal
    embellished-protoplan
    embedded-null-plan
    split-embedded-conjunctive-goal
    embedded-type-instantiation
    embedded-goal-regression 
    add-ordering-constraints
    add-embedded-ordering-constraints
    confrontation
    embedded-confrontation
    :premises
          ("(:type wheel1 wheel)" .99 nil t)
          ("(:type wheel2 wheel)" .99 nil t)
          ("(:type hub isa-hub)" .99 nil t)
          ("(:type nuts are-nuts)" .99 nil t)
          ("(:type boot container)" .99 nil t)
          ("( intact wheel2)" .99 nil t)
          ("( in jack boot)" .99 nil t)
          ("( in pump boot)" .99 nil t)
          ("( in wheel2 boot)" .99 nil t)
          ("( in wrench boot)" .99 nil t)
          ("( on wheel1 hub)" .99 nil t)
          ("( on-ground hub)" .99 nil t)
          ("( tight nuts hub)" .99 nil t)
          ("~( locked boot)" .99 nil t)
          ("~( is-open boot)" .99 nil t)
          ("~( inflated wheel2)" .99 nil t)
          ("~( unfastened hub)" .99 nil t)
          ("(all x)( (((:type x container) & (~( locked x) & ~( is-open x))) & ( open-up x)) => ( is-open x))" .99 nil t)
          ("(all x)( (((:type x container) & ( is-open x)) & ( close x)) => ~( is-open x))" .99 nil t)
          ("(all x)(all y)( (((:type y container) & (( in x y) & ( is-open y))) & ( fetch x y)) => (( have x) & ~( in x y)))" .99 nil t)
          ("(all x)(all y)( (((:type y container) & (( have x) & ( is-open y))) & ( put-away x y)) => (~( have x) & ( in x y)))" .99 nil t)
          ("(all x)(all y)( (((:type x are-nuts) & ((:type y isa-hub) & (( have wrench) & (( tight x y) & ( on-ground y))))) & ( loosen x y)) => (( loose x y) & ~( tight x y)))" .99 nil t)
          ("(all x)(all y)( (((:type x are-nuts) & ((:type y isa-hub) & (( have wrench) & (( loose x y) & ( on-ground y))))) & ( tighten x y)) => (( tight x y) & ~( loose x y)))" .99 nil t)
          ("(all x)( (((:type x isa-hub) & (( on-ground x) & ( have jack))) & ( jack-up x)) => (~( on-ground x) & ~( have jack)))" .99 nil t)
          ("(all x)( (((:type x isa-hub) & ~( on-ground x)) & ( jack-down x)) => (( on-ground x) & ( have jack)))" .99 nil t)
          ("(all x)(all y)( (((:type x are-nuts) & ((:type y isa-hub) & (~( on-ground y) & (~( unfastened y) & (( have wrench) & ( loose x y)))))) & ( undo x y)) => (( have x) & (( unfastened y) & (~( on x y) & ~( loose x y)))))" .99 nil t)
          ("(all x)(all y)( (((:type x are-nuts) & ((:type y isa-hub) & (~( on-ground y) & (( unfastened y) & (( have wrench) & ( have x)))))) & ( do-up x y)) => (( loose x y) & (~( unfastened y) & ~( have x))))" .99 nil t)
          ("(all x)(all y)( (((:type x wheel) & ((:type y isa-hub) & (~( on-ground y) & (( on x y) & ( unfastened y))))) & ( remove-wheel x y)) => (( have x) & (( wheeless y) & ~( on x y))))" .99 nil t)
          ("(all x)(all y)( (((:type x wheel) & ((:type y isa-hub) & (( have x) & (( wheeless y) & (( unfastened y) & ~( on-ground y)))))) & ( put-on-wheel x y)) => (( on x y) & (~( have x) & ~( wheeless y))))" .99 nil t)
          ("(all x)( (((:type x wheel) & (( have pump) & (~( inflated x) & ( intact x)))) & ( inflate x)) => ( inflated x))" .99 nil t)
    )

(SOLVE-PLANNING-PROBLEM)

(make-planning-problem
    :number 1
    :message "Flat tire problem for planner 41"
    :goal  

       ;  "(& ( on wheel2 hub)
       ;        ( tight nuts hub))"

         "(& ~( is-open boot)
               ( in jack boot)
               ( in pump boot)
               ( in wheel1 boot)
               ( in wrench boot)
               ( tight nuts hub)
               ( inflated wheel2)
               ( on wheel2 hub))"

    :reasons
    protoplan
    null-plan
    goal-regression
    split-conjunctive-goal
   ; relativized-UI
    REUSE-NODES
    REUSE-NODE
    protoplan-for-goal
    REUSE-PLANS
    simplify-=>
    =>-adjunction
    =>-neg1
    =>-neg2
    undermine-causal-links
    undermine-embedded-causal-links
    plan-undermines-first-causal-link
    plan-undermines-another-causal-link
    plan-undermines-causal-link
    embellished-protoplan-for-goal
    embellished-protoplan
    embedded-null-plan
    split-embedded-conjunctive-goal
    embedded-goal-regression 
    add-ordering-constraints
    add-embedded-ordering-constraints
    confrontation
    embedded-confrontation
    :premises
          ("( wheel wheel1)" .99 nil t)
          ("( wheel wheel2)" .99 nil t)
          ("( isa-hub hub)" .99 nil t)
          ("( are-nuts nuts)" .99 nil t)
          ("( container boot)" .99 nil t)
          ("( intact wheel2)" .99 nil t)
          ("( in jack boot)" .99 nil t)
          ("( in pump boot)" .99 nil t)
          ("( in wheel2 boot)" .99 nil t)
          ("( in wrench boot)" .99 nil t)
          ("( on wheel1 hub)" .99 nil t)
          ("( on-ground hub)" .99 nil t)
          ("( tight nuts hub)" .99 nil t)
          ("~( locked boot)" .99 nil t)
          ("~( is-open boot)" .99 nil t)
          ("~( inflated wheel2)" .99 nil t)
          ("~( unfastened hub)" .99 nil t)
          ("(all x)( ((( container x) & (~( locked x) & ~( is-open x))) & ( open-up x)) => ( is-open x))" .99 nil t)
          ("(all x)( ((( container x) & ( is-open x)) & ( close x)) => ~( is-open x))" .99 nil t)
          ("(all x)(all y)( ((( container y) & (( in x y) & ( is-open y))) & ( fetch x y)) => (( have x) & ~( in x y)))" .99 nil t)
          ("(all x)(all y)( ((( container y) & (( have x) & ( is-open y))) & ( put-away x y)) => (~( have x) & ( in x y)))" .99 nil t)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (( have wrench) & (( tight x y) & ( on-ground y))))) & ( loosen x y)) => (( loose x y) & ~( tight x y)))" .99 nil t)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (( have wrench) & (( loose x y) & ( on-ground y))))) & ( tighten x y)) => (( tight x y) & ~( loose x y)))" .99 nil t)
          ("(all x)( ((( isa-hub x) & (( on-ground x) & ( have jack))) & ( jack-up x)) => (~( on-ground x) & ~( have jack)))" .99 nil t)
          ("(all x)( ((( isa-hub x) & ~( on-ground x)) & ( jack-down x)) => (( on-ground x) & ( have jack)))" .99 nil t)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (~( on-ground y) & (~( unfastened y) & (( have wrench) & ( loose x y)))))) & ( undo x y)) => (( have x) & (( unfastened y) & (~( on x y) & ~( loose x y)))))" .99 nil t)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (~( on-ground y) & (( unfastened y) & (( have wrench) & ( have x)))))) & ( do-up x y)) => (( loose x y) & (~( unfastened y) & ~( have x))))" .99 nil t)
          ("(all x)(all y)( ((( wheel x) & (( isa-hub y) & (~( on-ground y) & (( on x y) & ( unfastened y))))) & ( remove-wheel x y)) => (( have x) & (( wheeless y) & ~( on x y))))" .99 nil t)
          ("(all x)(all y)( ((( wheel x) & (( isa-hub y) & (( have x) & (( wheeless y) & (( unfastened y) & ~( on-ground y)))))) & ( put-on-wheel x y)) => (( on x y) & (~( have x) & ~( wheeless y))))" .99 nil t)
          ("(all x)( ((( wheel x) & (( have pump) & (~( inflated x) & ( intact x)))) & ( inflate x)) => ( inflated x))" .99 nil t)
    )

(SOLVE-PLANNING-PROBLEM)

(make-planning-problem
    :number 1
    :message "Flat tire problem for planner 36"
    :goal  

    ; "(wheel wheel1)"
    ; "(isa-hub hub)"
    ;  "~(on-ground hub)"                  ;; gets this
     ;  "(unfastened hub)"                     ;; gets this

    ;  "(wheeless hub)"                       ;; gets this

     ;  "( on wheel2 hub)"                   ;; gets this

    ;  "(loose nuts hub)"

       ;   "(& ~(on-ground hub) (loose nuts hub))"

       ;  "(& ( on wheel2 hub)
       ;        ( tight nuts hub))"

       ;  "(& ( on wheel2 hub)
       ;        ( loose nuts hub))"

         "(& ( on wheel2 hub)
               ~( is-open boot))"

      ;   "(& ~( is-open boot)
      ;         ( in jack boot)
      ;         ( in pump boot)
      ;         ( in wheel1 boot)
      ;         ( in wrench boot)
      ;         ( tight nuts hub)
      ;         ( inflated wheel2)
      ;         ( on wheel2 hub))"

    :reasons
    protoplan
    null-plan
    goal-regression
    split-conjunctive-goal
    REUSE-NODES
    REUSE-NODE
    plan-node-result
    simplify-=>
    =>-adjunction
    =>-neg1
    =>-neg2
    undermine-causal-links
    undermine-embedded-causal-links
    plan-undermines-first-causal-link
    plan-undermines-another-causal-link
    plan-undermines-causal-link
    embellished-protoplan-for-goal
    embellished-protoplan
    embedded-null-plan
    split-embedded-conjunctive-goal
    embedded-goal-regression 
    add-ordering-constraints
    add-embedded-ordering-constraints
    confrontation
    embedded-confrontation
    :premises
          ("( wheel wheel1)" .99)
          ("( wheel wheel2)" .99)
          ("( isa-hub hub)" .99)
          ("( are-nuts nuts)" .99)
          ("( container boot)" .99)
          ("( intact wheel2)" .99)
          ("( in jack boot)" .99)
          ("( in pump boot)" .99)
          ("( in wheel2 boot)" .99)
          ("( in wrench boot)" .99)
          ("( on wheel1 hub)" .99)
          ("( on-ground hub)" .99)
          ("( tight nuts hub)" .99)
          ("~( locked boot)" .99)
          ("~( is-open boot)" .99)
          ("~( inflated wheel2)" .99)
          ("~( unfastened hub)" .99)
          ("(all x)( ((( container x) & (~( locked x) & ~( is-open x))) & ( open-up x)) => ( is-open x))" .99)
          ("(all x)( ((( container x) & ( is-open x)) & ( close x)) => ~( is-open x))" .99)
          ("(all x)(all y)( ((( container y) & (( in x y) & ( is-open y))) & ( fetch x y)) => (( have x) & ~( in x y)))" .99)
          ("(all x)(all y)( ((( container y) & (( have x) & ( is-open y))) & ( put-away x y)) => (~( have x) & ( in x y)))" .99)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (( have wrench) & (( tight x y) & ( on-ground y))))) & ( loosen x y)) => (( loose x y) & ~( tight x y)))" .99)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (( have wrench) & (( loose x y) & ( on-ground y))))) & ( tighten x y)) => (( tight x y) & ~( loose x y)))" .99)
          ("(all x)( ((( isa-hub x) & (( on-ground x) & ( have jack))) & ( jack-up x)) => (~( on-ground x) & ~( have jack)))" .99)
          ("(all x)( ((( isa-hub x) & ~( on-ground x)) & ( jack-down x)) => (( on-ground x) & ( have jack)))" .99)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (~( on-ground y) & (~( unfastened y) & (( have wrench) & ( loose x y)))))) & ( undo x y)) => (( have x) & (( unfastened y) & (~( on x y) & ~( loose x y)))))" .99)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (~( on-ground y) & (( unfastened y) & (( have wrench) & ( have x)))))) & ( do-up x y)) => (( loose x y) & (~( unfastened y) & ~( have x))))" .99)
          ("(all x)(all y)( ((( wheel x) & (( isa-hub y) & (~( on-ground y) & (( on x y) & ( unfastened y))))) & ( remove-wheel x y)) => (( have x) & (( wheeless y) & ~( on x y))))" .99)
          ("(all x)(all y)( ((( wheel x) & (( isa-hub y) & (( have x) & (( wheeless y) & (( unfastened y) & ~( on-ground y)))))) & ( put-on-wheel x y)) => (( on x y) & (~( have x) & ~( wheeless y))))" .99)
          ("(all x)( ((( wheel x) & (( have pump) & (~( inflated x) & ( intact x)))) & ( inflate x)) => ( inflated x))" .99)
    )

(SOLVE-PLANNING-PROBLEM)

(make-planning-problem
    :number 1
    :message "Flat tire problem for planner 34"
    :goal  
        "(& ( on wheel2 hub)
               ~( is-open boot))"
    :reasons
    protoplan
    null-plan
    goal-regression
    split-conjunctive-goal
    REUSE-NODES
    REUSE-NODE
    protoplan-for-goal
    REUSE-PLANS
    simplify-=>
    =>-adjunction
    =>-neg1
    =>-neg2
    undermine-causal-links
    undermine-embedded-causal-links
    plan-undermines-first-causal-link
    plan-undermines-another-causal-link
    plan-undermines-causal-link
    embellished-protoplan-for-goal
    embellished-protoplan
    embedded-null-plan
    split-embedded-conjunctive-goal
    embedded-goal-regression 
    add-ordering-constraints
    add-embedded-ordering-constraints
    confrontation
    embedded-confrontation
    :premises
          ("( wheel wheel1)" .99)
          ("( wheel wheel2)" .99)
          ("( isa-hub hub)" .99)
          ("( are-nuts nuts)" .99)
          ("( container boot)" .99)
          ("( intact wheel2)" .99)
          ("( in jack boot)" .99)
          ("( in pump boot)" .99)
          ("( in wheel2 boot)" .99)
          ("( in wrench boot)" .99)
          ("( on wheel1 hub)" .99)
          ("( on-ground hub)" .99)
          ("( tight nuts hub)" .99)
          ("~( locked boot)" .99)
          ("~( is-open boot)" .99)
          ("~( inflated wheel2)" .99)
          ("~( unfastened hub)" .99)
          ("(all x)( ((( container x) & (~( locked x) & ~( is-open x))) & ( open-up x)) => ( is-open x))" .99)
          ("(all x)( ((( container x) & ( is-open x)) & ( close x)) => ~( is-open x))" .99)
          ("(all x)(all y)( ((( container y) & (( in x y) & ( is-open y))) & ( fetch x y)) => (( have x) & ~( in x y)))" .99)
          ("(all x)(all y)( ((( container y) & (( have x) & ( is-open y))) & ( put-away x y)) => (~( have x) & ( in x y)))" .99)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (( have wrench) & (( tight x y) & ( on-ground y))))) & ( loosen x y)) => (( loose x y) & ~( tight x y)))" .99)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (( have wrench) & (( loose x y) & ( on-ground y))))) & ( tighten x y)) => (( tight x y) & ~( loose x y)))" .99)
          ("(all x)( ((( isa-hub x) & (( on-ground x) & ( have jack))) & ( jack-up x)) => (~( on-ground x) & ~( have jack)))" .99)
          ("(all x)( ((( isa-hub x) & ~( on-ground x)) & ( jack-down x)) => (( on-ground x) & ( have jack)))" .99)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (~( on-ground y) & (~( unfastened y) & (( have wrench) & ( loose x y)))))) & ( undo x y)) => (( have x) & (( unfastened y) & (~( on x y) & ~( loose x y)))))" .99)
          ("(all x)(all y)( ((( are-nuts x) & (( isa-hub y) & (~( on-ground y) & (( unfastened y) & (( have wrench) & ( have x)))))) & ( do-up x y)) => (( loose x y) & (~( unfastened y) & ~( have x))))" .99)
          ("(all x)(all y)( ((( wheel x) & (( isa-hub y) & (~( on-ground y) & (( on x y) & ( unfastened y))))) & ( remove-wheel x y)) => (( have x) & (( wheeless y) & ~( on x y))))" .99)
          ("(all x)(all y)( ((( wheel x) & (( isa-hub y) & (( have x) & (( wheeless y) & (( unfastened y) & ~( on-ground y)))))) & ( put-on-wheel x y)) => (( on x y) & (~( have x) & ~( wheeless y))))" .99)
          ("(all x)( ((( wheel x) & (( have pump) & (~( inflated x) & ( intact x)))) & ( inflate x)) => ( inflated x))" .99)
    )

(SOLVE-PLANNING-PROBLEM)
