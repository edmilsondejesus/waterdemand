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

# Instala pacote zoo de médias móveis 
#install.packages("zoo",dependences = TRUE)
library(zoo) # pacote com função para médias móveis

# Carrega pacote de manipulação otimizada de strings
library(stringr)

#Carrega package lubirdate  para trabalhar com data/hora 
library(lubridate)

# Retorna data e hora no momento da execução
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

#--------------------   Introdução: Conhecendo instâncias x atributos x valores  ----------


dados_consumo <- read.csv(paste(caminho,"DADOS_TELEMETRIA_2017_a_2022RMS.csv", sep=""), header = TRUE, sep = ";", encoding = 'latin1')

#head(dados_consumo)

#View(dados_consumo)

#Verify null fields
#count.nas(dados_consumo)

info(dados_consumo)


#Boxplot of booking points
boxplot(dados_consumo$VL_MEDICAO~dados_consumo$SK_PONTO)

#--------------------   Limpeza: Identificação e substituição de dados inválidos ----------

#copia a data original
dados_consumo$DT_ORIGINAL<-dados_consumo$DT_MEDICAO

class(dados_consumo$DT_MEDICAO)

#View(dados_consumo)
df_lista <- ds_consumo %>% group_by(SK_PONTO, NM_PONTO) %>%
  summarize(VL_MEDICAO=sum(VL_MEDICAO)) %>%
  arrange(SK_PONTO)

#List of present reservoirs from the data_consumo dataset
#Total of 13 sk_points, with reservoir R7 consisting of the sum of sk_point 2 to sk_point 3

# character date to date conversion
dados_consumo$DT_MEDICAO <- as.Date(parse_date_time(dados_consumo$DT_ORIGINAL, "%y-%m-%d-%H.%M.%S"))
class(dados_consumo$DT_MEDICAO)

# character date conversion to datetime in hours
dados_consumo$DT_MEDICAO_HORA <- as_datetime(parse_date_time(dados_consumo$DT_ORIGINAL, "%y-%m-%d-%H.%M.%S"))
class(dados_consumo$DT_MEDICAO_HORA)

#class(dados_consumo$VL_MEDICAO)
#dados_consumo$VL_MEDICAO=as.numeric(trimws(dados_consumo$VL_MEDICAO))
#class(dados_consumo$VL_MEDICAO)

dados_consumo$NN_DIAMES=day(dados_consumo$DT_MEDICAO)





# Get the dataset with the data of each point
ds_skp1 <- subset(dados_consumo, SK_PONTO==1 & DT_MEDICAO_HORA >= as_datetime(parse_date_time('2019-04-01-16.00.00.000000', "%y-%m-%d-%H.%M.%S")))
ds_skp2 <- subset(dados_consumo, SK_PONTO==2 & DT_MEDICAO_HORA >= as_datetime(parse_date_time('2017-11-08-12.00.00.000000', "%y-%m-%d-%H.%M.%S")))
ds_skp3 <- subset(dados_consumo, SK_PONTO==3 & DT_MEDICAO_HORA >= as_datetime(parse_date_time('2017-11-08-12.00.00.000000', "%y-%m-%d-%H.%M.%S")))
ds_skp4 <- subset(dados_consumo, SK_PONTO==4)
ds_skp5 <- subset(dados_consumo, SK_PONTO==5)
ds_skp6 <- subset(dados_consumo, SK_PONTO==6)
ds_skp7 <- subset(dados_consumo, SK_PONTO==7)
ds_skp8 <- subset(dados_consumo, SK_PONTO==8 & DT_MEDICAO_HORA >= as_datetime(parse_date_time('2017-11-27-00.00.00.000000', "%y-%m-%d-%H.%M.%S")))
ds_skp9 <- subset(dados_consumo, SK_PONTO==9 & DT_MEDICAO_HORA >= as_datetime(parse_date_time('2019-11-08-16.00.00.000000', "%y-%m-%d-%H.%M.%S")))
ds_skp10 <- subset(dados_consumo, SK_PONTO==10 & DT_MEDICAO_HORA >= as_datetime(parse_date_time('2022-05-30-00.00.00.000000', "%y-%m-%d-%H.%M.%S")))
ds_skp11 <- subset(dados_consumo, SK_PONTO==11)
ds_skp12 <- subset(dados_consumo, SK_PONTO==12)
# taking the descriptive measures

