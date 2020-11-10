# Savi Virolainen, 10.11.2020
# Portuguese secondary school achievement questionnaire data: performance in math (mat) and Portuguese language (por).

library(dplyr)

# 3. Read the data:
setwd("~/Documents/IODS-project")
math <- read.csv("data/student-mat.csv", sep=";")
por <- read.csv("data/student-por.csv", sep=";")

# Pre-examine the (cross-sectional) data:
str(math) # 395 observations for 33 variables
str(por) # 649 observations for 33 variables
colnames(math) == colnames(por) # The variables seem to be the same in both data

# 4. We join the two datasets using the backround variables as identifiers and keep only the student's
#    present in both datasets (it was discussed in the forum that this does not lead to perfect join but
#    we nevertheless do the join with the identifiers given in the assignment).
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu",
             "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
math_por <- inner_join(math, por, by=join_by)

# 5. We combine dublicate answers to the new data by taking the mean
alc <- select(math_por, any_of(join_by)) # Initialize new data set with the identifiers only
not_joined_cols <- colnames(math)[!colnames(math) %in% join_by] # Variables not used as identifiers

for(col_name in not_joined_cols) {
  two_cols <- select(math_por, starts_with(col_name)) # Corresponding columns from math and por
  first_col <- two_cols[,1] # The first of the two
  if(is.numeric(first_col)) { # If numeric variable...
    alc[col_name] <- round(rowMeans(two_cols)) # Take rounded average of the two columns
  } else { # If non-numeric variable...
    alc[col_name] <- first_col # Pick the first column
  }
}

# 6. Create a new column alc_use that is average of daily and weekly usages and also 
#    high_use that is logical indicating whether alc_use is more than two.
alc <- mutate(alc, alc_use = (Dalc+Walc)/2) %>% mutate(high_use = alc_use > 2)

# 7. Glimpse the data and save it:
glimpse(alc)
write.csv(alc, file="data/alc.csv", row.names=FALSE)

