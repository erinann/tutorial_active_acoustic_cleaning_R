library(leaflet)

# start basemap
map <- leaflet() %>% 
  
  # add ocean basemap
  addProviderTiles(providers$Esri.OceanBasemap) %>%
  
  # add another layer with place names
  addProviderTiles(providers$Hydda.RoadsAndLabels, group = 'Place names') %>%
  
  # add graticules from a NOAA webserver
  addWMSTiles(
    "https://gis.ngdc.noaa.gov/arcgis/services/graticule/MapServer/WMSServer/",
    layers = c("1-degree grid", "1-degree grid"),
    options = WMSTileOptions(format = "image/png8", transparent = TRUE),
    attribution = NULL,group = 'Graticules') %>%
  
  # focus map in a certain area / zoom level
  setView(lng = -73, lat = 38, zoom = 7) %>%
  
  # add layers control
  addLayersControl(overlayGroups = c('Place names',
                                     'Graticules',
                                     'Points',
                                     'Lines',
                                     'Polygons'),
                   options = layersControlOptions(collapsed = FALSE),
                   position = 'topright')  %>%
  
  # list groups to hide on startup
  hideGroup(c('Place names'))


# add lines
map <- map %>%
  addPolylines(data = bot, ~Longitude, ~Latitude,
               weight = 3,
               color = 'red',
               popup = 'This is a line!', 
               smoothFactor = 3,
               group = 'Lines')

# add more features
map <- map %>% 
  
  # add a map scalebar
  addScaleBar(position = 'topright') %>%
  
  # add measurement tool
  addMeasure(
    primaryLengthUnit = "kilometers",
    secondaryLengthUnit = 'miles', 
    primaryAreaUnit = "hectares",
    secondaryAreaUnit="acres", 
    position = 'topleft')

# show map    
map    

# # # save a stand-alone, interactive map as an html file
library(htmlwidgets)
# saveWidget(widget = map, file = 'map.html', selfcontained = T)

# # # save a snapshot as a png file
library(mapview)
mapshot(map, file = 'map.png')
