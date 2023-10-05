;; CPOEbasic.bat

;; ___________ TEMPLATES __________________

; Template 1: person who is prescribed
(deftemplate person
  (slot ID)
  (slot age)         
  (multislot allergies)     ;list of patient allergies
  (multislot diseases)    ;list of current patient diseases
  (multislot symptoms)     ;lisa of current patient symptoms
)

; Template 2: history of prescribed active components, including accumulated dose

(deftemplate person-activeComponent-dose
  (slot person)
  (slot activeComponent)
  (slot dose))

; Template 3: drug

(deftemplate drug
  (slot ID)
  (slot activeComponent)
  (multislot components)
  (multislot presentacion)
  (multislot indicacion)
)

; Template 4: prescription

(deftemplate prescription
  (slot ID)
  (slot person)
  (slot drug)
  (slot dose)
)

; Template 5: component

(deftemplate component
  (slot ID)
  (multislot is-a)
  (slot doseMaximAdult)
  (slot doseMaximchilds)
  (multislot contraindication-disease)
  (multislot contraindication-interaction)
  (multislot contraindication-symptom)
)

;; ___________ FUNCTIONS __________________


(deffunction action-stop (?pr ?p ?m ?t ?i)
  (bind ?id (fact-slot-value ?pr ID))
  (printout t "Stop prescription " ?id " de " ?m " a " ?p " por " ?t " de " ?i "." crlf)
  (retract ?pr)
)

(deffunction action-administer-new (?pr ?p ?m ?c ?d)
  (bind ?id (fact-slot-value ?pr ID))
  (printout t "Administer prescription " ?id ": " ?d " dose de " ?m " a " ?p "." crlf)
  (assert (person-activeComponent-dose (person ?p) (activeComponent ?c) (dose ?d)))
  (retract ?pr)
)

(deffunction action-administer-next (?pr ?p ?m ?c ?d ?pcd)
  (bind ?id (fact-slot-value ?pr ID))
  (bind ?dose (fact-slot-value ?pcd dose))
  (printout t "Administer prescription " ?id ": " ?d " dose de " ?m " a " ?p "." crlf)
  (modify ?pcd (dose (+ ?d ?dose)))
  (retract ?pr)
)

;; ___________  FACTS  __________________

;; Facts 1:

(deffacts terminology "taxonomy of analgesics"

(component (ID amina)
	    (is-a analgesico)
	    (contraindication-symptom empeoramiento dolorchild5Dias dolorAdunto10Dias fiebre3Dias fiebre3Dias))		
(component (ID antinflamatorio-no-esteroide) (is-a analgesico))
(component (ID cannabinoide) (is-a analgesico))
(component (ID opioide) (is-a analgesico))
(component (ID fenacetina)(is-a amina))
(component  (ID paracetamol) (is-a amina)
	     (contraindication-interaction analgesico)
	     (contraindication-disease higado renal cardiaco pulmonar anemia alcoholismo-menor alcolismo-mayor embarazo lactancia)
	     (contraindication-symptom empeoramiento dolorchild5Dias dolorAdunto10Dias)
	     (doseMaximAdult 8)
	     (doseMaximchilds 5)
)
(component (ID aspirina)  (is-a antinflamatorio-no-esteroide))
(component (ID celecoxib)(is-a antinflamatorio-no-esteroide))
(component (ID diclofenaco)(is-a  antinflamatorio-no-esteroide))
(component (ID ibuprofeno)(is-a  antinflamatorio-no-esteroide))
(component (ID ketoprofeno)(is-a  antinflamatorio-no-esteroide))
(component (ID ketorolaco)(is-a  antinflamatorio-no-esteroide))
(component (ID meloxicam)(is-a  antinflamatorio-no-esteroide))
(component (ID naproxeno)(is-a  antinflamatorio-no-esteroide))
(component (ID rofecoxib)(is-a  antinflamatorio-no-esteroide))
(component (ID indometacina)(is-a  antinflamatorio-no-esteroide))

(component (ID cannabis)(is-a cannabinoide))
(component (ID tetrahidrocannabinol)(is-a cannabinoide))

(component (ID alfentanilo)(is-a opioide))
(component (ID carfentanilo)(is-a opioide))
(component (ID buprenorfina)(is-a opioide) )
(component (ID codeina)(is-a opioide) )
(component (ID codeinona)(is-a opioide))
(component (ID dextropropoxifeno)(is-a opioide) )
(component (ID dihidrocodeina)(is-a opioide) )
(component (ID beta-endorfina)(is-a opioide) )
(component (ID fentanilo)(is-a opioide) )
(component (ID heroina)(is-a opioide) )
(component (ID hidrocodona)(is-a opioide))
(component (ID hidromorfona)(is-a opioide))
(component (ID metadona)(is-a opioide) )
(component (ID morfina)(is-a opioide) )
(component (ID morfinona)(is-a opioide))
(component (ID oxicodona)(is-a opioide) )
(component (ID oximorfona)(is-a opioide) )
(component (ID meperidina)(is-a opioide) )
(component (ID remifentanilo)(is-a opioide))
(component (ID sufentanilo)(is-a opioide) )
(component (ID tebaina)(is-a opioide) )
(component (ID tramadol)(is-a opioide))
)

