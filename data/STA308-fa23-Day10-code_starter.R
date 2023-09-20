##
##  STA308-fa23-Day10-code.R
##     Dr. Fisher
##

## Learning Objectives
## 1. Implicitly review data handling tools 
##    - filter, select, mutate, summarize, group_by
## 2. Introduce some new verbs & handy functions
## 3. Reading external file (natality, or birth data, 
##    from the CDC) and do summarize, group_by, etc.
##    to gain insight
## 4. Future classes: Merging (joining) data frames 
##    - today we have # of births (counts)
##    - what about overall population counts? 
##    - merge and mutate to form birth rates


## load needed packages 
##     (tidyverse includes readr::read_csv,
##      dplyr::mutate and much more)
library(tidyverse)

######################################################################
##
## class question - What insights can we gain about how live births
##                    occur in the United States?
##
######################################################################

## Browser search "CDC Natality Microdata"
##  https://www.cdc.gov/nchs/data_access/vitalstatsonline.htm
##

############
## Step 1
##
## Open the 2007 Users Guide 
##    (why 2007? - the data file is not as big
##       as other years but still includes many
##       variables of interest [convenient year?]).
## We will discuss some of the information that is in the file.
##
############
## Step 2
##
## Download the 141 MB file for 2007 in the US Data (zip files) section
##     (also a copy available on canvas)
##
## NOTE: We do NOT need to unzip the file and 
##        you DO NOT want to OPEN it directly.
##        (the real data file is 3.2)
##
############
## Step 3
## 
## Move that file Nat2007us.zip to the same folder/directory as this file!
##   Ex: c:/users/my_user_id/Documents/STA308/natality/
##       /home/my_user_is/Documents/STA308/natality/
##
############
## Step 4
##
## Now step through the below code!
##
## REMINDER: We do NOT need to unzip the file and 
##        you DO NOT want to OPEN it directly.

help(read_fwf)

nat2007 <- read_fwf("Nat2007us.zip",
                    col_positions = 
                      fwf_positions(start=c(19, 29, 89, 290, 436, 473),
                                    end=  c(20, 29, 90, 290, 436, 473),
                                    col_names=c("Month", "DayOfWeek", "MotherAge", "Smoker", "Sex", "BabyWeight") ),
                    col_types = "cnnncn" )

## Questions
##    Q1:  What are the variables in the data?
##    Q2:  What types of variables are in the data set?
##    Q3:  How many rows are in the data set?
##    Q4:  Describe a row in this data frame.



##########################################
## Convert the numeric and character coded variables to 
##    contextually meaningful values
## We will mutate() to change some variables
##
## Note: the below code has been spread across several lines and using
##       indentation to increase the readability of the code
nat2007 <- nat2007 %>%
  mutate(Month = factor(Month, 
                        levels=c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"),
                        labels=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec") ),
         DayOfWeek = factor(DayOfWeek, 
                            levels=1:7, 
                            labels=c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")),
         Smoker = factor(Smoker, 
                         levels=c(1,2,9), 
                         labels=c("Yes", "No", "Unknown")),
         Sex = factor(Sex, 
                      levels=c("M", "F"), 
                      labels=c("Male", "Female")),
         BabyWeight = factor(BabyWeight, 
                             levels=1:4,
                             labels=c("1499 grams or less", "1500-2499 grams", "2500 grams or more", "Unknown")))
summary(nat2007)

########################################
##
## Let's save our properly coded (variables 
##    with meaningful labels) data.frame in
##    a R's preferred format for the future.

save(nat2007, file="natality2007.RData")


###########################################
## 
## Now some data analysis...
##

##
##  How many births?
##




## Comment: we just used count()/summarize() WITHOUT using
##       group_by() -- note the behavior it counted/summarized
##       over the entire data frame!
## Comment: you can consider this a case with no grouping
##       variable, or where ALL observations are in
##       the same group.

##
## How do births vary by month?
##




##
## Lots of numbers there..., let's turn them into percentages
##




##
## What about day of week?
##




##
## Biological Sex?
##





##+!+!+!+!+!+!+!+!+!+!+!+!+!+!
## Write R code that does the following
##
## Only for records in which we know whether
##    the mother was a smoker or not, and
##    the baby's weight was recorded
##    Study the distribution of baby weight
##    as a function of smoking status by determining
##    the proportion of baby's in the different
##    weight classes based on the mother's
##    smoking status.
##
## The resulting data.frame should only include
##    Mother's smoking status, Weight of the baby
##    and the percentage.





#######################
## Note: in the above, it is very very similar to the penguins
##     and baseball example from last week
##  Here: 
##     - we choose only Smokers & non-smokers 
##      (2019 & 2020 seasons or penguins that 
##       do not have "unknown" sex)
##     - we group by multiple variables
##       (season & team, year & species)
##     - We aggregate with summations 
##       (total hits, total at bats...
##        with penguins, mean of bill ratio)
##     - Then convert to a percentage
##        (batting average!)
##     - We select the variables of interest.

