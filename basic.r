#Verifica valores ausentes no dataset

remove_outliers<- function (ds_skp){
        bp_MEDICAO=boxplot(ds_skp$VL_MEDICAO)
        ds_skp = ds_skp[-which(ds_skp$VL_MEDICAO %in% bp_MEDICAO$out),]
        boxplot(ds_skp$VL_MEDICAO)
        ds_skp
        
}

count.nas <- function(dataset){
        for(i in 1:ncol(dataset)){
                total.na = 0
                for(j in 1:nrow(dataset)){
                        if(is.na(dataset[j,i])){
                                total.na = total.na + 1
                        }
                }
                cat("Coluna: ", colnames(dataset)[i],": ",total.na, "\n");
        }
}


count.nasconsumo <- function(dataset){
        for(i in 1:ncol(dataset)){
                total.na = 0
                for(j in 1:nrow(dataset)){
                        if(is.na(dataset[j,i])||(dataset[j,i]!=0)){
                                total.na = total.na + 1
                        }
                }
                cat("Coluna: ", colnames(dataset)[i],": ",total.na, "\n");
        }
}

#Verifica valores ausentes no dataset
count.nulls <- function(dataset){
        for(i in 1:ncol(dataset)){
                total.na = 0
                for(j in 1:nrow(dataset)){
                        if(dataset[j,i]=="null"){
                                total.na = total.na + 1
                        }
                }
                cat("Coluna: ", colnames(dataset)[i],": ",total.na, "\n");
        }
}
replace.dant <- function(dataset){
        #percorre todas as colunas
        for(i in 1:ncol(dataset)){
                #percorre todas as linhas
                for(j in 1:nrow(dataset)){
                        if( (is.na(dataset[j,i])) || (dataset[j,i] ==-9999)){
                                if(is.na(dataset[j,i]))
                                        val.ant = 'null'
                                else
                                        val.ant = '-9999'
                                
                                #procura o valor não nulo anterior
                                x = 24 #incremenador de dia              
                                while((is.na(dataset[j-x,i])) || (dataset[j-x,i] ==-9999)) x = x - 24
                                day.ant = dataset[j-x,i]
                                #cat("day.ant: ",day.ant)
                                
                                
                                #procura o valor não nulo posterior
                                x <- 24 #incremenador de dia
                                while((is.na(dataset[j+x,i])) || (dataset[j+x,i] ==-9999)) x = x + 24
                                day.pos = dataset[j+x,i]
                                
                                #calcula a média    
                                avg = (as.numeric(day.ant) + as.numeric(day.pos)) / 2
                                
                                #preenche com o novo valor
                                dataset[j,i]=avg
                                cat("Col.:", colnames(dataset)[i]," Data:",dataset[j,1]," Hora:",dataset[j,10]," Ant:", val.ant, "Pos:",dataset[j,i]," dant:",day.ant," dpos:",day.pos,"\n")
                        }
                }
        }
        dataset
}

replace.mprox <- function(dataset){
        #percorre todas as colunas
        for(i in 1:ncol(dataset)){
                #percorre todas as linhas
                for(j in 1:nrow(dataset)){
                        if( (is.na(dataset[j,i])) || (dataset[j,i] ==-9999)){
                                if(is.na(dataset[j,i]))
                                        val.ant = 'null'
                                else
                                        val.ant = '-9999'
                                
                                #procura o valor não nulo anterior
                                x = 1 #incremenador de dia              
                                while((is.na(dataset[j-x,i])) || (dataset[j-x,i] ==-9999)) x = x - 1
                                day.ant = dataset[j-x,i]
                                #cat("day.ant: ",day.ant)
                                
                                
                                #procura o valor não nulo posterior
                                x <- 1 #incremenador de dia
                                while((is.na(dataset[j+x,i])) || (dataset[j+x,i] ==-9999)) x = x + 1
                                day.pos = dataset[j+x,i]
                                
                                #calcula a média    
                                avg = (as.numeric(day.ant) + as.numeric(day.pos)) / 2
                                
                                #preenche com o novo valor
                                dataset[j,i]=avg
                                cat("Col.:", colnames(dataset)[i]," Data:",dataset[j,1]," Hora:",dataset[j,10]," Ant:", val.ant, "Pos:",dataset[j,i]," dant:",day.ant," dpos:",day.pos,"\n")
                        }
                }
        }
        dataset
}

