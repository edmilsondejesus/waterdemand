# Machine Learning Algorithm for Water Demand forecasting

## Problem

- Climatic conditions and other factors, as described by Yassuda et al. (1976 apud SILVA et al., 2008), tends to influence the demand for water, leading the system to imbalance as it accelerates the outflow of the reservoirs.

- According to Santos (2014), errors in demand forecasting increase system operating costs and increase risks in water supply.

- The inaccuracy in properly forecasting the demand for water causes several problems, such as lack of water, necessary pumping costs, increased leaks and losses in network locations.

🇧🇷

## Motivation
- Investments in water supply infrastructure are expensive and take time to implement and return on investment (REES, 2020);
- Global warming and world population growth (DINIZ, 2019) are strong motivators for assertiveness in forecasting water demand;


## Objective

** Propose a machine learning model for forecasting RMS water demand, considering climate variables and consumption history:

- Implement and evaluate the accuracy of models for forecasting water demand;

- Establish a model that gives the best accuracy in forecasting demand


## Instructions for installation
1. Download the code from GitHub: [https://github.com/edmilsondejesus/waterdemand](https://github.com/edmilsondejesus/waterdemand)
2. Create a virtual environment. Name example: .venv
🇧🇷
    python -m venv .venv
🇧🇷
3. Activate this environment: Examples of commands below and between ' '
🇧🇷
    Example on Linux: 'source .venv/bin/activate'
    Example on Windows: '.venv/Scripts/Activate'
🇧🇷
4. Install the libraries on it from requirements.txt:
🇧🇷
      pip install -r requirements.txt
🇧🇷

5. Othes scripts *.R will can be run on R language softwares (RStudio, for example).
---

## Files
Pre_processamento.R - File for processing telemetry data, consumption and meteorological data. With replacement of missing data and treatment of invalid data.
MLP_Model_Hour.ipynb - Training and prediction using the MLP model for hourly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
MLP_Model_Day.ipynb - Training and prediction using the MLP model for daily prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
MLP_Model_Week.ipynb - Training and prediction using the MLP model for weekly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
SVR_Model_Hour.ipynb - Training and prediction using the SVR model for hourly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
SVR_Model_Day.ipynb - Training and prediction using the SVR model for daily prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
SVR_Model_Week.ipynb - Training and prediction using the SVR model for weekly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
ARIMA1_Model_Hour.R - Training and prediction using the untransformed ARIMA model for hourly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
ARIMA1_Model_Day.R - Training and prediction using the untransformed ARIMA model for daily prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
ARIMA1_Model_Week.R - Training and prediction using the untransformed ARIMA model for weekly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
ARIMA2_Model_Hour.R - Training and prediction using the ARIMA model with BoxCox transformation for hourly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
ARIMA2_Model_Day.R - Training and prediction using the ARIMA model with BoxCox transformation for daily prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
ARIMA2_Model_Week.R - Training and prediction using the ARIMA model with BoxCox transformation for weekly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
SVR-MLP_Model_Hour.ipynb - Training and prediction using the SVR-MLP hybrid model for hourly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
SVR-MLP_Model_Hour.ipynb - Training and prediction using the SVR-MLP hybrid model for daily prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
SVR-MLP_Model_Hour.ipynb - Training and prediction using the SVR-MLP hybrid model for weekly prediction of the 11 reservoirs, considering delay lag from 1 to 6 measurement values.
SVR_Model_general.ipynb - Training and prediction using the SVR model for hourly prediction of the general sum of reservoirs, considering delay lag from 1 measurement 
MLP_Model_general.ipynb - Training and prediction using the MLP  model for hourly prediction of the general sum of reservoirs, considering delay lag from 1 measurement 
MLP_Model_general_scaler.ipynb - Training and prediction using the MLP model for hourly prediction of the general sum of reservoirs, considering standard scaler normalization and delay lag from 1 measurement.

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
