## data path
setwd("data")
# librarys
library(raster)
library(png)

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

getRGB <- function(filepath){
  
  if(!file.exists(filepath))
    return;
  
  img <- readPNG(filepath)
  
  pix.top.left <- img[1,1,]     # row 1, column 1
  pix.bottom.left <- img[3,1,]  # row 3, column 1
  pix.top.right <- img[1,3,]    # row 1, column 3
  
  pix.top.left # 0.7019608 0.7098039 0.7137255 1.0000000
  pix.bottom.left
  pix.top.right
}



buildRaster <- function(filepath){

  if(!file.exists(filepath))
    return;
  
  img <- readPNG(filepath)
  
  # Convert imagedata to raster
  rst.blue <- raster(img[,,1])
  rst.green <- raster(img[,,2])
  rst.red <- raster(img[,,3])
  
  st <- stack(rst.red, rst.green, rst.blue)
  
  # set CRS
  crs(st) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
  
  # Plot single raster images and RGB composite
  plot(st,main = c("Blue band", "Green band", "Red band"))
  
  #
  # Write Raster
  #
  writeRaster(st,"st.tif",format='GTiff', overwrite=TRUE)
  #writeRaster(st,"st.tif",format='GTiff', datatype='INT2U', overwrite=TRUE) # fundo fica preto
  
}

#
# RUN
#
void_main <- function(){
  #exampleColors()
  buildRaster('INITIAL2010_REALDATA.PNG')
}
void_main()


