source("../api/common.R")
source("../api/eod-api.R")

niftyTR<-'NIFTY 50 TR'
nifty<-'NIFTY 50'

startDate<-as.Date('2000-01-01')
endDate<-as.Date('2016-08-31')

niftyTRVal<-getEodIndexByDateRange(niftyTR, startDate, endDate)
niftyVal<-getEodIndexByDateRange(nifty, startDate, endDate)

niftyTRRet<-dailyReturn(niftyTRVal$PX_CLOSE)
niftyRet<-dailyReturn(niftyVal$PX_CLOSE)

allRets<-na.omit(merge(niftyTRRet, niftyRet))
names(allRets)<-c(niftyTR, nifty)

png(sprintf("%snifty.TR.returns.png", reportPath), width=1000, height=500)
par(family='Segoe UI')
charts.PerformanceSummary(allRets, wealth.index = TRUE, main=sprintf("%s @StockViz", paste(names(allRets), collapse=",")))
dev.off()

niftyTRCumRet<-Return.cumulative(niftyTRRet)
niftyCumRet<-Return.cumulative(niftyRet)

niftyTRAnnReturns<-annualReturn(niftyTRVal$PX_CLOSE)
niftyAnnReturns<-annualReturn(niftyVal$PX_CLOSE)

annualReturnDiff<-100*(niftyTRAnnReturns-niftyAnnReturns)

png(sprintf("%snifty.Dividend.returns.png", reportPath), width=1000, height=500)
par(family='Segoe UI', las=2, mar=c(7, 4, 4, 4))
barplot(annualReturnDiff['/2015'], main=sprintf("Dividend (%%) %s @StockViz", paste(names(allRets), collapse="/")))
par(las=1)
mtext(sprintf("Avg: %.2f; Median: %.2f", mean(annualReturnDiff['/2015']), median(annualReturnDiff['/2015'])), side=3)
dev.off()