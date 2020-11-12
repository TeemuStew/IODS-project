#Teemu Mäkelä 12.11.2020
#Open Data Science exercises 3
#Source: "UCI Machine Learning Repository, Student Performance Data (incl. Alcohol consumption) "

library(dplyr)
library(data.table)

NHIS<-read.table("data/student-mat.csv",sep=";",header=TRUE)
dim(NHIS)
str(NHIS)

SIHN<-read.table("data/student-por.csv",sep=";",header=TRUE)
dim(SIHN)
str(SIHN)

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
AHNS <- inner_join(NHIS, SIHN, by = join_by, suffix = c(".NHIS", ".SIHN"))
dim(AHNS)
str(AHNS)

glimpse(AHNS)

colnames(AHNS)

# create a new data frame with only the joined columns
alc <- select(AHNS, one_of(join_by))

# columns that were not used for joining the data
notjoined_columns <- colnames(NHIS)[!colnames(NHIS) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(AHNS, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)

#uusi


library(ggplot2)
# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# initialize a plot of alcohol use
g1 <- ggplot(data = alc, aes(x = alc_use, fill = sex))

# define the plot as a bar plot and draw it
g1 + geom_bar()

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# initialize a plot of 'high_use'
g2 <- ggplot(alc, aes(high_use))

# draw a bar plot of high_use by sex
g2 + facet_wrap("sex") + geom_bar()

glimpse(alc)

# Save the dataset

write.csv(alc, file = "data/alc.csv", row.names = FALSE)

# Read back the dataset

alc <- read.csv("data/alc.csv")

str(alc)
head(alc)