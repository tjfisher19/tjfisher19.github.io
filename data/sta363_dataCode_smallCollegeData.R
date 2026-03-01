#####################################################
## This code builds the Ohio small colleges
##   and the midwest small colleges datasets.
##
## Description of the original source is in the first
##   comment chunk below. The rest is fairly 
##   straightforward data processing code
##
## You can also see some model testing ideas



#####################################################
##
## I went to collegeresults.org
##
## Filtered by size to 1,000 to 4,999
## 
## Zoomed in over Ohio, selected one of the schools
##   and then set it up for a comparison
## Then I selected all the schools in Ohio (I think 57)
##   and then saved that csv file as colleges_comparison.csv
##
## Then the code below builds the data for class.



library(tidyverse)
library(ggfortify)

full_college <- read_csv("colleges_comparison_oh.csv")

small_colleges_data <- full_college |> 
  dplyr::filter(state_abbr=="OH") |> 
  dplyr::select(Name=name, 
                sector_label, 
                Graduation_Rate = grad_rate_bachelors_6year, 
                #ACT_Math_Q1 = admissions_act_math_25th, 
                Average_Cost = costs_avg_coa_in_state, 
                demo_pct_undergrad_women, demo_pct_undergrad_men,
                student_factulty_ratio,
                institutional_category,
                pct_full_time_faculty) |>
  #drop_na() |> 
  mutate(Predominantly_Coed = ifelse(demo_pct_undergrad_women>33 & demo_pct_undergrad_women<67, 1, 0),
         Private_College = as.numeric(str_detect(sector_label, "Private") ),
         Pct_Part_Time_Faculty = 1-as.numeric(pct_full_time_faculty) ) |>
  select(Name, Graduation_Rate, Average_Cost, Student_Faculty_Ratio=student_factulty_ratio, Private_College)

names(small_colleges_data)
write_csv(small_colleges_data, file="ohio_small_colleges.csv")

fit <- lm(Graduation_Rate ~ Average_Cost +  Student_Faculty_Ratio + Private_College , data=small_colleges_data)
autoplot(fit)
autoplot(fit, which=1:6)
summary(fit)
summary(lm(Graduation_Rate ~ Average_Cost, data=small_colleges_data))
summary(lm(Graduation_Rate ~ Private_College, data=small_colleges_data))
summary(lm(Graduation_Rate ~ Student_Faculty_Ratio, data=small_colleges_data))
#summary(lm(Graduation_Rate ~ Pct_Part_Time_Faculty, data=small_colleges_data))
car::vif(fit)


#####################################
## Similar version that includes Indiana, Ohio and Michigan

ohio_college <- read_csv("colleges_comparison_oh.csv")
indiana_college <- read_csv("colleges_comparison_in.csv")
michigan_college <- read_csv("colleges_comparison_mi.csv")


ohio_college <- ohio_college |> 
  dplyr::filter(state_abbr=="OH") |> 
  dplyr::select(Name=name, 
                sector_label, 
                Graduation_Rate = grad_rate_bachelors_6year, 
                Average_Cost = costs_avg_coa_in_state, 
                student_factulty_ratio,
                institutional_category,
                pct_full_time_faculty, 
                state_abbr) |>
  #drop_na() |> 
  mutate(Private_College = as.numeric(str_detect(sector_label, "Private") ) ) |>
  select(Name, Graduation_Rate, Average_Cost, Student_Faculty_Ratio=student_factulty_ratio, Private_College, State=state_abbr)

indiana_college <- indiana_college |> 
  dplyr::filter(state_abbr=="IN") |> 
  dplyr::select(Name=name, 
                sector_label, 
                Graduation_Rate = grad_rate_bachelors_6year, 
                Average_Cost = costs_avg_coa_in_state, 
                student_factulty_ratio,
                institutional_category,
                pct_full_time_faculty,
                state_abbr) |>
  #drop_na() |> 
  mutate(Private_College = as.numeric(str_detect(sector_label, "Private") ) ) |>
  select(Name, Graduation_Rate, Average_Cost, Student_Faculty_Ratio=student_factulty_ratio, Private_College, State=state_abbr)

michigan_college <- michigan_college |> 
  dplyr::filter(state_abbr=="MI") |> 
  dplyr::select(Name=name, 
                sector_label, 
                Graduation_Rate = grad_rate_bachelors_6year, 
                Average_Cost = costs_avg_coa_in_state, 
                student_factulty_ratio,
                institutional_category,
                pct_full_time_faculty,
                state_abbr) |>
  #drop_na() |> 
  mutate(Private_College = as.numeric(str_detect(sector_label, "Private") ) ) |>
  select(Name, Graduation_Rate, Average_Cost, Student_Faculty_Ratio=student_factulty_ratio, Private_College, State=state_abbr)



full_college <- bind_rows(ohio_college, indiana_college, michigan_college) |>
  drop_na()

write_csv(full_college, file="midwest_small_colleges.csv")




fit <- lm(Graduation_Rate ~ Average_Cost +  Student_Faculty_Ratio + 
            Private_College + State, 
          data=full_college)
autoplot(fit)
summary(fit)

fit2 <- lm(Graduation_Rate ~ Average_Cost +  Student_Faculty_Ratio + 
            Private_College, 
          data=full_college)

anova(fit2, fit)


small_colleges_data <- full_college |> 
  dplyr::filter(state_abbr=="OH") |> 
  dplyr::select(Name=name, 
                sector_label, 
                Graduation_Rate = grad_rate_bachelors_6year, 
                #ACT_Math_Q1 = admissions_act_math_25th, 
                Average_Cost = costs_avg_coa_in_state, 
                demo_pct_undergrad_women, demo_pct_undergrad_men,
                student_factulty_ratio,
                institutional_category,
                pct_full_time_faculty) |>
  #drop_na() |> 
  mutate(Predominantly_Coed = ifelse(demo_pct_undergrad_women>33 & demo_pct_undergrad_women<67, 1, 0),
         Private_College = as.numeric(str_detect(sector_label, "Private") ),
         Pct_Part_Time_Faculty = 1-as.numeric(pct_full_time_faculty) ) |>
  select(Name, Graduation_Rate, Average_Cost, Student_Faculty_Ratio=student_factulty_ratio, Private_College)

