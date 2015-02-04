library(plyr) # for ldply(), mapvalues()
library(dplyr) # for select(), arrange(), group_by(), filter() 
library(ggplot2) # ggplot()
library(grid) 
require(scales)

#summary.I_sc = read.table("../data/macv_summary_data.csv", sep = ",", header = T)
top.hits = read.table("../data/macv_top_hits.csv", sep = ",", header = T)

             
# Plot 1: box plots               
p1 <- ggplot( top.hits, aes( x=TfR1, y=I_sc ) ) +
        geom_boxplot() +
        ylab( "Interface score" ) +
        theme_classic() #+ 
        #coord_cartesian(ylim=c(-4.5, -10.5)) + 
    	#scale_y_reverse(breaks=seq(-5, -10, -1)) 
        
        
# show plot
#show(p2)
# save plot
ggsave("../figures/macv_boxplot.pdf", plot = p1, width = 12, height = 8)
