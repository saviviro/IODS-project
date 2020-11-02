# Savi Virolainen, 2.11.2020
# Week 2 data wrangling exercise that creates the dataset.

########
## 2. ##
########

# Read the full learning2014 data from the url:
learning2014_orig <- read.csv(url("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt"), sep="\t")

########
## 3. ##
########

# Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points by
# combining questions in the learning2014_orig data.

# Variables gender, age, and attitude are already included in the data as is. We therefore create three
# more variables: means of variables related to deep, surface, and strategic learning.

# We create vectors of variable names that relate to the areas of learning, as in data camp:
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06", "D15", "D23", "D31")
surface_questions <- c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21", "SU29", "SU08", "SU16", "SU24", "SU32")
strategic_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")

# To avoid copy-paste code, we create a function that, for each area of learning, selects the related variables and
# calculates the sample mean of those variables for each respondent. 
create_var <- function(var_names) rowMeans(dplyr::select(learning2014_orig, any_of(var_names)))

# Finally, we construct the new dataset as instructed and remove respondents with exam points variable zero:
learning2014 <- with(learning2014_orig, data.frame(gender=gender,
                                       age=Age,
                                       attitude=Attitude,
                                       deep=create_var(deep_questions),
                                       stra=create_var(strategic_questions),
                                       surf=create_var(surface_questions),
                                       points=Points))
learning2014 <- dplyr::filter(learning2014, points != 0) # Filter out the zero-point respondents
str(learning2014) # 166 observations and 7 variables as should be.

########
## 4. ##
########

# We set working directory to be the project folder:
setwd("~/Documents/IODS-project")

# We save the analysis dataset to the 'data' folder as 'learning2014.csv':
write.csv(learning2014, file="data/learning2014.csv", row.names=FALSE)

# Finally, we read the data created above and examine its head and structure:
lrn2014 <- read.csv("data/learning2014.csv")
head(lrn2014, n=5)
str(lrn2014) # 166 observations and 7 variables as should be.
