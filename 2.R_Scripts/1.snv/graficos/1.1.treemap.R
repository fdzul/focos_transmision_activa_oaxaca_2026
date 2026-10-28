

# Step 1. load the dengue dataset ####
#path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"
path_sinave <- "1.data/DENGUE2_.txt"

x <- data.table::fread(path_sinave,
                       #select = vect_cols2,
                       encoding = "Latin-1",
                       quote="",
                       fill=TRUE)
# Step 2. make the treemap ####
densnv::plt_treemap(snv_dataset =x, 
                   country = FALSE, 
                   cve_edo = "20", 
                   year = 2026)
