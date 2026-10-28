
#Step 1. load the dengue dataset ####
path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"
dataset <- data.table::fread(path_sinave,
                             #select = vect_cols2,
                             encoding = "Latin-1",
                             quote="",
                             fill=TRUE)

# load the function ####
source("~/Desktop/capacitacion_oaxaca_2026/focos_transmision_activa_oaxaca_2026/3.Functions/mp_arealmap.R")
library(magrittr)


densi


mp_arealmap(x  = dataset, 
            year = 2026, 
            week_start = 1,
            week_end = 42,
            country = TRUE,
            breaks = 50)

mp_arealmap(x = dataset, 
            year = 2026, 
            week_end = 42,
            week_start = 1,
            country = FALSE, 
            cve_edo = "14",
            label_top = 5, 
            inset = TRUE)

mp_arealmap(x = dataset,
            breaks = 10,
            week_start = 1,
            week_end = 42,
            country = TRUE,
            year = 2026)


boldenr::static_map_areal(x = dataset,
                          breaks = 10,
                          week_start = 1,
                          week_end = 42,
                          country = TRUE,
                          year = 2026)

boldenr::static_map_areal(x = dataset,
                          breaks = 10,
                          week_start = 1,
                          week_end = 42,
                          country = FALSE,
                          cve_edo = 14,
                          year = 2026) +
    ggspatial::annotation_scale()
