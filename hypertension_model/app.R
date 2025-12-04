library(shiny)
library(rstanarm)
library(ggplot2)

# Load model
diabetes_model <- readRDS("diabetes_model.rds")

ui <- fluidPage(
  
  titlePanel("Bayesian Model: High Blood Pressure Predictor"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("BMI", "BMI:", value = 25, min = 10, max = 60),
      numericInput("Age", "Age:", value = 40, min = 18, max = 90),
      
      selectInput("Diabetes", "Diabetes:", choices = c(0, 1)),
      selectInput("HighChol", "High Cholesterol:", choices = c(0, 1)),
      selectInput("CholCheck", "Cholesterol Check (Past Year):", choices = c(0, 1)),
      selectInput("Sex", "Sex (1 = Female):", choices = c(0, 1)),
      selectInput("Smoker", "Smoker:", choices = c(0, 1)),
      selectInput("HeartDisease", "Heart Disease/Attack:", choices = c(0, 1)),
      selectInput("PhysActivity", "Physical Activity:", choices = c(0, 1)),
      selectInput("Stroke", "Stroke:", choices = c(0, 1)),
      selectInput("Alcohol", "Heavy Alcohol Consumer:", choices = c(0, 1))
    ),
    
    mainPanel(
      h3("Predicted Probability of High Blood Pressure"),
      textOutput("prediction"),
      br(),
      plotOutput("distPlot"),
      br(),
      plotOutput("oddsRatioPlot")   # <-- NEW ODDS RATIO VISUAL
    )
  )
)

server <- function(input, output) {
  
  # Reactive predicted probability
  predicted_prob <- reactive({
    
    new_data <- data.frame(
      Diabetes = as.numeric(input$Diabetes),
      HighChol = as.numeric(input$HighChol),
      BMI = input$BMI,
      CholCheck = as.numeric(input$CholCheck),
      Age = input$Age,
      Sex = as.numeric(input$Sex),
      Smoker = as.numeric(input$Smoker),
      HeartDiseaseorAttack = as.numeric(input$HeartDisease),
      PhysActivity = as.numeric(input$PhysActivity),
      Stroke = as.numeric(input$Stroke),
      HvyAlcoholConsump = as.numeric(input$Alcohol)
    )
    
    p <- posterior_epred(diabetes_model, newdata = new_data)
    mean(p)
  })
  
  output$prediction <- renderText({
    paste0(round(predicted_prob() * 100, 1), "%")
  })
  
  output$distPlot <- renderPlot({
    
    new_data <- data.frame(
      Diabetes = as.numeric(input$Diabetes),
      HighChol = as.numeric(input$HighChol),
      BMI = input$BMI,
      CholCheck = as.numeric(input$CholCheck),
      Age = input$Age,
      Sex = as.numeric(input$Sex),
      Smoker = as.numeric(input$Smoker),
      HeartDiseaseorAttack = as.numeric(input$HeartDisease),
      PhysActivity = as.numeric(input$PhysActivity),
      Stroke = as.numeric(input$Stroke),
      HvyAlcoholConsump = as.numeric(input$Alcohol)
    )
    
    p <- posterior_epred(diabetes_model, newdata = new_data)
    
    hist(as.numeric(p),
         breaks = 30,
         col = "skyblue",
         main = "Posterior Predictive Distribution",
         xlab = "Predicted Probability")
  })
  
  
  # ⭐ NEW: Odds Ratio Plot
  output$oddsRatioPlot <- renderPlot({
    
    # Extract posterior samples
    post <- as.matrix(diabetes_model)
    coef_names <- colnames(post)[-1]   # drop intercept
    
    # Compute OR = exp(beta)
    OR_means <- apply(post[, coef_names], 2, function(x) exp(mean(x)))
    OR_low   <- apply(post[, coef_names], 2, function(x) exp(quantile(x, 0.025)))
    OR_high  <- apply(post[, coef_names], 2, function(x) exp(quantile(x, 0.975)))
    
    df <- data.frame(
      Predictor = coef_names,
      OR = OR_means,
      Low = OR_low,
      High = OR_high
    )
    
    ggplot(df, aes(x = reorder(Predictor, OR), y = OR)) +
      geom_point(size = 3, color = "darkred") +
      geom_errorbar(aes(ymin = Low, ymax = High), width = 0.2) +
      geom_hline(yintercept = 1, linetype = "dashed") +
      coord_flip() +
      labs(
        title = "Odds Ratios for Predictors",
        x = "Predictor",
        y = "Odds Ratio"
      ) +
      theme_minimal(base_size = 14)
  })
}

shinyApp(ui = ui, server = server)
