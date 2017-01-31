setwd("../data/arapiuns")

library(rgdal)

ida <- readOGR (".", "Traj_IDA_lin", encoding = "ESRI Shapefile")
volta <- readOGR (".", "Traj_VOLTA_lin", encoding = "ESRI Shapefile")

plot(volta,col="red")
plot(ida, col="blue", add=T)

df = data.frame(x=c(), y=c())

for(i in c(1:5, 15:6))
  df = rbind(df, ida@lines[[i]]@Lines[[1]]@coords)

for(i in c(1, 3, 2))
  df = rbind(df, volta@lines[[i]]@Lines[[1]]@coords)

duplicatevolta = data.frame(x=c(), y=c())

for(i in c(4, 7:10, 13:19))
{
  coords = volta@lines[[i]]@Lines[[1]]@coords
  duplicatevolta = rbind(duplicatevolta, coords)
}

df = rbind(df, duplicatevolta)
df = rbind(df, duplicatevolta[rev(rownames(duplicatevolta)),])

for(i in c(6, 5, 20:24, 26, 25, 29:27, 30:32, 35, 34, 33, 36:37, 39, 38, 40:42, 44, 43))
{
  coords = volta@lines[[i]]@Lines[[1]]@coords
  df = rbind(df, coords)
}

l = Line(df)
ls = Lines(l, "1")
spls= SpatialLines(list(ls))

plot(spls, col = "blue", lwd=5)
plot(ida, col="green", add=T, lwd=3)
plot(volta, col="red", add=T, lwd=3)

splsdf = SpatialLinesDataFrame(spls, data.frame(value=c(3)))
splsdf@data
writeOGR(splsdf, ".", "ar1traj", driver = "ESRI Shapefile", verbose=TRUE,overwrite_layer=TRUE)

spplot(splsdf)

######################################################################

plot(spls, col = "blue", add=T, lwd=5)

plot(ida, col="green", add=T, lwd=3)

pos = 1
plot(volta[pos,], col="pink", add=T,lwd=5)
pos = pos+1
