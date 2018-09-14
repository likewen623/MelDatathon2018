
library(ggplot2)
library(ggiraph)
library(shiny)

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Melbourne Traffic"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "weekday",
                  label = "Choose a day:",
                  choices = c("Mon", "Tues", "Wed", "Thur", "Fri")),
      
      # Input: Numeric entry for number of obs to view ----
      selectInput(inputId = "time",
                   label = "Choose a time:",
                   choices = c("0:00","1:00","2:00","3:00","4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"))
                   # value = 10,
                   # min = 0,
                   # max = 24)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      plotOutput(outputId = "p")
      
    )
  )
)

# Define server logic to summarize and view selected dataset ----
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
    
    
   # ggiraph(ggobj = gg_plot)
  })
}

# Create Shiny app ----
### output

shinyApp(ui = ui, server = server)
