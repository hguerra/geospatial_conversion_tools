##############################################################
####################SetEnvironment###########################
# librarys
library(raster)
library(png)
library(parallel) 
# Calculate the number of cores
no_cores <- detectCores() - 1
 
# Initiate cluster
cl <- makeCluster(no_cores)
registerDoParallel(cl)

#start time
strt<-Sys.time()
##############################################################
#####################Variables################################
# Classe social
classe.ocasional1 <- 1
classe.ocasional2 <- 2
classe.ocasional3 <- 3
classe.ocasional4 <- 4
classe.ocasional5 <- 5
color.ocasional1 <- rgb(255,204,255, maxColorValue = 255)
color.ocasional2 <- rgb(242,160,241, maxColorValue = 255)
color.ocasional3 <- rgb(230,117,228, maxColorValue = 255)
color.ocasional4 <- rgb(214,71,212, maxColorValue = 255)
color.ocasional5 <- rgb(199,0,199, maxColorValue = 255)
# Raster
img.filepath <- "USO_OCASIONAL_TEST.png"
raster.name <- "int16_uso_ocasional.tif"
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
    color.actual <- rgb(img[i, j, 1], img[i, j, 2], img[i, j, 3])
    if (color.actual == color.ocasional1) {
      raster.img[i, j] <- classe.ocasional1
    } else if (color.actual == color.ocasional2) {
      raster.img[i, j] <- classe.ocasional2
    } else if (color.actual == color.ocasional3) {
      raster.img[i, j] <- classe.ocasional3
    } else if (color.actual == color.ocasional4) {
      raster.img[i, j] <- classe.ocasional4
    }else if (color.actual == color.ocasional5) {
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
stopCluster(cl)
#end time
print(Sys.time()-strt) #Time difference of 44.30828 secs
#END