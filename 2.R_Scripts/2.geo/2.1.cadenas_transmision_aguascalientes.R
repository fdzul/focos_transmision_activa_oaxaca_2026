
library(sf)
# Step 1. subir la base de datos geocodificada ####
#load("/Users/fdzul/Documents/geocoding_mx_2026_dengue/4.RData/dengue_mx_2026.RData")
load("8.RData/dengue_mx_2026.RData")
# Step 2. Cadenas de transmisión  ####
mapview::mapviewOptions(basemaps = c("Esri.WorldGrayCanvas",
                                     "Stadia.AlidadeSmoothDark",
                                     "OpenStreetMap", 
                                     "Esri.WorldImagery", 
                                     "OpenTopoMap"))
denhotspots::transmission_chains_map(geocoded_dataset = z,
                                     cve_edo = "01",
                                     locality = "Aguascalientes",
                                     dengue_cases = c("Confirmado"))

