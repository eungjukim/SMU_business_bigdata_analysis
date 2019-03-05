reg <- read.csv("reg_dataset.csv")

head(reg)

str(reg)

install.packages("caret")

install.packages("ggplot2")

install.packages("glue")

install.packages("tidyselect")

library(ggplot2)

library(caret)

library(glue)

library(tidyselect)

library(car)

set.seed(1712)
#������ �и�(�Ʒÿ� / �׽�Ʈ��)
train <- createDataPartition(y = reg$payment_value, p=0.7, list=F)
#�Ʒÿ� ������ ����
training <- reg[train,]
#�׽�Ʈ�� ������ ����
testing <- reg[-train,]
tail(training)
tail(testing)
#ȸ�ͺм�
reg_model <- lm(reg$order_item_id ~ reg$review_score + reg$price + reg$payment_value+ reg$product_name_lenght + reg$product_description_lenght + reg$product_photos_qty + reg$product_weight_g + reg$product_length_cm + reg$product_height_cm + reg$product_width_cm + reg$payment_installments + reg$delivering_date)
summary(reg_model)
reg_model2 <- lm(reg$review_score ~ reg$freight_value + reg$order_item_id+ reg$product_name_lenght + reg$product_description_lenght + reg$product_photos_qty + reg$product_weight_g + reg$product_length_cm + reg$product_height_cm + reg$product_width_cm + reg$payment_installments)
summary(reg_model2)

install.packages("bootstrap")

library(bootstrap)

#k fold
#https://rstudio-pubs-static.s3.amazonaws.com/190997_40fa09db8e344b19b14a687ea5de914b.html
shrinkage <- function(fit, k=10){ 
  require(bootstrap)
  
  theta.fit <- function(x,y){lsfit(x,y)} 
  theta.predict <- function(fit,x){cbind(1,x)%*%fit$coef}
  
  x <- fit$model[,2:ncol(fit$model)] 
  y <- fit$model[,1]
  
  results <- crossval(x, y, theta.fit, theta.predict, ngroup=k) 
  r2 <- cor(y, fit$fitted.values)^2 
  r2cv <- cor(y, results$cv.fit)^2 
  cat("Original R-square =", r2, "\n")
  cat(k, "Fold Cross-Validated R-square =", r2cv, "\n") 
  cat("Change =", r2-r2cv, "\n")
}

shrinkage(reg_model2)

