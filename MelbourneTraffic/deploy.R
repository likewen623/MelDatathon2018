install.packages('rsconnect')
library(rsconnect)

data.path = 'D:/Desktop/MD2018.scripts/MelbourneTraffic'
setwd(data.path)


library(shiny)
runApp()

rsconnect::setAccountInfo(name='likewen623',
                          token='30D2CF3F8A6EAF5F94CB697593D62200',
                          secret='sOYVe9Cbh+UrHLx0RLUNBrSnWqt16b1IO46BA1UX')


library(rsconnect)
deployApp()