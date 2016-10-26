source("../api/common.R")
source("../api/eod-api.R")

library('schoRsch')

nifty<-'NIFTY 50'

startDate<-as.Date('2011-01-01')
endDate<-as.Date('2016-09-30')

niftyVal<-getEodIndexByDateRange(nifty, startDate, endDate)

niftyGap<-na.omit(niftyVal$PX_OPEN/lag(niftyVal$PX_CLOSE)-1)
niftyGapMedianAbs<-median(abs(niftyGap))

png(sprintf("%snifty.GAP.density.png", reportPath), width=1000, height=500)
par(family='Segoe UI')
plot(density(100*niftyGap), main=sprintf("%s Daily Gap (%%) @StockViz", nifty))
mtext(side=3, text=sprintf("Median (abs): %.2f%%", 100*niftyGapMedianAbs))
dev.off()

openClose<-niftyVal$PX_CLOSE/niftyVal$PX_OPEN-1
closeClose<-dailyReturn(niftyVal$PX_CLOSE)
openCloseReturns<-Return.cumulative(openClose)
closeCloseReturns<-Return.cumulative(closeClose)
gapReturns<-Return.cumulative(niftyGap)

toPlot<-na.omit(merge(openClose, closeClose, niftyGap))
names(toPlot)<-c('Daily', 'B&H', 'Gap(C)')
png(sprintf("%snifty.OC.CC.GAP.png", reportPath), width=1000, height=500)
par(family='Segoe UI')
charts.PerformanceSummary(toPlot, wealth.index = TRUE, main="B&H vs. Daily vs. Gap Returns @StockViz")
dev.off()

table.Drawdowns(niftyGap, 20)

niftyGap2<-data.frame(DAY=index(niftyGap), RET=as.numeric(niftyGap), WEEKDAY=toupper(weekdays(index(niftyGap))))

monTs<-niftyGap2[niftyGap2$WEEKDAY=='MONDAY',]
tueTs<-niftyGap2[niftyGap2$WEEKDAY=='TUESDAY',]
wedTs<-niftyGap2[niftyGap2$WEEKDAY=='WEDNESDAY',]
thuTs<-niftyGap2[niftyGap2$WEEKDAY=='THURSDAY',]
friTs<-niftyGap2[niftyGap2$WEEKDAY=='FRIDAY',]

monRet<-Return.cumulative(monTs$RET)
tueRet<-Return.cumulative(tueTs$RET)
wedRet<-Return.cumulative(wedTs$RET)
thuRet<-Return.cumulative(thuTs$RET)
friRet<-Return.cumulative(friTs$RET)

monXts<-xts(monTs[,2], as.Date(monTs[,1]))
tueXts<-xts(tueTs[,2], as.Date(tueTs[,1]))
wedXts<-xts(wedTs[,2], as.Date(wedTs[,1]))
thuXts<-xts(thuTs[,2], as.Date(thuTs[,1]))
friXts<-xts(friTs[,2], as.Date(friTs[,1]))

toPlot<-merge(monXts, tueXts, wedXts, thuXts, friXts)
toPlot[is.na(toPlot[,1]),1]<-0
toPlot[is.na(toPlot[,2]),2]<-0
toPlot[is.na(toPlot[,3]),3]<-0
toPlot[is.na(toPlot[,4]),4]<-0
toPlot[is.na(toPlot[,5]),5]<-0
charts.PerformanceSummary(toPlot, wealth.index = TRUE, main="Day of Week Returns @StockViz")

table.Drawdowns(tueXts, 20)
table.Drawdowns(wedXts, 20)
table.Drawdowns(friXts, 20)

toPlot<-merge(tueXts,wedXts,friXts)
toPlot[is.na(toPlot[,1]),1]<-0
toPlot[is.na(toPlot[,2]),2]<-0
toPlot[is.na(toPlot[,3]),3]<-0
toPlot2<-toPlot[,1]+toPlot[,2]+toPlot[,3]
table.Drawdowns(toPlot2, 20)
charts.PerformanceSummary(toPlot2, wealth.index = TRUE, main="Day of Week Returns @StockViz")
