#Step 1. load the dengue dataset ####
#path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"

path_sinave <- "1.data/DENGUE2_.txt"
dataset <- data.table::fread(path_sinave,
                             #select = vect_cols2,
                             encoding = "Latin-1",
                             quote="",
                             fill=TRUE)

# Step 2. Sin guardar el mapa animado ####
densnv::mp_animated_mpo(data = dataset,
                        year = 2026,
                        name = "Jalisco",
                        dir = "6.Maps/",
                        country = FALSE,
                        breaks = 1,
                        cve_edo = "20",
                        text_size = 0.3,
                        save = FALSE,
                        dot = TRUE,
                        pal = viridis::viridis)

densnv::mp_animated_mpo(data = dataset,
                        year = 2026,
                        name = "Oaxaca",
                        dir = "6.Maps/",
                        country = FALSE,
                        breaks = 2,
                        text_size = 0.3,
                        cve_edo = "20",
                        save = FALSE,
                        dot = FALSE,
                        pal = viridis::viridis)


densnv::mp_animated_mpo(data = dataset,
                        year = 2026,
                        name = "Mexico",
                        dir = "6.Maps/",
                        country = TRUE,
                        breaks = 2,
                        cve_edo = "14",
                        text_size = 0.3,
                        save = FALSE,
                        dot = TRUE,
                        pal = viridis::viridis)

densnv::mp_animated_mpo(data = dataset,
                        year = 2026,
                        name = "Mexico",
                        dir = "6.Maps/",
                        country = TRUE,
                        breaks = 2,
                        text_size = 0.3,
                        cve_edo = "14",
                        save = FALSE,
                        dot = FALSE,
                        pal = viridis::viridis)

# Step 3. Guardando el mapa animado ####
densnv::mp_animated_mpo(data = dataset,
                        year = 2026,
                        name = "jalisco",
                        dir = "6.Maps/",
                        country = FALSE,
                        breaks = 2,
                        cve_edo = "14",
                        text_size = 0.3,
                        save = TRUE,
                        dot = TRUE,
                        pal = viridis::viridis)

densnv::mp_animated_mpo(data = dataset,
                        year = 2026,
                        name = "jalisco",
                        dir = "6.Maps/",
                        country = FALSE,
                        text_size = 0.3,
                        breaks = 2,
                        cve_edo = "14",
                        save = TRUE,
                        dot = FALSE,
                        pal = viridis::viridis)

densnv::mp_animated_mpo(data = dataset,
                        year = 2026,
                        name = "mex",
                        dir = "6.Maps/",
                        country = TRUE,
                        breaks = 2,
                        cve_edo = "14",
                        text_size = 0.3,
                        save = TRUE,
                        dot = TRUE,
                        pal = viridis::viridis)

densnv::mp_animated_mpo(data = dataset,
                        year = 2026,
                        name = "mex",
                        dir = "6.Maps/",
                        country = TRUE,
                        breaks = 2,
                        cve_edo = "14",
                        text_size = 0.3,
                        save = TRUE,
                        dot = FALSE,
                        pal = viridis::viridis)



