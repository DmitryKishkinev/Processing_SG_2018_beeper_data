# set working directory and read in data for only radio hits for all birds
setwd()

df_only_hits<-read.csv(file = "df_only_hits.csv", header=TRUE, sep=",", 
                      na.strings="", colClasses="character", 
                      fill=TRUE, strip.white=TRUE, blank.lines.skip=TRUE, 
                      stringsAsFactors = FALSE)
# delete the column "X"
df_only_hits$X<-NULL

# plot histograms with diff bins to see "real tags distributions"
# parameter "breaks" determine bin size (on historgram bins may vary to fit to a window space)

# start with broad band covering all radio tags
# then zoom in into particular bumps (individual distributions)
# manipulate xlim(). make sure freq as numerical

# all tags
hist(as.numeric(df_only_hits$V3), 
     main="Histogram for Radio Hits", 
     xlab="Radio Frequency", 
     ylab="Frequency of Hit Occurence",
     border="blue", 
     col="green",
     xlim=c(148000,150000),
     las=1, 
     breaks=100000)

# zoom into a tag distribution
hist(as.numeric(df_only_hits$V3), 
     main="Histogram for Radio Hits", 
     xlab="Radio Frequency", 
     ylab="Frequency of Hit Occurence",
     border="blue", 
     col="green",
     xlim=c(149620,149660),
     las=1, 
     breaks=100000)

# as a result determine bands for specific tag IDs
# eg
# ID 148778 -> 148765-148785 kHz
# ID 149199 -> 149195-149220 kHz
# ID 149901 -> 149885-149910 kHz

# add columns for tag IDs using freq bands
df_only_hits$V3<-as.numeric(df_only_hits$V3)

len=length(df_only_hits$V1)

for (i in 1:len){
  if(df_only_hits$V3[i] > 148765 && df_only_hits$V3[i] < 148785){df_only_hits$V7[i]=as.numeric(148778)}
  if(df_only_hits$V3[i] > 149195 && df_only_hits$V3[i] < 149220){df_only_hits$V7[i]=as.numeric(149199)}
  if(df_only_hits$V3[i] > 149885 && df_only_hits$V3[i] < 149910){df_only_hits$V7[i]=as.numeric(149901)}
}


# subset df for particular bird IDs
# by creating a mask for subsetting

ID_148778_ind <- which(df_only_hits$V7==148778)
ID_148778_df <- df_only_hits[ID_148778_ind, ]
rownames(ID_148778_df) <- NULL

# set directory and save df for particular bird ID
setwd()
write.csv(ID_148778_df, 'ID_148778_df_all_data.csv')

# subset df for a particular bird's antenna
# by creating a mask for subsetting

# Port (antenna) 2
ID_148778_ind_p2 <- which(ID_148778_df$V1=="p2")
ID_148778_df_p2 <- ID_148778_df[ID_148778_ind_p2, ]
# Port (antenna) 3
ID_148778_ind_p3 <- which(ID_148778_df$V1=="p3")
ID_148778_df_p3 <- ID_148778_df[ID_148778_ind_p3, ]

# save df for this bird ID for particular port (antenna)
write.csv(ID_148778_df_p2, 'ID_148778_p2.csv')
write.csv(ID_148778_df_p3, 'ID_148778_p3.csv')
