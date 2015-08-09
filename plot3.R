library(data.table)

#download and unzip data file
dataUrl_zip<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(dataUrl_zip,destfile=".\\household_power_consumption.zip")
unzip("household_power_consumption.zip")
hpc_data<-fread("household_power_consumption.txt",sep=";")


#get only subset for two days of interest
hpc<-hpc_data[Date %in% c("1/2/2007","2/2/2007"),]

#replace '?' for NA
qm.replace = function(dt) {
        for (i in names(dt))
                dt[get(i)=='?',i:=NA,with=FALSE]
}
qm.replace(hpc)

#create datetime column in Posix format
hpc[, datetime:=paste(Date,Time)]
hpc<-as.data.frame(hpc)
hpc$datetime<-strptime(hpc$datetime,'%d/%m/%Y %H:%M:%S')
for (i in 3:9) {
        hpc[,i]<-as.numeric(hpc[,i])
}

#create plot 3 and write directly to png (to avoid legend truncation)
png(file='plot3.png',width=480,height=480,units="px")

plot(hpc$datetime, hpc$Sub_metering_1, type="l", 
     xlab="",ylab="Energy sub metering")
lines(hpc$datetime,hpc$Sub_metering_2, col='red')
lines(hpc$datetime,hpc$Sub_metering_3, col='blue')
legend("topright", c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
       col=c('black','red','blue'),lty=c(1,1,1))

dev.off()