;; Facts 2:

(deffacts Vademucum "drugs in the pharmacy"
  (drug (ID Mundogen500mgTabletsEFG)
  	       (activeComponent paracetamol)
	       (components paracetamol almidon-pregelatimizado povidona acido-estearico)
	       (presentacion comprimido 500)
	       (indicacion fiebre dolor-muscular dolor-cabeza dolor-intensidad-leve dolor-intensidad-moderada)
  )

  (drug (ID Termalgin650mgTablets)
  	       (activeComponent paracetamol)
	       (components paracetamol talco almido-maiz silice coloidal-anhidra celulosa-microcristalina almidon-pregelatimizado povidona acido-estearico)
	       (presentacion comprimido 650)
	       (indicacion fiebre dolor-muscular dolor-cabeza dolor-intensidad-leve dolor-intensidad-moderada)
  )
)

;; ___________  RULES __________________

(defrule extend-allergies-terminology
  (component (ID ?z) (is-a ?x))
  ?p <- (person (allergies $?a ?x $?b))
  (not (test (member$ ?z ?a)))
  (not (test (member$ ?z ?b)))
  =>
  (modify ?p (allergies ?a ?x ?b ?z))
;;  (printout t ?p.ID " " ?p.allergies crlf)
)

(defrule extend-interaction-terminology
  (component (ID ?z) (is-a ?x))
  ?c <- (component (ID ?id)(contraindication-interaction $?a ?x $?b))
  (not (test (member$ ?z ?a)))
  (not (test (member$ ?z ?b)))
  (not (test (eq ?z ?id))) ;; a component cannot be contraindicated wit itself
  =>
  (modify ?c (contraindication-interaction ?a ?x ?b ?z))
)

(defrule extend-disease-terminology
  (component (ID ?z) (is-a ?x))
  (component (ID ?x)(contraindication-disease $?a ?e $?b))
  ?c <- (component (ID ?z)(contraindication-disease $?e2))
  (not (test (member$ ?e ?e2)))
  =>
  (modify ?c (contraindication-disease ?e2 ?e))
)

(defrule extend-symptom-terminology
  (component (ID ?z) (is-a ?x))
  (component (ID ?x)(contraindication-symptom $?a ?e $?b))
  ?c <- (component (ID ?z)(contraindication-symptom $?e2))
  (not (test (member$ ?e ?e2)))
  =>
  (modify ?c (contraindication-symptom ?e2 ?e))
)

(defrule contraindication-allergy-component
  (person (ID ?p) (allergies $?a))
  (drug  (ID ?m) (components $?c))
  ?pr <- (prescription (drug ?m) (person ?p))
  (test (> (length$ (intersection$ ?a ?c)) 0))
  =>
  (action-stop ?pr ?p ?m allergy (intersection$ ?a ?c))
)

(defrule contraindication-component-disease
  (component (ID ?c) (contraindication-disease $?ce))
  (drug (ID ?m) (components $? ?c $?))
  ?pr <- (prescription (person ?p) (drug ?m))
  (person (ID ?p) (diseases $?e))
  (test (> (length$ (intersection$ ?e ?ce)) 0))
  =>
  (action-stop ?pr ?p ?m diseases (intersection$ ?e ?ce))
)

(defrule contraindication-component-symptom
  (component (ID ?c) (contraindication-symptom $?cs))
  (drug (ID ?m) (components $? ?c $?))
  ?pr <- (prescription (person ?p) (drug ?m))
  (person (ID ?p) (symptoms $?s))
  (test (> (length$ (intersection$ ?s ?cs)) 0))
  =>
  (action-stop ?pr ?p ?m symptom (intersection$ ?s ?cs))
)

