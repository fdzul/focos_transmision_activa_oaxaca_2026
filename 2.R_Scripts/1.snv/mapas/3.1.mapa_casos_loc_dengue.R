


# Step 1. define the path ####
path_sinave_den <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"
path_sinave_zika <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/zik/2026/ZIKA2_.txt"
path_sinave_chik <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/chik/2026/CHIKUNGUNYA2_.txt"

#path_sinave_den <- "1.data/DENGUE2_.txt"

# Step 2. load the dataset ####
dengue_acumulado <- densnv::cases_by_loc(path = path_sinave_den, snv_dataset = "DENV")
dengue_activo <- densnv::cases_by_loc(path = path_sinave_den,
                                      snv_dataset = "DENV", 
                                      week = 38:42, 
                                      year = 2026)

zik <- densnv::cases_by_loc(path = path_sinave_zika, snv_dataset = "ZIKV")
chik <- densnv::cases_by_loc(path = path_sinave_chik, snv_dataset = "CHIKV")


# México #####
densnv::mp_cases_loc(data = dengue_acumulado,
                     var = "confirmado",
                     top_n = 10,
                     title = "Casos Confirmados",
                     palette = "D",
                     r_min = 4,
                     cve_edo = NULL,
                     r_max = 20,
                     table_position = "topright")
densnv::mp_cases_loc(data = dengue_activo,
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
