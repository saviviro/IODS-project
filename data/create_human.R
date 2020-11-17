# Savi Virolainen 17.11.2020
# Human developments and Gender inequality data creation file

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
colnames(hd) <- c("HDrank", "country", "HDindex", "lifexp", "expedu", "meanedu", "GNI", "GNIminusHDrank")
colnames(gii) <- c("GIrank", "country", "GIindex", "matmortality", "teenbirthrate", "percparlament",
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
