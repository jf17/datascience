# устанавливаем рабочую директорию
setwd("D:/Go/examples/http/read")



install.packages("RSQLite")
install.packages("ggplot2")
install.packages("dplyr")
# install.packages("devtools")
#devtools::install_github("rstats-db/RSQLite")


library("RSQLite")
library("ggplot2")
library("dplyr")

# Создаём коннект к базе
con <- dbConnect(SQLite(), dbname="currencyrate.db")

# список таблиц
dbListTables(con)


a_data <- dbGetQuery(con,"SELECT rate,quotesforday FROM currencyrate WHERE currency = 'USD' ORDER BY quotesforday")

# форматируем в правильный формат дату 
a_data$quotesforday <- as.Date(a_data$quotesforday)



# Plot 
plot( a_data$quotesforday, a_data$rate) # для начала нанесем точки
lines(a_data$quotesforday, a_data$rate) # теперь нанесем линии


# ggplot
a_data %>%
  ggplot( aes(x=quotesforday, y=rate)) +
  geom_line() +
  geom_point()



