install.packages("h2o")
library("h2o")

dff <- read.csv("rf1_train.csv")
#Inital opening of H2o
h2o.init(
  nthreads = -1,
  max_mem_size = "2G")

#Importing File to h2O
df <- h2o.importFile(path = "rf1_train.csv")
#Creating a Split for train, test
splits <- h2o.splitFrame( df, c(0.6, 0.2), seed = 1234 )
#Splits being made
train <- h2o.assign(splits[[1]], "train")   
valid <- h2o.assign(splits[[2]], "valid")
test <-  h2o.assign(splits[[3]], "test")     
test$Weekly_Sales
#H2O Model for Forecasting Weekly_Sales by..
rf1 <- h2o.randomForest(
  training_frame = train,
  validation_frame = valid,
  #Predict Variables
  x= 3:16,
  #Predict Y based on X vari
  y= 1,
  model_id = "rf_weekly",
  ntrees = 50,
  max_depth = 10,
  stopping_rounds = 2,
  stopping_tolerance = 1e-3,
  seed = 1000000)

rf2 <- h2o.predict(rf1, newdata = test)
rf2

summary(rf1)
#Gradient Boostin Model for greater accuracy
gbm1 <- h2o.gbm(
  training_frame = train, 
  validation_frame = valid,      
  x=3:16,                      
  y=1,     
  ntrees = 50,
  max_depth = 10,
  stopping_rounds = 2,
  stopping_tolerance = 1e-3,
  model_id = "gbm_covType1",    
  seed = 2000000)               

#Summary of models created
summary(gbm1)
summary(rf1)

#Test Predict
rf2 <- h2o.predict(rf1, newdata = test)
rf2
test[1:15,]
summary(rf2)
summary(test)
#Grad Boosting Model `Created for predicting Test Data`
gm2 <- h2o.predict(gbm1, newdata = test )
gm2
summary(gm2)
h2o.accuracy(gm2)
