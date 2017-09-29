; Templates

; Template untuk sorting dan ranking restaurant suggestions

(deftemplate iter  (slot suggestion-iter))
(deftemplate farthest 
    (slot rest_name)
    (slot distance))

; Template untuk merepresentasikan restoran.
(deftemplate restaurant
  (slot rest_name) 
  (slot isSmoker)
  (slot minBudget)
  (slot maxBudget)
  (multislot dresscode)
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
  (multislot dresscode)
  (slot hasWifi)
  (slot latitude)
  (slot longitude)
)

; Template untuk merepresentasikan skor setiap restaurant berdasarkan preference user
; Setiap restaurant dinilai skornya sebelum ditampilkan sebagai suggestion
(deftemplate score
  (slot rest_name)
  (slot score)
)

; Template untuk merepresentasikan restaurant suggestion.
(deftemplate suggestion
  (slot rest_name)
  (slot recommendation-type) ; Very recommended / recommended / not recommended
  (slot distance)
  (slot score)
)

