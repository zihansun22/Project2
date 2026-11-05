
#' Process one year of EPA air quality data
#'
#' @param file_path Character. Path to a yearly AQ .csv file
#' @param o3_unit Character. "ppm" (default) or "ppb"; units for O3
#' @return A tibble with one row per day: date, co_ppm, pm25_ugm3, o3_ppm
#'   (or o3_ppb if o3_unit = "ppb")

process_air <- function(file_path, o3_unit = "ppm") {
  # Parameter validation
  o3_unit <- match.arg(o3_unit, c("ppm", "ppb"))
  
  raw <- readr::read_csv(file_path, show_col_types = FALSE)
  
  # 1. deduplicate
  raw <- dplyr::distinct(raw)
  
  # 2. date formatting
  raw <- raw |>
    dplyr::mutate(
      date = as.Date(.data$Date, format = "%m/%d/%Y")
    )
  
  # 3. average by day
  daily <- raw |>
    dplyr::group_by(date) |>
    dplyr::summarise(
      co_ppm     = mean(.data$`Daily Max 8-hour CO Concentration`, na.rm = TRUE),
      pm25_ugm3  = mean(.data$`Daily Mean PM2.5 Concentration`,     na.rm = TRUE),
      o3_ppm     = mean(.data$`Daily Max 8-hour Ozone Concentration`, na.rm = TRUE),
      .groups = "drop"
    )
  
  daily <- daily |>
    dplyr::mutate(dplyr::across(
      c(co_ppm, pm25_ugm3, o3_ppm),
      ~ ifelse(is.nan(.x), NA, .x)
    ))
  
  # 4. set negative value to 0
  pollutant_cols <- c("co_ppm", "pm25_ugm3", "o3_ppm")
  for (col in pollutant_cols) {
    daily[[col]][!is.na(daily[[col]]) & daily[[col]] < 0] <- 0
  }
  
  # 5. O3 unit conversion
  if (o3_unit == "ppb") {
    daily <- daily |>
      dplyr::mutate(o3_ppb = .data$o3_ppm * 1000) |>
      dplyr::select(-.data$o3_ppm)
  }
  
  daily
}



# draw tables
make_summary <- function(df, yr) {
  df |>
    filter(year == yr) |>
    summarise(
      `CO (ppm) min`      = min(co_ppm,     na.rm = TRUE),
      `CO (ppm) max`      = max(co_ppm,     na.rm = TRUE),
      `PM2.5 (µg/m³) min` = min(pm25_ugm3,  na.rm = TRUE),
      `PM2.5 (µg/m³) max` = max(pm25_ugm3,  na.rm = TRUE),
      `O3 (ppm) min`      = min(o3_ppm,     na.rm = TRUE),
      `O3 (ppm) max`      = max(o3_ppm,     na.rm = TRUE)
    ) |>
    mutate(across(everything(), 
                  ~ round(ifelse(is.infinite(.x), NA, .x), 3)))
}

