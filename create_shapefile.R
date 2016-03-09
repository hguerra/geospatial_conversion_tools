## data path
setwd("data")

# librarys
library(rgdal)

fileName <- "ignore_data/caragua/caragua.shp"

# Get the layer names
fileLayers <- ogrListLayers(dsn = fileName)

# Load the file for the first layer
pols <- readOGR(dsn = fileName, fileLayers[1])

pols2 = pols

pols2@polygons[[1]]@Polygons[[1]] = pols2@polygons[[1]]@Polygons[[4]]

sr1 = Polygon(pols2@polygons[[1]]@Polygons[[1]])
srs1 = Polygons(list(sr1), "1")
sp=SpatialPolygons(list(srs1), as.integer(1))

# http://cod.ibge.gov.br/A9P
df=data.frame(population=2015, idh=0.759, pib=22088.41, name="Caraguatatuba")
spdf=SpatialPolygonsDataFrame(sp, df)

spdf@proj4string =  pols@proj4string

writeOGR(spdf, ".", "caragua_editado", "ESRI Shapefile")