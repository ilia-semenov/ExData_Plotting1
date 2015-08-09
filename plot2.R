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

#create plot 2 on screen device
plot(hpc$datetime, hpc$Global_active_power, type="l", 
     xlab="",ylab="Global Active Power (kilowatts)")

#save plot 2 as png
dev.copy(png,file='plot2.png',width=480,height=480,units="px")
dev.off()