library(lmtest)
library(forecast)
library(xts)
#install.packages('fpp2')
library(lmtest)
library(tseries)
#install.packages('astsa')
library(astsa)
library(plyr)
library(lubridate)
#install.packages("TSA")
library(TSA)


caminho = paste("C:/Users/Edmilson/Downloads/mestrado/waterdemand/", sep="")
source(paste(caminho,"basic.r",sep = ""))
caminho = paste("C:/Users/Edmilson/Downloads/mestrado/waterdemand/data/", sep="")
arquivo <- 'DS_Agua_2017_2022_por_ponto.csv'
ds_water <- read.csv(paste(caminho,arquivo, sep=""), header = TRUE, sep = ";", encoding = 'latin1')

caminho_result = paste("C:/Users/Edmilson/Downloads/mestrado/waterdemand/results/", sep="")
arquivo_result = 'Result_ARIMA2_Model_Hour.csv'

salvar_resultado <- function (sk_ponto, ds_best_param, n_time_steps, MSE, RMSE, MAE, MAPE, Duration){
  #Script to write training cycle results
  data = data.frame(sk_ponto = sk_ponto, ds_best_param = ds_best_param, 
                    n_time_steps = n_time_steps, MSE = MSE, RMSE = RMSE, 
                    MAE = MAE, MAPE = MAPE, Duration = Duration)
  write.table(data,paste(caminho_result,arquivo_result, sep=""),sep=';',append = TRUE, col.names = FALSE, row.names = FALSE, dec = ',')
}

#Script to create the results file
criar_arquivo_resultado <- function(){
  data = data.frame(sk_ponto = '', ds_best_param = '', 
                    n_time_steps = '', MSE = '', RMSE = '', 
                    MAE = '', MAPE = '', Duration = '')
  write.table(data,paste(caminho_result,arquivo_result, sep=""), sep=';')
}

criar_arquivo_resultado ()


previsao_ARIMA1 <- function (sk_ponto, ds_ponto, n_time_steps){
  
  ds_ponto$DT_MEDICAO_HORA<- as_datetime(ds_ponto$DT_MEDICAO_HORA)

  ds_st<-cbind(ds_ponto$DT_MEDICAO_HORA,ds_ponto$VL_MEDICAO,ds_ponto$PRECIPITACAO, ds_ponto$PRESSAO_ATMOSFERICA, ds_ponto$TEMPERATURA_DO_AR_C,
             ds_ponto$UMIDADE_RELATIVA_DO_AR, ds_ponto$VELOCIDADE_VENTO)

  # time serire transform - shift of n_time_steps lag time
  for (i in 1:n_time_steps){
    if(i>1)
      ds_stlag <- cbind(ds_stlag,lag.xts(ds_ponto$VL_MEDICAO, k = i))
    else
      ds_stlag <- cbind(ds_st,lag.xts(ds_ponto$VL_MEDICAO, k = i))
  }

  #Concatenates the matrix with the result vector and eliminates the last line
  ds_matrix <- na.omit(ds_stlag)

  #colnames(ds_matrix) <- c("DT_MEDICAO_HORA","VL_MEDICAO","PRECIPITACAO","PRESSAO","TEMPERATURA","UMIDADE","VELOCIDADE_VENTO","VL_RESULTADO")
  new_index <- as_datetime(ds_matrix[,1])
  ds_matrix <- ds_matrix[,2:ncol(ds_matrix)]


  #head(ts_matrix)
  #Plot all series
  #ts_matrix <- xts(ds_matrix, order.by = new_index)
  #autoplot(ts_matrix)

  #Plot VL_MEDICAO
  #autoplot(ts_matrix[,1])


  #Check the stationarity of the VL_MEDICAO series
  #adf.test(ds_matrix[,1])  

  # Check the autocorrelation and partial autocorrelation functions
  #acf2(as.numeric(ds_matrix[,1]))

  d_resultado <-ds_matrix[,1]
  
  # BoxCox transformation for hourly prediction 
  lambda<- BoxCox.lambda(ds_matrix[,1])

  # Stores the training execution start time
  Inicio <- Sys.time()

  #Search the best ARIMA model without lambda
  modelo=auto.arima(ds_matrix[,1],xreg=ds_matrix[,2:ncol(ds_matrix)], trace = TRUE,approximation = FALSE, max.p = 5, max.q = 5 , lambda = lambda)

  #identify index number for separate data of treain 75% and test 25%
  idx_teste <- round(length(d_resultado)* 0.75)
  idx_validacao <-length(d_resultado)

  # Adjustment of the result series for training x test
  y_treino <- ts(d_resultado[1:idx_teste], frequency = 24 * 365)
  y_teste  <- ts(d_resultado[(idx_teste +1):idx_validacao], frequency = 24 * 365)

  #adjustment of series of independent variables for training x testing
  X_treino <- ts(ds_matrix[1:idx_teste,2:ncol(ds_matrix)], frequency = 24 * 365)
  X_teste <- ts(ds_matrix[(idx_teste +1):idx_validacao, 2:ncol(ds_matrix)], frequency = 24 * 365)

  #make prediction
  predicao <- forecast(modelo, h=length(y_teste), xreg = X_teste)

  # Stores the training execution end time
  Fim <- Sys.time()

  #Calculate the duration of the training execution
  Duration = Fim - Inicio
  Duration = round(as.numeric(difftime(time1 =Fim , time2 = Inicio, units = "secs")), 3)

  #Get the best params
  ar_order<-modelo$arma[1]
  ma_order<-modelo$arma[2]
  diff_order = modelo$arma[6]
  s_ar_order = modelo$arma[3]
  s_ma_order = modelo$arma[4]
  s_ddiff_order =  modelo$arma[7]

  #get best params names
  ds_best_param = paste('ARMA(',ar_order,',',diff_order,',',ma_order,')(',s_ar_order,',',s_ddiff_order,',',s_ma_order,')', sep='')


  accuracy = accuracy(as.numeric(y_teste), as.numeric(predicao$mean))
  ME <-accuracy[1,1]
  RMSE <-accuracy[1,2]
  MSE <- RMSE * RMSE
  MAE <-accuracy[1,3]
  MPE <-accuracy[1,4]
  MAPE <-accuracy[1,5]


  salvar_resultado(sk_ponto, ds_best_param, n_time_steps, MSE, RMSE, MAE, MAPE, Duration)

  #plot result of prediction
  #plot(predicao)
  #plot(as.numeric(y_teste), type = 'l', main = "Validação", xlab = "Tempo em horas", ylab = "Consumo l/h")
  #lines(as.numeric(predicao$mean), col='blue')

  #analysis of the metrics found in the model for the training phase
  #accuracy(y_treino, modelo$fitted)
}

#get list of sk_ponto
lista_pontos=unique(ds_water['SK_PONTO'])
length(lista_pontos[,1])

# make prediction for each sk_ponto
for (x in 1:length(lista_pontos[,1])){
  sk_ponto=lista_pontos[x,1]
  ds_ponto <- ds_water[ds_water$SK_PONTO==sk_ponto,]
  for (n_time_Steps in 1:6){
    print(paste('prediction sk_ponto=',sk_ponto,' lag times = ',n_time_Steps, sep=''))
    print(paste('ds_ponto = ',count(ds_ponto),' lines', sep=''))
    previsao_ARIMA1(sk_ponto, ds_ponto, n_time_Steps)
  }
}