#Join data of  ds_skip 2 and 3 to ds_skip13 for reservoir  R7 data
ds_skp13 <-sqldf::sqldf('select sum(a.VL_MEDICAO + b.VL_MEDICAO) as VL_MEDICAO, 13 as SK_PONTO, a.DT_MEDICAO, 0 as NN_QUALIDADE, a.NN_ANO, \'ETA PRINCIPAL - R7 \' as NM_PONTO, a.DT_ORIGINAL, a.DT_MEDICAO_HORA, a.NN_DIAMES from ds_skp3 b inner join ds_skp2 a on b.DT_ORIGINAL=a.DT_ORIGINAL group by a.DT_MEDICAO, a.DT_ORIGINAL, a.DT_MEDICAO_HORA, a.NN_ANO, a.NN_DIAMES')
ds_skp13$DT_MEDICAO_HORA <- as_datetime(parse_date_time(ds_skp13$DT_ORIGINAL, "%y-%m-%d-%H.%M.%S"))


summary_gecy(ds_skp1$VL_MEDICAO)
summary_gecy(ds_skp2$VL_MEDICAO)
summary_gecy(ds_skp3$VL_MEDICAO)
summary_gecy(ds_skp4$VL_MEDICAO)
summary_gecy(ds_skp5$VL_MEDICAO)
summary_gecy(ds_skp6$VL_MEDICAO)
summary_gecy(ds_skp7$VL_MEDICAO)
summary_gecy(ds_skp8$VL_MEDICAO)
summary_gecy(ds_skp9$VL_MEDICAO)
summary_gecy(ds_skp10$VL_MEDICAO)
summary_gecy(ds_skp11$VL_MEDICAO)
summary_gecy(ds_skp12$VL_MEDICAO)
summary_gecy(ds_skp13$VL_MEDICAO)



#R1 Dunas - remove major outliers
show_plot_skp(ds_skp1)
ds_skp1<-remove_outliers(ds_skp1)
show_plot_skp(ds_skp1)

#remove major outliers
ds_skp2<-remove_outliers(ds_skp2)
ds_skp3<-remove_outliers(ds_skp3)
ds_skp4<-remove_outliers(ds_skp4)
ds_skp5<-remove_outliers(ds_skp5)
ds_skp6<-remove_outliers(ds_skp6)
ds_skp7<-remove_outliers(ds_skp7)
ds_skp8<-remove_outliers(ds_skp8)
ds_skp9<-remove_outliers(ds_skp9)
ds_skp10<-remove_outliers(ds_skp10)
ds_skp11<-remove_outliers(ds_skp11)
ds_skp12<-remove_outliers(ds_skp12)


#use this function to generate art combination at 500 dpi, print and save on GIMP
#method que funciona
jpeg('C:\\Users\\Edmilson\\Downloads\\mestrado\\Orientacao\\artigo01\\Latex\\figures\\FIG4.jpg', quality = 100, res = 500, width=1772, height=1528)
par(mfrow=c(1,1))
ggplot(data = ds_skp13, aes(x = DT_MEDICAO_HORA, y = VL_MEDICAO)) + geom_point() 
dev.off()

#show_plot_dynt(ds_skp13,1772,1528,500)

ds_skp13<-remove_outliers(ds_skp13)
#other function to show graph


#shows the graph of reservoir R7 after pre-processing.

#desatived fucntion - to limit value of inputs
#ds_skp1 <- anula_valor(ds_skp1,3,6000,-1)

