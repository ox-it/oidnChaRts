# source("https://bioconductor.org/biocLite.R")
# biocLite("EBImage")

library(hexSticker)
## Please note the "all of the meme" is inspired by the work of "Hyperbole and a Half" here: http://hyperboleandahalf.blogspot.com/2010/06/this-is-why-ill-never-be-adult.html
imgPath <- "data-raw/all-of-the-htmlwidgets.png"

sticker(imgPath, package="oidnChaRts", p_size=8, s_x=1, s_y=.75, s_width=.6,
        filename="data-raw/oidnChaRt-sticker.png")