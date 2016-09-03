library('RODBC')
library('quantmod')
library('PerformanceAnalytics')
library('extrafont')
library('colorspace')

source("c:/stockviz/R/config.R")
reportPath<-"report/"

lcon <- odbcDriverConnect(sprintf("Driver={SQL Server};Server=%s;Database=%s;Uid=%s;Pwd=%s;", ldbserver, ldbname, ldbuser, ldbpassword), case = "nochange", believeNRows = TRUE)
lcon2 <- odbcDriverConnect(sprintf("Driver={SQL Server};Server=%s;Database=%s;Uid=%s;Pwd=%s;", ldbserver2, ldbname2, ldbuser2, ldbpassword2), case = "nochange", believeNRows = TRUE)
