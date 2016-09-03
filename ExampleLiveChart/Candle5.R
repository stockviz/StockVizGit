source("../api/common.R")
source("../api/live-api.R")

fromDt<-as.Date('2016-08-29')
toDt<-as.Date('2016-09-03')
liveTs<-getLiveIndexByDateRange(0, fromDt, toDt)
xtsData1<-to.period(liveTs, 'minutes', 5)

labInd<-round(seq(from=1, to=length(xtsData1[,1]), length.out=20),0)
png(sprintf("%s%s.%s.png", reportPath, "NIFTY", fromDt), bg="transparent", width=1000, height=600)
par(family='Segoe UI')
plot(xtsData1, type='candles', las=2, xaxt='n',
	main=sprintf("%s %s @StockViz", "NIFTY", toupper(format(fromDt, format="%Y-%b-%d"))))
axis(1, at=index(xtsData1)[labInd], label=format(index(xtsData1)[labInd], format="%H:%M"), las=2)
dev.off()