calc_vazao <- function(dataset){
        for(j in 1:nrow(dataset)-1){
                
                vl_medicao2=if_else(dataset[j+1,5]>0, dataset[j+1,5], 0)
                vl_medicao = if_else(dataset[j,5]>0, dataset[j,5], 0)
                
                #cat("med1:",vl_medicao,"med2:",vl_medicao2,"\n")
                vl_vazao = if_else(vl_medicao2 > vl_medicao,vl_medicao2 - vl_medicao, 0)
                
                
                dataset[j,5] = vl_vazao
        }
        dataset[nrow(dataset),5]<-dataset[nrow(dataset)-1,5]
        dataset[,5]
}

summary_gecy = function(x){
        z = cbind(min(x), t(quantile(x, c(.25, .5, .75))), max(x), mean(x), median(x),sd(x), var(x), round(100*(sd(x)/mean(x)),2), skewness(x))
        colnames(z) <- c("min",c("1Qr.","2Qr.","3Qr."),"max.","mean","median","sd","var","c.v.","skew")
        return(z)
}

replace_media_consumo <- function(dataset, col, vl_outliers){
        #percorre a col j, que seria o outlier
        i = col

        #percorre todas as linhas
        for(j in 1:nrow(dataset)){
                #cat(trimws(dataset[j,i]),"\n")
                if((is.element(trimws(dataset[j,i]), vl_outliers)==TRUE) ||(dataset[j ,i] < 0)){ 
                        day.ant = 0
                        day.pos = 0
                        
                        #procura o valor não nulo anterior
                        x = 1 #incremenador de linha              
                        while((is.na(dataset[j-x,i])) || is.element(trimws(dataset[j-x,i]), vl_outliers) ||(dataset[j-x,i] < 0) && (j-x >0)) x = x - 1
                        if(j-x >0)
                                day.ant = dataset[j-x,i]
                        else
                                day.ant = 0
                        #cat("day.ant: ",day.ant)
                        
                        
                        #procura o valor não nulo posterior
                        x = 1 #incremenador de linha 
                        while((is.na(dataset[j+x,i])) || is.element(trimws(dataset[j+x,i]), vl_outliers) ||(dataset[j+x,i] < 0) && (j+x <= nrow(dataset))) x = x + 1
                        if(j+x <= nrow(dataset))
                                day.pos = dataset[j+x,i]
                        else
                                day.pos =0
                        
                        #calcula a média
                        if((day.ant >0) && (day.pos >0)){
                                avg = (as.numeric(day.ant) + as.numeric(day.pos)) / 2
                        }else # ou apenas repete o valor
                                avg = day.ant + day.pos
                        
                        #preenche com o novo valor
                        cat(" Data:",as.Date(dataset[j,8])," Ant:", dataset[j,i], "Pos:", avg," a:",day.ant," p:",day.pos,"\n")
                        dataset[j,i]=avg                        
                }
        }
        #}
        dataset
}

anula_valor <-function (dataset, col, limit,new_value){
        i=col
        for(j in 1:nrow(dataset)){
                if(dataset[j,i]>limit)
                        dataset[j,i]=new_value
        }
        dataset
}

#grafico de linha 
show_plot_skp <- function (dataset){ 
        fig <- plot_ly(dataset, x = ~DT_MEDICAO_HORA)
        fig <- fig %>% add_trace(y = ~dataset$VL_MEDICAO, name = dataset[1,6], type = 'scatter', mode = 'lines+markers') %>%
        layout( title=paste(dataset[1,6]),xaxis = list(title = 'DT_MEDICAO_HORA'), yaxis = list(title = 'VL_MEDICAO '))
        fig 
}

