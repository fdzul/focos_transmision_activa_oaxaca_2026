

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



# Step 2.1 map the dengue dataset (leaflet) ####
leaflet::leaflet() |>
    leaflet::addProviderTiles(leaflet::providers$Stadia.AlidadeSmoothDark,
                              group = "Stadia.AlidadeSmoothDark") |>
    # limites municipale
    leaflet::addPolylines(data = x,
                      color = "gray",
                      opacity = 0.7,
                      weight = 0.5,
                      group = "Municipios",
                      popup = ~popup,
                      label = ~NOMGEO) |>
    # municipios con casos
    leaflet::addPolygons(data = x |> dplyr::filter(n>0),
                         fillColor = ~pal_fun(n),
                         fillOpacity = 0.7,
                         color = "white",
                         weight = 1,
                         group = "Casos Confirmados",
                         popup = ~popup,
                         label = ~as.character(n),
                         highlightOptions = leaflet::highlightOptions(weight = 2,
                                                                      color = "black",
                                                                      bringToFront = TRUE)) |>
    leaflet::addLegend(position = "topright",
                       pal = pal_fun,
                       values = x_pos$n,
                       title = "Casos Confirmados",
                       opacity = 0.7)




###########

x_pos <- x |> dplyr::filter(n > 0)

pal_fun <- leaflet::colorNumeric(palette = viridis::viridis(n = 10),
                                 domain = x_pos$n)

leaflet::leaflet() |>
    # mapas base
    leaflet::addProviderTiles(leaflet::providers$Stadia.AlidadeSmoothDark,
                              group = "Stadia.AlidadeSmoothDark") |>
    leaflet::addProviderTiles(leaflet::providers$OpenStreetMap,
                              group = "OpenStreetMap") |>
    leaflet::addProviderTiles(leaflet::providers$Esri.WorldImagery,
                              group = "Esri.WorldImagery") |>
    leaflet::addProviderTiles(leaflet::providers$OpenTopoMap,
                              group = "OpenTopoMap") |>
    # límites municipales
    leaflet::addPolylines(data = x,
                          color = "gray",
                          opacity = 0.7,
                          weight = 0.5,
                          group = "Municipios",
                          popup = ~popup,
                          label = ~NOMGEO) |>
    # municipios con casos
    leaflet::addPolygons(data = x_pos,
                         fillColor = ~pal_fun(n),
                         fillOpacity = 0.7,
                         color = "white",
                         weight = 1,
                         group = "Casos Confirmados",
                         popup = ~popup,
                         label = ~as.character(n),
                         highlightOptions = leaflet::highlightOptions(weight = 2,
                                                                      color = "black",
                                                                      bringToFront = TRUE)) |>
    leaflet::addLegend(position = "topright",
                       pal = pal_fun,
                       values = x_pos$n,
                       title = "Casos Confirmados",
                       opacity = 0.7) |>
    leaflet::addLayersControl(baseGroups = c("Stadia.AlidadeSmoothDark",
                                             "OpenStreetMap",
                                             "Esri.WorldImagery",
                                             "OpenTopoMap"),
                              overlayGroups = c("Municipios",
                                                "Casos Confirmados"),
                              position = "topleft",
                              options = leaflet::layersControlOptions(collapsed = TRUE)) |>
    leaflet.extras::addFullscreenControl(position = "topleft") |>
    leaflet::addScaleBar(position = "bottomleft")
