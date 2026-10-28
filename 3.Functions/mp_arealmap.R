#' static_map_areal
#'
#' Static choropleth map of dengue cases (DNG, DWS and SD) aggregated by
#' municipality, with north arrow, scale bar, automatic title and optional
#' labels for the most affected municipalities and a locator inset.
#'
#' @param x the SINAVE dengue dataset.
#' @param year year to map (ANO column).
#' @param week_start first epidemiological week (default 1).
#' @param week_end last epidemiological week (default 53).
#' @param country logical. TRUE = all municipalities of Mexico; FALSE = the
#'   municipalities of the state given in `cve_edo`.
#' @param cve_edo INEGI state code ("14" or 14). Required if `country = FALSE`.
#' @param by_residence logical. TRUE (default) aggregates cases by municipality
#'   of residence (CVE_EDO_RES / CVE_MPO_RES); FALSE by reporting municipality
#'   (CVE_EDO_REP / CVE_MPO_REP).
#' @param breaks legend classes. A single number is the class width (e.g. 10
#'   gives 1, 10, 20, ...); a vector gives the class limits; NULL (default)
#'   computes them with `pretty()`.
#' @param palette viridis option ("A" to "H", or "magma", "inferno", ...).
#' @param direction 1 or -1, direction of the palette (default -1, darker =
#'   more cases).
#' @param legend_title legend title (default "Casos").
#' @param label_top number of municipalities with the most cases to label on
#'   the map (default 0 = none).
#' @param label_size text size of the labels.
#' @param title,subtitle plot title and subtitle. NULL (default) builds them
#'   from the state, year and weeks; use NA to remove them.
#' @param caption plot caption (default cites SINAVE/DGE). NA removes it.
#' @param north_arrow logical. Add a north arrow (default TRUE).
#' @param scale_bar logical. Add a scale bar (default TRUE).
#' @param inset logical. With `country = FALSE`, add a small map of Mexico
#'   that locates the state (default FALSE). Requires cowplot.
#' @param inset_position numeric vector c(x, y, width, height) of the inset in
#'   relative units (0-1). Default c(0.70, 0.68, 0.30, 0.30).
#' @param crs projected CRS used to draw the map (default 6372, Mexico ITRF2008
#'   / LCC) so that the scale bar is accurate.
#'
#' @author Felipe Antonio Dzul Manzanilla \email{felipe.dzul.m@gmail.com}
#'
#' @return a ggplot object.
#' @export
#'
#' @examples
#' \dontrun{
#' x <- data.table::fread("DENGUE2_.txt", quote = "", fill = TRUE)
#'
#' # Mexico, whole year
#' static_map_areal(x = x, year = 2026, country = TRUE, breaks = 50)
#'
#' # Jalisco, weeks 1-40, labels of the 5 municipalities with most cases
#' static_map_areal(x = x, year = 2026, week_end = 40,
#'                  country = FALSE, cve_edo = "14",
#'                  label_top = 5, inset = TRUE)
#' }
mp_arealmap <- function(x,
                        year,
                        week_start = 1,
                        week_end = 53,
                        country = TRUE,
                        cve_edo = NULL,
                        by_residence = TRUE,
                        breaks = NULL,
                        palette = "B",
                        direction = -1,
                        legend_title = "Casos",
                        label_top = 0,
                        label_size = 3,
                        title = NULL,
                        subtitle = NULL,
                        caption = "Fuente: SINAVE/DGE, Secretaría de Salud.",
                        north_arrow = TRUE,
                        scale_bar = TRUE,
                        inset = FALSE,
                        inset_position = c(0.70, 0.68, 0.30, 0.30),
                        crs = 4326){
    
    # Step 0. checks ####
    if(!country && is.null(cve_edo)){
        stop("With country = FALSE you must provide cve_edo (e.g. cve_edo = \"14\").")
    }
    if(week_start > week_end){
        stop("week_start must be less than or equal to week_end.")
    }
    if(!is.null(cve_edo)){
        cve_edo <- stringr::str_pad(as.character(cve_edo), width = 2,
                                    side = "left", pad = "0")
    }
    edo_col <- if(by_residence) "CVE_EDO_RES" else "CVE_EDO_REP"
    mpo_col <- if(by_residence) "CVE_MPO_RES" else "CVE_MPO_REP"
    
    # Step 1. polygons (projected) ####
    mun <- rgeomex::AGEM_inegi19_mx |>
        sf::st_make_valid() |>
        sf::st_transform(crs)
    edo <- rgeomex::AGEE_inegi19_mx |>
        sf::st_make_valid() |>
        sf::st_transform(crs)
    
    # Step 2. aggregate dengue cases by municipality ####
    cases <- x |>
        dplyr::filter(ANO %in% year) |>
        dplyr::filter(!DES_EDO_RES %in% c("OTROS PAISES",
                                          "OTROS PAISES DE LATINOAMERICA",
                                          "ESTADOS UNIDOS DE NORTEAMERICA")) |>
        dplyr::filter(DES_DIAG_FINAL %in% c("DENGUE CON SIGNOS DE ALARMA",
                                            "DENGUE NO GRAVE",
                                            "DENGUE GRAVE")) |>
        dplyr::filter(SEM >= week_start, SEM <= week_end) |>
        dplyr::mutate(CVE_EDO_REP = stringr::str_pad(.data[[edo_col]], width = 2,
                                                 side = "left", pad = "0"),
                      CVE_MUN_REP = stringr::str_pad(.data[[mpo_col]], width = 3,
                                                 side = "left", pad = "0")) |>
        dplyr::summarise(n = dplyr::n(), .by = c(CVE_EDO_REP, CVE_MUN_REP))
    
    # Step 3. join (only n is set to 0, not the text columns) ####
    y <- dplyr::left_join(x = mun, 
                          y = cases, 
                          by = c( "CVE_ENT" ="CVE_EDO_REP", 
                                  "CVEGEO" = "CVE_MUN_REP")) |>
        dplyr::mutate(n = tidyr::replace_na(n, 0L))
    
    if(!country){
        y   <- y   |> dplyr::filter(CVE_ENT %in% cve_edo)
        edo <- edo |> dplyr::filter(CVE_ENT %in% cve_edo)
    }
    
    y_pos <- y |> dplyr::filter(n >= 1)
    
    if(nrow(y_pos) == 0){
        warning("There are no dengue cases for the selected year/weeks/state.")
    }
    
    # Step 4. legend classes ####
    max_n <- max(c(y$n, 1))
    if(is.null(breaks)){
        brks <- pretty(c(1, max_n), n = 5)
    } else if(length(breaks) == 1){
        brks <- seq(from = 0, to = max_n + breaks, by = breaks)
    } else {
        brks <- sort(breaks)
    }
    brks <- unique(c(1, brks[brks > 1 & brks < max_n]))
    
    # Step 5. automatic title and subtitle ####
    area_name <- if(country) "México" else
        stringr::str_to_title(stringr::str_trim(unique(edo$NOMGEO)[1]))
    if(is.null(title)){
        title <- paste0("Casos de dengue por municipio, ", area_name, " ", year)
    }
    if(is.null(subtitle)){
        subtitle <- paste0("Semanas epidemiológicas ", week_start, " a ", week_end,
                           " · Total: ", format(sum(y$n), big.mark = ","),
                           " casos en ", nrow(y_pos), " municipios",
                           if(by_residence) " (municipio de residencia)" else
                               " (municipio de notificación)")
    }
    if(length(title) == 1 && is.na(title))       title    <- NULL
    if(length(subtitle) == 1 && is.na(subtitle)) subtitle <- NULL
    if(length(caption) == 1 && is.na(caption))   caption  <- NULL
    
    # Step 6. map ####
    p <- ggplot2::ggplot() +
        # municipalities without cases
        ggplot2::geom_sf(data = y,
                         fill = "gray90",
                         color = "white",
                         linewidth = if(country) 0.01 else 0.15) +
        # municipalities with cases
        ggplot2::geom_sf(data = y_pos,
                         ggplot2::aes(fill = n),
                         color = "white",
                         linewidth = if(country) 0.01 else 0.15) +
        # state boundaries
        ggplot2::geom_sf(data = edo,
                         fill = NA,
                         color = "gray20",
                         linewidth = if(country) 0.25 else 0.5) +
        ggplot2::scale_fill_viridis_b(legend_title,
                                      option = palette,
                                      direction = direction,
                                      breaks = brks,
                                      limits = c(1, max(max_n, 2)),
                                      show.limits = TRUE,
                                      guide = ggplot2::guide_coloursteps(
                                          title.position = "top",
                                          title.hjust = 0.5,
                                          direction = "horizontal",
                                          even.steps = TRUE))
    
    # labels of the municipalities with the most cases
    if(label_top > 0 && nrow(y_pos) > 0){
        top <- y_pos |>
            dplyr::slice_max(n, n = label_top, with_ties = FALSE)
        top_xy <- top |>
            sf::st_geometry() |>
            sf::st_point_on_surface() |>
            sf::st_coordinates() |>
            dplyr::as_tibble() |>
            dplyr::mutate(label = paste0(stringr::str_trim(top$NOMGEO),
                                         " (", top$n, ")"))
        p <- p +
            ggplot2::geom_point(data = top_xy,
                                ggplot2::aes(x = X, y = Y),
                                size = 1, color = "gray10") +
            ggrepel::geom_label_repel(data = top_xy,
                                      ggplot2::aes(x = X, y = Y, label = label),
                                      size = label_size,
                                      color = "gray10",
                                      fill = ggplot2::alpha("white", 0.8),
                                      label.size = 0,
                                      segment.color = "gray30",
                                      segment.size = 0.3,
                                      min.segment.length = 0,
                                      box.padding = 0.5,
                                      max.overlaps = Inf,
                                      seed = 123)
    }
    
    # scale bar and north arrow
    if(scale_bar){
        p <- p +
            ggspatial::annotation_scale(location = "bl",
                                        width_hint = 0.25,
                                        style = "ticks",
                                        line_col = "gray30",
                                        text_col = "gray30",
                                        text_cex = 0.7)
    }
    if(north_arrow){
        p <- p +
            ggspatial::annotation_north_arrow(location = if(inset && !country) "tl" else "tr",
                                              which_north = "true",
                                              height = ggplot2::unit(1, "cm"),
                                              width = ggplot2::unit(1, "cm"),
                                              pad_x = ggplot2::unit(0.3, "cm"),
                                              pad_y = ggplot2::unit(0.3, "cm"),
                                              style = ggspatial::north_arrow_fancy_orienteering(
                                                  line_col = "gray30",
                                                  fill = c("white", "gray30"),
                                                  text_col = "gray30"))
    }
    
    p <- p +
        ggplot2::coord_sf(crs = crs, datum = NA) +
        ggplot2::labs(title = title, subtitle = subtitle, caption = caption) +
        ggplot2::theme_void(base_size = 11) +
        ggplot2::theme(legend.position = "bottom",
                       legend.title = ggplot2::element_text(colour = "gray30",
                                                            face = "bold",
                                                            size = 10),
                       legend.text = ggplot2::element_text(colour = "gray30",
                                                           size = 8),
                       legend.key.width = ggplot2::unit(1.2, "cm"),
                       legend.key.height = ggplot2::unit(0.3, "cm"),
                       legend.margin = ggplot2::margin(0, 0, 0, 0),
                       legend.box.margin = ggplot2::margin(-5, 0, 5, 0),
                       plot.title = ggplot2::element_text(colour = "gray20",
                                                          face = "bold",
                                                          size = 14,
                                                          hjust = 0),
                       plot.subtitle = ggplot2::element_text(colour = "gray40",
                                                             size = 9,
                                                             hjust = 0,
                                                             margin = ggplot2::margin(b = 8)),
                       plot.caption = ggplot2::element_text(colour = "gray50",
                                                            size = 7,
                                                            hjust = 1),
                       plot.margin = ggplot2::margin(10, 10, 10, 10),
                       plot.background = ggplot2::element_rect(fill = "white",
                                                               colour = NA))
    
    # Step 7. locator inset ####
    if(inset && !country){
        mx <- rgeomex::AGEE_inegi19_mx |>
            sf::st_make_valid() |>
            sf::st_transform(crs)
        inset_map <- ggplot2::ggplot() +
            ggplot2::geom_sf(data = mx, fill = "gray85",
                             color = "white", linewidth = 0.1) +
            ggplot2::geom_sf(data = mx |> dplyr::filter(CVE_ENT %in% cve_edo),
                             fill = "#E01E5A", color = "white", linewidth = 0.1) +
            ggplot2::coord_sf(crs = crs, datum = NA) +
            ggplot2::theme_void() +
            ggplot2::theme(panel.border = ggplot2::element_rect(fill = NA,
                                                                colour = "gray60",
                                                                linewidth = 0.3),
                           plot.background = ggplot2::element_rect(fill = "white",
                                                                   colour = NA))
        p <- cowplot::ggdraw(p) +
            cowplot::draw_plot(inset_map,
                               x = inset_position[1],
                               y = inset_position[2],
                               width = inset_position[3],
                               height = inset_position[4])
    }
    
    p
}