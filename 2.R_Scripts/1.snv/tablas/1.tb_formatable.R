
# Step 1. load the dengue dataset ####
path_sinave <- "/Users/fdzul/Library/CloudStorage/Dropbox/dataset/dge/denv/2026/DENGUE2_.txt"
dataset <- data.table::fread(path_sinave,
                             #select = vect_cols2,
                             encoding = "Latin-1",
                             quote="",
                             fill=TRUE)
library(formattable)
boldenr::tb_conf(x = dataset,
                 inst = TRUE,
                 year = 2026,
                 state = "JALISCO")

boldenr::tb_conf(x = dataset,
                 inst = FALSE,
                 year = 2026,
                 state = "JALISCO")

densnv::tb_conf(data = dataset,
                inst = TRUE,
                year = 2026,
                state = "JALISCO")
densnv::tb_conf(data = dataset,
                inst = TRUE,
                year = 2026,
                state = "JALISCO")
densnv::tb_conf(data = dataset,
                inst = FALSE,
                year = 2026,
                state = "JALISCO")
densnv::tb_conf(data = dataset,
                inst = FALSE,
                year = 2026,
                state = "MORELOS")


######

y  <- data |>
    dplyr::filter(ESTATUS_CASO == 2 ) |>
    dplyr::filter(ANO %in% c(year) )  |>
    dplyr::filter(DES_EDO_RES %in% c(state)) |>
    dplyr::filter(DES_DIAG_FINAL %in% c("DENGUE CON SIGNOS DE ALARMA",
                                        "DENGUE NO GRAVE",
                                        "DENGUE GRAVE")) |>
    dplyr::group_by(DES_INS_UNIDAD, DES_DIAG_FINAL) |>
    dplyr::summarise(count = dplyr::n(), .groups = "drop") |>
    tidyr::spread(key = "DES_DIAG_FINAL", fill = 0, value = "count") 
if(ncol(y) == 2) {
    if(names(y)[2] == c("DENGUE NO GRAVE")) {
        names(y) <- c("Instituciones", "DNG")
    } else if(names(y)[2] == c("DENGUE CON SIGNOS DE ALARMA")) {
        names(y) <- c("Instituciones", "DCSA")
    } else if (names(y)[2] == c("DENGUE GRAVE")) {
        names(y) <- c("Instituciones", "DG")
    }
}

if(ncol(y) == 4){
    names(y) <- c("Instituciones", "DCSA", "DG", "DNG")
}
y <- y |>
    dplyr::mutate(Total = rowSums(dplyr::pick(dplyr::starts_with("D")),
                                  na.rm = TRUE))
y2 <- y |>
    dplyr::arrange(dplyr::desc(Total)) |>
    dplyr::bind_rows(
        y |>
            dplyr::summarise(dplyr::across(c(DCSA, DG, DNG, Total), sum)) |>
            dplyr::mutate(Instituciones = "TOTAL")
    )

n <- nrow(y2)   # el renglón TOTAL no entra en los colores
# Tabla ####
tabla_inst <- formattable::formattable(
    y2,
    align = c("l", "c", "c", "c", "l"),
    table.attr = 'class="tabla-dengue"',
    list(
        Instituciones = formattable::formatter(
            "span",
            style = x ~ formattable::style(
                display = "inline-block",
                width = "100%",
                `border-radius` = "4px",
                padding = "2px 6px",
                font.weight = "bold",
                #color = ifelse(x %in% c("IMSS", "SSA"), "white", "black"),
                `background-color` = ifelse(x == "TOTAL", "white",
                                                   "#DeF7E9"))),
        area(row = 1:(n - 1), col = c("DCSA", "DG", "DNG")) ~
            formattable::color_tile("#DeF7E9", "#71CA97"),
        area(row = 1:(n - 1), col = "Total") ~
            formattable::formatter(
                "span",
                style = x ~ formattable::style(
                    display = "inline-block",
                    `border-radius` = "4px",
                    `padding-right` = "4px",
                    `text-align` = "right",
                    `background-color` = formattable::csscolor(
                        formattable::gradient(as.numeric(x), "#FFE0B2", "orange")),
                    width = formattable::percent(
                        formattable::proportion(as.numeric(x)))))
    )
)

# Función auxiliar: título + encabezado con recuadro ####
tabla_html <- function(tbl, titulo, subtitulo = NULL, nota = NULL,
                       color_header = "#0E5F76"){
    css <- paste0("
        .tabla-dengue { border-collapse: separate; border-spacing: 0;
                        width: 100%; font-family: Helvetica, Arial, sans-serif; }
        .tabla-dengue thead th {
            background-color: ", color_header, ";
            color: white;
            text-align: center !important;
            padding: 8px 6px;
            border: 1px solid ", color_header, ";
        }
        .tabla-dengue thead th:first-child { border-top-left-radius: 6px; }
        .tabla-dengue thead th:last-child  { border-top-right-radius: 6px; }
        .tabla-dengue td { padding: 4px 6px; vertical-align: middle; }
        .tabla-dengue tbody tr:last-child td { border-top: 2px solid #999;
                                               font-weight: bold; }
        .titulo-tabla    { font-family: Helvetica, Arial, sans-serif;
                           color: #333; margin-bottom: 2px; }
        .subtitulo-tabla { font-family: Helvetica, Arial, sans-serif;
                           color: #777; font-size: 13px; margin-top: 0; }
        .nota-tabla      { font-family: Helvetica, Arial, sans-serif;
                           color: #888; font-size: 11px; margin-top: 4px; }")
    htmltools::browsable(
        htmltools::tagList(
            htmltools::tags$style(htmltools::HTML(css)),
            htmltools::tags$h3(class = "titulo-tabla", titulo),
            if(!is.null(subtitulo)) htmltools::tags$p(class = "subtitulo-tabla", subtitulo),
            formattable::as.htmlwidget(tbl),
            if(!is.null(nota)) htmltools::tags$p(class = "nota-tabla", nota)
        )
    )
}

tabla_html(tabla_inst,
           titulo    = "Casos de dengue por institución notificante",
           #subtitulo = "Jalisco, 2026 · Fuente: SINAVE/DGE",
           subtitulo = paste0(stringr::str_to_title(state), ", ", year, " | Fuente: SINAVE/DGE"),
           nota      = "DNG: dengue no grave · DCSA: dengue con signos de alarma · DG: dengue grave")