ds_skp1 <- ds_skp1[order(ds_skp1$DT_MEDICAO_HORA),]
ds_skp2 <- ds_skp2[order(ds_skp2$DT_MEDICAO_HORA),]
ds_skp3 <- ds_skp3[order(ds_skp3$DT_MEDICAO_HORA),]
ds_skp4 <- ds_skp4[order(ds_skp4$DT_MEDICAO_HORA),]
ds_skp5 <- ds_skp5[order(ds_skp5$DT_MEDICAO_HORA),]
ds_skp6 <- ds_skp6[order(ds_skp6$DT_MEDICAO_HORA),]
ds_skp7 <- ds_skp7[order(ds_skp7$DT_MEDICAO_HORA),]
ds_skp8 <- ds_skp8[order(ds_skp8$DT_MEDICAO_HORA),]
ds_skp9 <- ds_skp9[order(ds_skp9$DT_MEDICAO_HORA),]
ds_skp10 <- ds_skp10[order(ds_skp10$DT_MEDICAO_HORA),]
ds_skp11 <- ds_skp11[order(ds_skp11$DT_MEDICAO_HORA),]
ds_skp12 <- ds_skp12[order(ds_skp12$DT_MEDICAO_HORA),]
ds_skp13 <- ds_skp13[order(ds_skp13$DT_MEDICAO_HORA),]

#elimina valores negativos
ds_skp1 <- replace_consumo_negativo(ds_skp1, 3)
ds_skp2 <- replace_consumo_negativo(ds_skp2, 3)
ds_skp3 <- replace_consumo_negativo(ds_skp3, 3)
ds_skp4 <- replace_consumo_negativo(ds_skp4, 3)
ds_skp5 <- replace_consumo_negativo(ds_skp5, 3)
ds_skp6 <- replace_consumo_negativo(ds_skp6, 3)
ds_skp7 <- replace_consumo_negativo(ds_skp7, 3)
ds_skp8 <- replace_consumo_negativo(ds_skp8, 3)
ds_skp9 <- replace_consumo_negativo(ds_skp9, 3)
ds_skp10 <- replace_consumo_negativo(ds_skp10, 3)
ds_skp11 <- replace_consumo_negativo(ds_skp11, 3)
ds_skp12 <- replace_consumo_negativo(ds_skp12, 3)
ds_skp13 <- replace_consumo_negativo(ds_skp13, 3)


#use this function to generate art combination at 500 dpi, after preprocessing, print and save on GIMP
#method que funciona
jpeg('C:\\Users\\Edmilson\\Downloads\\mestrado\\Orientacao\\artigo01\\Latex\\figures\\FIG5.jpg', quality = 100, res = 500, width=1772, height=1528)
par(mfrow=c(1,1))
ggplot(data = ds_skp13, aes(x = DT_MEDICAO_HORA, y = VL_MEDICAO)) + geom_point() 
dev.off()
#show_plot_dynt(ds_skp13,1772,1528,500)

#---------- Exploration: Charts for analysis and understanding ----------


#show_plot_dyn(ds_skp1)
#show_plot_dyn(ds_skp2)
#show_plot_dyn(ds_skp3)
#show_plot_dyn(ds_skp4)
#show_plot_dyn(ds_skp5)
#show_plot_dyn(ds_skp6)
#show_plot_dyn(ds_skp7)
#show_plot_dyn(ds_skp8)
#show_plot_dyn(ds_skp9)
#show_plot_dyn(ds_skp10)
#show_plot_dyn(ds_skp11)
#show_plot_dyn(ds_skp12)
#show_plot_dyn(ds_skp13)


#----------   Transform   ----------

#merging data from all reservoirs
ds_consumo <- bind_rows (ds_skp1, ds_skp13, ds_skp4, ds_skp5, ds_skp6, ds_skp7, ds_skp8, ds_skp9, ds_skp10, ds_skp11, ds_skp12)


head(ds_consumo)
# isna verify
count.nas(ds_consumo)

#ds_consumo$VL_MEDICAO=str_replace(dados_consumo$VL_MEDICAO,",",".")
ds_consumo$VL_MEDICAO=as.numeric(ds_consumo$VL_MEDICAO)
ds_consumo$DT_MEDICAO_HORA <- as_datetime(parse_date_time(ds_consumo$DT_MEDICAO_HORA, "%y-%m-%d-%H.%M.%S"))

#save file
f_out <- 'C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/DADOS_CONSUMO_2017_a_2022_tratado_geral.csv'
write.csv2(ds_consumo,f_out, col.names=TRUE, sep=';',qmethod="double" )
desc(ds_consumo)

