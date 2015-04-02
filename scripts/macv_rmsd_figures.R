require(plyr) # for mapvalues()
require(dplyr) # for filter() 
require(ggplot2) # ggplot()

macv.summary.I_sc = read.table("../data/macv_summary_data.csv", sep = ",", header = T)
macv.data  = read.table("../data/macv_model_data.csv", sep = ",", header = T)

TfR1_names <- c("C. callosus", "Human", "Human L212V", "Mouse", "Mouse-Hum", "Rat", "Rat-Short", "Rat-Long")

infection_data <- data.frame(TfR1 = TfR1_names, infects = factor(c("yes", "yes", "no", "no", "yes", "no", "partially", "yes")))

macv.data$TfR1 <- mapvalues( macv.data$TfR1, from=c("C.cal_MACV", "human_MACV", "human.L212V_MACV", "mouse_MACV", "mouse.5aa_MACV", "rat_MACV", "rat.5aa_MACV", "rat.9aa_MACV"), to=TfR1_names)    

macv.data$TfR1 <- factor( macv.data$TfR1, levels=c("Human", "Human L212V", "Mouse", "Mouse-Hum", "Rat", "Rat-Short", "Rat-Long", "C. callosus"))

macv.data <- join(macv.data, infection_data)

macv.data.reduced <- filter(macv.data, TfR1 %in% c("Human", "Human L212V", "Rat", "Rat-Long"))


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
	xlab("RMSD") + 
	theme_bw() +
	facet_wrap(~TfR1, ncol = 4) +
	theme(axis.title.x = element_text(face="bold"),
              axis.text.x = element_text(face="bold"),
              axis.title.y = element_text(face="bold"),
              axis.text.y = element_text(face="bold"))
#show(p2) 
ggsave("../figures/MACV_Funnels.pdf", plot = p2, width=9, height=4.5, useDingbats=F)

p3 = ggplot()+
	geom_point(macv.data.reduced, mapping = aes(x = rms, y = I_sc), size = 0.5)  +
	xlim(0, 40) + #These are warnings because some points are outside this range
	ylab("Interface score")+ 
	xlab("RMSD") + 
	theme_bw() +
	facet_wrap(~TfR1, ncol = 4) +
	theme(axis.title.x = element_text(face="bold"),
              axis.text.x = element_text(face="bold"),
              axis.title.y = element_text(face="bold"),
              axis.text.y = element_text(face="bold"))
show(p3) 
ggsave("../figures/MACV_Funnels_reduced.pdf", plot = p3, width=9, height=2.5, useDingbats=F)
