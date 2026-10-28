cases_by_loc <- function(path, snv_dataset){
    
    # Step 1. # Step 2. load the ITER 2020 ####
    loc <- rgeomex::iter_2020_loc |>
        dplyr::mutate(cvegeo = paste0(entidad, mun, loc)) |>
        dplyr::select(cvegeo, longitud, latitud, altitud, pobtot)
    
    # Step 2 load the sinave dataset #####
    if(snv_dataset == "DENV"){
        data <- data.table::fread(path,
                               encoding = "Latin-1",
                               quote="",
                               fill=TRUE) |>
            dplyr::filter(ESTATUS_CASO %in% c(1, 2)) |>
            dplyr::mutate(CVE_EDO_REP = stringr::str_pad(CVE_EDO_REP,
                                                         width = 2,
                                                         side = "left",
                                                         pad = "0"),
                          CVE_MPO_REP = stringr::str_pad(CVE_MPO_REP,
                                                         width = 3,
                                                         side = "left",
                                                         pad = "0"),
                          CVE_LOC_REP = stringr::str_pad(CVE_LOC_REP,
                                                         width = 4,
                                                         side = "left",
                                                         pad = "0")) |>
            dplyr::filter(CVE_EDO_REP != "00") |>
            dplyr::filter(CVE_MPO_REP != "00=") |>
            dplyr::filter(CVE_LOC_REP != "0000") |>
            dplyr::mutate(cvegeo = paste0(CVE_EDO_REP,CVE_MPO_REP,CVE_LOC_REP))|>
            dplyr::select(ANO, SEM, cvegeo, ESTATUS_CASO, DES_DIAG_FINAL,DENGUE_SER_TRIPLEX) |>
            dplyr::mutate(DENGUE_SER_TRIPLEX  = dplyr::case_when(DENGUE_SER_TRIPLEX == 1 ~ "DENV1",
                                                                 DENGUE_SER_TRIPLEX == 2 ~ "DENV2",
                                                                 DENGUE_SER_TRIPLEX == 3 ~ "DENV3",
                                                                 DENGUE_SER_TRIPLEX == 4 ~ "DENV4")) |>
            dplyr::filter(ANO == 2026) |>
            dplyr::group_by(cvegeo) |>
            dplyr::summarise(probables =  dplyr::n(),
                             confirmado = sum(ESTATUS_CASO == 2, na.rm = T),
                             DNG = sum(DES_DIAG_FINAL == "DENGUE NO GRAVE", na.rm = T),
                             DCGA = sum(DES_DIAG_FINAL == "DENGUE CON SIGNOS DE ALARMA", na.rm = T),
                             DG = sum(DES_DIAG_FINAL == "DENGUE GRAVE", na.rm = T),
                             DENV1 = sum(DENGUE_SER_TRIPLEX == "DENV1", na.rm = T),
                             DENV2 = sum(DENGUE_SER_TRIPLEX == "DENV2", na.rm = T),
                             DENV3 = sum(DENGUE_SER_TRIPLEX == "DENV3", na.rm = T),
                             DENV4 = sum(DENGUE_SER_TRIPLEX == "DENV4", na.rm = T))
        
    } else if(snv_dataset == "ZIKV") {
        data <- data.table::fread("/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/zik/2026/ZIKA2_.txt",
                                  encoding = "Latin-1") |>
            dplyr::filter(ESTATUS_CASO %in% c(1, 2)) |>
            dplyr::mutate(CVE_EDO_REP = stringr::str_pad(CVE_EDO_REP,
                                                         width = 2,
                                                         side = "left",
                                                         pad = "0"),
                          CVE_MPO_REP = stringr::str_pad(CVE_MPO_REP,
                                                         width = 3,
                                                         side = "left",
                                                         pad = "0"),
                          CVE_LOC_REP = stringr::str_pad(CVE_LOC_REP,
                                                         width = 4,
                                                         side = "left",
                                                         pad = "0")) |>
            dplyr::filter(CVE_EDO_REP != "00") |>
            dplyr::filter(CVE_MPO_REP != "00=") |>
            dplyr::filter(CVE_LOC_REP != "0000") |>
            dplyr::mutate(cvegeo = paste0(CVE_EDO_REP,CVE_MPO_REP,CVE_LOC_REP)) |>
            dplyr::filter(ANO == 2026) |>
            dplyr::group_by(cvegeo) |>
            dplyr::summarise(probable = dplyr::n(),
                             confirmado = sum(ESTATUS_CASO == 2, na.rm = T))
    } else if(snv_dataset == "CHIKV") {
        data <- data.table::fread("/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/chik/2026/CHIKUNGUNYA2_.txt",
                                  encoding = "Latin-1") |>
            dplyr::filter(ESTATUS_CASO %in% c(1, 2)) |>
            dplyr::mutate(CVE_EDO_REP = stringr::str_pad(CVE_EDO_REP,
                                                         width = 2,
                                                         side = "left",
                                                         pad = "0"),
                          CVE_MPO_REP = stringr::str_pad(CVE_MPO_REP,
                                                         width = 3,
                                                         side = "left",
                                                         pad = "0"),
                          CVE_LOC_REP = stringr::str_pad(CVE_LOC_REP,
                                                         width = 4,
                                                         side = "left",
                                                         pad = "0")) |>
            dplyr::filter(CVE_EDO_REP != "00") |>
            dplyr::filter(CVE_MPO_REP != "00=") |>
            dplyr::filter(CVE_LOC_REP != "0000") |>
            dplyr::mutate(cvegeo = paste0(CVE_EDO_REP,CVE_MPO_REP,CVE_LOC_REP)) |>
            dplyr::filter(ANO == 2026) |>
            dplyr::group_by(cvegeo) |>
            dplyr::summarise(probable = dplyr::n(),
                             confirmado = sum(ESTATUS_CASO == 2, na.rm = T))
    } else {
        
    }
    # Step 3. bind the dataset ####
    dplyr::left_join(x = data,
                     y = loc,
                     by = c("cvegeo")) |>
        dplyr::filter(!is.na(longitud)) |>
        sf::st_as_sf(coords = c("longitud", "latitud"),
                     crs = 4326) 
       
}