#consolidates the volume to a single flow rate
ds_dados_c <- ds_consumo %>% group_by(DT_MEDICAO, DT_MEDICAO_HORA, NN_ANO) %>%
  summarize(VL_MEDICAO=sum(VL_MEDICAO), .groups='drop') %>%
  arrange(DT_MEDICAO_HORA)

head(ds_dados_c)
plot(ds_dados_c$DT_MEDICAO_HORA,ds_dados_c$VL_MEDICAO)

#show_plot_dyntotal(ds_dados_c)

#salvar para arquivo
f_out <- 'C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/DADOS_CONSUMO_2017_a_2022_tratado_unificado.csv'
write.csv2(ds_dados_c,f_out, col.names=TRUE, sep=';',qmethod="double" )


#consolidates the volume for SK_PONTO flow rate
ds_dados_c <- ds_consumo %>% group_by(SK_PONTO, DT_MEDICAO, DT_MEDICAO_HORA, NN_ANO) %>%
  summarize(VL_MEDICAO=sum(VL_MEDICAO), .groups='drop') %>%
  arrange(DT_MEDICAO_HORA)

head(ds_dados_c)
plot(ds_dados_c$DT_MEDICAO_HORA,ds_dados_c$VL_MEDICAO)

#show_plot_dyntotal(ds_dados_c)

#salvar para arquivo
f_out <- 'C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/DADOS_CONSUMO_2017_a_2022_tratado_por_ponto.csv'
write.csv2(ds_dados_c,f_out, col.names=TRUE, sep=';',qmethod="double" )


#Finalizado o préprocessamento dos dados de consumo


#----------------------------------------------------------------------------------
#----------------------------------------------------------------------------------
#-----------------------------------Tratamento dos dados de metereológicos ------------------------------------------


#--------------------   Introdução: Conhecendo instâncias x atributos x valores  ----------

caminho = paste("C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/", sep="")

dados_clima <- read.csv(paste(caminho,"INMET_SALVADOR_2016_A_2022.csv", sep=""), header = TRUE, sep = ";", encoding = 'latin1')


#Valores ausentes de clima
count.nas(dados_clima)

#trata dataset dados_clima
#Medidas descritivas
summary(dados_clima)

#--------------------   Limpeza: Identificação e substituição de dados inválidos ----------

# Converte character para Data usando o formato dmy
dados_clima$DT_DATA<- dmy(dados_clima$DATA)

#carrega o dia do mês baseado na data
dados_clima$NN_DIAMES=day(dados_clima$DT_DATA)

#Convert character hora para Integer hora 
dados_clima$NN_HORA<- str_sub(dados_clima$HORA,1,2)
dados_clima$NN_HORA <- as.integer(dados_clima$NN_HORA)
class(dados_clima$NN_HORA)

#Substitui caracter virgula por ponto
dados_clima$TEMPERATURA_DO_AR_C <- str_replace(dados_clima$TEMPERATURA_DO_AR_C,",",".")

#Converte temperatura para formato numérico
dados_clima$TEMPERATURA_DO_AR_C <- as.numeric(dados_clima$TEMPERATURA_DO_AR_C)

#Substitui caracter virgula por ponto
dados_clima$VELOCIDADE_VENTO <- str_replace(dados_clima$VELOCIDADE_VENTO,",",".")

#Converte velocidade para formato numérico
dados_clima$VELOCIDADE_VENTO <- as.numeric(dados_clima$VELOCIDADE_VENTO)

#Substitui caracter virgula por ponto
dados_clima$PRESSAO_ATMOSFERICA <- str_replace(dados_clima$PRESSAO_ATMOSFERICA,",",".")

#Converte pressão para caracter numérico
dados_clima$PRESSAO_ATMOSFERICA <- as.numeric(dados_clima$PRESSAO_ATMOSFERICA)

#Converte precipitacao para caracter numérico
dados_clima$PRECIPITACAO <- str_replace(dados_clima$PRECIPITACAO,",",".")
dados_clima$PRECIPITACAO <- as.numeric(dados_clima$PRECIPITACAO)

# gera um numerador incremental para cara liinha para gerar grafico de dados ausentes de temperatura
dados_clima$ROWNUM <- row_number(dados_clima$DT_DATA)
#view(dados_clima)

#boxplot da temperatura

