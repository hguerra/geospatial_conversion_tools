## data path
setwd("data")

# librarys
library(raster)
library(rgdal)

getShapefileInfo <- function(fileName){
  
  if(!file.exists(fileName))
    return;
  
  # Get the layer names
  
  fileLayers <- ogrListLayers(dsn = fileName)
  
  # Get the file information for the first layer
  
  fileInfo <- ogrInfo(dsn = fileName, fileLayers[1])
  fileInfo
  
  # Load the file for the first layer
  
  fileData <- readOGR(dsn = fileName, fileLayers[1])
  fileData
}

shp2raster <- function(fileName, extentValue){
  
  if(!file.exists(fileName))
    return;
  
  # Get the layer names
  fileLayers <- ogrListLayers(dsn = fileName)
  
  # read shapefile
  teow <- readOGR(dsn = fileName, fileLayers[1]) #layer = "vegtype_2000"
  
  ## Set up a raster "template" to use in rasterize()
  ext <-  extent (-74, -34.5, -34, 5)
  xy <- abs(apply(as.matrix(bbox(ext)), 1, diff))
  n <- 5
  r <- raster(ext, ncol=xy[1]*n, nrow=xy[2]*n)
  
  ## Rasterize the shapefile
  rr <-rasterize(teow, r)
  
  ## A couple of outputs
  plot(rr)
  
  #writes a tiff
  writeRaster(rr,"raster_from_shp.tif",format = 'GTiff', datatype='INT2U', overwrite=TRUE)
}

#
# RUN
#
void_main <- function(){
  #----------caragua--------------------------
  
  getShapefileInfo("ignore_data/urbano_caragua_coluna_classes2010/caragua_classes2010.shp")
  
  # -------- vegtype_2000----------------------
  
  #getShapefileInfo("vegtype_2000/vegtype_2000.shp")
  
  # Set up a raster "template" to use in rasterize()
  #extent      : -74, -34.5, -34, 5  (xmin, xmax, ymin, ymax)
  
  #extentValue <- c(-74, -34.5, -34, 5)
  #shp2raster("vegtype_2000/vegtype_2000.shp", extentValue)
}
void_main()
