## data path
setwd("data")
# librarys
library(raster)
library(png)
#
# ---------Colors methods--------------------------
#

exampleColors <- function(){
  # Colors
  colors()[1:25]
  
  # 0 - 1
  # red
  rgb(1,0,0) #FF0000 or 255, 0, 0
  
  # green
  rgb(0,1,0) #00FF00 or 0, 255, 0
  
  # yellow
  rgb(1,1,0) #FFFF00 or 255, 255, 0
  
  # 0 - 255
  # red
  rgb(255,0,0, maxColorValue=255) #FF0000 or 255, 0, 0
  
  # Color by name
  col2rgb(c("blue", "yellow"))
  
}

isNotValidColor <- function(color.actual){
  color.yellow <- rgb(255,255,0, maxColorValue=255)#A
  color.orange <- rgb(255,130,0, maxColorValue=255)#B
  color.red <- rgb(255,0,0, maxColorValue=255)#C  
  
  return(color.actual != color.yellow
         && color.actual != color.orange
         && color.actual != color.red)
}

makeTransparent = function(..., alpha=0.5) {
  
  if(alpha<0 | alpha>1) stop("alpha must be between 0 and 1")
  
  alpha = floor(255*alpha)  
  newColor = col2rgb(col=unlist(list(...)), alpha=FALSE)
  
  .makeTransparent = function(col, alpha) {
    rgb(red=col[1], green=col[2], blue=col[3], alpha=alpha, maxColorValue=255)
  }
  
  newColor = apply(newColor, 2, .makeTransparent, alpha=alpha)
  
  return(newColor)
  
}

#
# ---------Raster methods--------------------------
#

getRasterInfo <- function(r){
  if(!is.raster(r))
    return;
  
  # ---------- informacoes shapefile caragua --------------
  
  #OGR data source with driver: ESRI Shapefile 
  #Source: "ignore_data/urbano_caragua_coluna_classes2010/caragua_classes2010.shp", layer: "caragua_classes2010"
  #with 209 features
  #It has 1 fields
  #class       : SpatialPolygonsDataFrame 
  #features    : 209 
  #extent      : -58.82195, -58.58221, -23.74066, -23.5563  (xmin, xmax, ymin, ymax)
  #coord. ref. : +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
  #variables   : 1
  #names       : CLASES2010 
  #min values  :          1 
  #max values  :          3 
  
  # --------------------------------------------------------
  
  print("CRS:")
  print(projection(r))
  
  print("RASTER INFO:")
  print(r)
  
  # cell number and values from coordinate
  
  #cell <- cellFromXY(r, cbind(-58, -23))	# get cell number from coordinates Log -58, Lat -23
  #cell.ts <- r[cell]	# get values for this cell
  #cell.ts
  #plot(as.vector(cell.ts), type="l")
}

buildRaster <- function(img){
  
  if(!is.array(img))
    return;
  
  # Convert imagedata to raster
  
  rst.red <- raster(img[,,1])
  rst.green <- raster(img[,,2])
  rst.blue <- raster(img[,,3])
  
  st <- stack(rst.red, rst.green, rst.blue)
  
  # Give it lat/lon coords 
  #ex:  extent(rast) <- c(36,37,-3,-2) # for 36-37°E, 3-2°S
  
  #caragua: -58.82195, -58.58221, -23.74066, -23.5563  (xmin, xmax, ymin, ymax)
  extent(st) <- c(-58.82195, -58.58221, -23.74066, -23.5563)
  
  # set CRS
  crs(st) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  
  
  # Plot single raster images and RGB composite
  #plot(st,main = c("Blue band", "Green band", "Red band"))
  
  ## get raster info
  
  getRasterInfo(st)
  
  #
  # Write Raster
  #
  writeRaster(st,"st.tif",format='GTiff', overwrite=TRUE)
}
png.to.raster <- function(filepath){
  
  if(!file.exists(filepath))
    return;
  
  img <- readPNG(filepath)
  
  for(i in 1:nrow(img)){
    for(j in 1:ncol(img)){
      color.actual <- rgb(img[i, j, 1], img[i, j, 2], img[i, j, 3])
      
      if(isNotValidColor(color.actual)){
        img[i, j, 1] <- 1 #red
        img[i, j, 2] <- 0 #green
        img[i, j, 3] <- 1 #blue
      }
    }
  }
  # Convert imagedata to raster
  buildRaster(img)
}
png.to.raster2<- function(filepath){
  
  if(!file.exists(filepath))
    return;
  
  img <- readPNG(filepath)
  
  color.yellow <- rgb(255,255,0, maxColorValue=255)#A
  color.orange <- rgb(255,130,0, maxColorValue=255)#B
  color.red <- rgb(255,0,0, maxColorValue=255)#C  
  
  raster.img <- raster(nrow= nrow(img), ncol= ncol(img))
  
  for(i in 1:nrow(img)){
    for(j in 1:ncol(img)){
      color.actual <- rgb(img[i, j, 1], img[i, j, 2], img[i, j, 3])
      
      if(color.actual == color.red){
        raster.img[i,j] <- 1
      }else if(color.actual == color.orange){
        raster.img[i,j] <- 2
      }else if(color.actual == color.yellow){
        raster.img[i,j] <- 3
      }else{
        raster.img[i, j] <- NA
      }
    }
  }# end for
  extent(raster.img) <- c(-58.82195, -58.58221, -23.74066, -23.5563)
  crs(raster.img) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  writeRaster(raster.img,"raster-img4.tif",format='GTiff', overwrite=TRUE)
}#END

#
# ---------------TESTs-----------------------------
#
test <- function(){
  #exampleColors()
  #isNotValidColor(rgb(0,1,0)) # verde
  #isNotValidColor(rgb(1,1,0)) # amarelo
  print(makeTransparent(2, 4))
  #"#FF00007F" "#0000FF7F"
  print(makeTransparent("red", "blue"))
  #"#FF00007F" "#0000FF7F"
  print(makeTransparent(rgb(1,0,0), rgb(0,0,1)))
  #"#FF00007F" "#0000FF7F"
  print(makeTransparent("red", "blue", alpha=0.8))
  #"#FF0000CC" "#0000FFCC"
}
#
# ---------------RUN-------------------------------
#
void_main <- function(){
  #test()
  png.to.raster2('real.png')
}
void_main()


