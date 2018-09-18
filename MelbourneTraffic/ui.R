library(shiny)
library(shinydashboard)
library(ggplot2)
library(ggiraph)


dashboardPage(
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