boxplot(dados_clima$TEMPERATURA_DO_AR_C)
boxplot.temperatura <-boxplot(dados_clima$TEMPERATURA_DO_AR_C)


#identifica valores de outliers -9999
boxplot.temperatura$out


#temperaturas válidas
df_temperatura_sem_dados_ausentes = subset(dados_clima, TEMPERATURA_DO_AR_C > -9999)

#grafico de temperaturas válidas
ggplot(data = df_temperatura_sem_dados_ausentes, aes(x = DATA, y = TEMPERATURA_DO_AR_C)) + geom_line(color = "#FC4E07", size = 2)

boxplot.temperatura <-boxplot(df_temperatura_sem_dados_ausentes$TEMPERATURA_DO_AR_C)

# novos valores de outliers
boxplot.temperatura$out

rm(df_temperatura_sem_dados_ausentes)
rm(boxplot.temperatura)
#View(df_temperatura_dados_ausentes)

# Temperatura dezembro 2020
df_temp122020 <- subset(dados_clima, (DT_DATA >= as.Date("2020-12-01")) &(DT_DATA <= as.Date("2020-12-31")))
ggplot(data = df_temp122020, aes(x = NN_HORA, y = TEMPERATURA_DO_AR_C)) + geom_point() + scale_x_continuous(limits=c(0,24))

#Grafico de umidade relativa x data dezembro/2020
ggplot(data = df_temp122020, aes(x = DT_DATA, y = UMIDADE_RELATIVA_DO_AR)) + geom_point()
#Grafico de umidade relativa x hora dezembro/2020
ggplot(data = df_temp122020, aes(x = NN_HORA, y = UMIDADE_RELATIVA_DO_AR)) + geom_point()
rm(df_temp122020)

# Temperatura dezembro 24/12/2020
df_temp24122020 <- subset(dados_clima, (DT_DATA >= as.Date("2020-12-24")) &(DT_DATA <= as.Date("2020-12-24")))
ggplot(data = df_temp24122020, aes(x = NN_HORA, y = TEMPERATURA_DO_AR_C)) + geom_point() +  geom_line(color = "#FC4E07", size = 1) + scale_x_continuous(limits=c(0,24))
rm(df_temp24122020)

# Temperatura 24/12/2019
df_temp24122019 <- subset(dados_clima, (DT_DATA >= as.Date("2019-12-24")) & (DT_DATA <= as.Date("2019-12-24")))
ggplot(data = df_temp24122019, aes(x = NN_HORA, y = TEMPERATURA_DO_AR_C)) + geom_point() + geom_line(color = "#FC4E07", size = 1)
rm(df_temp24122019)

# Gráfico de umidade relativa 24/12/2019
df_umidade24122019 <- subset(dados_clima, (DT_DATA >= as.Date("2019-12-24")) & (DT_DATA <= as.Date("2019-12-24")))
ggplot(data = df_umidade24122019, aes(x = NN_HORA, y = UMIDADE_RELATIVA_DO_AR))  + geom_point()  + geom_line(color = "#FC4E07", size = 1)
rm(df_umidade24122019)

#Correlação umidade relativa x temperatura 24/12/2020
df_24122020 <- subset(dados_clima, (DT_DATA >= as.Date("2020-12-24")) &(DT_DATA <= as.Date("2020-12-24")))
ggplot(data = df_24122020, aes(x = UMIDADE_RELATIVA_DO_AR, y = TEMPERATURA_DO_AR_C)) + geom_point() + geom_line(color = "#FC4E07", size = 1)
rm(df_24122020)

# Histograma da variável temperatura
hist(dados_clima$TEMPERATURA_DO_AR_C)

#Outliers de temperatura
boxplot(dados_clima$TEMPERATURA_DO_AR_C, main="Outliers de Temperatura do Ar")

#Outliers de Umidade relativa do ar
boxplot(dados_clima$UMIDADE_RELATIVA_DO_AR, main="Outliers de Umidade relativa")

# Limpeza dos Outliers
dados_clima2 <- subset(dados_clima, TEMPERATURA_DO_AR_C >=0)

#Outliers de temperatura
boxplot(dados_clima2$TEMPERATURA_DO_AR_C, main="Outliers de Temperatura do Ar")

