#Author:Sini Hautala
#Date: 1.12.2022
#Data wrangling week 6

#read data
library(stringr)
library(dplyr)

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = '\t', header = T)

#"Longitudinal data, where a response variable is measured on each subjecton several different occasions poses problems for their analysis because therepeated measurements on each subject are very likely to be correlated rather than independent.

colnames(BPRS)
colnames(RATS)
str(BPRS)
str(RATS)
View(BPRS)
View(RATS)

#In RATS there is data from 16 different Rats("IDs"). They have been assigned to 3 different groups. Every rat has been measured several times during the 64 week follow up and every weeks measurement has it's own column.
#In BRPBS there are 2 different treatment groups where the 20 subjects have been allocated. Their bprs scores have been followed during the treatment. There is a measurement every week that is assigned to its own columns.

# Convert the categorical variables of both data sets to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)
RATS$WD <- factor(RATS$WD)


#Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS. 
BPRSL <-  pivot_longer(BPRS, cols=-c(treatment,subject),names_to = "weeks",values_to = "bprs") %>% arrange(weeks)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
BPRSL <- BPRSL %>%
  group_by(week)

#create a growth variable that tells the procentual growth of the rats during the follow up time
RATSP <-RATS %>% mutate(growth=(RATS$WD64-RATS$WD1)/RATS$WD1)
RATSL <- pivot_longer(RATSP, cols=-c(ID,Group,growth), names_to = "WD",values_to = "Weight")  %>%  mutate(Time = as.integer(substr(WD,3,4))) %>% arrange(Time) 
View(RATSL)
#View long form data
colnames(BPRSL)
colnames(RATSL)
str(BPRSL)
str(RATSL)
View(BPRSL)
View(RATSL)

# Now that the tables are in the long form, all the values from different week for each subject can be found under one column (previously every week had its own column). The week number is reported in its own long column.

#write csv
library(readr)
write_csv(BPRSL, "BPRSL.csv")
write_csv(RATSL, "RATSL.csv")
#read_csv("BPRSL.csv")