#grafico de linha 
show_plot_skpt <- function (dataset, stitle, sxlegend, width, height, dpi){ 
        fig <- plot_ly(dataset, x = ~DT_MEDICAO_HORA)
        fig <- fig %>% add_trace(y = ~dataset$VL_MEDICAO, name = dataset[1,6], type = 'scatter', mode = 'lines+markers') %>%
                layout( title=paste(stitle,dataset[1,6]),xaxis = list(title = paste('DT_MEDICAO_HORA \n\n',sxlegend)), yaxis = list(title = 'VL_MEDICAO ')) %>%
                config(
                        toImageButtonOptions = list(
                                format = "jpg",
                                width = width,
                                height = height,
                                res = dpi
                        )
                )
        fig 
}

replace_consumo_negativo <- function(dataset, col){
        #percorre a col j, que seria o outlier
        i = col
        
        #percorre todas as linhas
        for(j in 1:nrow(dataset)){
                cat("line ",j, " of ", nrow(dataset),"\n")
                if((is.na(dataset[j,i]))||(dataset[j ,i] < 0)){ 
                        day.ant = 0
                        day.pos = 0
                        
                        #procura o valor não nulo anterior
                        x = 1 #incremenador de linha              
                        while((j-x >0) && ((is.na(dataset[j-x,i])) ||(dataset[j-x,i] < 0))) x = x - 1
                        if(j-x >0)
                                day.ant = dataset[j-x,i]
                        else
                                day.ant = 0

                        #procura o valor não nulo posterior
                        x = 1 #incremenador de linha 
                        while((j+x <= nrow(dataset)) &&(is.na(dataset[j+x,i]))||(dataset[j+x,i] < 0)) x = x + 1
                        if(j+x <= nrow(dataset))
                                day.pos = dataset[j+x,i]
                        else
                                day.pos =0
                        
                        #calcula a média
                        if((day.ant >0) && (day.pos >0)){
                                avg = (as.numeric(day.ant) + as.numeric(day.pos)) / 2
                        }else # ou apenas repete o valor
                                avg = day.ant + day.pos
                        
                        #preenche com o novo valor
                        cat(" Data:",dataset[j,7]," Ant:", dataset[j,i], "Pos:", avg," a:",day.ant," p:",day.pos,"\n")
                        dataset[j,i]=avg                        
                }
        }
        dataset
}

mediaga<-function(x){
        n<-length(x)
        mg<-(prod(x))^(1/n)
        mh<-(1/n*sum(1/x))^(-1)
        mh2<-n / sum(1/x)
        
        cat(" média geom=",mg," média harm=",mh, " média harm2=", mh2)
}

moda<-function(x){
        subset(table(x), table(x)==max(table(x)))
}



moda = function(x) {
        z = table(as.vector(x))
        as.numeric(names(z)[z == max(z)])
}

medpond<-function(x,w){sum(x*w)/sum(w)}

#coeficiente de variação
cv<-function(x){
        cv<- round((sd(x) / mean(x))*100,2)
        if(cv < 15)
                cat(cv, " baixa dispersão (dados homogêneos)")
        else if(cv<30)
                cat(cv," média dispersão (dados moderadamente homogêneos)")
        else
                cat(cv," elevada dispersão (dados hetereogêneos)")
}

ca<-function(x){
        ca<-skewness(x)
        if(ca==0)
                cat(ca, " distribuição é simétrica")
        else if(ca>0)
                cat(ca," distribuição assimétrica positiva ou à direita")
        else
                cat(ca," distribuição assimétrica negativa ou à esquerda")
}

#quantile
quanti <- function (x){
        quantile(x)
        q1<-quantile(x,0)
        q2<-quantile(x,0.25)
        q3<-quantile(x,0.5)
        q4<-quantile(x,0.75)
        q5<-quantile(x,1)
        cat("\n Não existe x < ",q1)
        cat("\n Não existe x > ",q5)
        cat("\n 25% dos valores de x são ??? ",q2)
        cat("\n 50% dos valores de x são ??? ",q3)
        cat("\n 75% dos valores de x são ??? ",q4)
}

