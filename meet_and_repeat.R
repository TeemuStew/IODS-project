# Teemu Mäkelä
# 3.12.2020

library(dplyr)
library(magrittr)
library(tidyr)

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = T)

glimpse(BPRS)
glimpse(RATS)

summary(BPRS)
summary(RATS)

BPRS$treatment <- as.factor(BPRS$treatment)
BPRS$subject <- as.factor(BPRS$subject)
RATS$ID <- as.factor(RATS$ID)
RATS$Group <- as.factor(RATS$Group)

BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject) %>% mutate(week = as.integer(substr(weeks, 5,5)))
RATSL <- RATS %>%  gather(key = WD, value = Weight, -ID, -Group) %>% mutate(Time = as.integer(substr(WD, 3, 4))) 

glimpse(BPRSL)
glimpse(RATSL)

write.table(RATSL, "RATSL.txt")
write.table(BPRSL, "BPRSL.txt")