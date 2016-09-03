
#get internal index codes

getLiveIndexMapping<-function(){
	ret<-sqlQuery(lcon2, "select * from INDEX_MASTER")
	return(ret)
}

#get live index values
getLiveIndexByDateRange<-function(indexCode, startDate, endDate){
	stopifnot(is.numeric(indexCode), as.Date(startDate) < as.Date(endDate))

	sd<-as.numeric(as.POSIXct(startDate))
	ed<-as.numeric(as.POSIXct(endDate))

	data<-sqlQuery(lcon2, sprintf("select CUR_VAL, SERVER_TS from INDEX_LIVE_DX where sec_tok=%d 
									and CUR_VAL > 0
									and server_tick >= %d 
									and server_tick <= %d", indexCode, sd, ed))

	xtsData<-xts(data$CUR_VAL, order.by=as.POSIXct(data$SERVER_TS, format='%y-%m-%d %H:%M:%S'))
	return(xtsData)
}