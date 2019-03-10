# UP-ZIPPING AND POOLING ALL DATA FOR PARTICULAR DATE

### GO INSIDE YOUR FOLDER WITH PARTICULAR DAY DATA SET (e.g. 2016-07-23)
### MAKE SURE NO UNGZIPPED FILES ARE THERE, IF THERE ARE THAN DELETE THEM, KEEP ONLY
### ARCHIVED FILES

setwd("C:/to_your_folder_with_x.tar.gz files")


# Unzip all files in a folder
# need gunzip function from R.utils package
# first install two dependencies via Tools/Install Packages
# R.oo (CRAN) - dependency for R.utils
# R.methodsS3 (CRAN) - - dependency for R.utils
# then via Tools/Install Packages
# install R.utils

#install.packages("https://cran.r-project.org/src/contrib/R.utils_2.4.0.tar.gz", repos=NULL)
# INSTAL R.UTILS via Tools->Install Packages
library(R.utils)

# read all names of compressed gz files
temp = list.files(pattern="*.gz")

# un-gz all files by lapply function. Replaced all gz files with uncompressed txt files

lapply(temp, function(x) gunzip(x))


# POOLING ALL TXT FILES INTO ONE ALL DATA DF
cdir<-choose.dir(default = "", caption = "Choose dir with data files")
myfiles <- list.files(path = cdir, pattern = NULL, all.files = FALSE, full.names = FALSE, recursive = FALSE, ignore.case = FALSE)



# pool all files into a big df. edit lapply() accordingly
all_data_df = do.call(rbind, lapply(myfiles, 
                                    function(x) 
                                      read.table(x, header=F, sep=",", quote='"', 
                                                 dec=".", na.strings="", colClasses="character", 
                                                 fill=TRUE, strip.white=TRUE, blank.lines.skip=TRUE, 
                                                 stringsAsFactors = FALSE)))

# choose new working directory and save data for all birds in it
setwd("Directory for all data")
write.csv(all_data_df, 'all_data_df.csv')