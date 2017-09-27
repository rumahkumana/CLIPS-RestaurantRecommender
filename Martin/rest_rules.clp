;; Rules

(deffacts restaurantList
	(restaurant (rest_name A) (isSmoker yes) (minBudget 1000) (maxBudget 2000) (dresscode casual) (hasWifi yes) (latitude -6.8922186) (longitude 107.5886173))
	(restaurant (rest_name B) (isSmoker no) (minBudget 1200) (maxBudget 2500) (dresscode informal) (hasWifi yes) (latitude -6.224085) (longitude 106.7859815))
	(restaurant (rest_name C) (isSmoker yes) (minBudget 2000) (maxBudget 4000) (dresscode formal) (hasWifi no) (latitude	-6.2145285) (longitude 106.8642591))
	(restaurant (rest_name D) (isSmoker no) (minBudget 500) (maxBudget 1400) (dresscode formal) (hasWifi no) (latitude -6.9005363) (longitude 107.6222191))
	(restaurant (rest_name E) (isSmoker yes) (minBudget 1000) (maxBudget 2000) (dresscode informal, casual) (hasWifi yes) (latitude -6.2055617) (longitude 106.8001597))
	(restaurant (rest_name F) (isSmoker no) (minBudget 2500) (maxBudget 5000) (dresscode informal) (hasWifi yes) (latitude -6.9045679) (longitude 107.6399745))
	(restaurant (rest_name G) (isSmoker yes) (minBudget 1300) (maxBudget 3000) (dresscode casual) (hasWifi yes) (latitude -6.1881082) (longitude 106.7844409))
	(restaurant (rest_name H) (isSmoker no) (minBudget 400) (maxBudget 1000) (dresscode informal) (hasWifi no) (latitude -6.9525133) (longitude 107.6052906))
	(restaurant (rest_name I) (isSmoker no) (minBudget 750) (maxBudget 2200) (dresscode informal, casual) (hasWifi yes) (latitude -6.9586985) (longitude 107.7092281))
	(restaurant (rest_name J) (isSmoker no) (minBudget 1500) (maxBudget 2000) (dresscode casual) (hasWifi yes) (latitude -6.2769732) (longitude 106.775133))
	)

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

		(assert (cust_preference (cust_name ?name) (isSmoker ?smoke) (minBudget ?minbudget) (maxBudget ?maxbudget) (dresscode ?clothes) (hasWifi ?wifi) (latitude ?latcoord) (longitude ?longcoord)))
)

(defrule match-preference
	?cust <- (cust_preference (cust_name ?custName) (isSmoker ?custSmoke) (minBudget ?custMinBudget) (maxBudget ?custMaxBudget) (dresscode ?custClothe $?custClothes) (hasWifi ?custWifi) (latitude ?custLat) (longitude ?custLong))
	(restaurant (rest_name ?restName) (isSmoker ?restSmoke) (minBudget ?restMinBudget) (maxBudget ?restMaxBudget) (dresscode ?restClothe $?restClothes) (hasWifi ?restWifi) (latitude ?restLat) (longitude ?restLong))
=>
	(bind ?counter 0)
	(if (eq ?restSmoke ?custSmoke) then
		(bind ?counter (+ ?counter 1)))
;	(if (eq ?dresscode ) then
;		(bind ?counter (+ ?counter 1)))
	(if (eq ?restWifi ?custWifi) then
		(bind ?counter (+ ?counter 1)))
	(assert (counter ?counter))
	(if (> ?counter 1) then
		(bind ?recommendation "Very Recommended")
	else
		(bind ?recommendation "Recommended"))
	(assert (suggestion (rest_name ?restName) (recommendation-type ?recommendation)))
	(retract ?cust)
	(printout t "Nama restoran :  " ?restName crlf)
)

