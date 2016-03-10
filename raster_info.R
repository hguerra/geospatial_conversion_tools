## data path
setwd("data")
# librarys
library(raster)
library(rgdal)

#--------------------shapefile---------------------------
#shp.name <- "classes_sociais_2010/caragua_classes2010.shp"
shp.name <- "classes_sociais_2010/regions.shp"

if(!file.exists(shp.name))
  return;
# Get the layer names
shp.layers <- ogrListLayers(dsn = shp.name)
# Load the file for the first layer
shp.data <- readOGR(dsn = shp.name, shp.layers[1])
shp.extent <- extent(shp.data)
#--------------------raster---------------------------
raster.name <- "classes_sociais_2010/editar.tif"

if(!file.exists(raster.name))
  return;

rs <- raster(raster.name)
rs.extent.old <- extent(rs)

extent(rs) <- shp.extent
rs.extent.new <- extent(rs)

rs.extent.old
rs.extent.new

#---------------------write---------------------------
#extent      : -45.48924, -45.25525, -23.745, -23.539(xmin, xmax, ymin, ymax)
raster.extent <- c(-45.48924, -45.25525, -23.745, -23.539)
extent(rs) <- raster.extent
writeRaster(rs,
            "classes_sociais_2010/caragua_classes2010_regioes.tif",
            format = 'GTiff',
            overwrite = TRUE)

