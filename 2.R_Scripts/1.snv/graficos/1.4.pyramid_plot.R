
# Step 1. load the dengue dataset ####
#path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"
path_sinave <- "1.data/DENGUE2_.txt"
x <- data.table::fread(path_sinave,
                       #select = vect_cols2,
                       encoding = "Latin-1",
                       quote="",
                       fill=TRUE)

# Step 2. create the pyramid plot ####
densnv::plt_pyramid(data = x,
                    col_male   = "#0072B2",
                    col_female = "#CC79A7",
                    gap = 0.1,
                    size_age = 3.5,
                    size_count = 3,
                    icon_male = "person",
                    icon_female = "person-dress",
                    show_zero = FALSE,
                    title = "Casos confirmados de dengue por grupo de edad y sexo",
                    subtitle = "México, 2026",
                    caption = "Fuente: SINAVE/DGE, Secretaría de Salud.")


