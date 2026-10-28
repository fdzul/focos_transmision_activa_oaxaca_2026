library(sf)
# Step 1. load the geocoded dengue databaset ####
#load("/Users/fdzul/Documents/geocoding_mx_2026_dengue/4.RData/dengue_mx_2026.RData")

load("8.RData/dengue_mx_2026.RData")

# step 2. load the function ####
source("~/Desktop/capacitacion_oaxaca_2026/focos_transmision_activa_oaxaca_2026/mp_heatmap_gl.R")


# todos los casos probables y confirmados del año
mp_heatmap_gl(geocoded_dataset = z,
              yrs = 2026,
              cve_edo = "01",
              locality = "Aguascalientes",
              status_caso = c(1, 2),
              week = NULL,
              radius_m =  800,
              opacity = 0.75,
              show_points = FALSE,
              points_zoom = 15,
              style = "positron")

# confirmados de las últimas semanas (transmisión activa)
mp_heatmap_gl(geocoded_dataset = z,
              yrs = 2026,
              cve_edo = "01",
              locality = "Aguascalientes",
              status_caso = 2,
              week = 38:42,
              radius_ = 800,
              opacity = 0.75,
              show_points = FALSE,
              points_zoom = 15,
              style = "positron")


