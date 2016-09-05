source("../api/common.R")
source("../api/eod-api.R")

indexName<-'NIFTY MID100 FREE'
ival<-getEodIndexByDateRange(indexName, '2000-01-01', '2016-08-31')

nRet<-dailyReturn(ival$PX_CLOSE)

#drawdowns seen by the investor over 1000 days
ddcum1<-data.frame(TS="", DD=0.0, PDD=0.0, stringsAsFactors =F)
for(i in 1:(length(nRet[,1])-1000)){
	srange<-nRet[i:(1000+i),]
	td<-data.frame(table.Drawdowns(srange, top=1))
	ddcum1<-rbind(ddcum1, c(toString(last(index(srange))), 100*as.numeric(td$Depth[1]), ifelse(as.Date(last(index(srange))) == as.Date(td$Trough[1]), 100*as.numeric(td$Depth[1]), NA)))
}
ddcum1<-ddcum1[-1,]
ddcum1$DD<-as.numeric(ddcum1$DD)
ddcum1$PDD<-as.numeric(ddcum1$PDD)
ddcum1<-xts(ddcum1[, -1], as.Date(ddcum1[,1]))

#drawdowns seen by the investor over 500 days
ddcum11<-data.frame(TS="", DD=0.0, PDD=0.0, stringsAsFactors =F)
for(i in 1:(length(nRet[,1])-500)){
	srange<-nRet[i:(500+i),]
	td<-data.frame(table.Drawdowns(srange, top=1))
	ddcum11<-rbind(ddcum11, c(toString(last(index(srange))), 100*as.numeric(td$Depth[1]), ifelse(as.Date(last(index(srange))) == as.Date(td$Trough[1]), 100*as.numeric(td$Depth[1]), NA)))
}
ddcum11<-ddcum11[-1,]
ddcum11$DD<-as.numeric(ddcum11$DD)
ddcum11$PDD<-as.numeric(ddcum11$PDD)
ddcum11<-xts(ddcum11[, -1], as.Date(ddcum11[,1]))

#drawdowns seen by the investor over 200 days
ddcum12<-data.frame(TS="", DD=0.0, PDD=0.0, stringsAsFactors =F)
for(i in 1:(length(nRet[,1])-200)){
	srange<-nRet[i:(200+i),]
	td<-data.frame(table.Drawdowns(srange, top=1))
	ddcum12<-rbind(ddcum12, c(toString(last(index(srange))), 100*as.numeric(td$Depth[1]), ifelse(as.Date(last(index(srange))) == as.Date(td$Trough[1]), 100*as.numeric(td$Depth[1]), NA)))
}
ddcum12<-ddcum12[-1,]
ddcum12$DD<-as.numeric(ddcum12$DD)
ddcum12$PDD<-as.numeric(ddcum12$PDD)
ddcum12<-xts(ddcum12[, -1], as.Date(ddcum12[,1]))

toPlot<-merge(ddcum1, ddcum11, ddcum12)

png(sprintf("%sdrawdowns.%s.png", reportPath, indexName), width=1000, height=600*3)
par(col='red', mfrow=c(3, 1), cex=0.8, las=2, mar=c(1, 4, 4, 4), family='Segoe UI')
plot(toPlot[,1], main="Drawdown seen by an investor", xaxt='n')
points(toPlot[,2], col='red')
mtext(sprintf('% d in 1000 days', length(toPlot[!is.na(toPlot[,2]),2])), las=1, adj=1)
par(col='blue', mar=c(1, 4, 1, 4))
plot(toPlot[,3], main=NA, xaxt='n')
points(toPlot[,4], col='blue')
mtext(sprintf('% d in 500 days', length(toPlot[!is.na(toPlot[,4]),4])), las=1, adj=1)
par(col='green', mar=c(7, 4, 1, 4))
plot(toPlot[,5], main=NA, las=2)
points(toPlot[,6], col='green')
mtext(sprintf('% d in 200 days', length(toPlot[!is.na(toPlot[,6]),6])), las=1, adj=1)
mtext("@StockViz", col='grey', side=1, adj=1, padj=1, las=1)
dev.off()

png(sprintf("%scumulative.returns.%s.png", reportPath, indexName), width=1000, height=600)
charts.PerformanceSummary(nRet, wealth.index = TRUE, main=sprintf("Cumulative Returns of %s @StockViz", indexName))
dev.off()

png(sprintf("%sdrawdown.p2p.%s.png", reportPath, indexName), width=1000, height=600)
chart.Drawdown(nRet, main=sprintf("Drawdown of %s @StockViz", indexName))
dev.off()