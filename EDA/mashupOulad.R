# Loading OULAD subset
load("data/mashupData.RData")

# Checking current directory
getwd() # Obtained data tables (transform to dataframe https://www.geeksforgeeks.org/how-to-convert-table-to-dataframe-in-r/)

# Select female students studentInfo[studentInfo$gender == "F",]
df <- as.data.frame.matrix(studentInfo)
femaleStudents <- df[df$gender == "F",] # https://michaelgastner.com/R_for_QR/extracting-values-from-data-frames.html

library(dplyr) # https://www.marsja.se/select-columns-in-r-by-name-index-letters-certain-words-with-dplyr
library(ggplot2)

femaleStudents <- studentInfo %>% select(c('id_student', 'gender'))
ggplot(studentInfo, aes(gender, fill = gender)) + geom_bar()
# Select registered students
registeredStudents <- studentRegistration[
  is.na(studentRegistration$date_unregistration) | studentRegistration$date_unregistration > 28,]
# Select active students
activeStudents <- studentVle[studentVle$date == 28,]
# More actions]
