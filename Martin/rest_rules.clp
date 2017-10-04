;; Rules

(deffunction isEmpty (?str)
=>
	(return (= (length ?str) 0))
)

(defmethod float ((?s STRING))
   (float (string-to-field ?s)))

(defrule ask-preference
=>
	(printout t "What is your name ? ")
	(bind ?name (readline))
	(printout t "Do you smoke ? (yes / no) ")
	(bind ?smoke (readline))
	(printout t "What is your minimum budget ? [0-9999] ")
	(bind ?minbudget (readline))
	(printout t "What is your maximum budget ? [0-9999] ")
	(bind ?maxbudget (readline))
	(printout t "What clothes are you wearing ? (casual, informal, formal) ")
	(bind ?clothes (readline))
	(printout t "Do you want a restaurant with wifi ? (yes / no) ")
	(bind ?wifi (readline))
	(printout t "What are you lat. coordinate ? ")
	(bind ?latcoord (readline))
	(printout t "What are you long. coordinate ? ")
	(bind ?longcoord (readline))

	(if (isEmpty ?name) then 
		(bind ?name UNNAMED))
	(bind ?maxbudget (sym-cat ?maxbudget))
	(if (isEmpty ?smoke) then 
		(bind ?smoke no))
	(bind ?smoke (sym-cat ?smoke))
	(if (isEmpty ?minbudget) then
		(bind ?minbudget 0)
		(assert (empty minBudget))
	else
		(bind ?maxbudget (str-cat ?maxbudget)))
	(bind ?minbudget (float ?minbudget))
	(if (isEmpty ?maxbudget) then
		(bind ?maxbudget 9999)
		(assert (empty maxBudget))
	else
		(bind ?maxbudget (str-cat ?maxbudget)))
	(bind ?maxbudget (float ?maxbudget))
	(if (isEmpty ?clothes) then 
		(bind ?clothes casual))
	(bind ?clothes (sym-cat ?clothes))
	(if (isEmpty ?wifi) then 
		(bind ?wifi yes))
	(bind ?wifi (sym-cat ?wifi))
	(if (isEmpty ?latcoord) then 
		(bind ?latcoord -6.8))
	(bind ?latcoord (float ?latcoord))
	(if (isEmpty ?longcoord) then 
		(bind ?longcoord 107.6))
	(bind ?longcoord (float ?longcoord))

	(assert (vr-to-print 3))
	(assert (cust_preference (cust_name ?name) (isSmoker ?smoke) (minBudget ?minbudget) (maxBudget ?maxbudget) (dresscode ?clothes) (hasWifi ?wifi) (latitude ?latcoord) (longitude ?longcoord)))
	(printout t crlf)
)

(defrule match-preference
	(cust_preference (cust_name ?custName) (isSmoker ?custSmoke) (minBudget ?custMinBudget) (maxBudget ?custMaxBudget) (dresscode ?custClothe) (hasWifi ?custWifi) (latitude ?custLat) (longitude ?custLong))
	(restaurant (rest_name ?restName) (isSmoker ?restSmoke) (minBudget ?restMinBudget) (maxBudget ?restMaxBudget) (dresscode ?restClothe) (hasWifi ?restWifi) (latitude ?restLat) (longitude ?restLong))
	(not (suggestion (rest_name ?restName)))
=>
	;; Scoring

	(bind ?counter 0)
	(if (eq ?restSmoke ?custSmoke) then
		(bind ?counter (+ ?counter 1)))
	(if (or (and (<= ?restMinBudget ?custMinBudget) (>= ?restMaxBudget ?custMaxBudget))
			(and (<= ?restMinBudget ?custMinBudget) (<= ?restMaxBudget ?custMaxBudget))
			(and (>= ?restMinBudget ?custMinBudget) (>= ?restMaxBudget ?custMaxBudget))
			(and (>= ?restMinBudget ?custMinBudget) (<= ?restMaxBudget ?custMaxBudget))) then
		(bind ?counter (+ ?counter 1)))
;	(if (<= ?restMaxBudget ?custMaxBudget) then
;		(bind ?counter (+ ?counter 1)))
	(if (eq ?restClothe ?custClothe) then
		(bind ?counter (+ ?counter 1)))
	(if (eq ?restWifi ?custWifi) then
		(bind ?counter (+ ?counter 1)))
	(if (= ?counter 4) then
		(bind ?recommendation 1)d
	else (if (<= ?counter 2) then
			(bind ?recommendation 3)
		else
			(bind ?recommendation 2)
		)
	)

	;; Euclidean distance
	
	(bind ?dist (sqrt (+ (** (abs (- ?restLat ?custLat)) 2) (** (abs (- ?restLong ?custLong)) 2))))

	(assert (suggestion (rest_name ?restName) (recommendation-type ?recommendation) (distance ?dist) (minBudget ?restMinBudget)))
)

(defrule assert-unprinted
	(declare (salience -10))
	(suggestion (rest_name ?restName))
=>
	(assert (unprinted ?restName)))

(deffunction distance-sort (?f1 ?f2)
   (> (fact-slot-value ?f1 distance) (fact-slot-value ?f2 distance)))

(deffunction cost-sort (?f1 ?f2)
   (> (fact-slot-value ?f1 minBudget) (fact-slot-value ?f2 minBudget)))

(defrule print-very-recommended
	?u <- (vr-to-print ?r)
=>
	(bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 1)))
   (bind ?facts (sort cost-sort ?facts))
   (bind ?facts (sort distance-sort ?facts))
	(bind ?n ?r)
	(bind ?i 1)
	(progn$ (?f ?facts)
   		(if (<= ?i ?n) then
   			(printout t "Very recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) " and cost " (fact-slot-value ?f minBudget) crlf))
   			(bind ?i (+ ?i 1)))
   	(retract ?u)
   	(assert (r-to-print (+ (- ?n ?i) 1))))

(defrule print-recommended
	?u <- (r-to-print ?r)
=>
	(bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 2)))
   (bind ?facts (sort cost-sort ?facts))
   (bind ?facts (sort distance-sort ?facts))
	(bind ?n ?r)
	(bind ?i 1)
	(progn$ (?f ?facts)
   		(if (<= ?i ?n) then
   			(printout t "Recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) " and cost " (fact-slot-value ?f minBudget) crlf))
   			(bind ?i (+ ?i 1)))
   	(retract ?u)
   	(assert (nr-to-print (+ (- ?n ?i) 1))))

(defrule print-not-recommended
	?u <- (nr-to-print ?r)
=>
	(bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 3)))
   (bind ?facts (sort cost-sort ?facts))
   (bind ?facts (sort distance-sort ?facts))
	(bind ?n ?r)
	(bind ?i 1)
	(progn$ (?f ?facts)
   		(if (<= ?i ?n) then
   			(printout t "Not recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) " and cost " (fact-slot-value ?f minBudget) crlf))
   			(bind ?i (+ ?i 1)))
   	(retract ?u))