#Outliers de Umidade relativa do ar
boxplot(dados_clima2$UMIDADE_RELATIVA_DO_AR, main="Outliers de Umidade relativa")

#Relação entre temperatura x umdiade relativa
plot(y=dados_clima2$TEMPERATURA_DO_AR_C, x = dados_clima2$UMIDADE_RELATIVA_DO_AR, main = 'Relação entre a Temperatura x Umidade Relativa')

rm(dados_clima2)

#------------------------------------------------------------
#-> fazer um levantamento em cada variável para identificar até quando tem dados ausentes e qual a frequencia.


dados_clima$NN_ANO <- substr(dados_clima$DATA,7,10)
dados_clima$NN_MESANO <- substr(dados_clima$DATA,4,10)
dados_clima$NN_MES <- substr(dados_clima$DATA,4,5)
#dados_clima$NN_MESANO <- str_replace(dados_clima$NN_MESANO,'/','')
#dados_clima$NN_MESANO <- as.numeric(dados_clima$NN_MESANO)
#View(dados_clima)

df_dados_aus <-sqldf::sqldf('select count(*) TOTAL,  NN_ANO from dados_clima where TEMPERATURA_DO_AR_C < -100 group by NN_ANO')
# dados inválidos de temperatura por ano
ggplot(df_dados_aus, aes(x=NN_ANO, y=TOTAL, fill=NN_ANO))+ 
  geom_bar(stat = "identity", color ="black", fill="red", width=0.30) +
  ggtitle("Quantidade de dados inválidos por ano") +
  xlab("Ano") + ylab("Qtd de erros")
rm(df_dados_aus)

# dados inválidos por variável e ano
df_erros_ano <-sqldf::sqldf("select sum(CASE WHEN VELOCIDADE_VENTO < -100 THEN 1 ELSE 0 end)'Velocidade vento',sum(CASE WHEN PRESSAO_ATMOSFERICA < -100 THEN 1 ELSE 0 end)'Pressão atmosférica', sum(CASE WHEN PRECIPITACAO < -100 THEN 1 ELSE 0 end)'Precipitação', NN_ANO, sum(CASE WHEN TEMPERATURA_DO_AR_C < -100 THEN 1 ELSE 0 end)'Temperatura',sum(CASE WHEN UMIDADE_RELATIVA_DO_AR < -100 THEN 1 ELSE 0 end)'Umidade relativa'   from dados_clima  where NN_ANO > 2016 group by NN_ANO")
df_erros_ano.long<-melt(df_erros_ano,id.vars="NN_ANO") # formatar para long
ggplot(df_erros_ano.long,aes(x=NN_ANO,y=value,fill=factor(variable)))+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_discrete(name="Variável")+
  ylab("Quantidade de erros")+xlab('Ano')+
  theme(plot.title = element_text(hjust = 0.5))+
  ggtitle('Dados metereológicos inválidos por ano')+
  geom_text(aes(label=value), position=position_dodge(width=0.9), vjust=-0.25, size=1.5)
rm(df_erros_ano.long)
rm(df_erros_ano)



# dados metereológicos por variável e ano
df_erros_ano <-sqldf::sqldf("select sum(1)'Velocidade vento',sum(1)'Pressão atmosférica', sum(1)'Precipitação', NN_ANO, sum(1)'Temperatura',sum(1)'Umidade relativa'   from dados_clima  where NN_ANO > 2016 group by NN_ANO")
df_erros_ano.long<-melt(df_erros_ano,id.vars="NN_ANO") # formatar para long
ggplot(df_erros_ano.long,aes(x=NN_ANO,y=value,fill=factor(variable)))+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_discrete(name="Variável")+
  ylab("Quantidade de entradas")+xlab('Ano')+
  theme(plot.title = element_text(hjust = 0.5))+
  ggtitle('Dados metereológicos por ano')+
  geom_text(aes(label=value), position=position_dodge(width=0.9), vjust=-0.25, size=1.5)
rm(df_erros_ano.long)
rm(df_erros_ano)



#elimina os dados do ano de 2016
datasetest1 <- subset(dados_clima, DT_DATA >= dmy('01-01-2017'))
head(datasetest1)