(defrule contraindication-component-interaction
  (person-activeComponent-dose (person ?p) (activeComponent ?c2))
  ?pr <- (prescription (person ?p) (drug ?m))
  (drug (ID ?m) (components $? ?c $?))
  (component (ID ?c) (contraindication-interaction $? ?c2 $?))
  =>
  (action-stop ?pr ?p ?m interaction ?c2)
)

(defrule contraindication-dose-adulto
  ?pr <- (prescription (person ?p) (drug ?m)(dose ?d))
  (person (ID ?p) (age ?age&:(> ?age 11)))
  (drug (ID ?m) (activeComponent ?ca))
  (component (ID ?ca) (doseMaximAdult ?d1))
  (person-activeComponent-dose (person ?p) (activeComponent ?ca) (dose ?dh))
  (test (> (+ ?d ?dh) ?d1))
  =>
  (action-stop ?pr ?p ?m accumulatedDose (+ ?d ?dh))
)

(defrule contraindication-dose-child
  ?pr <- (prescription (person ?p) (drug ?m)(dose ?d))
  (person (ID ?p) (age ?age&:(<= ?age 11)))
  (drug (ID ?m) (activeComponent ?ca))
  (component (ID ?ca) (doseMaximchilds ?d1))
  (person-activeComponent-dose (person ?p) (activeComponent ?ca) (dose ?dh))
  (test (> (+ ?d ?dh) ?d1))
  =>
  (action-stop ?pr ?p ?m accumulatedDose (+ ?d ?dh))
)

(defrule prescription-correct-next
  (declare (salience -99))
  ?pr <- (prescription (person ?p) (drug ?m)(dose ?d))
  (drug (ID ?m) (activeComponent ?c))
  ?pcd <- (person-activeComponent-dose (person ?p) (activeComponent ?c) (dose ?dh))
  =>
  (action-administer-next ?pr ?p ?m ?c ?d ?pcd)
)

(defrule prescription-correct-new
  (declare (salience -100))
  ?pr <- (prescription (person ?p) (drug ?m)(dose ?d))
  (drug (ID ?m) (activeComponent ?c))
  =>
  (action-administer-new ?pr ?p ?m ?c ?d)
)

;; __ TODO: EJERCICIO 3__

; EJERCICIO 3.1
;(deffunction action-suggest-alternative (?pr ?p ?m ?t ?i ?m2)
  ;   ;TODO
  ;)

; EJERCICIO 3.2
;(defrule contraindication-allergy-component-suggest-alternative
  ;    ;TODO
  ;)

; EJERCICIO 3.6
;(defrule contraindication-allergy-component-suggest-alternative
  ;    ;TODO
  ;)

;; ___________  FACTS __________________

(deffacts situationExample
   (person (ID Juan)
  	  (age 32)
	  (allergies pescado penicilina)
	  (diseases renal)
	  (symptoms fiebre)
  )
  (person (ID Salva)
  	  (age 29)
	  (allergies nil)
	  (symptoms dolor-muscular)
  )
  (person-activeComponent-dose (person Salva)
  				  (activeComponent fentanilo)
				  (dose 2)
  )

  (prescription (ID Juan-20100505-1001)
  		(person Juan)
  		(drug Mundogen500mgTabletsEFG)
		(dose 1)
  )
  (prescription (ID Salva-20100505-2225)
  		(person Salva)
  		(drug Mundogen500mgTabletsEFG)
		(dose 1)
  )


;; __ TO DO: BLOCK II__

; EJERCICIO 2.2
  ; Patient Jose, 37 years old, allergic to analgesics, is prescribed 1 dose of Mundogen500mgTabletsEFG, which must be stopped due to allergy to paracetamol (which is an amine-type analgesic).
  ; define la person Jose
  ; (person (ID Jose)
    ;TODO
  ; )
  ; define prescription Jose-20100505-2342, with 1 dose of Mundogen500mgTabletsEFG
  ; (prescription (ID Jose-20100505-2342)
   ;TODO
  ; )

;; __TO DO: BLOCK III__

   ; EXERCISE 3.3
   ;(person (ID Javier)
      ;TODO
    ;)

    ; EXERCISE 3.4
    ;(prescription (ID Javier-20100505-50001)
       ;TODO
    ;)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(reset)
(run)
