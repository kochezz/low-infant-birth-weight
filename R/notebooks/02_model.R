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
install.packages("e1071")
install.packages("glue")
install.packages("pROC")



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
library(e1071)
library(glue)
library(pROC)




#------------------------------------------------------

# OBJECTIVE:

# Develop a model to predict if birth weight is low or not using the given variables

# The Data for a Study of Risk Factors Associated with Low Infant Birth Weight is as follows.

# Description of variables:

# low – Low Birth Weight (0 means Not low and 1 means low) 
# age- Age of the Mother in Years 
# lwt- Weight in Pounds at the Last Menstrual Period 
# race- Race (1 = White, 2 = Black, 3 = Other) 
# smoke- Smoking Status During Pregnancy (1 = Yes, 0 = No) 
# ptl- History of Premature Labor (0 = None, 1 = One, etc.) 
# ht- History of Hypertension (1 = Yes, 0 = No) 
# ui- Presence of Uterine Irritability (1 = Yes, 0 = No) 
# ftv- Number of Physician Visits During the First Trimester (0 = None, 1 = One, 2 = Two, etc.)



#------------------------------------------------------

# Load cleaned dataset.

birth_wt_cleaned <- read.csv("birth_wt_cleaned.csv", header = TRUE)


str(birth_wt_cleaned,5)

#------------------------------------------------------

# birth_wt_cleaned <- birth_wt_cleaned %>%
  #mutate(low = factor(low, levels = c(0, 1), labels = c("Not Low", "Low")))

# Now partition
set.seed(123)
train_index <- createDataPartition(birth_wt_cleaned$low, p = 0.8, list = FALSE)

train_data <- birth_wt_cleaned[train_index, ]
test_data  <- birth_wt_cleaned[-train_index, ]

# View Train Data

glimpse(train_data)
summary(train_data)

# View Test Data

glimpse(test_data)
summary(test_data)





#---------------------------------------------------------

# Save Train and Test Data

write.csv(train_data, "train_data.csv", row.names = FALSE)
write.csv(test_data,  "test_data.csv",  row.names = FALSE)


#---------------------------------------------------------
# Fitting the model

logit_model <- glm(low ~ age+lwt+race+smoke+ptl+ht+ui+ftv,
                   data = train_data,
                   family = binomial)


summary(logit_model)

#---------------------------------------------------------

# Predict on the test set

# Generate predicted probabilities on test data
pred_probs <- predict(logit_model, newdata = test_data, type = "response")

# Classify as Low (< threshold 0.5)
pred_class <- ifelse(pred_probs >= 0.5, "Low", "Not Low")

# Convert to factor with same levels
pred_class <- factor(pred_class, levels = levels(test_data$low))


#----------------------------------------------------------

# Predict Probabilities on Test Data set

test_data$pred_prob <- predict(logit_model, newdata = test_data, type = "response")



#----------------------------------------------------------

# Evaluate model performance


# Confusion Matrix
conf_matrix <- confusionMatrix(pred_class, test_data$low)

print(conf_matrix)



#----------------------------------------------------------------


# Generate three classification tables with cut-off values 0.4, 0.3 and 0.55.

# Create a function to generate confusion matrices at different cut-offs:


generate_conf_matrix <- function(threshold) {
  predicted_class <- ifelse(test_data$pred_prob >= threshold, "Low", "Not Low")
  actual_class <- ifelse(test_data$low == 1, "Low", "Not Low")
  
  # Convert to factors with same levels
  predicted_class <- factor(predicted_class, levels = c("Not Low", "Low"))
  actual_class <- factor(actual_class, levels = c("Not Low", "Low"))
  
  # Create confusion matrix
  cm <- confusionMatrix(predicted_class, actual_class, positive = "Low")
  print(glue::glue("Threshold = {threshold}"))
  print(cm$table)
  print(cm$byClass[c("Sensitivity", "Specificity")])
  print(glue::glue("Misclassification Rate = {round(1 - sum(diag(cm$table)) / sum(cm$table), 3)}"))
  cat("\n\n")
}



# Running the Cut offs, generating the classification Tables.

generate_conf_matrix(0.4)

generate_conf_matrix(0.3)

generate_conf_matrix(0.55)


#------------------------------------------------------------

# Based on Out put we shall evaluate the prediction probabilities

summary(test_data$pred_prob)


#------------------------------------------------------------

# Plot Probability Distribution

test_data$low <- as.factor(test_data$low)

# Density plot
ggplot(test_data, aes(x = pred_prob, fill = low)) +
  geom_density(alpha = 0.5) +
  labs(title = "Distribution of Predicted Probabilities",
       x = "Predicted Probability of Low Birth Weight",
       fill = "Actual Class") +
  theme_minimal()



#------------------------------------------------------------

# ROC curve and report area under curve.

# "Low" is the positive class

roc_obj <- roc(response = test_data$low,
               predictor = test_data$pred_prob,
               levels = c("Not Low", "Low"),
               direction = "<")  


plot(roc_obj, col = "#2c7fb8", lwd = 2, main = "ROC Curve - Logistic Regression")
abline(a = 0, b = 1, lty = 2, col = "gray")  # Diagonal reference line


auc(roc_obj)


table(test_data$low)


#---------------------------------------------------------------

# Save Model

setwd("C:/Users/willi/GitHub/APM_low_infant_birth_wt_R/models")

saveRDS(logit_model, file = "birth_wt_logit_model.rds")







































