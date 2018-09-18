library(ggplot2)
library(magick)
library(here) # For making the script run without a wd
library(magrittr) # For piping the logo

# Make a simple plot and save it
ggplot(mpg, aes(displ, hwy, colour = class)) + 
  geom_point() + 
  ggtitle("Cars") +
  ggsave(filename = paste0(here("/"), last_plot()$labels$title, ".png"),
         width = 5, height = 4, dpi = 300)

# Call back the plot
plot <- image_read(paste0(here("/"), "Cars.png"))
# And bring in a logo
logo_raw <- image_read("http://hexb.in/hexagons/ggplot2.png") 

# Scale down the logo and give it a border and annotation
# This is the cool part because you can do a lot to the image/logo before adding it
logo <- logo_raw %>%
  image_scale("100") %>% 
  image_background("grey", flatten = TRUE) %>%
  image_border("grey", "600x10") %>%
  image_annotate("Powered By R", color = "white", size = 30, 
                 location = "+10+50", gravity = "northeast")

# Stack them on top of each other
final_plot <- image_append(image_scale(c(plot_raw, logo), "1500"), stack = TRUE)
# And overwrite the plot without a logo
image_write(final_plot, 'test.png')




plot_raw <- image_read('D:/Desktop/MD2018.scripts/Melbourne.v1.png')



p <- ggplot(iris) + aes(x = Sepal.Length, y = Sepal.Width, color=Species) + 
  geom_point(size=5) + theme_classic()


require(ggimage) 
img = "https://assets.bakker.com/ProductPics/560x676/10028-00-BAKI_20170109094316.jpg"
ggbackground(p, img)

img = 'D:/Desktop/MD2018.scripts/Melbourne.v1.png'
p1 = ggbackground(p, img) + ggtitle("ggbackground(p, img)")
p2 = ggbackground(p, img, alpha=.7) + ggtitle("ggbackground(p, img, alpha=.3)")
p3 = ggbackground(p, img, alpha=.7, color="steelblue") + ggtitle('ggbackground(p, img, alpha=.3, color="steelblue")')
library("cowplot")
cowplot::plot_grid(p1, p2, p3, ncol=1)







##### main
traffic <- read.csv("file:///D:/Desktop/MelbDatathon2018/car_speeds/melbourne_vehicle_traffic.csv")
head(traffic$mean_speed)
colnames(traffic)
typeof(traffic$mean_speed[[1]])
traffic$mean_speed[1]
traffic$mean_speed[1][1]
