# source("https://bioconductor.org/biocLite.R")
# biocLite("EBImage")

library(hexSticker)

imgPath <- "data-raw/all-of-the-htmlwidgets.png"

sticker(imgPath, package="oidnChaRts", p_size=8, s_x=1, s_y=.75, s_width=.6,
        filename="data-raw/oidnChaRt-sticker.png")