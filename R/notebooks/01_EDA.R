###########################

# Advanced Predictive Modelling

###########################

# Author: William C. Phiri
# Date: 07 May 2025
# Pillar 1e: - Module 4 - Assignment

#------------------------------------------

# Install PAckages


install.packages("tidyverse")
install.packages("naniar")
install.packages("dplyr")
install.packages("car")
install.packages("GGally")
install.packages("MASS")
install.packages("caret")
install.packages("reshape2")
install.packages("nortest")
install.packages("janitor")
install.packages("rsample")
install.packages("gmodels")
install.packages("ROCR")

# Load necessary packages
library(tidyverse)
library(naniar)
library(dplyr)
library(ggplot2)
library(car)
library(GGally)
library(MASS)
library(caret)
library(reshape2)
library(nortest)
library(janitor)
library(rsample)
library(gmodels)
library(ROCR)
#------------------------------------------------------

# Load Data sets from PostgreSQL Database

file.edit("~/.Renviron")

birth_weight_data<-read.csv("BIRTH WEIGHT.csv",header=T)

#-------------------------------------------------------


# Sanitization Check

str(birth_weight_data)

head(birth_weight_data)

any(is.na(birth_weight_data))

summary(birth_weight_data)


#--------------------------------------------------------

# Initial Data Viz


birth_weight_data$LOW <- as.factor(birth_weight_data$LOW)
levels(birth_weight_data$LOW) <- c("Not Low", "Low")

ggpairs(birth_weight_data[, c("AGE", "LWT", "PTL", "FTV", "LOW")],
        aes(color = LOW, alpha = 0.6))























