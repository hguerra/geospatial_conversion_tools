require(ncdf)
require(raster)
require(rgdal)

## Input: a shp file
file.nc <- 'vegtype_2050.nc'

## Output: a GeoTIFF file
file.tiff <- 'vegtype_2050.tiff'

## Import netCDF
r.rain <- raster(file.nc)

## Save to disk as GeoTIFF
writeRaster(r.rain, filename = file.tiff, format = 'GTiff', datatype='INT2U', overwrite=TRUE)

## Save to disk as Polygon
r.pol = rasterToPolygons(r.rain)
spplot(r.pol)
names(r.pol@data) = "attr"
writeOGR(obj = r.pol, dsn = "tempdir", layer = "vegtype_2050", driver = "ESRI Shapefile")
