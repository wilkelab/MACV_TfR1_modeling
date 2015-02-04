suppressMessages(library(plyr)) # for ldply(), mapvalues()
suppressMessages(library(dplyr)) # for select(), arrange(), group_by(), filter() 
suppressMessages(library(ggplot2)) # ggplot()

macv.summary.I_sc = read.table("../data/macv_summary_data.csv", sep = ",", header = T)
macv.top.hits = read.table("../data/macv_top_hits.csv", sep = ",", header = T)
macv.data  = read.table("../data/macv_model_data.csv", sep = ",", header = T)

#Plot 1: Plot means 
p1  = ggplot(macv.summary.I_sc, aes(x = -mean, y = sd.rms)) + 
	geom_point() +
	xlab("-(Mean Interface score)") +
	ylab("Standard Deviation of RMS for Top 100 Models") + 
	theme_classic()
ggsave("../figures/macv_rmsd_sd.pdf", plot = p1)

#Plot Funnels
p2 = ggplot()+
	geom_point(macv.data, mapping = aes(x = rms, y = I_sc), size = 0.5)  +
	xlim(0, 40) + #These are warnings because some points are outside this range
	ylab("Interface score")+ 
	xlab("RMS") + 
	theme_classic() +
	facet_wrap(~TfR1, ncol = 4) 
ggsave("../figures/macv_funnels.pdf", plot = p2)

