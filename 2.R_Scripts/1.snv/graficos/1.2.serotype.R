

# Step 1. load the dengue dataset ####
#path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"
path_sinave <- "1.data/DENGUE2_.txt"
x <- data.table::fread(path_sinave,
                       #select = vect_cols2,
                       encoding = "Latin-1",
                       quote="",
                       fill=TRUE)

# Step 2. make the treemap ####
densnv::plt_serotype(data = x, 
                     year = 2026, 
                     x_serotype  = 0.5, 
                     y_serotype = 0.17, 
                     scale_serotype = 1.7,
                     cve_edo = NULL)
densnv::plt_serotype(data = x, 
                     year = 2026, 
                     x_serotype  = 0.5, 
                     y_serotype = 0.17, 
                     scale_serotype = 1.7,
                     cve_edo = 20)
