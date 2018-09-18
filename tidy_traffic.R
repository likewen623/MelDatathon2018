##### main
traffic <- read.csv("file:///D:/Desktop/MelbDatathon2018/car_speeds/melbourne_vehicle_traffic.csv")

library(data.table)
library(ggplot2)
meanSpeed <- as.data.frame(tstrsplit(traffic$mean_speed,"\\,"))

names(meanSpeed) = paste0('a', c(1:120))

meanSpeed[,1] = sub(pattern = "\\[", replacement = "", meanSpeed[,1])
meanSpeed[,120] = sub(pattern = "\\]", replacement = "", meanSpeed[,120])


traffic_split = traffic[,2:3] # drop index
traffic_final = cbind(traffic_split, meanSpeed)


library(tidyr)
traffic_exact = gather(traffic_final, label, mean_speed, a1:a120) # generate support column label, and value column mean_speed

# colnames(traffic_final)
# colnames(traffic_exact)

weekday <- function(label){ # calculate days
  temp <- sub(pattern = "a", replacement = "", label)
  temp <- as.integer(temp)
  ifelse(temp < 25, 'Mon', ifelse(temp < 49, 'Tues', ifelse(temp < 73, 'Wed', ifelse(temp < 97, 'Thur', 'Fri'))))
}

time <- function(label){ # calculate hours
  temp <- sub(pattern = "a", replacement = "", label)
  temp <- as.integer(temp)
  temp <- temp %% 24
  ifelse(temp != 0, paste0(temp-1, ':00'), '23:00')
}


traffic_exact$weekday = weekday(traffic_exact$label)
traffic_exact$time = time(traffic_exact$label)

traffic_exact$label <- NULL # delete support column label

head(traffic_exact) # have a glace

### output
data.path = 'D:/Desktop/MelbDatathon2018/'
setwd(data.path)

write.csv(traffic_exact, 'melbourne_vehicle_traffic.exact.csv', row.names = FALSE)


### Further analysis

### 1. Remove -1
traffic_exact$mean_speed = as.numeric(traffic_exact$mean_speed)
traffic_exact = traffic_exact[traffic_exact$mean_speed != -1,]
min(traffic_exact$mean_speed) # for check

write.csv(traffic_exact, 'melbourne_vehicle_traffic.exact.csv', row.names = FALSE)


### 2. 




### Plot1
traffic <- read.csv('melbourne_vehicle_traffic.exact.csv')
dataset = traffic_new
p <- ggplot(dataset) + aes(x = lat, y = lon, color=mean_speed) + 
  geom_point(size=1, alpha = 0.4) +
  theme(panel.grid =element_blank()) +   ## 删去网格线
  theme(axis.text = element_blank()) +   ## 删去刻度标签
  theme(axis.ticks = element_blank()) +   ## 删去刻度线
  theme(panel.border = element_blank())+
  theme(legend.position = "none")+   ##隐藏所有图例
  theme(axis.title = element_blank())+
  scale_color_gradient(low="darkblue", high="lightblue")
  #theme_bw()
p

### Add requirements
input_weekday = 'Mon'
input_time = '9:00'

traffic_new = traffic[traffic$weekday == input_weekday & traffic$time == input_time,]



interactive_points_grob(x = traffic_new$lat, y = traffic_new$lon,
                        tooltip = NULL, onclick = NULL, data_id = NULL, pch = 1,
                        size = unit(1, "char"), default.units = "native", name = NULL,
                        vp = NULL)

#### interactive plot
gg_plot = ggplot(traffic_new) + aes(x = lat, y = lon, color=mean_speed, tooltip = mean_speed, data_id = mean_speed) + 
  geom_point_interactive() +
  geom_point(size=0.1, alpha = 0.2) +
  theme(panel.grid =element_blank()) +   ## 删去网格线
  theme(axis.text = element_blank()) +   ## 删去刻度标签
  theme(axis.ticks = element_blank()) +   ## 删去刻度线
  theme(panel.border = element_blank())+
  theme(legend.position = "none")+   ##隐藏所有图例
  theme(axis.title = element_blank())+
  scale_color_gradient(low="darkblue", high="lightblue")


ggiraph(ggobj = gg_plot)



### Plot2 interactive
data.path = 'D:/Desktop/MelbDatathon2018/'
setwd(data.path)

traffic <- read.csv('melbourne_vehicle_traffic.exact.csv')

names(traffic)



rose_weekday = data.frame('time'=NA, 'type'=NA, 'speed'=NA)
input_weekday = 'Mon'

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


# g <- ggplot(mpg, aes( x = class, tooltip = class,
#                       data_id = class ) ) +
#   geom_bar_interactive()
# ggiraph(code = print(g))


rose_time = data.frame('weekday'=NA, 'type'=NA, 'speed'=NA)
input_time = '10:00'

traffic_new = traffic[traffic$time == input_time,]
dataset = traffic_new

for (weekday in unique(dataset$weekday)){
  dataset_using = dataset[dataset$weekday == weekday,]
  new_row1 = c(weekday, 'min', round(min(dataset_using$mean_speed), 2))
  new_row3 = c(weekday, 'max', round(max(dataset_using$mean_speed), 2))
  rose_time = rbind(rose_time, new_row1)
  rose_time = rbind(rose_time, new_row3)  
}

rose_time = rose_time[-1,]


gg_plot <- ggplot(rose_time, aes(x=weekday, y=speed, fill=type, tooltip = speed, data_id = speed))+ geom_bar(stat="identity")+
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


