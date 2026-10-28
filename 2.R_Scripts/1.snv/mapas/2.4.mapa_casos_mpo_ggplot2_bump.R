

library(sf)
# Step 1. load the dengue dataset ####
#path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"
path_sinave <- "1.data/DENGUE2_.txt"

dataset <- data.table::fread(path_sinave,
                             #select = vect_cols2,
                             encoding = "Latin-1",
                             quote="",
                             fill=TRUE)

# Step 2. load the function ####
densnv::mp_bumpmap(dataset = dataset, 
                   year = 2026, 
                   state = TRUE,
                   size_text_value = 2,
                   size_text_country = 2,
                   country_text_x = 0.5, 
                   country_text_y = 0.8,
                   line_size = 1.5, 
                   pal_vir = "viridis")

densnv::mp_bumpmap(dataset, 
                   year = 2026, 
                   state = FALSE, 
                   cve_edo = "20",
                   label_spacing = 0.12, 
                   axis_start = 0.01,
                   size_text_value = 3, 
                   size_text_country =2.5,
                   country_text_y = 0.005, 
                   line_size = 0.8, 
                   pal_vir = "viridis")

densnv::mp_bumpmap(dataset, 
                   year = 2026, 
                   state = FALSE, 
                   cve_edo = "20",
                   label_spacing = 0.18, 
                   axis_start = 0.01,
                   size_text_value = 3, 
                   size_text_country = 2.5,
                   country_text_y = 0.005, 
                   line_size = 0.8, 
                   pal_vir = "viridis")
