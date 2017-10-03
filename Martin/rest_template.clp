; Templates dan initial facts

; Template untuk merepresentasikan restoran.
(deftemplate restaurant
  (slot rest_name) 
  (slot isSmoker)
  (slot minBudget)
  (slot maxBudget)
  (slot dresscode)
  (slot hasWifi)
  (slot latitude)
  (slot longitude)
 )

; Template untuk merepresentasikan customer preference.
(deftemplate cust_preference
  (slot cust_name)
  (slot isSmoker)
  (slot minBudget)
  (slot maxBudget)
  (slot dresscode)
  (slot hasWifi)
  (slot latitude)
  (slot longitude)
)


; Template untuk merepresentasikan restaurant suggestion.
(deftemplate suggestion
  (slot rest_name)
  (slot recommendation-type) ; Very recommended / recommended / not recommended
  (slot distance)
)

; Facts awal untuk restoran

(deffacts restaurantList
  (restaurant (rest_name A) (isSmoker yes) (minBudget 1000) (maxBudget 2000) (dresscode casual) (hasWifi yes) (latitude -6.8922186) (longitude 107.5886173))
  (restaurant (rest_name B) (isSmoker no) (minBudget 1200) (maxBudget 2500) (dresscode informal) (hasWifi yes) (latitude -6.224085) (longitude 106.7859815))
  (restaurant (rest_name C) (isSmoker yes) (minBudget 2000) (maxBudget 4000) (dresscode formal) (hasWifi no) (latitude  -6.2145285) (longitude 106.8642591))
  (restaurant (rest_name D) (isSmoker no) (minBudget 500) (maxBudget 1400) (dresscode formal) (hasWifi no) (latitude -6.9005363) (longitude 107.6222191))
  (restaurant (rest_name E) (isSmoker yes) (minBudget 1000) (maxBudget 2000) (dresscode informal) (hasWifi yes) (latitude -6.2055617) (longitude 106.8001597))
  (restaurant (rest_name E) (isSmoker yes) (minBudget 1000) (maxBudget 2000) (dresscode casual) (hasWifi yes) (latitude -6.2055617) (longitude 106.8001597))
  (restaurant (rest_name F) (isSmoker no) (minBudget 2500) (maxBudget 5000) (dresscode informal) (hasWifi yes) (latitude -6.9045679) (longitude 107.6399745))
  (restaurant (rest_name G) (isSmoker yes) (minBudget 1300) (maxBudget 3000) (dresscode casual) (hasWifi yes) (latitude -6.1881082) (longitude 106.7844409))
  (restaurant (rest_name H) (isSmoker no) (minBudget 400) (maxBudget 1000) (dresscode informal) (hasWifi no) (latitude -6.9525133) (longitude 107.6052906))
  (restaurant (rest_name I) (isSmoker no) (minBudget 750) (maxBudget 2200) (dresscode informal) (hasWifi yes) (latitude -6.9586985) (longitude 107.7092281))
  (restaurant (rest_name I) (isSmoker no) (minBudget 750) (maxBudget 2200) (dresscode casual) (hasWifi yes) (latitude -6.9586985) (longitude 107.7092281))
  (restaurant (rest_name J) (isSmoker no) (minBudget 1500) (maxBudget 2000) (dresscode casual) (hasWifi yes) (latitude -6.2769732) (longitude 106.775133))
  )