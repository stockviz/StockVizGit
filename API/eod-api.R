#get a list of all indices with EOD prices
getEodIndices<-function(){
	indices<-sqlQuery(lcon, "select INDEX_NAME, min(time_stamp) START_DATE, max(time_stamp) END_DATE
							 from bhav_index group by index_name")

	indices$START_DATE<-as.Date(indices$START_DATE)
	indices$END_DATE<-as.Date(indices$END_DATE)
	return(indices)
}

#get time series of EOD index values
getEodIndexByDateRange<-function(indexName, startDate, endDate){
	indices<-getEodIndices()
	stopifnot(indexName %in% indices$INDEX_NAME, as.Date(startDate) >= min(indices$START_DATE), as.Date(endDate) <= max(indices$END_DATE))

	data<-sqlQuery(lcon, sprintf("select TIME_STAMP, PX_OPEN, PX_HIGH, PX_LOW, PX_CLOSE, TRD_QTY
								  FROM bhav_index WHERE INDEX_NAME='%s' 
								  and time_stamp >= '%s' and time_stamp <= '%s'", indexName, startDate, endDate))

	retXts<-xts(data[, -1], as.Date(data$TIME_STAMP))
	return(retXts)
}