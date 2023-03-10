# Federal University of Bahia
# Computer Science Department
# Graduate Program in Computing
# Masters' Degree in Computer Science
# Student: Edmilson de Jesus
# Advisor: Gecynalda Gomes
#Date: 7/2/2022

#Topic: Water demand forecast for Salvador and Metropolitan Region using AI models

#Carrega pacote readxl
library(readxl)

#bibliotecal sql

library(sqldf)
#Instala pacote de escrita para arquivos excel
#install.packages("writexl")

#Carrega pacote wirtexl
#library(writexl)

#install.packages("plotly")
library(plotly)

# Carrega pacote forecast
library(forecast)

# Carrega 
#install.packages("ggplot2")
library(ggplot2)

library(reshape2)

#Carrega package tidyverse
library(tidyverse)

#Para descarregar o pacote
#detach("package:tidyverse", unload = TRUE)

# Instala pacote zoo de m?dias m?veis 
#install.packages("zoo",dependences = TRUE)
library(zoo) # pacote com fun??o para m?dias m?veis

# Carrega pacote de manipula??o otimizada de strings
library(stringr)

#Carrega package lubirdate  para trabalhar com data/hora 
library(lubridate)

# Retorna data e hora no momento da execu??o
# base::date()


day <- today()
rm(day)
library(scales)
library(tidyr)
library(dplyr)
library(e1071)
library(BSDA)


caminho = paste("C:/Users/Edmilson/Downloads/mestrado/waterdemand/", sep="")

source(paste(caminho,"basic.r",sep = ""))

caminho = paste("C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/", sep="")

#--------------------   Introdu??o: Conhecendo inst?ncias x atributos x valores  ----------


ds_R9 <- read.csv(paste(caminho,"resultado_LSTM_R9.csv", sep=""), header = TRUE, sep = ",", encoding = 'latin1')


par(mfrow=c(1,1))
#ggplot(data = ds_skp13, aes(x = DT_MEDICAO_HORA, y = VL_MEDICAO)) + geom_point() 

t <- ggplot(data = ds_R9, aes(x = Data, y = Test)) + geom_point(size = 0.2) +
  geom_line(color = "black", size = 0.2)  + labs(x = "Time in hours", y = "Consumption l/h", )

p <- ggplot(data = ds_R9, aes(x = Data, y = Predict) + geom_point(size = 0.2) +
  geom_line(color = "blue", size = 0.2)  + labs(x = "Time in hours", y = "Consumption l/h", )

ggplot(rbind(t,p)) 


ggsave(file = "C:\\Users\\Edmilson\\Downloads\\mestrado\\Orientacao\\artigo02\\submission\\Fig6.eps")
