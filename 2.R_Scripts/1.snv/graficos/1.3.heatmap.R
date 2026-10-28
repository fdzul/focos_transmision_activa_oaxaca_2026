

# Step 1. load the dengue dataset ####
#path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"
path_sinave <- "1.data/DENGUE2_.txt"
x <- data.table::fread(path_sinave,
                       #select = vect_cols2,
                       encoding = "Latin-1",
                       quote="",
                       fill=TRUE)
# Step 2. make the heatmap confirmados & hospitalizados ####
densnv::plt_heatmap(dataset = x,
                    state = NULL,
                    year = "2026",
                    hospitalizados = TRUE,
                    status = 1)

densnv::plt_heatmap(dataset = x,
                    state = "OAXACA",
                    year = "2026",
                    hospitalizados = TRUE,
                    status = 1)


# Step 2. make the heatmap confirmados ####
densnv::plt_heatmap(dataset = x,
                    state = NULL,
                    year = "2026",
                    hospitalizados = FALSE,
                    status = 2)

densnv::plt_heatmap(dataset = x,
                    state = "OAXACA",
                    year = "2026",
                    hospitalizados = FALSE,
                    status = 2)
