#Author:Sini Hautala
#Date: 24.11.2022
#Data wrangling week 4


#install.packages("boot")
#install.packages("readr")

#read the data
library(tidyverse)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

str(gii)
dim(gii)

str(hd)
str(hd)
View(hd)
View(gii)

#Give more informative names to columns
colnames(hd) <- c('HDRank','Country', 'HDI','LifeExp','EduYExp', 'EduYMean', 'Income', 'GNI-HDI')
colnames(gii) <- c('GIIRank','Country','GII', 'Mdeaths', 'Alabours', 'parlament', 'edu2F', 'edu2M', 'workF', 'workM')

#Mutate gender inequality data.  
#The first calculated ratio is the ratio of Female and Male populations with secondary education in each country. (edu2F / edu2M). The second new variable
#The second is the ratio of labor force participation of females and males in each country (workF / workM). 
gii <- mutate(gii, ratio1 = edu2F/edu2M) 
gii <- mutate(gii, ratio2 = workF/workM)
View(gii)

#Join the two datasets
#Join together the two datasets using the variable Country as the identifier.
#Keep only the countries in both data sets (Hint: inner join). The joined data should have 195 observations and 19 variables. Call the new joined data "human" and save it in your data folder. (1 point)


# access the dplyr package
library(dplyr)

# join the two data sets by the selected identifiers (=country)
hd_gii <- inner_join(hd, gii, by = "Country", suffix = c(".hd", ".gii"))

# look at the column names of the joined data set
colnames(hd_gii)

# glimpse at the joined data set
View(hd_gii)
# hd_gii has 195 observations and 19 variables as it should.

#saving
write.csv(hd_gii, "./data/human.csv")
