source("../api/common.R")
source("../api/eod-api.R")

mncIndex<-'NIFTY MNC'
nifyIndex<-'NIFTY 50'
midcapIndex<-'NIFTY MID100 FREE'

startDate<-as.Date('2000-01-01')
endDate<-as.Date('2016-08-31')

mncVal<-getEodIndexByDateRange(mncIndex, startDate, endDate)
niftyVal<-getEodIndexByDateRange(nifyIndex, startDate, endDate)
midcapVal<-getEodIndexByDateRange(midcapIndex, startDate, endDate)

mncRet<-dailyReturn(mncVal$PX_CLOSE)
niftyRet<-dailyReturn(niftyVal$PX_CLOSE)
midcapRet<-dailyReturn(midcapVal$PX_CLOSE)

allRets<-na.omit(merge(mncRet, niftyRet, midcapRet))
names(allRets)<-c(mncIndex, nifyIndex, midcapIndex)

png(sprintf("%sMNC.returns.png", reportPath), width=1000, height=500)
par(family='Segoe UI')
charts.PerformanceSummary(allRets, wealth.index = TRUE, main=sprintf("%s @StockViz", paste(names(allRets), collapse=",")))
dev.off()

png(sprintf("%sMNC.drawdown.p2p.png", reportPath), width=1000, height=600)
par(family='Segoe UI')
chart.Drawdown(allRets, main=sprintf("Drawdowns %s @StockViz", paste(names(allRets), collapse=",")), legend.loc = 'bottomleft')
dev.off()

beginYr<-as.numeric(format(as.Date(first(index(allRets))), "%Y"))
endYr<-as.numeric(format(as.Date(last(index(allRets))), "%Y"))-1

annualReturns<-data.frame(YEAR=0, MNC=0.0, NIFTY=0.0, MIDCAP=0.0)
maxDD<-data.frame(YEAR=0, MNC=0.0, NIFTY=0.0, MIDCAP=0.0)
for(yr in beginYr:endYr){
	yrStr<-toString(yr)
	annualReturns<-rbind(annualReturns, c(yr, 100*Return.cumulative(allRets[yrStr, 1]), 100*Return.cumulative(allRets[yrStr, 2]), 100*Return.cumulative(allRets[yrStr, 3])))
	maxDD<-rbind(maxDD, c(yr, 100*maxDrawdown(allRets[yrStr, 1]), 100*maxDrawdown(allRets[yrStr, 2]), 100*maxDrawdown(allRets[yrStr, 3])))
}

annualReturns<-annualReturns[-1,]
maxDD<-maxDD[-1,]

write.csv(annualReturns, file=sprintf("%smnc.annualReturns.csv", reportPath), row.names=F)
write.csv(maxDD, file=sprintf("%smnc.maxDD.csv", reportPath), row.names=F)

### funds reinvest dividends whereas indices do not
### 'regular growth' funds prefered over indices

bslMncCode<-100064
bslMncName<-'Birla Sun Life MNC Fund'

bslMidcapCode<-101592
bslMidcapName<-'Birla Sun Life MIDCAP Fund'

bslVal<-getMfNavByDateRange(bslMncCode, startDate, endDate)
bslRet<-dailyReturn(bslVal)

bslVal2<-getMfNavByDateRange(bslMidcapCode, startDate, endDate)
bslRet2<-dailyReturn(bslVal2)

allRets<-na.omit(merge(bslRet, bslRet2))

names(allRets)<-c(bslMncName, bslMidcapName)


png(sprintf("%sMNC.vs.MIDCAP.fund.returns.png", reportPath), width=1000, height=500)
par(family='Segoe UI')
charts.PerformanceSummary(allRets, wealth.index = TRUE, main=sprintf("%s @StockViz", paste(names(allRets), collapse=",")))
dev.off()

png(sprintf("%sMNC.vs.MIDCAP.fund.drawdown.p2p.png", reportPath), width=1000, height=600)
par(family='Segoe UI')
chart.Drawdown(allRets, main=sprintf("Drawdowns %s @StockViz", paste(names(allRets), collapse=",")), legend.loc = 'bottomleft')
dev.off()