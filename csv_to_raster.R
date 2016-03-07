# Use 'read.table' to read the file.
# Use 'SpatialPixelsDataFrame' to convert it to a sp object.
# Plot this SpatialPixelsDataFrame.
# Use 'raster' to convert the SpatialPixelsDataFrame to a RasterLayer.
# Assign a projection.
# Plot the Koeppen-Geiger map.
# Write the RasterLayer with 'writeRaster'.


## data path
setwd("data")
# librarys
require(ncdf)
require(raster)
require(rgdal)

## ----read-csv------------------------------------------------------------

#Read the .csv file

#plot.locations_caragua <- read.csv("caragua.csv",stringsAsFactors = FALSE)
plot.locations_caragua <- read.table("Koeppen-Geiger-ASCII.txt", header=TRUE)

#look at the data structure
str(plot.locations_caragua)

## ----find-coordinates----------------------------------------------------

#view column names
names(plot.locations_caragua)

## ----check-out-coordinates-----------------------------------------------
#view first 6 rows of the X and Y columns
head(plot.locations_caragua$easting)
head(plot.locations_caragua$northing)

#Note that  you can also call the same two columns using their COLUMN NUMBER
#view first 6 rows of the X and Y columns
head(plot.locations_caragua[,1])
head(plot.locations_caragua[,2])

## ----view-CRS-info-------------------------------------------------------
#view first 6 rows of the X and Y columns
head(plot.locations_caragua$geodeticDa)
head(plot.locations_caragua$utmZone)


## ----CRS-----------------------------------------------------------------

wgs84 <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")

## ----convert-sp-object-----------------------------------------------
#note that the easting and northing columns are in columns 1 and 2
plot.locationsSp_caragua <- SpatialPointsDataFrame(plot.locations_caragua[,1:2],
                                                   plot.locations_caragua,    #the R object to convert
                                                proj4string = wgs84)   # assign a CRS 

#look at CRS
crs(plot.locationsSp_caragua)

## ----plot-data-points----------------------------------------------------
plot(plot.locationsSp_caragua, 
     main="Map of Plot Locations")

## ------Convert the SpatialPixelsDataFrame to a RasterLayer------------

rs <- raster(plot.locationsSp_caragua)

# check if convert
class(rs)

#look at CRS
crs(rs)

## ------Write Raster---------------------------------------------

writeRaster(rs,"tiff_from_csv.tif",format='GTiff', overwrite=TRUE)


#