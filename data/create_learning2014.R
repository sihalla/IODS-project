
#Author:Sini Hautala
#Date: 10.11.2022
#Regression analysis exercise


# read the data into memory
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

View(lrn14)
#This dataset includes 183 rows and 60 columns. 

library(dplyr)
#Here we create  an analysis dataset with combination variables gender, age, attitude, deep, stra, surf and points.
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")

lrn14$deep <- rowMeans(lrn14[, deep_questions])

surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

lrn14$surf <- rowMeans(lrn14[, surface_questions])

strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
lrn14$stra <- rowMeans(lrn14[, strategic_questions])

#scaling Attitude back to its original scale by dividing each number in the column vector by the total number of questions.
lrn14$attitude <- lrn14$Attitude / 10


# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

#changing column names according to the assignment
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

#excluding observations where exam points variable is zero
learning2014 <- filter(learning2014, points > 0)

#166 observations 7 variables
View (learning2014)

write.csv(learning2014, "./data/learning2014.csv") 

#This chunk can be reactivated if willing to test similarity of the saved data. I was able to read the data again
#relrn2014 <- read_csv("./data/learning2014.csv")
#str(relrn2014)
#head(relrn2014)





