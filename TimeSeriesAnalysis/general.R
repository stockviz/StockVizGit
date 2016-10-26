source("../api/common.R")
source("../api/eod-api.R")

#########################################################################
#sample data
fromDt<-as.Date('2015-01-01')
toDt<-as.Date('2016-01-01')

eod<-getEodIndexByDateRange("NIFTY 50", fromDt, toDt)
write.csv(data.frame(eod), file=sprintf("%sNIFTY50.csv", reportPath))

#########################################################################