summary_gecy = function(x){
        z = cbind(min(x), t(quantile(x, c(.25, .5, .75))), max(x), mean(x), median(x),sd(x), var(x), round(100*(sd(x)/mean(x)),2), skewness(x))
        colnames(z) <- c("min",c("1Qr.","2Qr.","3Qr."),"max.","mean","median","sd","var","c.v. (%)","skewness")
        return(z)
}

show_grafreq<-function(ds_freq,x,titulo){
        titulo<-paste("Frequência do ", titulo)
        ylimite=5
        plot(ds_freq$Group.1, ds_freq$x, type="o",xlab=titulo,ylab="Frequência",pch=19, ylim = c(0,ylimite),main=titulo)
        value <-quantile(x,0)
        q0<-rep(value, ylimite)
        xline <- seq(1,ylimite,1)
        lines(q0,xline,type="l",col=c("purple"),lty=2, pch=18)
        
        value <-quantile(x,0.25)
        q1<-rep(value, ylimite)
        lines(q1,xline,type="l",col=c("blue"),lty=2, pch=18)
        
        value <-quantile(x,0.5)
        q2<-rep(value, ylimite)
        lines(q2,xline,type="l",col=c("red"),lty=2, pch=18)
        
        
        value <-quantile(x,0.75)
        q3<-rep(value, ylimite)
        lines(q3,xline,type="l",col=c("yellow"),lty=2, pch=18)
        
        
        value <-quantile(x,1)
        q4<-rep(value, ylimite)
        lines(q4,xline,type="l",col=c("green"),lty=2, pch=18)
        
        legend(x="top",legend=c("Q0","Q1","Q2","Q3","Q4"), col=c("purple","blue","red","yellow","green"),lty=1:4, ncol=5)
        
        text(x = q0, y = 0.5, 
             labels = q0)
        
        text(x = q1, y = 0.5, 
             labels = q1)
        text(x = q2, y = 0.5, 
             labels = q2)
        text(x = q3, y = 0.5, 
             labels = q3)
        text(x= q4[1], y= 0.5, 
             labels = q4)
}

show_plot_dyn <- function(dataset){
        fig <- plot_ly( width = 900, height=800, dataset, type = 'scatter', mode = 'lines')%>%
                add_trace(x = ~DT_MEDICAO_HORA, y = ~VL_MEDICAO)%>%
                layout(showlegend = F, title=paste('Hourly consumption ',dataset[1,6]),
                       xaxis = list(rangeslider = list(visible = T),
                                    rangeselector=list(
                                            buttons=list(
                                                    list(count=1, label="1m", step="month", stepmode="backward"),
                                                    list(count=6, label="6m", step="month", stepmode="backward"),
                                                    list(count=1, label="YTD", step="year", stepmode="todate"),
                                                    list(count=1, label="1y", step="year", stepmode="backward"),
                                                    list(step="all")
                                            ))))
        fig <- fig %>%
                layout(
                        xaxis = list(zerolinecolor = '#ffff',
                                     zerolinewidth = 2,
                                     gridcolor = 'ffff'),
                        yaxis = list(zerolinecolor = '#ffff',
                                     zerolinewidth = 2,
                                     gridcolor = 'ffff'),
                        plot_bgcolor='#e5ecf6', margin = 0.1)
        fig
}

