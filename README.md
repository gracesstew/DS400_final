# DS400 Final Project: Hypertension Probability Prediction Using Bayesian Modeling

Ashley Alfaro, Berylin Lau, Grace Stewart

December 4, 2025

## **Project Summary** ##
This project investigates which personal characteristics and health behaviors are most strongly associated with hypertension and evaluates how accurately these factors can predict an individual's probability of having high blood pressure.

**Research Question:** What are the strongest indicators of hypertension, and how accurately can we predict the probability that someone with similar habits and characteristics would have hypertension?

## **Data** ##
[Diabetes, Hypertension and Stroke Prediction](https://www.kaggle.com/datasets/prosperchuks/health-dataset)<br>
The dataset comes from the Behavioral Risk Factor Surveillance System (BRFSS) 2015 survey, made available through Kaggle. After cleaning, the dataset contains 70,692 individual survey responses from adults in the United States. This dataset includes a mixture of demographic information, such as age category and sex, along with several health-related behavioral and medical history variables.


## Folder Structure

```
project_root/
│
├── data/
│   └── diabetes_data.csv
│
├── hypertension_model/
│   ├── hpt_model.rds
│   ├── diabetes.rds
│   ├── app.R
│   └── app-2.R
│
└── individual_code/
    └── (optional exploratory scripts)
```

## How to Run the Shiny Apps
### Required Downloads

To successfully run the Shiny applications:

1. Download both model files (`hpt_model.rds` and `diabetes_model.rds`).
2. Download the Shiny app R scripts (`app.R` and `app-2.R`).
3. Download the dataset `diabetes_data.csv` and place it into a folder named `data`.

### Running the Apps
**`app.R`** provides:
* Posterior predictive distribution based on selected characteristics.
* A plot displaying odds ratios for predictors.

To run:
Open `app.R` in R or RStudio and click Run App.

**`app-2.R`** provides:
* Predicted probability of hypertension (posterior distribution).
* A simulation of 1,000 people with selected characteristics, showing expected number of individuals with hypertension.

To run:
Open `app-2.R` in R or RStudio and click Run App.

## **Our Team** ##

Ashley Alfaro — [GitHub](https://github.com/AshleySofiaAlfaro)

Berylin Lau — [GitHub](https://github.com/m22belau)

Grace Stewart — [GitHub](https://github.com/gracesstew)
