# Savi Virolainen 30.11.2020
# Meet and repeat wrangling

library(dplyr)
library(tidyr)

# Read and load the BPRS and RATS datas:
BPRS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep=" ")
RATS <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep="\t")

# Examine structure of the data (also shows the variable names,  dimensions, etc):
str(BPRS) # 40 observations from nine (0-8) weeks
str(RATS) # 16 observations from 11 different days (WD)

# Summaries of the variables:
summary(BPRS)
summary(RATS)

# The variables "treatment" and "subject" in the BPRS data are categorical, so
# we transform them into factors:
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# WE ALSO NEED TO CREATE ID VARIABLE FOR BPRS DATA BECAUSE THE SUBJECT VARIABLE
# ONLY DIFFERENCIATES INDIVIDUALS WITHIN EACH TREATMENT GROUP:
BPRS$ID <- factor(1:nrow(BPRS))

# The variables "ID" and "Group" in the RATS data are categorical, so we 
# transform them into factors:
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# We convert the data into long form:
BPRSL <- gather(BPRS, key = weeks, value = bprs, -treatment, -subject, -ID)
RATSL <- gather(RATS, key = WD, value = Weight, -ID, -Group)

# We add a week variable to BPRS and a Time variable to RATS:
BPRSL <-  mutate(BPRSL, week = as.integer(substr(weeks, 5, 5)))
RATSL <- mutate(RATSL, Time = as.integer(substr(WD, 3, 4))) 

# Examine the long form data:
str(BPRSL) # Shows variable names, contents, and structure
str(RATSL)

head(BPRSL) # Shows some of the contents from different perspective
head(RATSL)

# BPRS long data summary: means and se's of variable bprs of by treatment and week:
BPRSL %>% group_by(treatment, week) %>% summarise(mean = mean(bprs), se = sd(bprs)/sqrt(length(unique(BPRSL$week))))

# RATS long data summary: means and se's of variable weights by group and time:
RATSL %>% group_by(Group, Time) %>% summarise(mean = mean(Weight), se = sd(Weight)/sqrt(length(unique(RATSL$Time))))

# Save the data:
write.csv(BPRS, file="data/BPRS.csv", row.names=FALSE)
write.csv(RATS, file="data/RATS.csv", row.names=FALSE)
write.csv(BPRSL, file="data/BPRSL.csv", row.names=FALSE)
write.csv(RATSL, file="data/RATSL.csv", row.names=FALSE)


