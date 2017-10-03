;; Rules and functions

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
	(printout t "How many suggestions do you want ? ")
	(bind ?suggNum (readline))

	(if (isEmpty ?name) then 
		(bind ?name UNNAMED))
	(if (isEmpty ?smoke) then 
		(bind ?smoke no))
	(if (isEmpty ?minbudget) then
		(bind ?minbudget 9999)
		(bind ?minbudget (float ?minbudget))
		(assert (empty minBudget)))	
	(if (isEmpty ?maxbudget) then
		(bind ?maxbudget 9999)
		(bind ?maxbudget (float ?maxbudget))
		(assert (empty maxBudget)))
	(if (isEmpty ?clothes) then 
		(bind ?clothes casual))
	(if (isEmpty ?wifi) then 
		(bind ?wifi yes))
	(if (isEmpty ?latcoord) then 
		(bind ?latcoord -6))
	(if (isEmpty ?longcoord) then 
		(bind ?longcoord 107))
	(if (isEmpty ?suggNum) then 
		(bind ?suggNum 10))

	(assert (numberOfSuggestion ?suggNum))
	(assert (cust_preference (cust_name ?name) (isSmoker ?smoke) (minBudget ?minbudget) (maxBudget ?maxbudget) (dresscode ?clothes) (hasWifi ?wifi) (latitude ?latcoord) (longitude ?longcoord)))
	(printout t crlf)
)

(defrule match-preference
	?cp <- (cust_preference (cust_name ?custName) (isSmoker ?custSmoke) (minBudget ?custMinBudget) (maxBudget ?custMaxBudget) (dresscode ?custClothe) (hasWifi ?custWifi) (latitude ?custLat) (longitude ?custLong))
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
=>
   (bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 1)))
   (bind ?facts (sort cost-sort ?facts))
   (bind ?facts (sort distance-sort ?facts))
   (progn$ (?f ?facts)
      (printout t "Very recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) " and cost " (fact-slot-value ?f minBudget) crlf)))

(defrule print-recommended
=>
   (bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 2)))
   (bind ?facts (sort cost-sort ?facts))
   (bind ?facts (sort distance-sort ?facts))
   (progn$ (?f ?facts)
      (printout t "Recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) " and cost " (fact-slot-value ?f minBudget) crlf)))

(defrule print-not-recommended
=>
   (bind ?facts (find-all-facts ((?f suggestion)) (= (fact-slot-value ?f recommendation-type) 3)))
   (bind ?facts (sort cost-sort ?facts))  
   (bind ?facts (sort distance-sort ?facts))
   (progn$ (?f ?facts)
      (printout t "Not recommended : Restaurant " (fact-slot-value ?f rest_name) " with distance " (fact-slot-value ?f distance) " and cost " (fact-slot-value ?f minBudget) crlf)))