show_plot_dynt <- function(dataset, width, height,dpi){
        fig <- plot_ly( dataset, type = 'scatter', mode = 'lines')%>%
                add_trace(x = ~DT_MEDICAO_HORA, y = ~VL_MEDICAO)%>%
                layout(showlegend = F, title=paste('Hourly consumption ',dataset[1,6]),
                       xaxis = list(rangeslider = list(visible = T),
                                    rangeselector=list(
                                            buttons=list(
                                                    list(count=1, label="1m", step="month", stepmode="backward"),
                                                    list(count=6, label="6m", step="month", stepmode="backward"),
                                                    list(count=1, label="YTD", step="year", stepmode="todate"),
                                                    list(count=1, label="1y", step="year", stepmode="backward"),
                                                    list(step="all")
                                            ))))%>%
                config(
                        toImageButtonOptions = list(
                                format = "jpg",
                                width = width,
                                height = height,
                                res = dpi
                        )
                )
        fig <- fig %>%
                layout(
                        xaxis = list(zerolinecolor = '#ffff',
                                     zerolinewidth = 2,
                                     gridcolor = 'ffff'),
                        yaxis = list(zerolinecolor = '#ffff',
                                     zerolinewidth = 2,
                                     gridcolor = 'ffff'),
                        plot_bgcolor='#e5ecf6', margin = 0.1)
        fig
}

show_plot_dyntotal <- function(dataset){
        fig <- plot_ly(dataset, type = 'scatter', mode = 'lines')%>%
                add_trace(x = ~DT_MEDICAO_HORA, y = ~VL_MEDICAO)%>%
                layout(showlegend = F, title=paste('Consumo horário '),
                       xaxis = list(rangeslider = list(visible = T),
                                    rangeselector=list(
                                            buttons=list(
                                                    list(count=1, label="1m", step="month", stepmode="backward"),
                                                    list(count=6, label="6m", step="month", stepmode="backward"),
                                                    list(count=1, label="YTD", step="year", stepmode="todate"),
                                                    list(count=1, label="1y", step="year", stepmode="backward"),
                                                    list(step="all")
                                            ))))
        fig <- fig %>%
                layout(
                        xaxis = list(zerolinecolor = '#ffff',
                                     zerolinewidth = 2,
                                     gridcolor = 'ffff'),
                        yaxis = list(zerolinecolor = '#ffff',
                                     zerolinewidth = 2,
                                     gridcolor = 'ffff'),
                        plot_bgcolor='#e5ecf6', margin = 0.1, width = 900)
        fig
}

#gera gráfico de pontos com datas no exio X para  a série temporal de volume por ponto
gera_grafico_cons_diario <- function(ds_dados_consumo){
        ds_nmponto <-sqldf::sqldf("SELECT distinct SK_PONTO, NM_PONTO FROM ds_dados_consumo ")
        
        for(x in 1:nrow(ds_nmponto)){
                
                sk_ponto<-ds_nmponto[x,1]
                titulo<-paste("Gráfico de Volume diário \n",ds_nmponto[x,2])
                str_sql<-paste("SELECT DT_MEDICAO, sum(VL_MEDICAO) VL_CONSUMO,NM_PONTO FROM ds_dados_consumo where SK_PONTO=",sk_ponto," group by NM_PONTO,DT_MEDICAO order by 1 asc")
                print(titulo)
                ds_dponto <-sqldf::sqldf(str_sql)
                head(ds_dponto)
                ds_dponto$ROWNUM <- seq(1,nrow(ds_dponto),1)      
                
                png(filename=paste(caminho,"graficos/diario/grafico_volume_diario_",x,".png", sep = ""))
                plot(ds_dponto$ROWNUM, ds_dponto$VL_CONSUMO, xlab="dia",ylab="Volume",pch=19, main=titulo)
                dev.off()
        }
}

