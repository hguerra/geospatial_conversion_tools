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
classe.a <- 3
classe.b <- 2
classe.c <- 1
color.red <- rgb(255, 0, 0, maxColorValue = 255)#C
color.orange <- rgb(255, 130, 0, maxColorValue = 255)#B
color.yellow <- rgb(255, 255, 0, maxColorValue = 255)#A
# Raster
img.filepath <- "SIMULACAO2025_BASELINE.png"
raster.name <- "int16_simulacao2025_baseline.tif"
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