library(shiny)
library(shinydashboard)
library(ggplot2)
library(ggiraph)



function(input, output) {
  traffic <- read.csv('melbourne_vehicle_traffic.exact.csv')
  
  output$p <- renderPlot({
    
    input_weekday = input$weekday
    input_time = input$time
    
    traffic_new = traffic[traffic$weekday == input_weekday & traffic$time == input_time,]
    dataset = traffic_new
    
    ggplot(dataset) + aes(x = lat, y = lon, color=mean_speed, tooltip = mean_speed, data_id = mean_speed) + 
      # geom_point_interactive() +
      geom_point(size=0.1, alpha = 0.2) +
      theme(panel.grid =element_blank()) +   
      theme(axis.text = element_blank()) +   
      theme(axis.ticks = element_blank()) +   
      theme(panel.border = element_blank())+
      theme(legend.position = "none")+   
      theme(axis.title = element_blank())+
      scale_color_gradient(low="darkblue", high="lightblue")
  })
  
  output$hours <- renderggiraph({
    input_weekday = input$hours_weekday
    rose_weekday = data.frame('time'=NA, 'type'=NA, 'speed'=NA)
    
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
    
    gg_plot <- ggplot(rose_weekday, aes(x=time, y=speed, fill=type, tooltip = speed, data_id = speed))+ #geom_bar(stat="identity")+
      geom_bar_interactive(stat="identity")+
      coord_polar()+
      scale_fill_brewer(palette="Blues")+
      theme_bw()+
      theme(axis.text.y = element_blank()) +   
      theme(axis.ticks = element_blank()) +   
      theme(panel.border = element_blank())
    # gg_plot
    
    ggiraph(code = print(gg_plot))
  })
  
  output$weekdays <- renderggiraph({
    input_time = input$weekdays_time
    rose_time = data.frame('weekday'=NA, 'type'=NA, 'speed'=NA)
    
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
      scale_fill_brewer(palette="Blues")+
      theme_bw()+
      theme(axis.text.y = element_blank()) +  
      theme(axis.ticks = element_blank()) +   
      theme(panel.border = element_blank())
    
    ggiraph(ggobj = gg_plot)
    
  })
}