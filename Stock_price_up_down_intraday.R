library('quantmod')
library('xts')
library('TTR')
http://finance.yahoo.com/q/hp?s=WU&a=01&b=19&c=2010&d=01&e=19&f=2010&g=d



#intraday (15 mins delay)
f.get.google.intraday <- function(symbol, freq, period) {
  base.url <- 'http://www.google.com/finance/getprices?'
  options.url <- paste('i=', freq, '&p=', period, '&f=d,o,h,l,c,v&df=cpct&q=', symbol, sep = '')
  full.url <- paste(base.url, options.url, sep = '')
  
  data <- read.csv(full.url, skip = 7, header = FALSE, stringsAsFactors = FALSE)
  
  starting.times.idx <- which(substring(data$V1, 1, 1) == 'a')
  ending.seconds.idx <- c(starting.times.idx[-1] - 1, nrow(data))
  r.str.idx.use <- paste(starting.times.idx, ':', ending.seconds.idx, sep = '')
  
  starting.times <- as.numeric(substring(data[starting.times.idx, 1], 2))
  
  data[starting.times.idx, 1] <- 0
  clean.idx <- do.call(c, lapply(seq(1, length(r.str.idx.use)),
                                 function(i) {
                                   starting.times[i] + freq * as.numeric(data[eval(parse(text = r.str.idx.use[i])), 1])
                                 })
  )
  data.xts <- xts(data[,-1], as.POSIXct(clean.idx, origin = '1970-01-01', tz = 'GMT'))
  
  indexTZ(data.xts) <- 'America/New_York'
  colnames(data.xts) <- c('Open', 'High', 'Low', 'Close', 'Volume')
  
  data.xts
}

ticker <- 'SPY'
intra2 <- f.get.google.intraday(ticker, 720*5, '600d') # pris hver time
candleChart(intra2, multi.col = TRUE, theme = 'black')

# converting into data.
intra3 <- data.frame(date=index(intra2), coredata(intra2))

# minus 6 hours
intra3$date <- intra3$date-6*60*60

# assigning up & down 
out_price <- NULL
for (i in 2:nrow(intra3)){
  up_down=ifelse(intra3$Close[i-1]>intra3$Close[i],0,1)
  c <- data.frame(up_down)
  out_price <- rbind(out_price,c)
}

# final data.frame
final <- data.frame(Date=intra3$date[2:nrow(intra3)],Close_price=intra3$Close[2:nrow(intra3)],out_price)
