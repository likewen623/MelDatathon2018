## app.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)
library(ggiraph)

ui <- dashboardPage(
  dashboardHeader(title = "Melbourne Traffic",
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "Category",
                                 message = "Data2App category"
                               ),
                               messageItem(
                                 from = "Team",
                                 message = "A student only team @Monash",
                                 icon = icon("american-sign-language-interpreting"),
                                 time = "likewen623"
                               ),
                               messageItem(
                                 from = "Modified",
                                 message = "Last modified time",
                                 icon = icon("archive"),
                                 time = "2018-09-16"
                               )
                  )
  
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Hours Comparison", tabName = "HoursComparison", icon = icon("hourglass-end")),
      menuItem("Weekdays Analysis", tabName = "WeekdaysAnalysis", icon = icon("calendar")),
      menuItem("Realtime Traffic", tabName = "RealtimeTraffic", icon = icon("dashboard")),
      menuItem("Source code", icon = icon("file-code-o"), href = "https://github.com/likewen623/MelDatathon2018/")
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "RealtimeTraffic",
              fluidRow(
                box(title = 'Please select time and day:',
                    background = 'light-blue',
                    selectInput(inputId = "weekday",
                                label = "Choose a day:",
                                choices = c("Mon", "Tues", "Wed", "Thur", "Fri")),

                        # Input: Numeric entry for number of obs to view ----
                    selectInput(inputId = "time",
                                label = "Choose a time:",
                                choices = c("0:00","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"))
                  ),
                box(title = "Traffic status", background = "light-blue", solidHeader = TRUE,
                      plotOutput("p", height = 550, width = 550))
                
              )
      ),
      tabItem(tabName = "HoursComparison",
              fluidRow(
                box(title = 'Please select weekday:',
                    background = 'light-blue',
                    selectInput(inputId = "hours_weekday",
                                label = "Choose a day:",
                                choices = c("Mon", "Tues", "Wed", "Thur", "Fri"))
                    ),
                box(title = "Hours Comparison", ggiraphOutput("hours", height = 550, width = 550))
                
              )
      
      ),
      # Second tab content
      tabItem(tabName = "WeekdaysAnalysis",
              fluidRow(
                box(title = 'Please select time:',
                    background = 'light-blue',
                    selectInput(inputId = "weekdays_time",
                                label = "Choose a time:",
                                choices = c("0:00","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"))
                ),
                box(title = "Weekdays Analysis", background = "light-blue", solidHeader = TRUE,
                    ggiraphOutput("weekdays", height = 550, width = 850))
                
              )
              
      )
    )
  )
)

server <- function(input, output) {
  data.path = 'D:/Desktop/MelbDatathon2018/'
  setwd(data.path)
  traffic <- read.csv('melbourne_vehicle_traffic.exact.csv')
  
  output$p <- renderPlot({
    
    input_weekday = input$weekday
    input_time = input$time
    
    traffic_new = traffic[traffic$weekday == input_weekday & traffic$time == input_time,]
    dataset = traffic_new
    
    ggplot(dataset) + aes(x = lat, y = lon, color=mean_speed, tooltip = mean_speed, data_id = mean_speed) + 
      # geom_point_interactive() +
      geom_point(size=0.1, alpha = 0.2) +
      theme(panel.grid =element_blank()) +   ## 删去网格线
      theme(axis.text = element_blank()) +   ## 删去刻度标签
      theme(axis.ticks = element_blank()) +   ## 删去刻度线
      theme(panel.border = element_blank())+
      theme(legend.position = "none")+   ##隐藏所有图例
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
      theme(axis.text.y = element_blank()) +   ## 删去刻度标签
      theme(axis.ticks = element_blank()) +   ## 删去刻度线
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
      theme(axis.text.y = element_blank()) +   ## 删去刻度标签
      theme(axis.ticks = element_blank()) +   ## 删去刻度线
      theme(panel.border = element_blank())
    
    ggiraph(ggobj = gg_plot)
    
  })
}

shinyApp(ui, server)