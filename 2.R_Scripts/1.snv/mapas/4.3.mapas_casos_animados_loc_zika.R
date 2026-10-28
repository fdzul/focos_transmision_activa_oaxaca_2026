# Step 1. define the path ####
path_sinave_zika <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/zik/2026/ZIKA2_.txt"

library(sf)
# Mapa animado de los casos Probables & Confirmados ####
densnv::mp_animated_loc(path = path_sinave_zika,
                        snv_dataset = "ZIKV",
                        year = 2026,
                        week = 1:52,
                        var = c("probable", "confirmado"),
                        multi = "facet",
                        ncol = 2,
                        country = TRUE,
                        cve_edo = "14",
                        breaks = NULL,
                        pal = "-viridis",
                        text_size = 0.4,
                        fps = 2,
                        save = TRUE,
                        name = "probable_confirmado_mexico_2026_zik",
                        dir = "./",
                        width = NULL,
                        height = 2000,
                        size_range = c(3, 16),
                        strip_size = 20,
                        curve = TRUE)
