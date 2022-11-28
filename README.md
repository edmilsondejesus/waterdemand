# Algoritmo de Aprendizagem de Máquina para previsão da Demanda de Água

## Problema

- As condições climáticas e outros fatores, como descrito por Yassuda et al. (1976 apud SILVA et al., 2008), tendem a influenciar a demanda de água, levando o sistema ao desequilíbrio à medida em que acelera a vazão de saída dos reservatórios.

- Segundo Santos (2014), erros na previsão da demanda aumentam os custos de operação dos sistemas e aumentam os riscos no abastecimento de água.

- A imprecisão na previsão adequada da demanda de água ocasiona diversos problemas, como falta d'água, custos desnecessários de bombeamento, aumento de vazamentos e perdas em locais da rede.

---  

## Motivação
- Investimentos em infraestrutura de abastecimento de água é caro e leva tempo para implementação e para retorno do investimento (REES, 2020); 
- Aquecimento global e o crescimento da população mundial (DINIZ, 2019) são fortes motivadores para assertividade na previsão da demanda de água;


## Objetivo

** Propor um modelo de aprendizagem de máquina para previsão de demanda de água da RMS, considerando variáveis climáticas, sazonalidade e o histórico de consumo:

- Implementar e avaliar a precisão de modelos para previsão da demanda de água; 

- Estabelecer um modelo que forneça a melhor precisão na previsão da demanda


## Instructions for installation
1. Download code from GitHub: [https://github.com/edmilsondejesus/previsao-agua-am](https://github.com/edmilsondejesus/previsao-agua-am)
2. Create a virtual environment. Example name: .venv 
```
  python -m venv .venv
```
3. Activate this environment: Examples commands below and between ' '
```
  Example in Linux: 'source .venv/bin/activate'
  Example in Windows: '.venv/Scripts/Activate'
```
4. Install libraries in it from requirements.txt:
```
    pip install -r requirements.txt
``` 
 
---
## Referências

- ADAMOWSKI, J.; KARAPATAKI, C. Comparison of multivariative regression and artificial neural networks for peak urban water-demand forecasting: evaluation of diferente ann learning algorithms. J. Hydrol. Eng., v. 15, p. 729–743, 2010.

- BABU, C. N.; REDDY, B. E. A moving-average filter based hybrid arima–ann model for forecasting time series data. Applied Soft Computing, v. 23, p. 27–38, 2014. ISSN 1568-4946. Disponível em: <https://www.sciencedirect.com/science/article/pii/S1568494614002555>.

- BAKKER, M. et al. Improving the performance of water demand forecasting models by using weather input. Procedia Engineering, v. 70, p. 93–102, 2014. ISSN 1877-7058. 12th International Conference on Computing and Control for the Water Industry, CCWI2013. Disponível em: <https://www.sciencedirect.com/science/article/pii/S1877705814000149>

- ALVISI, S.; FRANCHINI, M.; MARINELLI, A. A short-term, pattern-based model for water-demand forecasting. Journal of Hydroinformatics, v. 9, n. 1, p. 39–50, 01 2007. ISSN 1464-7141. Disponível em: <https://doi.org/10.2166/hydro.2006.016>.


- BOUGADIS, J.; ADAMOWSKI, K.; DIDUCH, R. Short-term municipal water demand forecasting. Hydrological Processes, v. 19, n. 1, p. 137–148, 2005. Disponível em: <https://onlinelibrary.wiley.com/doi/abs/10.1002/hyp.5763>.

- CANDELIERI, A. Clustering and support vector regression for water demand forecasting and anomaly detection. Water, v. 9, n. 3, 2017. ISSN 2073-4441. Disponível em: <https://www.mdpi.com/2073-4441/9/3/224>.

- DONKOR, E. A. et al. Urban water demand forecasting: Review of methods and models. Journal of Water Resources Planning & Management, v. 140, n. 2, p. 146 – 159, 2014. ISSN 07339496. Disponível em: <https://search-ebscohost-com.ez10.periodicos.capes.gov.br/login.aspx?direct=true&db=aph&AN=93677319&lang=pt-br&site=ehost-live>.

- M. Ghiassi, David Zimbra, Hassine Saidane. Urban Water Demand Forecasting with a Dynamic Artificial Neural Network Model. Journal of Water Resources Planning and Management, v134 n.2, mar. 2008. Disponível em:<http://dx.doi.org/10.1061/(ASCE)0733-9496(2008)134:2(138) >. Acesso em: 10 jun. 2022.

- PIPPE – Plataforma de Informações das Plantas de Processos da EMBASA 2022. Disponível em: <http://pippe.embasanet.ba.gov.br/monitor/rmsgeral.aspx>. Acesso em: 07 jun. 2022.

- Rees, Philip ; Clark, Stephen ; Nawaz, Rizwan. Household Forecasts for the Planning of Long-Term Domestic Water Demand: Application to London and the Thames Valley. Population, Space and Place. v. 26 e 2, jan 2020. Disponível em: < https://doi.org/10.1002/psp.2288 >. Acesso em: 02 jun. 2022.

- SANTOS, C. C. dos; FILHO, A. J. P. Water demand forecasting model for the metropolitan area of são paulo, Brazil. Water Resources Management, v. 28, p. 13, 2014. Disponível em: < https://doi.org/10.1007/s11269-014-0743-7>

- Yan, Kun; Yang, Min-Zhi. Water demand forecast model of least squares support vector machine based on particle swarm optimization. MATEC Web Conf., v. 246, p. 01029, 2018. Disponível em: <https://doi.org/10.1051/matecconf/201824601029>

- Wang, L., Zou, H., Su, J., Li, L. and Chaudhry, S. (2013), An ARIMA-ANN Hybrid Model for Time Series Forecasting. Syst. Res., 30: 244-259. Disponível em: < https://doi.org/10.1002/sres.2179 >.

- WU, B. An introduction to neural networks and their applications in manufacturing.Journal of Intelligent Manufacturing, Springer, v. 3, n. 6, p. 391–403, 1992.
ZHANG, G. Time series forecasting using a hybrid arima and neural network model. Neurocomputing, v. 50, p. 159–175, 2003. ISSN 0925-2312. Disponível em: <https://www.sciencedirect.com/science/article/pii/S0925231201007020>.
