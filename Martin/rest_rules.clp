;; Rules

(defrule ask-preference
=>
	(printout t "What is your name ? ")
	(bind ?name (read))
	(printout t "Do you smoke ? (yes / no) ")
	(bind ?smoke (read))
	(printout t "What is your minimum budget ? [0-9999] ")
	(bind ?minbudget (read))
	(printout t "What is your maximum budget ? [0-9999] ")
	(bind ?maxbudget (read))
	(printout t "What clothes are you wearing ? (casual, informal, formal) ")
	(bind ?clothes (read))
	(printout t "Do you want a restaurant with wifi ? (yes / no) ")
	(bind ?wifi (read))
	(printout t "What are you lat. coordinate ? ")
	(bind ?latcoord (read))
	(printout t "What are you long. coordinate ? ")
	(bind ?longcoord (read))
	(printout t "How many suggestions do you want ? ")
	(bind ?suggNum (read))

	(assert (numberOfSuggestion ?suggNum))
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
		(printout t ?restName " Match isSmoke" crlf)
		(bind ?counter (+ ?counter 1)))
	(if (>= ?restMinBudget ?custMinBudget) then
		(printout t ?restName " Match minBudget" crlf)
		(bind ?counter (+ ?counter 1)))
	(if (<= ?restMaxBudget ?custMaxBudget) then
		(printout t ?restName " Match maxBudget" crlf)
		(bind ?counter (+ ?counter 1)))
	(if (eq ?restClothe ?custClothe) then
		(printout t ?restName " Match dresscode" crlf)
		(bind ?counter (+ ?counter 1)))
	(if (eq ?restWifi ?custWifi) then
		(printout t ?restName " Match hasWifi" crlf)
		(bind ?counter (+ ?counter 1)))
	(if (= ?counter 5) then
		(bind ?recommendation 1)
	else (if (<= ?counter 2) then
			(bind ?recommendation 3)
		else
			(bind ?recommendation 2)
		)
	)

	(printout t ?restName " " ?counter " " ?recommendation crlf)
	;; Euclidean distance
	
	(bind ?dist (sqrt (+ (** (abs (- ?restLat ?custLat)) 2) (** (abs (- ?restLong ?custLong)) 2))))

	(assert (suggestion (rest_name ?restName) (recommendation-type ?recommendation) (distance ?dist)))
)

(defrule assert-unprinted
	(declare (salience -10))
	(suggestion (rest_name ?restName))
=>
	(assert (unprinted ?restName)))

(deffunction distance-sort (?f1 ?f2)
   (> (fact-slot-value ?f1 distance) (fact-slot-value ?f2 distance)))


(defrule print-very-recommended

=>
   (bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 1)))
   (bind ?facts (sort distance-sort ?facts))
   (progn$ (?f ?facts)
      (printout t "Very recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) "." crlf)))

(defrule print-recommended
=>
   (bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 2)))
   (bind ?facts (sort distance-sort ?facts))
   (progn$ (?f ?facts)
      (printout t "Recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) "." crlf)))

(defrule print-not-recommended
=>
   (bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 3)))
   (bind ?facts (sort distance-sort ?facts))
   (progn$ (?f ?facts)
      (printout t "Not recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) "." crlf)))