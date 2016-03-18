##############################################################
####################SetEnvironment###########################
## data path
setwd("data")
# librarys
library(raster)
library(png)
#start time
strt<-Sys.time()
##############################################################
#####################Variables################################
# Colors
# Get color values:(col2rgb(color)/255)
# ex: 
# color.red <- rgb(255, 0, 0, maxColorValue = 255)
# rgb.red <- col2rgb(color.red)/255
#
# Color 1
color.ocasional1.red <- 1
color.ocasional1.green <- 0.8
color.ocasional1.blue <- 1
#
# Color 2
color.ocasional2.red <- 0.9490196
color.ocasional2.green <- 0.6274510
color.ocasional2.blue <- 0.9450980
#
# Color 3
color.ocasional3.red <- 0.9019608
color.ocasional3.green <- 0.4588235
color.ocasional3.blue <- 0.8941176
#
# Color 4
color.ocasional4.red <- 0.8392157
color.ocasional4.green <- 0.2784314
color.ocasional4.blue <- 0.8313725
#
# Color 5
color.ocasional5.red <-  0.7803922
color.ocasional5.green <- 0.0000000
color.ocasional5.blue <- 0.7803922
# Raster values
classe.ocasional1 <- 1
classe.ocasional2 <- 2
classe.ocasional3 <- 3
classe.ocasional4 <- 4
classe.ocasional5 <- 5
# Raster/Image
img.filepath <- "ignore_data/USO_OCASIONAL_200.PNG"
raster.name <- "int16_uso_ocasional-linux.tif"
raster.proj <-
  "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
#extent      : -45.48924, -45.25525, -23.745, -23.539(xmin, xmax, ymin, ymax)
raster.extent <- c(-45.48924, -45.25525, -23.745, -23.539)
##############################################################
#####################Engine###################################
if (!file.exists(img.filepath))
  return

img <- readPNG(img.filepath)
raster.img <- raster(nrow = nrow(img), ncol = ncol(img))

print("Iniciando...")
for (i in 1:nrow(img)) {
  for (j in 1:ncol(img)) {
  	color.red <- img[i, j, 1]
    color.green <- img[i, j, 2]
    color.blue <- img[i, j, 3]
    if(color.red == color.ocasional1.red && color.green == color.ocasional1.green && color.blue == color.ocasional1.blue){
      raster.img[i, j] <- classe.ocasional1
    }else if(color.red == color.ocasional2.red && color.green == color.ocasional2.green && color.blue == color.ocasional2.blue){
      raster.img[i, j] <- classe.ocasional2
    }else if(color.red == color.ocasional3.red && color.green == color.ocasional3.green && color.blue == color.ocasional3.blue){
      raster.img[i, j] <- classe.ocasional3
    }else if(color.red == color.ocasional4.red && color.green == color.ocasional4.green && color.blue == color.ocasional4.blue){
      raster.img[i, j] <- classe.ocasional4
    }else if(color.red == color.ocasional5.red && color.green == color.ocasional5.green && color.blue == color.ocasional5.blue){
      raster.img[i, j] <- classe.ocasional5
    }else{
      raster.img[i, j] <- NA
    }
  }
}# end loop
#################################################################
######################WriteRaster################################
extent(raster.img) <- raster.extent
crs(raster.img) <- raster.proj
writeRaster(
  raster.img,
  raster.name,
  format = 'GTiff',
  datatype = 'INT2U',
  overwrite = TRUE
)
print("Finalizado!")
#end time
print(Sys.time()-strt) # Time difference of 45.2793 secs
#END