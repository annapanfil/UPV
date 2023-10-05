# Check oulad correlation
# Left join
dat <-
  left_join(studentAssessment, assessments,
            by = "id_assessment") 
# Select num
dat <- subset(dat, select = c(3,5,8,9,10))
levels(dat$assessment_type) <- c(1,2,3)
dat$assessment_type <- as.numeric(factor(dat$assessment_type))
# library(corrplot)
ou_corr <- cor(dat)
corrplot(ou_corr, type = "lower")
# Try clickinfo
getClickInfo<-function(course,days)
{
  studentVle%>%
    filter(code_module==course)%>%
    filter(date<days+1)%>%
    group_by(id_student,date)%>%
    summarise(daily_clicks=sum(sum_click),daily_elements=n())%>%
    group_by(id_student)%>%
    summarise(total_clicks=sum(daily_clicks),total_elements=sum(daily_elements),active_days=n())%>%
    mutate(average_daily_clicks=total_clicks/active_days,average_elements=total_elements/active_days)
}
# correlate vle info
course="DDD"
days=100

clicksInfo<-getClickInfo(course,days)
subclicksInfo <- clicksInfo[, -1]
# cor library(corrplot)
ou_corr <- cor(subclicksInfo)
corrplot(ou_corr, type = "upper")