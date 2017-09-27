(deffacts knowledge-base 
(goal is type.animal)
(legal answers are yes no)

  	 (rule  (if backbone is yes) 
        		 (then superphylum is backbone))
  	 (rule  (if backbone is no) 
        		 (then superphylum is jellyback ))
   	(question backbone is "Does your animal have a backbone?")
 
 	 (rule  (if superphylum is backbone and
         	            warm.blooded is yes) 
         	            (then phylum  is warm))
  	(rule  (if superphylum is backbone and
        	            warm.blooded is no) 
        	           (then phylum is cold))
  	 (question warm.blooded is "Is the animal warm blooded?")

(rule  (if superphylum is jellyback and
        	           live.prime.in.soil is yes) 
                        (then phylum is soil))
(rule  (if superphylum is jellyback and
                        live.prime.in.soil is no) 
                        (then phylum is elsewhere))
(question live.prime.in.soil is "Does your animal live primarily in soil?")

(answer is "I think your animal is a " type.animal))