#repete o gráfico sem os dados de 2016
# dados inválidos por variável e ano
df_erros_ano <-sqldf::sqldf("select sum(CASE WHEN VELOCIDADE_VENTO < -100 THEN 1 ELSE 0 end)'Velocidade vento',sum(CASE WHEN PRESSAO_ATMOSFERICA < -100 THEN 1 ELSE 0 end)'Pressão atmosférica', sum(CASE WHEN PRECIPITACAO < -100 THEN 1 ELSE 0 end)'Precipitação', NN_ANO, sum(CASE WHEN TEMPERATURA_DO_AR_C < -100 THEN 1 ELSE 0 end)'Temperatura',sum(CASE WHEN UMIDADE_RELATIVA_DO_AR < -100 THEN 1 ELSE 0 end)'Umidade relativa'   from datasetest1  group by NN_ANO")

df_erros_ano.long<-melt(df_erros_ano,id.vars="NN_ANO") # formatar para long
ggplot(df_erros_ano.long,aes(x=NN_ANO,y=value,fill=factor(variable)))+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_discrete(name="Variável")+
  ylab("Quantidade de erros")+xlab('Ano')+
  theme(plot.title = element_text(hjust = 0.5))+
  ggtitle('Dados inválidos por ano')+
  geom_text(aes(label=value), position=position_dodge(width=0.9), vjust=-0.25, size=1.5)

rm(df_erros_ano.long)
rm(df_erros_ano)

# novo dataset - consulta de dados ausentes dsest1
#substitui todos os dados ausentes pela média das 24h

ds_clima_tratado <-replace.mprox(datasetest1)


rm(datasetest1)

summary(ds_clima_tratado)

df_erros_ano <-sqldf::sqldf("select sum(CASE WHEN VELOCIDADE_VENTO < -100 THEN 1 ELSE 0 end)'Velocidade vento',sum(CASE WHEN PRESSAO_ATMOSFERICA < -100 THEN 1 ELSE 0 end)'Pressão atmosférica', sum(CASE WHEN PRECIPITACAO < -100 THEN 1 ELSE 0 end)'Precipitação', NN_ANO, sum(CASE WHEN TEMPERATURA_DO_AR_C < -100 THEN 1 ELSE 0 end)'Temperatura',sum(CASE WHEN UMIDADE_RELATIVA_DO_AR < -100 THEN 1 ELSE 0 end)'Umidade relativa'   from ds_clima_tratado  group by NN_ANO")
df_erros_ano.long<-melt(df_erros_ano,id.vars="NN_ANO") # formatar para long
ggplot(df_erros_ano.long,aes(x=NN_ANO,y=value,fill=factor(variable)))+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_discrete(name="Variável")+
  ylab("Quantidade de erros")+xlab('Ano')+
  theme(plot.title = element_text(hjust = 0.5))+
  ggtitle('Dados inválidos por ano')+
  geom_text(aes(label=value), position=position_dodge(width=0.9), vjust=-0.25, size=1.5)

rm(df_erros_ano.long)
rm(df_erros_ano)

#salva dados tratado em arquivo com leitura por ponto
f_out <- 'C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/DADOS_TEMPERATURA_2017_a_2022_tratado.csv'
write.csv2(ds_clima_tratado,f_out, col.names=TRUE, sep=';',qmethod="double")
count.nas(ds_clima_tratado)
count.nas(ds_dados_c)

#Merge dos dados metereológicos e de consumo

ds_clima_tratado$DT_MEDICAO_HORA <- as_datetime(parse_date_time(paste(paste(ds_clima_tratado$DT_DATA,"-",sep=""),ds_clima_tratado$HORA,sep=""), "%y-%m-%d-%H:%M"))

#join clima x consumo pela DT_MEDICAO_HORA
ds_data <- merge(ds_clima_tratado, ds_dados_c, by="DT_MEDICAO_HORA")

#limpa o dataset
ds_data = subset(ds_data, select = -c(DATA,HORA,DT_DATA, NN_DIAMES, NN_HORA, ROWNUM, NN_ANO.x, NN_MESANO, NN_MES, DT_MEDICAO, NN_ANO.y))

summary(ds_data)


