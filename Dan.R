install.packages('forecast')
library('randomForest')
library('dplyr')
library('h2o')
#Merging CSV files----
test <- read.csv(file = "trainMerged.csv")
train <- read.csv(file = 'train.csv')
dfStore <- read.csv(file='stores (1).csv')
dfTrain <- read.csv(file='train.csv')
dfTest <- read.csv(file='test.csv')
dfFeatures <- read.csv(file='features.csv')
dfTest1 <- read.csv(file = "dfTest.csv")

#Remove DataFrames
rm(test,train,dfStore,dfTrain,dfTest,dfFeatures)
rm(dfTestTmp,dfTrainTmp)

#Merge Type and Size Ref: https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting/discussion/7214
dfTrainTmp <- merge(x=dfTrain, y=dfStore, all.x=TRUE)
dfTestTmp <- merge(x=dfTest, y=dfStore, all.x=TRUE)

#Merge all the features
dfTrainMerged <- merge(x=dfTrainTmp, y=dfFeatures, all.x=TRUE)
dfTestMerged <- merge(x=dfTestTmp, y=dfFeatures, all.x=TRUE)

#Subsetting To Store 1 (Train)
store1 <- dfTrainMerged %>%
  filter(Store == 1)%>%
  
#Test Set
store1Test <- dfTest1 %>%
  filter(Store == 1)

#Changing NA's to Zeros
store1Test[is.na(store1Test)] <- 0
store1[is.na(store1)] <- 0
store1$Type <- NULL

#Train
store1 <- store1[,c(1,2,3,17:20,4:16)]
store1 <- store1[c(1,2,6,4,5,3,7:20)]
#Test
store1Test <- store1Test[,c(1,2,3,16:19,4:15)]
#store1Test <- store1Test[c(1,2,6,4,5,3,7:19)]


tester <- tester[,c(5,1:4,6:20)]
#Save datasets
write.table(x=tester,
            file='rf_train.csv',
            sep=',', row.names=FALSE, quote=FALSE)
write.table(x=store1Test,
         file='rf_test.csv',
            sep=',', row.names=FALSE, quote=FALSE)



#
#store1 <- as.data.frame( ts(store1))
#train$Returns <- lapply(train$Weekly_Sales,function(sales){
#  ifelse(sales < 0,sales,0)
#})
#train$Weekly_Sales <- lapply(train$Weekly_Sales,function(sales){
#  ifelse(sales > 0,sales,0)
#})


