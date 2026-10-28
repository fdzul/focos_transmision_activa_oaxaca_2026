


# Step 1. define the path ####
path_sinave_zika <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/zik/2026/ZIKA2_.txt"


# Step 2. load the zika dataset ####

zika_acumulado <- densnv::cases_by_loc(path = path_sinave_zika, snv_dataset = "ZIKV")
zika_activo <- densnv::cases_by_loc(path = path_sinave_zika, snv_dataset = "ZIKV", 
                             week = 38:42, 
                             year = 2026)


# Step 2. loas the function ####
source("~/Desktop/capacitacion_oaxaca_2026/focos_transmision_activa_oaxaca_2026/mp_cases_loc3.R")


# México #####
densnv::mp_cases_loc(data = zika_acumulado,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = NULL,
                     r_max = 20,
                     table_position = "topright")
densnv::mp_cases_loc(data = zika_activo,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = NULL,
                     r_max = 20,
                     table_position = "topright")

# Estado ####
densnv::mp_cases_loc(data = dengue_acumulado,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = "20",
                     r_max = 20,
                     table_position = "topright")
densnv::mp_cases_loc(data = dengue_activo,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = "20",
                     r_max = 20,
                     table_position = "topright")
