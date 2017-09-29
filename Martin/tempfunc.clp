(defrule sort-by-distance
	(not (print-sorted))
	?u2 <- (unprinted-phase2 ?restName)
	?iter <- (suggestion-iter ?iterValue)
	(numberOfSugg ?suggNum)
	(suggestion (rest_name ?restName) (recommendation-type ?recommendation) (distance ?dist) (score ?scr))
	(forall (and (unprinted-phase2 ?name) (suggestion (rest_name ?name) (recommendation-type ?recommendation) (distance ?d) (score ?s)))
          (test (>= ?d ?dist)))
=>
	(retract ?iter)
	(if (< ?iterValue ?suggNum) then
		(assert (suggestion-iter (+ ?iterValue 1)))
		(retract ?u2)
		(printout t ?recommendation " : " ?restName "(" ?dist ")" crlf)))
