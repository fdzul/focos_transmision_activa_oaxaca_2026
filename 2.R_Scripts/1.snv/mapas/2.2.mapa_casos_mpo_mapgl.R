

# Step 1.1 define the path 
path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/"

# Step 1.2 load dengue dataset 
library(sf)
x <- densnv::cases_by_agem(path_vbd = path_sinave,
                           vbd = "DENGUE",
                           country = FALSE,
                           cve_edo = "14",
                           status_case = 2)

x <- x |>
    dplyr::mutate(NOMGEO = iconv(NOMGEO, from = "latin1", to = "UTF-8")) |>
    dplyr::mutate(popup = paste0("<b>Municipio:</b> ", NOMGEO,
                                 "<br><b>CVEGEO:</b> ", CVEGEO,
                                 "<br><b>Casos:</b> ", n))



# Step 2.1 map the dengue dataset (mapgl) ####

mapgl::maplibre(style = mapgl::carto_style("positron"),
                bounds = x) |>
    mapgl::add_line_layer(id = "Municipios",
                          line_color = "gray",
                          line_opacity = 0.7,
                          line_width = 0.5,
                          source = x,
                          popup = "popup",
                          tooltip = "NOMGEO") |>
    mapgl::add_fill_layer(id = "Casos Confirmados",
                          source = x |> dplyr::filter(n>0),
                          fill_color = mapgl::interpolate(column = "n",
                                                          values = seq(from = min(x$n),
                                                                       to = max(x$n),
                                                                       length.out = 10),
                                                          stops = viridis::viridis(n = 10)),
                          fill_opacity = 0.7,
                          fill_outline_color = "white",
                          popup = "popup",
                          tooltip = "n") |>
    mapgl::add_legend(legend_title = "Casos Confirmados",
                      values = seq(from = min(x$n),
                                   to = max(x$n),
                                   by = 10),
                      draggable = TRUE,
                      colors = viridis::viridis(n = 10),
                      type = "continuous") |>
    mapgl::add_fullscreen_control(position = "top-left") |> 
    mapgl::add_navigation_control() |>
    mapgl::add_globe_control() |>
    mapgl::add_scale_control()




### 

x_pos <- x |> dplyr::filter(n > 0)

pal <- viridis::viridis(n = 10)
rng <- range(x_pos$n, na.rm = TRUE)

mapgl::maplibre(style = mapgl::carto_style("positron"),
                bounds = x) |>
    # mapas base
    mapgl::add_raster_source(id = "osm_src",
                             tiles = "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                             tileSize = 256) |>
    mapgl::add_raster_layer(id = "OpenStreetMap",
                            source = "osm_src",
                            visibility = "none") |>
    mapgl::add_raster_source(id = "esri_src",
                             tiles = "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                             tileSize = 256) |>
    mapgl::add_raster_layer(id = "Esri.WorldImagery",
                            source = "esri_src",
                            visibility = "none") |>
    mapgl::add_raster_source(id = "topo_src",
                             tiles = "https://tile.opentopomap.org/{z}/{x}/{y}.png",
                             tileSize = 256) |>
    mapgl::add_raster_layer(id = "OpenTopoMap",
                            source = "topo_src",
                            visibility = "none") |>
    # todos los municipios en gris
    mapgl::add_line_layer(id = "Municipios",
                          line_color = "gray",
                          line_opacity = 0.7,
                          line_width = 0.5,
                          source = x,
                          popup = "popup",
                          tooltip = "NOMGEO") |>
    # municipios con casos
    mapgl::add_fill_layer(id = "Casos Confirmados",
                          source = x_pos,
                          fill_color = mapgl::interpolate(column = "n",
                                                          values = seq(from = rng[1], 
                                                                       to = rng[2], 
                                                                       length.out = 10),
                                                          stops = pal),
                          fill_opacity = 0.7,
                          fill_outline_color = "white",
                          popup = "popup",
                          tooltip = "n") |>
    mapgl::add_legend(legend_title = "Casos Confirmados",
                      position = "top-right",
                      values = seq(from = min(x$n),
                                   to = max(x$n),
                                   by = 10),
                      colors = pal,
                      type = "continuous") |>
    mapgl::add_layers_control(position = "top-left",
                              layers = c("OpenStreetMap",
                                         "Esri.WorldImagery",
                                         "OpenTopoMap",
                                         "Municipios",
                                         "Casos Confirmados"),
                              collapsible = TRUE) |>
        mapgl::add_fullscreen_control(position = "top-left") |> 
        mapgl::add_navigation_control() |>
        mapgl::add_globe_control() |>
        mapgl::add_scale_control()
    


