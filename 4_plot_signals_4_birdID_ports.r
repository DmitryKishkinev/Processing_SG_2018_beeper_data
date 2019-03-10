# set working directory and read in data for particular bird ID and port
setwd()

# read in all data (needs for the full time span for this bird ID)
#ID_148778_all<-read.csv(file = "ID_148778_df_all_data.csv", header=TRUE, sep=",", 
#                       na.strings="", colClasses="character", 
#                       fill=TRUE, strip.white=TRUE, blank.lines.skip=TRUE, 
#                       stringsAsFactors = FALSE)
# delete the column "X"
#ID_148778_all$X<-NULL

# p2
ID_148778_p2<-read.csv(file = "ID_148778_p2.csv", header=TRUE, sep=",", 
                       na.strings="", colClasses="character", 
                       fill=TRUE, strip.white=TRUE, blank.lines.skip=TRUE, 
                       stringsAsFactors = FALSE)
# delete the column "X"
ID_148778_p2$X<-NULL

#p3
ID_148778_p3<-read.csv(file = "ID_148778_p3.csv", header=TRUE, sep=",", 
                       na.strings="", colClasses="character", 
                       fill=TRUE, strip.white=TRUE, blank.lines.skip=TRUE, 
                       stringsAsFactors = FALSE)
# delete the column "X"
ID_148778_p3$X<-NULL


#make sure all df are in an ascending order on timestamp and row names are from 1 increment 1
# all data for this ID
#ID_148778_all <- ID_148778_all[order(ID_148778_all$V2),]
#rownames(ID_148778_all) <- NULL
# p2
ID_148778_p2 <- ID_148778_p2[order(ID_148778_p2$V2),]
rownames(ID_148778_p2) <- NULL
# p3
ID_148778_p3 <- ID_148778_p3[order(ID_148778_p3$V2),]
rownames(ID_148778_p3) <- NULL


# padding [filling gaps] the time series with NAs by creating a new df spanning
# the whole day with NAs for each sec and merge the two dfs on one column
# make sure that you round time stamps and to whole (no) fractional) numbers

df2<-data.frame(V2=seq(from = as.POSIXct('2018-07-12 00:00:00', tz='Europe/Berlin'),
                             to = as.POSIXct('2018-07-12 23:59:59', tz='Europe/Berlin'), 
                              by = "sec"))

# convert your bird ID/port number df to Rybachy summetime time zone 
# which is 'Europe/Berlin' and add it as a separate column
# get rid of rows with rows with multiple hits during the same second
ID_148778_p2$V2 <- as.POSIXct(round(as.numeric(ID_148778_p2$V2), digits=0), tz='Europe/Berlin', 
                                 origin='1970-01-01 00:00:00')
uniq_ind_p2 <- !duplicated(ID_148778_p2$V2)
ID_148778_p2 <- ID_148778_p2[uniq_ind_p2, ]

ID_148778_p3$V2 <- as.POSIXct(round(as.numeric(ID_148778_p3$V2), digits=0), tz='Europe/Berlin', 
                                 origin='1970-01-01 00:00:00')
uniq_ind_p3 <- !duplicated(ID_148778_p3$V2)
ID_148778_p3 <- ID_148778_p3[uniq_ind_p3, ]

# merge the two df for NAs padding on DateTime column (make sure it exists)
ID_148778_p2_NApad <- merge(df2, ID_148778_p2, all=TRUE, by = "V2")
ID_148778_p3_NApad <- merge(df2, ID_148778_p3, all=TRUE, by = "V2")

# check that the two dfs are of equal length
length(ID_148778_p2_NApad) == length(ID_148778_p3_NApad)

# plot separate ports (antennas) for the entire day
# signal to noise ratio is absolute value, 2 decimal positions
ID_148778_p2_NApad$V6<-round(abs(as.numeric(ID_148778_p2_NApad$V6)), digits=2)
ID_148778_p3_NApad$V6<-round(abs(as.numeric(ID_148778_p3_NApad$V6)), digits=2)

# save df for this bird ID for particular port (antenna)
write.csv(ID_148778_p2_NApad, 'ID_148778_p2_padded.csv')
write.csv(ID_148778_p3_NApad, 'ID_148778_p3_padded.csv')


# plotting data by ports
# Time bin is 1 s (too small maybe, need to bin to 1 min but do not know how)
par(mfrow=c(2,1))

# determine range of min-max SNR  by plotting without set ylim=c() parameter
# and then normalize [make equal] ylim=c(0,20) parameter

# port 2
plot(ID_148778_p2_NApad$V2, ID_148778_p2_NApad$V6,
     main = 'port 2',
     xlab ="Time", 
     ylab="SNR", 
     xlim=as.POSIXct(c("2018-07-12 00:00:00","2018-07-12 23:59:59")),
     ylim=c(0,20))

# port 3
plot(ID_148778_p3_NApad$V2, ID_148778_p3_NApad$V6,
     main = 'port 3',
     xlab ="Time", 
     ylab="SNR", 
     xlim=as.POSIXct(c("2018-07-12 00:00:00","2018-07-12 23:59:59")),
     ylim=c(0,20))


# template for zoom in/out
plot(ID_148778_p2_NApad$V2, ID_148778_p2_NApad$V6,
     main = 'port 2',
     xlab ="Time", 
     ylab="SNR", 
     xlim=as.POSIXct(c("2018-07-12 20:00:00","2018-07-12 23:59:59")),
     ylim=c(0,20))

# port 3
plot(ID_148778_p3_NApad$V2, ID_148778_p3_NApad$V6,
     main = 'port 3',
     xlab ="Time", 
     ylab="SNR", 
     xlim=as.POSIXct(c("2018-07-12 20:00:00","2018-07-12 23:59:59")),
     ylim=c(0,20))

### inserting 1 min tick ####

x = ID_148778_p3_NApad$V2
y = ID_148778_p3_NApad$V6

plot(x, y, 
     ylim=c(0,20), 
     xlim=as.POSIXct(c("2018-07-12 21:00:00","2018-07-12 22:00:00")))

axis.POSIXct(side = 1, x = x,
             at = seq(from = round(x[1], "mins"),
                      to = x[1] + ceiling(difftime(tail(x, 1), head(x, 1), 
                                                   units = "mins")),
                      by = "1 min"), las = 2)
