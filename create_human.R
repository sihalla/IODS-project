#Author:Sini Hautala
#Date: 24.11.2022
#Data wrangling week 4-5


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
colnames(hd) <- c('HDRank','Country', 'HDI','LifeExp','EduYExp', 'EduYMean', 'Income', 'GNI')
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
#write.csv(hd_gii, "./data/human.csv")



# access the stringr and dplyr package 
library(stringr)
library(dplyr)

#transform GNI variable to numeric (using string manipulation)
hd_gii$GNI
str(hd_gii$GNI)

# remove the commas from GNI and print out a numeric version of it
hd_gii$GNI <- gsub(",", ".", hd_gii$GNI) %>% as.numeric

#Exclude unneeded variables
keep_columns <- c("Country", "edu2M", "workF", "LifeExp", "EduYExp", "GNI", "Mdeaths", "Alabours", "parlament")
hd_gii_ <- dplyr::select(hd_gii, one_of(keep_columns))

# remove rows with missing values
hd_gii_F <- filter(hd_gii_, complete.cases(hd_gii_))

#Remove the observations which relate to regions instead of countries. Regions were already automatically removed when NA values were removed. Only were 155 rows left. Here regions removed from the original data.
#hd_gii_F2 <- hd_gii %>% top_n(188, HDRank)

#Define the row names of the data by the country names and remove the country name 
rownames(hd_gii_F) <- hd_gii_F$Country
hd_gii_F
View(hd_gii_F)

#remove the country name column from the data
hd_gii_F<- dplyr::select(hd_gii_F, -Country)
str(hd_gii_F)

write_csv(hd_gii_F, "human.csv")
#read_csv("human.csv")