#gera gráfico de linha com datas no exio X para  a série temporal de volume por ponto
gera_grafico_serie_diario <- function(ds_dados_consumo){
        ds_nmponto <-sqldf::sqldf("SELECT distinct SK_PONTO, NM_PONTO FROM ds_dados_consumo ")
        
        for(x in 1:nrow(ds_nmponto)){
                
                sk_ponto<-ds_nmponto[x,1]
                titulo<-paste("Gráfico de Volume diário \n",ds_nmponto[x,2])
                str_sql<-paste("SELECT DT_MEDICAO, sum(VL_MEDICAO) VL_CONSUMO,NM_PONTO FROM ds_dados_consumo where SK_PONTO=",sk_ponto," group by NM_PONTO,DT_MEDICAO order by 1 asc")
                print(titulo)
                ds_dponto <-sqldf::sqldf(str_sql)
                
                fig <- plot_ly(ds_dponto, type = 'scatter', mode = 'lines')%>%
                        add_trace(x = ~DT_MEDICAO, y = ~VL_CONSUMO)%>%
                        layout(showlegend = F, title=titulo)
                fig <- fig %>%
                        layout(
                                xaxis = list(zerolinecolor = '#ffff',
                                             zerolinewidth = 2,
                                             gridcolor = 'ffff', title='Data'),
                                yaxis = list(zerolinecolor = '#ffff',
                                             zerolinewidth = 2,
                                             gridcolor = 'ffff', title='Volume'),
                                plot_bgcolor='#e5ecf6', width = 900)
                fig
                
                filename=paste(caminho,"graficos/diario/grafico_ts_vol_diario_",x,".png", sep = "")
                plotly_IMAGE( fig, format = "png", out_file = filename)
        }
}

#gera gráfico com seletort de zoom
show_grafseletor<-function (ds_dponto, nm_ponto){
        #gráfico dinâmico de volume consumido 1m a todos
        fig <- plot_ly(ds_dponto, type = 'scatter', mode = 'lines')%>%
                add_trace(x = ~Date, y = ~VL_CONSUMO)%>%
                layout(showlegend = F, title=paste('Consumo total diário ',nm_ponto),
                       xaxis = list(rangeslider = list(visible = T),
                                    rangeselector=list(
                                            buttons=list(
                                                    list(count=1, label="1m", step="month", stepmode="backward"),
                                                    list(count=6, label="6m", step="month", stepmode="backward"),
                                                    list(count=1, label="YTD", step="year", stepmode="todate"),
                                                    list(count=1, label="1y", step="year", stepmode="backward"),
                                                    list(step="all")
                                            ))))
        fig <- fig %>%
                layout(
                        xaxis = list(zerolinecolor = '#ffff',
                                     zerolinewidth = 2,
                                     gridcolor = 'ffff'),
                        yaxis = list(zerolinecolor = '#ffff',
                                     zerolinewidth = 2,
                                     gridcolor = 'ffff'),
                        plot_bgcolor='#e5ecf6', margin = 0.1, width = 900)
        fig
        
}

#gera gráfico de linha com datas no exio X para  a série temporal de volume por ponto
gera_grafico_serie_horario <- function(ds_dados_consumo){
        ds_nmponto <-sqldf::sqldf("SELECT distinct SK_PONTO, NM_PONTO FROM ds_dados_consumo ")
        
        for(x in 1:nrow(ds_nmponto)){
                
                sk_ponto<-ds_nmponto[x,1]
                titulo<-paste("Gráfico de Volume horário \n",ds_nmponto[x,2])
                str_sql<-paste("SELECT DT_MEDICAO_HORA, sum(VL_MEDICAO) VL_CONSUMO,NM_PONTO FROM ds_dados_consumo where SK_PONTO=",sk_ponto," group by NM_PONTO,DT_MEDICAO_HORA order by 1 asc")
                print(titulo)
                ds_dponto <-sqldf::sqldf(str_sql)
                
                fig <- plot_ly(ds_dponto, type = 'scatter', mode = 'lines')%>%
                        add_trace(x = ~DT_MEDICAO_HORA, y = ~VL_CONSUMO)%>%
                        layout(showlegend = F, title=titulo)
                fig <- fig %>%
                        layout(
                                xaxis = list(zerolinecolor = '#ffff',
                                             zerolinewidth = 2,
                                             gridcolor = 'ffff', title='Data'),
                                yaxis = list(zerolinecolor = '#ffff',
                                             zerolinewidth = 2,
                                             gridcolor = 'ffff', title='Volume'),
                                plot_bgcolor='#e5ecf6', width = 900)
                fig
                
                filename=paste(caminho,"graficos/horario/grafico_ts_vol_horario_",x,".png", sep = "")
                plotly_IMAGE( fig, format = "png", out_file = filename)
        }
}

