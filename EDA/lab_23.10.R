library(cluster)

# select students student_Info.R
student_Info <- read.csv("data/studentInfo.csv")
AAA_st_info <- student_Info[student_Info$code_module == "AAA", ]
table(AAA_st_info$gender)

# compare final results
with(student_Info, table(code_module, final_result))
aggregate(studied_credits ~ code_presentation, data=student_Info, mean)
