data.path = 'D:/Desktop/MelbDatathon2018/'
setwd(data.path)

traffic <- read.csv('melbourne_vehicle_traffic.exact.csv')

names(traffic)



rose_weekday = data.frame('time'=NA, 'type'=NA, 'speed'=NA)
#input_weekday = 'Mon'

traffic_new = traffic[traffic$weekday == input_weekday,]
dataset = traffic_new

for (time in unique(dataset$time)){
  dataset_using = dataset[dataset$time == time,]
  new_row1 = c(time, 'min', round(min(dataset_using$mean_speed), 2))
  new_row3 = c(time, 'max', round(max(dataset_using$mean_speed), 2))
  rose_weekday = rbind(rose_weekday, new_row1)
  rose_weekday = rbind(rose_weekday, new_row3)
}

rose_weekday = rose_weekday[-1,]


library(ggplot2)
library(ggiraph)


gg_plot <- ggplot(rose_weekday, aes(x=time, y=speed, fill=type, tooltip = speed, data_id = speed))+ geom_bar(stat="identity")+
      geom_bar_interactive(stat="identity")+
      coord_polar()+
      scale_fill_brewer(palette="Blues")+
      theme_bw()+
      #theme(panel.grid =element_blank()) +   ## 删去网格线
      theme(axis.text.y = element_blank()) +   ## 删去刻度标签
      theme(axis.ticks = element_blank()) +   ## 删去刻度线
      theme(panel.border = element_blank())
      #theme(legend.position = "none")   ##隐藏所有图例
  
  
ggiraph(ggobj = gg_plot)




