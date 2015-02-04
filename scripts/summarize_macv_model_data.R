library(plyr) # for ldply(), mapvalues()
library(dplyr) # for select(), arrange(), group_by(), filter() 


# turn file names into nice receptor names
macv = list("ccal_MACV_GP1_docking.fasc",
    		"mouse_5aa_MACV_GP1_docking.fasc",
    		"mouse_MACV_GP1_docking.fasc",
             "human_MACV_GP1_docking.fasc",
             "human_L212V_MACV_GP1_docking.fasc",
             "rat_MACV_GP1_docking.fasc",
             "rat_5aa_MACV_GP1_docking.fasc",
             "rat_9aa_MACV_GP1_docking.fasc")

macv.gp1 <- c("C.cal_MACV",
        	"mouse.5aa_MACV",
    		"mouse_MACV",
             "human_MACV",
             "human.L212V_MACV",
             "rat_MACV",
             "rat.5aa_MACV",
             "rat.9aa_MACV")
				
names(macv) <- macv.gp1

# get names of all files in current dir ending in docking.fasc 
setwd("../scorefiles/machupo/")
# read all files into one large table
all.data <- ldply(macv, read.table, .id='TfR1', header=T, stringsAsFactors=T)
setwd("../../scripts/")

# turn TfR1 column into factor, so we can group by receptors
all.data$TfR1 <- factor( all.data$TfR1 )
# pull human in front, otherwise order is alphabetical
all.data$TfR1 <- relevel(  all.data$TfR1, "human_MACV" )

# clean-up data, pick top hits, store in data frame "top.hits"
top.hits <-
    # select columns of interest
    select(all.data, TfR1, I_sc, total_score, rms) %>%
    # order them by TfR1 and interface score
    arrange( TfR1, I_sc ) %>%
    # group by TfR1
    group_by( TfR1 ) %>%
    # keep the first 10 entries in each group
    filter( row_number() <= 10 )

# summarize data by calculating mean, median, sd, best hit
summary.I_sc <-
    summarize( top.hits,
            mean=mean(I_sc),
            median=median(I_sc),
            sd=sd(I_sc),
            top=min(I_sc),
            mean.rms = mean(rms),
            sd.rms = sd(rms) )
write.csv(summary.I_sc, file = "../data/macv_summary_data.csv")
write.csv(top.hits, file = "../data/macv_top_hits.csv")
write.csv(all.data, file = "../data/macv_model_data.csv")
