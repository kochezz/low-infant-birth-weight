###########################

# Advanced Predictive Modelling

###########################

# Author: William C. Phiri
# Date: 07 May 2025
# Pillar 1e: - Module 4 - Assignment

#------------------------------------------

# Install PAckages


install.packages("tidyverse")
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
install.packages("DBI")
install.packages("RPostgres")
install.packages("readr")
install.packages("patchwork")



# Load necessary packages
library(tidyverse)
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
library(DBI)
library(RPostgres)
library(readr)
library(patchwork)

#------------------------------------------------------

# BACKGROUND

# # The Data for a Study of Risk Factors Associated with Low Infant Birth Weight. 
# Data were collected at Baystate Medical Center, Springfield, Massachusetts.
# 
# Description of variables -
#   
# LOW – Low Birth Weight (0 means Not low and 1 means low)
# 
# AGE- Age of the Mother in Years
# 
# LWT- Weight in Pounds at the Last Menstrual Period
# 
# RACE- Race (1 = White, 2 = Black, 3 = Other)
# 
# SMOKE- Smoking Status During Pregnancy (1 = Yes, 0 = No)
# 
# PTL- History of Premature Labor (0 = None, 1 = One, etc.)
# 
# HT- History of Hypertension (1 = Yes, 0 = No)
# 
# UI- Presence of Uterine Irritability (1 = Yes, 0 = No)
# 
# FTV- Number of Physician Visits During the First Trimester (0 = None, 1 = One, 2 = Two, etc.)



#------------------------------------------------------

# Load Data sets from PostgreSQL Database

file.edit("~/.Renviron")

Sys.getenv("NEON_DB_HOST") 

con <- dbConnect(
  RPostgres::Postgres(),
  dbname   = Sys.getenv("NEON_DB_NAME"),
  host     = Sys.getenv("NEON_DB_HOST"),
  port     = as.integer(Sys.getenv("NEON_DB_PORT")),
  user     = Sys.getenv("NEON_DB_USER"),
  password = Sys.getenv("NEON_DB_PASS"),
  sslmode  = "require"
)


# Check the connection
print("Connected successfully to Neon PostgreSQL!")

# View available tables
print(dbListTables(con))

# Read Data

birth_wt_data<-dbReadTable(con, "birth_weight")

#-------------------------------------------------------


# Sanitization Check


str(birth_wt_data)

head(birth_wt_data)

any(is.na(birth_wt_data))

summary(birth_wt_data)


#--------------------------------------------------------

# Convert relevant variables 

birth_wt_cleaned <- birth_wt_data %>%
  rename_with(tolower) %>%
  mutate(
    
    low = as.numeric(as.character(low)),
    
    low = factor(low, levels = c(0, 1), labels = c("Not Low", "Low")),
    
    race  = factor(race, levels = c(1, 2, 3), labels = c("White", "Black", "Other")),
    smoke = factor(smoke, levels = c(0, 1), labels = c("No", "Yes")),
    ptl   = factor(ptl),
    ht    = factor(ht, levels = c(0, 1), labels = c("No", "Yes")),
    ui    = factor(ui, levels = c(0, 1), labels = c("No", "Yes")),
    ftv   = factor(ftv)
  )

table(birth_wt_cleaned$low)


str(birth_wt_cleaned)

#--------------------------------------------------------


# Initial Data Viz

# 1: Bar plots for categorical predictors vs. low


#  i SMOKE vs LOW

p1 <- ggplot(birth_wt_cleaned, aes(x = smoke, fill = low)) +
  geom_bar(position = "fill") +
  labs(title = "Proportion of Low Birth Weight by Smoking Status",
       x = "Smoking During Pregnancy",
       y = "Proportion") +
  scale_fill_manual(values = c("steelblue", "tomato")) +
  theme_minimal()

#  ii HT (Hypertension) vs LOW

p2 <- ggplot(birth_wt_cleaned, aes(x = ht, fill = low)) +
  geom_bar(position = "fill") +
  labs(title = "Proportion of Low Birth Weight by Hypertension Status",
       x = "Hypertension",
       y = "Proportion") +
  scale_fill_manual(values = c("lightgreen", "tomato")) +
  theme_minimal()



# 2: Boxplots for continuous variables vs. low

# i- Age vs Low

p3 <- ggplot(birth_wt_cleaned, aes(x = low, y = age, fill = low)) +
  geom_boxplot() +
  labs(title = "Age Distribution by Birth Weight Category",
       x = "Birth Weight Category",
       y = "Mother's Age") +
  scale_fill_manual(values = c("steelblue", "lightgreen")) +
  theme_minimal()

# ii- LWT vs Low

p4 <- ggplot(birth_wt_cleaned, aes(x = low, y = lwt, fill = low)) +
  geom_boxplot() +
  labs(title = "Mother's Weight (LWT) by Birth Weight Category",
       x = "Birth Weight Category",
       y = "Weight at Last Menstrual Period (lbs)") +
  scale_fill_manual(values = c("steelblue", "tomato")) +
  theme_minimal()



(p1 + p2) / (p3 + p4) + plot_annotation(title = "Summary of Key Predictors vs. Low Birth Weight")


#--------------------------------------------------------


# Cross Tabulation of dependent variable(LOW) with each Independent variable.

# Smoke vs Low
cat("Smoking vs Low Birth Weight:\n")
print(table(birth_wt_cleaned$low, birth_wt_cleaned$smoke))

# Hypertension vs Low
cat("\nHypertension vs Low Birth Weight:\n")
print(table(birth_wt_cleaned$low, birth_wt_cleaned$ht))

# Uterine Irritability vs Low
cat("\nUterine Irritability vs Low Birth Weight:\n")
print(table(birth_wt_cleaned$low, birth_wt_cleaned$ui))

# Premature Labor vs Low
cat("\nPremature Labor vs Low Birth Weight:\n")
print(table(birth_wt_cleaned$low, birth_wt_cleaned$ptl))

# First Trimester Visits vs Low
cat("\nFirst Trimester Visits vs Low Birth Weight:\n")
print(table(birth_wt_cleaned$low, birth_wt_cleaned$ftv))

# Race vs Low
cat("\nRace vs Low Birth Weight:\n")
print(table(birth_wt_cleaned$low, birth_wt_cleaned$race))


# Proportional Cross-Tabs

# Proportions across columns (within smoke groups)
prop.table(table(birth_wt_cleaned$low, birth_wt_data$smoke), margin = 2)


#-------------------------------------------------------


# Save birth_wt data set locally

setwd("C:/Users/willi/GitHub/APM_low_infant_birth_wt_R/data/processed")

readr::write_csv(birth_wt_cleaned,"birth_wt_cleaned.csv")


#-------------------------------------------------------









