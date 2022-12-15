library(lmtest)
library(forecast)
library(xts)
#install.packages('fpp2')
library(lmtest)
library(tseries)
#install.packages('astsa')
library(astsa)
caminho = paste("C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/", sep="")
source(paste(caminho,"basic.r",sep = ""))
arquivo <- 'DS_Agua_2017_2022_por_ponto.csv'
ds_water <- read.csv(paste(caminho,arquivo, sep=""), header = TRUE, sep = ";", encoding = 'latin1')


View(ds_ponto)
ds_ponto <- ds_water %>% filter(ds_water$SK_PONTO==1)
head(ds_ponto)
, DT_MEDICAO, DT_MEDICAO_HORA, NN_ANO) %>%
  summarize(VL_MEDICAO=sum(VL_MEDICAO))
order_by(DT_MEDICAO_HORA)

max_date <-max(ds_water$DT_MEDICAO_HORA)
min_date <-min(ds_water$DT_MEDICAO_HORA)
min_date
max_date
index_time <- seq(from = as.POSIXct(min_date), to = as.POSIXct(max_date), by = "hour")
#set.seed(1)
index_time

ds_st<-cbind(ds_water$PRECIPITACAO, ds_water$PRESSAO_ATMOSFERICA, ds_water$TEMPERATURA_DO_AR_C,
             ds_water$UMIDADE_RELATIVA_DO_AR, ds_water$VELOCIDADE_VENTO,ds_water$VL_MEDICAO)

#aplica o lag de 1 tempo na série de valores de medição
ds_stlag <- lag.xts(ds_water$VL_MEDICAO, k = -1)

#Concatena a matrix com o vetor de resultados e elimina a última linha 
ds_matrix <- na.omit(cbind(ds_st, ds_stlag))

#renomeia o título das colunas
colnames(ds_matrix) <- c("PRECIPITACAO","PRESSAO","TEMPERATURA","UMIDADE","VELOCIDADE_VENTO","VL_MEDICAO","VL_RESULTADO")

head(ds_matrix)

new_index <- index_time[2:length(index_time)]

ts_matrix <- xts(ds_matrix, order.by = new_index)
head(ts_matrix)
#Plotagem de todas as séries
autoplot(ts_matrix)
#Plotagem da variável VL_RESULTADO
autoplot(ts_matrix[,7:7])


#Separa o vetor de resultado
d_resultado<- ds_matrix[,7]

#Verifica a estacionariedade da série de resultado
adf.test(ds_matrix[,7])

#Verifica as funções de autocorrelação e autocorrelação parcial
acf2(d_resultado)

#Buscando o melhor modelo ARIMA
modelo=auto.arima(ds_matrix[,7],xreg=ds_matrix[,1:6], trace = TRUE,approximation = FALSE, max.p = 3, max.q = 3)

#encontra o índice para separação dos dados em treinamento 75% e teste 25%
idx_teste <- round(length(d_resultado)* 0.75)
idx_validacao <-length(d_resultado)

#Ajuste da série de resultado para treinamento x teste 
treino <- ts(d_resultado[1:idx_teste], frequency = 24 * 365)
validacao <- ts(d_resultado[(idx_teste +1):idx_validacao], frequency = 24 * 365)

head(d_resultado)

#ajuste das séries de variáveis independentes para treinamento x teste
m_treino <- ts(ds_matrix[1:idx_teste,1:6], frequency = 24 * 365)
m_validacao <- ts(ds_matrix[(idx_teste +1):idx_validacao, 1:6], frequency = 24 * 365)

modelo <- Arima( y = treino, order = c(1, 1, 1),  xreg = m_treino)
install.packages("TSA")
library(TSA)

ml = arimax(treino,order=c(2,1,1),xtransf = m_treino)
coeftest(ml)
summary(ml)
predicao <- forecast(ml, h=length(validacao), xtransf = m_validacao)

plot(predicao)
plot(as.numeric(validacao), type = 'l', main = "Validação", xlab = "Tempo em horas", ylab = "Consumo l/h")
lines(as.numeric(predicao$mean), col='blue')
accuracy(as.numeric(validacao), as.numeric(predicao$mean))
show_metrics(as.numeric(validacao), as.numeric(predicao$mean))

plot(predicao$residuals)

#modelo <-Arima( y = treino, order = c(2, 1, 2), lambda = 0.1827694, xreg = m_treino) # Lambda anterior '10.83251

#Visualizando a parametrização e coeficientes do modelo
summary(modelo)

#testar a eficiencia do modelo
coeftest(modelo)

plot(treino)

lines(modelo$fitted, col = 'blue')

#análise das métricas encontrada no modelo para a fase de treinamento
accuracy(treino, modelo$fitted)
show_metrics(treino, modelo$fitted)
#fazendo previsão no futuro com o cojunto de validação
predicao <- forecast(modelo, h=length(validacao), xreg = m_validacao)

plot(predicao)
plot(as.numeric(validacao), type = 'l', main = "Validação", xlab = "Tempo em horas", ylab = "Consumo l/h")
lines(as.numeric(predicao$mean), col='blue')
accuracy(as.numeric(validacao), as.numeric(predicao$mean))
show_metrics(as.numeric(validacao), as.numeric(predicao$mean))

plot(predicao$residuals)
 

