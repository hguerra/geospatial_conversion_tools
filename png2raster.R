##############################################################
####################SetEnvironment###########################
## data path
setwd("data")
# librarys
library(raster)
library(png)
##############################################################
#####################Variables################################
# Classe social
classe.a <- 3
classe.b <- 2
classe.c <- 1
color.red <- rgb(255, 0, 0, maxColorValue = 255)#C
color.orange <- rgb(255, 130, 0, maxColorValue = 255)#B
color.yellow <- rgb(255, 255, 0, maxColorValue = 255)#A
# Raster
img.filepath <- "INITIAL2010_REALDATA.PNG"
raster.name <- "raster-img4.tif"
raster.proj <-
  "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
raster.extent <- c(-58.82195,-58.58221,-23.74066,-23.5563)
##############################################################
#####################Engine###################################
if (!file.exists(img.filepath))
  return

img <- readPNG(img.filepath)
raster.img <- raster(nrow = nrow(img), ncol = ncol(img))

print("Iniciando...")
for (i in 1:nrow(img)) {
  for (j in 1:ncol(img)) {
    color.actual <- rgb(img[i, j, 1], img[i, j, 2], img[i, j, 3])
    if (color.actual == color.red) {
      raster.img[i, j] <- classe.c
    } else if (color.actual == color.orange) {
      raster.img[i, j] <- classe.b
    } else if (color.actual == color.yellow) {
      raster.img[i, j] <- classe.a
    } else{
      raster.img[i, j] <- NA
    }
  }
}# end loop
#################################################################
######################WriteRaster################################
extent(raster.img) <- raster.extent
crs(raster.img) <- raster.proj
writeRaster(raster.img,
            raster.name,
            format = 'GTiff',
            overwrite = TRUE)
print("Finalizado!")