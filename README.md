# Low Infant Birth Weight Classification using Logistic Regression (R)

[![R](https://img.shields.io/badge/Built%20With-R-blue?logo=r)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status](https://img.shields.io/badge/Status-In%20Progress-orange)]()
[![Data](https://img.shields.io/badge/Data-Cleaned-lightgrey)]()

---

## 📘 Project Overview

This project applies **Logistic Regression** in **R** to classify whether an infant’s birth weight is considered **low** based on various maternal and clinical factors. The dataset comes from a study conducted at **Baystate Medical Center**, Springfield, Massachusetts.

The goal is to:
- Model and predict low birth weight using available features.
- Evaluate model performance across different thresholds.
- Save and reuse the trained model for deployment.

---

## 📂 Repository Structure

```
├── data/
│   ├── raw/                       # Original BIRTH WEIGHT.csv
│   ├── processed/                 # Cleaned, split, and transformed datasets
├── models/                        # Saved model (logit_model.rds)
├── R/
│   ├── scripts/                   # R scripts used throughout
│   └── reports/                   # Output summaries and visualizations
├── dashboards/                    # (optional) Shiny or Streamlit apps
└── README.md                      # Project documentation
```

---

## 🔍 Dataset Summary

**Target Variable:**  
- `low`: 1 = Low birth weight, 0 = Not low

**Independent Variables:**
- `age`: Age of the mother
- `lwt`: Mother’s weight at last menstrual period
- `race`: 1 = White, 2 = Black, 3 = Other
- `smoke`: Smoker during pregnancy (1 = Yes, 0 = No)
- `ptl`: Number of previous premature labors
- `ht`: History of hypertension (1 = Yes, 0 = No)
- `ui`: Uterine irritability (1 = Yes, 0 = No)
- `ftv`: Physician visits during 1st trimester

---

## 🧪 Model Development Summary

| Step                     | Outcome                                                                 |
|--------------------------|-------------------------------------------------------------------------|
| Data Cleaning            | Variables converted to proper factor/numeric types                     |
| Train/Test Split         | 80/20 stratified split using `caret::createDataPartition()`             |
| Model Type               | Logistic Regression (`glm(family = binomial)`)                          |
| Variables Used           | All clinically relevant predictors                                      |
| Model Export             | Saved using `saveRDS()` in `models/` folder                            |

---

## 📊 Model Evaluation

### 📈 Classification Performance at Multiple Thresholds:
| Threshold | Sensitivity | Specificity | Misclassification Rate |
|-----------|-------------|-------------|--------------------------|
| 0.30      | 0.00        | 0.54        | 0.459                    |
| 0.40      | 0.00        | 0.70        | 0.297                    |
| 0.55      | 0.00        | 0.78        | 0.216                    |

🔍 **Note:** The model struggled to identify “Low” cases due to class imbalance in the test set.

---

### 📉 ROC Curve & AUC

- **AUC:** 0.521  
- **Interpretation:** Very weak classification ability, nearly random
- **Next steps:** Consider resampling (e.g., SMOTE), feature tuning, or ensemble methods

---

## 💾 Files Saved

- `logit_model.rds`: Trained logistic regression model
- `test_data_with_predictions.csv`: Contains probabilities and predicted labels
- `birth_wt_cleaned.csv`: Cleaned dataset used for modeling

---

## 🚀 Next Steps

- Investigate imbalance handling techniques (e.g. SMOTE)
- Explore alternative models: decision trees, random forest
- Build interactive dashboard using Shiny or Streamlit
- Compare multiple models and threshold strategies

---

## 📬 Contact

Developed by **Business Enterprise Data Architecture (BEDA)**  
📩 Email: [wphiri@beda.ie](mailto:wphiri@beda.ie)  
🔗 LinkedIn: [William Phiri](https://www.linkedin.com/in/william-phiri-866b8443/)  
🧭 _"Get it done the BEDA way"_

---

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.
