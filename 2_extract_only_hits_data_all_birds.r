# set working directory and read in all data
setwd()

all_data_df<-read.csv(file = "all_data_df.csv", header=TRUE, sep=",", 
                      na.strings="", colClasses="character", 
                      fill=TRUE, strip.white=TRUE, blank.lines.skip=TRUE, 
                      stringsAsFactors = FALSE)
# delete the column "X"
all_data_df$X<-NULL

# sorting in an asceding order by V2 column (time stamp)
ordered_all_df<-all_data_df[order(all_data_df$V2),]

# HERE NEED TO RENAME ALL ROWS. SIMPLY DELETING OLD ROWNAMES WILL DO THE JOB (AUTOMATIC RENAMING)
rownames(ordered_all_df) <- NULL


# go over rows using  FOR LOOP, always renew current radio frequency value unless a row
# starts with "p" (a row with radio tag data). in this case add the freq value to offset
# V3 (offset) is now substituted with real frequency in kHz

len=length(ordered_all_df$V1)

for (i in 1:len){
  if(grepl("S", ordered_all_df$V1[i])){current_freq=ordered_all_df$V5[i]}
  if(grepl("p", ordered_all_df$V1[i])){ordered_all_df$V3[i]=as.numeric(ordered_all_df$V3[i])+as.numeric(gsub('.','',current_freq, fixed=TRUE))}
}

# FINDING INDEXES OF ROWS WITH V1 column containing "p" (port, rows with radio hits)
# discard all rows but starting with "p"
ind_rows = which(grepl("p", ordered_all_df$V1))
df_only_hits<-ordered_all_df[ind_rows, ]

# HERE NEED TO RENAME ALL ROWS. SIMPLY DELETING OLD ROWNAMES WILL DO THE JOB (AUTOMATIC RENAMING)
rownames(df_only_hits) <- NULL

# add a column with SNR (is it just addition of signal and noise bc they are in dB?)
df_only_hits$V6=(abs(as.numeric(df_only_hits$V4)) - abs(as.numeric(df_only_hits$V5)))

# change working directory and save df_only_hits
setwd()
write.csv(df_only_hits, 'df_only_hits.csv')