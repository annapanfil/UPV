##########################################################################################

# NOTE 1: RULES MUST BE EVALUATED TO FALSE TO ACCOUNT AS AN INCONSISTENCY, THEREFORE YOU
# MUST WRITE AS A RULE WHAT IS THE EXPECTED CONSISTENT SITUATION

# NOTE 2: REMEMBER, TO VALIDATE AN OR CLAUSE AS FALSE BOTH SIDES MUST BE FALSE

# NOTE 3: TIP, TO EVALUATE THE CORRECT BEHAVIOUR OF RULES, TRY TO MANUALLY FIND AN
# INCONSISTENT REGISTRY WHICH SHOULD BE FOUND

##########################################################################################

# RULE 1: If the delivery mode is an elective caesarea, the used aneshtesia must have been
# epidural, epidural/general, spinal, spinal/general or general anesthesia.

!(sapply(DEL_MODE,tolower) %in% "elective caesarea") | (sapply(DEL_TYPE_ANE,tolower) %in% c("epidural anesthesia","epidural anesthesia / general anesthesia","spinal anesthesia","spinal anesthesia / general anesthesia","general anesthesia"))

# RULE 2: If the delivery mode is an emergency caesarea (also known as intrapartum
# caesarea), the used aneshtesia must have been spinal, spinal/general, 
# epidural/general or general anesthesia.

!(sapply(DEL_MODE,tolower) %in% c("emergency caesarea", "intrapartum caesarea")) | (sapply(DEL_TYPE_ANE,tolower) %in% c("epidural anesthesia / general anesthesia","spinal anesthesia","spinal anesthesia / general anesthesia","general anesthesia"))



