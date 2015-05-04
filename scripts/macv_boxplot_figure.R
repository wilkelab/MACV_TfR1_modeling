library(plyr) # for mapvalues()
library(dplyr) # for join() 
library(ggplot2) # ggplot()

#summary.I_sc = read.table("../data/macv_summary_data.csv", sep = ",", header = T)
top.hits <- read.table("../data/macv_top_hits.csv", sep = ",", header = T)

TfR1_names <- c("C. callosus", "Human", "Human L212V", "Mouse", "Mouse-Hum", "Rat", "Rat-Short", "Rat-Long")

infection_data <- data.frame(TfR1 = TfR1_names, infects = factor(c("yes", "yes", "partially", "no", "yes", "no", "partially", "yes")))

top.hits$TfR1 <- mapvalues( top.hits$TfR1, from=c("C.cal_MACV", "human_MACV", "human.L212V_MACV", "mouse_MACV", "mouse.human_MACV", "rat_MACV", "rat.short_MACV", "rat.long_MACV"), to=TfR1_names)    

top.hits$TfR1 <- factor( top.hits$TfR1, levels=c("Human", "Human L212V", "Mouse", "Mouse-Hum", "Rat", "Rat-Short", "Rat-Long", "C. callosus"))


top.hits <- join(top.hits, infection_data)

# Plot 1: box plots               
p1 <- ggplot(top.hits, aes(x=TfR1, y=I_sc, color=infects)) +
        geom_boxplot() +
        ylab( "Interface score" ) +
        theme_classic() +
        scale_colour_manual(values = c("yes" = "forestgreen", "no" = "tomato3", "partially" = "tan2")) +
        guides(color = guide_legend("MACV infects")) + 
        theme(axis.title.x = element_text(face="bold"),
              axis.text.x = element_text(face="bold"),
              axis.title.y = element_text(face="bold"),
              axis.text.y = element_text(face="bold"))
        
        
# show plot
show(p1)
# save plot
ggsave("../figures/macv_boxplot.pdf", plot = p1, width = 9, height = 3, useDingbats=F)