ds_data$PRECIPITACAO= as.numeric(ds_data$PRECIPITACAO)
ds_data$PRESSAO_ATMOSFERICA=as.numeric(ds_data$PRESSAO_ATMOSFERICA)
ds_data$TEMPERATURA_DO_AR_C=as.numeric(ds_data$TEMPERATURA_DO_AR_C)
ds_data$UMIDADE_RELATIVA_DO_AR=as.numeric(ds_data$UMIDADE_RELATIVA_DO_AR)
ds_data$VELOCIDADE_VENTO=as.numeric(ds_data$VELOCIDADE_VENTO)
ds_data$VL_MEDICAO=as.numeric(ds_data$VL_MEDICAO)

ds_data
#salva dados tratado em arquivo
f_out <- 'C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/DS_Agua_2017_2022_por_ponto.csv'
write.csv2(ds_data,f_out, sep = ';')
write.table(ds_data,f_out,sep = ';', dec = '.')

View(ds_data)
#Merge dos dados metereológicos e de consumo unificado

ds_dados_c <- read.csv2('C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/DADOS_CONSUMO_2017_a_2022_tratado_unificado.csv', sep=';')
#join clima x consumo pela DT_MEDICAO_HORA
ds_data <- merge(ds_clima_tratado, ds_dados_c, by="DT_MEDICAO_HORA")

#limpa o dataset
ds_data = subset(ds_data, select = -c(DATA,HORA,DT_DATA, NN_DIAMES, NN_HORA, ROWNUM, NN_ANO.x, NN_MESANO, NN_MES, DT_MEDICAO, NN_ANO.y))

summary(ds_data)


ds_data$PRECIPITACAO= as.numeric(ds_data$PRECIPITACAO)
ds_data$PRESSAO_ATMOSFERICA=as.numeric(ds_data$PRESSAO_ATMOSFERICA)
ds_data$TEMPERATURA_DO_AR_C=as.numeric(ds_data$TEMPERATURA_DO_AR_C)
ds_data$UMIDADE_RELATIVA_DO_AR=as.numeric(ds_data$UMIDADE_RELATIVA_DO_AR)
ds_data$VELOCIDADE_VENTO=as.numeric(ds_data$VELOCIDADE_VENTO)
ds_data$VL_MEDICAO=as.numeric(ds_data$VL_MEDICAO)

#salva dados tratado em arquivo
f_out <- 'C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/DS_Agua_2017_2022_unificado.csv'
#write.csv2(ds_data,f_out, sep = )
write.table(ds_data,f_out,sep = ';', dec = '.')

# outros tratamentos utilizados sobre os dados ---------------------------------
# outros tratamentos utilizados sobre oos dados ---------------------------------
# outros tratamentos utilizados sobre oos dados ---------------------------------


#Carrega arquivos tratados
f_get_consumo <- 'DADOS_CONSUMO_2017_a_2022_tratado_por_ponto.csv'
f_get_temp <- 'DADOS_TEMPERATURA_2017_a_2022_tratado.csv'
dados_clima <- read.csv(paste(caminho,f_get_temp, sep=""), header = TRUE, sep = ";", encoding = 'latin1')
dados_consumo  <- read.csv(paste(caminho,f_get_consumo, sep=""), header = TRUE, sep = ";", encoding = 'latin1')

head(dados_consumo)

dados_consumo$VL_MEDICAO=str_replace(dados_consumo$VL_MEDICAO,",",".")
dados_consumo$VL_MEDICAO=as.numeric(dados_consumo$VL_MEDICAO)
dados_consumo$DT_MEDICAO_HORA <- as_datetime(parse_date_time(dados_consumo$DT_MEDICAO_HORA, "%y-%m-%d-%H.%M.%S"))

ds_dados_c <- dados_consumo %>% group_by(SK_PONTO, DT_MEDICAO, DT_MEDICAO_HORA, NN_ANO) %>%
  summarize(VL_MEDICAO=sum(VL_MEDICAO))
order_by(DT_MEDICAO_HORA)

head(ds_dados_c)
plot(ds_dados_c$DT_MEDICAO_HORA,ds_dados_c$VL_MEDICAO)

#show_plot_dyntotal(ds_dados_c)

