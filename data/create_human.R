# Savi Virolainen 17.11.2020
# Human developments and Gender inequality data creation file

######################
## Week 4 wrangling ##
######################

# Download Human development (hd) and Gender inequality (gii) data:
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Information regarding the data ara available though the following links:
browseURL("http://hdr.undp.org/en/content/human-development-index-hdi")
browseURL("http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf")

# Exploring the structure and dimensions of the data:
str(hd) # 195 observations, 8 variables some of which are numeric and some character
str(gii) # 195 observations, 10 variables some of which are named similarly to hd data

# Summaries of the variables:
summary(hd)
summary(gii)

# Rename columns with shorter but descriptive names:
# Old names:
colnames(hd)
colnames(gii)

# New names:
colnames(hd) <- c("HDIrank", "country", "HDI", "lifexp", "expedu", "meanedu", "GNI", "GNIminusHDrank")
colnames(gii) <- c("GIIrank", "country", "GII", "matmortality", "teenbirthrate", "percparliament",
                   "edu2F", "edu2M", "laborF", "laborM")

# We add two more variables to the gii data: female/male second education population ratio and 
# female/male labor force participation ratio:
library(dplyr)
gii <- mutate(gii, edu2ratio=edu2F/edu2M) %>% mutate(labratio=laborF/laborM)

# Finally, we combine the two the data and keep only countries that appear in both data (all them do):
human <- inner_join(hd, gii, by="country")
dim(human) # 195 observations and 19 variables

# Save the data
write.csv(human, file="data/human.csv", row.names=FALSE)

######################
## Week 5 wrangling ##
######################

# Load the data:
human <- read.csv("data/human.csv")

# Explore the structure and dimensions:
str(human) # 195 observations of 19 variables.

# The data "human" was created by combining human development index (HDI) and gender inequality index (GII) data that contain
# several variables for different counties (observation units). The HDI constitutes of indicators that measure long and
# healthy life, knowledge, and decent standard of living. The variables in the data are the following. The GII constitues of
# indicators that measure health, empowerment, and labour market.
# HDIrank = rank in the HDI
# country = country
# HDI = HDI
# lifexp = life expectancy at birth
# expedu = expected years of education
# meanedu = mean years of education
# GNI = gross national income per capita
# GNIminusHDrank = GNI per capita rank minus HDI rank
# GIIrank = rank in GII
# GII = GII
# matmortality = maternal mortality ratio
# teenbirthrate = adolescent birth rate
# percparliament = percent representation in parliament
# edu2F = population with secondary education female
# edu2M = population with secondary education male
# laborF = labor force participation ratio female
# laborM = labor force participation ratio male
# edu2ratio = edu2F/edu2M
# labratio = laborF/laborM

# We transform GNI into numeric and remove the comma:
human$GNI <- stringr::str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

# Keep only some of the columns (note the difference in naming of the variables 
# we did in the previous week compared to the assignment):
keep <- c("country", "edu2ratio", "labratio", "lifexp", "expedu", "GNI", "matmortality", "teenbirthrate", "percparliament")
human <- dplyr::select(human, any_of(keep))

# Remove rows with missing vaues:
human <- filter(human, complete.cases(human))
complete.cases(human)

# Remove the observations which relate to regions instead of countries:
regions <- c("East Asia and the Pacific", "Latin America and the Caribbean", "Sub-Saharan Africa",
             "Arab States", "Europe and Central Asia", "South Asia", "World")
human <- filter(human, !country %in% regions)

# Define row names by countries and remove the variable country
rownames(human) <- human$country
human <- dplyr::select(human, -country)

dim(human) # 155 observations and 8 variables

# Save the data
write.csv(human, file="data/human.csv", row.names=TRUE)
