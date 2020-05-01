# устанавливаем рабочую директорию
setwd("D:/Dataset/titanic")

#загружаем данные из файлов CSV 
titanic.train <- read.csv(file = "train.csv", stringsAsFactors = FALSE, header = TRUE)
titanic.test <- read.csv(file = "test.csv", stringsAsFactors = FALSE, header = TRUE)

# добавляем новую переменную IsTrainSet 
titanic.train$IsTrainSet <- TRUE
titanic.test$IsTrainSet <- FALSE


# добавляем недастоющую колонку в TEST
titanic.test$Survived <- NA


# обьединяем два датасета 
titanic.full <- rbind(titanic.train, titanic.test)


# заменяем два пустых значения в колонке на значение 'S' .
titanic.full[titanic.full$Embarked=='',"Embarked"] <- 'S'


# проверяем сколько пропущеных данных в колонке Age ?
table(is.na(titanic.full$Age))


# вычисляем медиану Age 
age.median <- median(titanic.full$Age, na.rm=TRUE)


# Заполняем все пропущеные данные в колонке Age значением медианы 
titanic.full[is.na(titanic.full$Age), "Age"] <- age.median


# вычисляем медиану Fare 
fare.median <- median(titanic.full$Fare, na.rm=TRUE)

# Заполняем все пропущеные данные в колонке Fare значением медианы 
titanic.full[is.na(titanic.full$Fare), "Fare"] <- fare.median

# Делаем катигориальный кастинг
titanic.full$Pclass <- as.factor(titanic.full$Pclass)
titanic.full$Sex <- as.factor(titanic.full$Sex)
titanic.full$Embarked <- as.factor(titanic.full$Embarked)



# Возвращаем уже правильные данные обратно в таблички
titanic.train <-titanic.full[titanic.full$IsTrainSet==TRUE,]
titanic.test <-titanic.full[titanic.full$IsTrainSet==FALSE,]


# Делаем катигориальный кастинг
titanic.train$Survived <- as.factor(titanic.train$Survived)


# Создаём формулу выживших
survived.equation <- "Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked"
survived.formula <- as.formula(survived.equation)

# Устанавливаем пакет RandomForest
install.packages("randomForest")

# создаём библиотеку 
library(randomForest)


# Создаём модель 
titanic.model <- randomForest(formula = survived.formula, data = titanic.train, ntree = 500 , mtry = 3, nodesize = 0.01*nrow(titanic.test))


# Создаём фичи
features.equation <- "Pclass + Sex + Age + SibSp + Parch + Fare + Embarked"


# Создаём предсказание
Survived <- predict(titanic.model, newdata = titanic.test)


# Создаём результирующий датафрейм 
PassengerId <- titanic.test$PassengerId
output.dataFrame <- as.data.frame(PassengerId)
output.dataFrame$Survived <- Survived

# Записываем результат предсказания в CSV файл 
write.csv(output.dataFrame, file = "kaggle_submission.csv", row.names = FALSE)


