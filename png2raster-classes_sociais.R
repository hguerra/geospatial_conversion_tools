##############################################################
####################SetEnvironment###########################
## data path
setwd("data")
# librarys
library(rgdal)
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
color.classe.a.red <- 1
color.classe.a.green <- 1
color.classe.a.blue <- 0
color.classe.b.red <- 1.0000000
color.classe.b.green <- 0.5098039
color.classe.b.blue <- 0.0000000
color.classe.c.red <- 1
color.classe.c.green <- 0
color.classe.c.blue <- 0
# Raster values
classe.a <- 3
classe.b <- 2
classe.c <- 1
# Raster/Image
img.filepath <- "ignore_data/INITIAL2010_REALDATA_100.PNG"
raster.name <- "int16_initial.tif"
raster.proj <-
  "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
#extent      : -45.48924, -45.25525, -23.745, -23.539(xmin, xmax, ymin, ymax)
raster.extent <- c(-45.48924,-45.25525,-23.745,-23.539)
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
    if(color.red == color.classe.c.red && color.green == color.classe.c.green && color.blue == color.classe.c.blue){
      raster.img[i, j] <- classe.c
    }else if(color.red == color.classe.b.red && color.green == color.classe.b.green && color.blue == color.classe.b.blue){
      raster.img[i, j] <- classe.b
    }else if(color.red == color.classe.a.red && color.green == color.classe.a.green && color.blue == color.classe.a.blue){
      raster.img[i, j] <- classe.a
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