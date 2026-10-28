

# Step 1.1 define the path 
#path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/"
path_sinave <- "1.data/DENGUE2_.txt"
# Step 1.2 load dengue dataset 
library(sf)
x <- densnv::cases_by_agem(path_vbd = path_sinave,
                           vbd = "DENGUE",
                           country = FALSE,
                           cve_edo = "14", #####
                           status_case = 2)

x <- x |>
    dplyr::mutate(NOMGEO = iconv(NOMGEO, from = "latin1", 
                                 to = "UTF-8")) |>
    dplyr::mutate(popup = paste0("<b>Municipio:</b> ", NOMGEO,
                                 "<br><b>CVEGEO:</b> ", CVEGEO,
                                 "<br><b>Casos:</b> ", n))



# Step 2.1 map the dengue dataset (mapview) ####
mapview::mapviewOptions(basemaps = c("Esri.WorldGrayCanvas",
                            "Stadia.AlidadeSmoothDark",
                            "OpenStreetMap", 
                            "Esri.WorldImagery", 
                            "OpenTopoMap"))

mapview::mapview(x,
                 col.regions = "grey90",
                 color. = "white",
                 #layer.name = "Casos Confirmados",
                 popup = TRUE) +
    mapview::mapview(x |> dplyr::filter(n>0),
                     zcol = "n",
                     layer.name = "Casos Confirmados",
                     color = "white",
                     col.regions = viridis::viridis(n = 10),
                     popup = TRUE)

# cambio de colores
pal1 <- viridis::viridis(n = 3, option = "C")
pal2 <- rcartocolor::carto_pal(n = 3, name = "OrYel")
mapview::mapview(x,
                 col.regions = "grey90",
                 color. = "white",
                 #layer.name = "Casos Confirmados",
                 popup = TRUE) +
    mapview::mapview(x |> dplyr::filter(n>0),
                 zcol = "n",
                 layer.name = "Casos de Dengue",
                 color = "white",
                 popup = TRUE,
                 col.regions = pal2)


