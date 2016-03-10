## data path
setwd("data")

# librarys
library(rgdal)

fileName <- "ignore_data/caragua.shp"

# Load the file for the first layer
pols <- readOGR(dsn = fileName, "caragua")

#pos = c(75, 3040, 3350, 4950, 5053)
#(upRed, downRed, upBlue, x, x)
pos = c(85, 3040, 3350, 4970, 5053)

plot(pols)

data = pols@polygons[[1]]@Polygons[[4]]@coords

sr1 = Polygon(rbind(data[pos[1]:pos[2],], data[pos[1],]))
srs1 = Polygons(list(sr1), "1")

sr2 = Polygon(rbind(data[pos[2]:pos[3],], data[pos[4]:pos[5],], data[1:pos[1],], data[pos[2],]))
srs2 = Polygons(list(sr2), "2")

sr3 = Polygon(rbind(data[pos[3]:pos[4],], data[pos[3],]))
srs3 = Polygons(list(sr3), "3")

sp=SpatialPolygons(list(srs1, srs2, srs3), as.integer(c(1, 2, 3)))
plot(sp, add=T, col = c("red", "green", "blue"))

df=data.frame(name=c("North", "Center", "South"))
spdf=SpatialPolygonsDataFrame(sp, df)
spdf@proj4string =  pols@proj4string
writeOGR(spdf, ".", "regions", "ESRI Shapefile") 
