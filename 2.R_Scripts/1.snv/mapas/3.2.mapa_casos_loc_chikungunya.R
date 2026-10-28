
# Step 1. define the path ####
path_sinave_chik <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/chik/2026/CHIKUNGUNYA2_.txt"

# Step 2. load the function ####
#source("~/Desktop/capacitacion_oaxaca_2026/focos_transmision_activa_oaxaca_2026/3.Functions/cases_by_loc.R")
#source("~/Desktop/capacitacion_oaxaca_2026/focos_transmision_activa_oaxaca_2026/cases_by_loc.R")

chik_acumulado <- densnv::cases_by_loc(path = path_sinave_chik, 
                                       snv_dataset = "CHIKV")
chik_activo <- densnv::cases_by_loc(path = path_sinave_chik, snv_dataset = "CHIKV", 
                             week = 10:42, 
                             year = 2026)

# México #####
densnv::mp_cases_loc(data = chik_acumulado,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = NULL,
                     r_max = 20,
                     table_position = "topright")
densnv::mp_cases_loc(data = dengue_chik,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = NULL,
                     r_max = 20,
                     table_position = "topright")

# Estado ####
densnv::mp_cases_loc(data = chik_acumulado,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = "07",
                     r_max = 20,
                     table_position = "topright")
densnv::mp_cases_loc(data = chik_activo,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = "07",
                     r_max = 20,
                     table_position = "topright")
