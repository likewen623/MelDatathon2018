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
      menuItem("Widgets", tabName = "widgets", icon = icon("th")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th")),
      menuItem("Realtime Traffic", tabName = "RealtimeTraffic", icon = icon("dashboard")),
      menuItem("Source code", icon = icon("file-code-o"), 
               href = "https://github.com/rstudio/shinydashboard/")
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
              # fluidRow(
              #   
              #   # App title ----
              #   titlePanel("Melbourne Traffic"),
              #   
              #   # Sidebar layout with a input and output definitions ----
              #   sidebarLayout(
              #     
              #     
              #     # Sidebar panel for inputs ----
              #     sidebarPanel(
              #       
              #       # Input: Selector for choosing dataset ----
              #       selectInput(inputId = "weekday",
              #                   label = "Choose a day:",
              #                   choices = c("Mon", "Tues", "Wed", "Thur", "Fri")),
              #       
              #       # Input: Numeric entry for number of obs to view ----
              #       selectInput(inputId = "time",
              #                   label = "Choose a time:",
              #                   choices = c("0:00","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"))
              # 
              #     ),
              #     
              #     # Main panel for displaying outputs ----
              #     mainPanel(
              #       
              #       plotOutput(outputId = "p")
              #       
              #     )
              #   )
              # )##
      ),
      
      # Second tab content
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    )
  )
)

server <- function(input, output) {
  output$p <- renderPlot({
    data.path = 'D:/Desktop/MelbDatathon2018/'
    setwd(data.path)
    
    traffic <- read.csv('melbourne_vehicle_traffic.exact.csv')
    
    input_weekday = input$weekday
    #input_time = paste0(as.character(input$time) + ':00')
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
}

shinyApp(ui, server)