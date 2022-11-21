#Author:Sini Hautala
#Date: 17.11.2022
#Data wrangling week 3


# read the data into memory
por <- read.csv("student-por.csv", sep = ";", header = TRUE)
dim(por)
str(por)

math <- read.csv("student-mat.csv", sep = ";", header = TRUE)
dim(math)
str(math)

#Join the two data sets using all other variables than "failures", "paid", "absences", "G1", "G2", "G3" as (student) identifiers. 
#Keep only the students present in both data sets. Explore the structure and dimensions of the joined data


# access the dplyr package
library(dplyr)

# give only the columns that vary in the two data sets and that we dont want to include in the end
free_cols <- c("failures","paid","absences","G1","G2","G3")
# the rest of the columns are common identifiers that we want to use for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)

join_cols
# join the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

# look at the column names of the joined data set
colnames(math_por)

# glimpse at the joined data set
math_por


#Get rid of the duplicate records in the joined data set. Either a) copy the solution from the exercise "3.3 The if-else structure" to combine the 'duplicated' answers in the joined data, or b) write your own solution to achieve this task

# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

# print out the columns not used for joining (those that varied in the two data sets)
colnames(free_cols)

# for every column name not used for joining...
for(col_name in free_cols) {
  
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric... 
  #is_numeric — Finds whether a variable is a number or a numeric string
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# glimpse at the new combined data
glimpse(alc)


#take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise).


# Work with the exercise in this chunk, step-by-step. Fix the R code!
# alc is available

# access the tidyverse packages dplyr and ggplot2
library(dplyr); library(ggplot2)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use', prints "true or false"
alc <- mutate(alc, high_use = alc_use > 2)

#glimpse at the joined and modified data to make sure everything is in order
view(alc)
#370 observations as there should be!

#Save the joined and modified data set to the ‘data’ folder
write.csv(alc, "data/alc.csv", row.names = FALSE)
