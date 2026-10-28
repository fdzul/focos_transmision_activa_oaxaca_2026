library(sf)
# Step 1. load the geocoded dengue databaset ####
#load("/Users/fdzul/Documents/geocoding_mx_2026_dengue/4.RData/dengue_mx_2026.RData")

load("8.RData/dengue_mx_2026.RData")
# Paso 2. mapa de calor con manzanas ###
library(magrittr)
# Paso 2.1 correr mapa sin guardar y con kernel 0
densnv::mp_heatmap(geocoded_dataset = z,
                   cve_edo = "23",
                   locality = "Cancun", 
                   status_caso = c(1, 2),
                   week = c(1:52), # c(1:52)
                   kernel = 0, ## control las manzanas de mapa de calor
                   zoom = NULL,      # mapas estaticos
                   map_type = NULL,   # mapas estaticos
                   alpha = 1,
                   static = FALSE,
                   palette = viridis::turbo,
                   save = FALSE)

# Paso 2.2 correr mapa sin guardar y con kernel 0
densnv::mp_heatmap(geocoded_dataset = z,
                   cve_edo = "23",
                   locality = "Cancun", 
                   status_caso = c(1, 2),
                   week = c(1:52), # c(1:52)
                   kernel = 217, ## control las manzanas de mapa de calor
                   zoom = NULL,      # mapas estaticos
                   map_type = NULL,   # mapas estaticos
                   alpha = 1,
                   static = FALSE,
                   palette = viridis::turbo,
                   save = FALSE)
