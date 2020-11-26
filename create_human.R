# Teemu Mäkelä
# 19.11.2020

library(dplyr)

# Read the datasets

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Exploring the datasets

glimpse(hd)
glimpse(gii)

# Summaries

summary(hd)
summary(gii)

# Renaming the variables

hd <- rename(hd, HDI_rank = HDI.Rank, HDI = Human.Development.Index..HDI., life_exp = Life.Expectancy.at.Birth, ed_exp = Expected.Years.of.Education, ed_mean = Mean.Years.of.Education, GNI = Gross.National.Income..GNI..per.Capita, GNI_minus_HDI = GNI.per.Capita.Rank.Minus.HDI.Rank)
head(hd) 

gii <- rename(gii, GII_rank = GII.Rank, GII = Gender.Inequality.Index..GII., mat_mort_ratio = Maternal.Mortality.Ratio, adol_birthrate = Adolescent.Birth.Rate, rep_parliament = Percent.Representation.in.Parliament, F_secondary_ed = Population.with.Secondary.Education..Female., M_secondary_ed = Population.with.Secondary.Education..Male., F_labour_force = Labour.Force.Participation.Rate..Female., M_labour_force = Labour.Force.Participation.Rate..Male.)
head(gii) 

gii <- gii %>% mutate(ed_FM = F_secondary_ed/M_secondary_ed, labour_FM = F_labour_force, M_labour_force)
head(gii) 

# Join the datasets
human <- inner_join(hd, gii, by = "Country")
dim(human) # 195 and 19 as it should

write.table(human, file = "human.txt")

# Week 5 exercise
# 26.11.2020

human <- human %>% rename(country = Country, edu_exp = ed_exp, edu_mean = ed_mean, secondary_eduF = F_secondary_ed, secondary_eduM = M_secondary_ed, labour_forceF = F_labour_force, labour_forceM = M_labour_force, edu_FM = ed_FM)

glimpse(human)

# Mutate GNI to numeric
library(stringr)

human <- human %>% mutate(GNI= as.numeric(str_replace(GNI, pattern=",", replace ="")))

# Keep certain columns
keep_columns <- c("country", "edu_FM", "labour_FM", "edu_exp", "life_exp", "GNI", "mat_mort_ratio", "adol_birthrate", "rep_parliament")
human <- select(human, one_of(keep_columns))

# Exclude missing values
human <- human %>% na.omit

# Remove regional observations (not countries)
human$country

# Looks like the last 7 are regional observations

tail(human, 7)

# Define the last indice we want to keep
last <- nrow(human)- 7

# Choose everything until the last 7 observations
human_ <- human[1:last,]

# Add countries as rownames and remove countries
rownames(human_) <- human_$country
human_ <- select(human_, -country)
dim(human_) 

write.table(human_, file = "human_5", col.names = TRUE)