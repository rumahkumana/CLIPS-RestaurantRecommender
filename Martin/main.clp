(deftemplate recommendation
   (slot name)
   (slot message)
   (slot rating))

(deffacts recommendations
   (recommendation (name chocolate) (rating 10.0))
   (recommendation (name vanilla) (rating 6.8))
   (recommendation (name strawberry) (rating 8.5)))

(deffunction rating-sort (?f1 ?f2)
   (> (fact-slot-value ?f1 rating) (fact-slot-value ?f2 rating)))

(defrule print
   =>
   (bind ?facts (find-all-facts ((?f recommendation)) TRUE))
   (bind ?facts (sort rating-sort ?facts))
   (progn$ (?f ?facts)
      (printout t (fact-slot-value ?f name) " has rating " (fact-slot-value ?f rating) "." crlf)))