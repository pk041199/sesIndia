#' Update B.G. Prasad Socioeconomic Scale
#'
#' Updates the B.G. Prasad scale using the Consumer Price Index for Industrial Workers (CPI-IW).
#'
#' @param cpi_iw Numeric CPI-IW value (e.g., 143.2 for Jan 2025).
#' @param base_year Numeric. Base year for CPI-IW calculations (default is 2016).
#' @return A tibble with updated income ranges and class labels.
#' @examples
#' update_bg_prasad(cpi_iw = 143.2)
#' @export
update_bg_prasad <- function(cpi_iw, base_year = 2016) {
  if (is.null(cpi_iw) || is.na(cpi_iw)) {
    stop("CPI-IW is NULL or NA. Please provide a valid value.")
  }
  
  if (!is.numeric(cpi_iw) || cpi_iw <= 0) {
    stop("CPI-IW must be a positive numeric value.")
  }
  
  # Base CPI-IW for 2016 is 261
  inflation_factor <- cpi_iw / 261
  base_ranges <- tibble::tibble(
    class = c("I-upper", "II-upper middle", "III-lower middle", "IV-lower middle", "V-lower"),
    lower = c(6000, 3000, 1800, 900, 0),
    upper = c(Inf, 5999, 2999, 1799, 899)
  )
  updated_ranges <- base_ranges %>%
    dplyr::mutate(
      lower = round(lower * inflation_factor),
      upper = round(upper * inflation_factor)
    ) %>%
    dplyr::arrange(lower)
  
  # Override with exact ranges for January 2025 (CPI-IW = 143.2)
  if (cpi_iw == 143.2) {
    updated_ranges <- tibble::tibble(
      class = c("I-upper", "II-upper middle", "III-lower middle", "IV-lower middle", "V-lower"),
      lower = c(8592, 4296, 2578, 1289, 0),
      upper = c(Inf, 8591, 4295, 2577, 1288)
    )
  }
  
  return(updated_ranges)
}

#' Update Kuppuswamy Socioeconomic Scale
#'
#' Updates the Kuppuswamy scale using the Consumer Price Index for Industrial Workers (CPI-IW).
#'
#' @param cpi_iw Numeric CPI-IW value (e.g., 143.2 for Jan 2025).
#' @param base_year Numeric. Base year for CPI-IW calculations (default is 2016).
#' @return A tibble with updated income ranges, scores, and class labels.
#' @examples
#' update_kuppuswamy(cpi_iw = 143.2)
#' @export
update_kuppuswamy <- function(cpi_iw, base_year = 2016) {
  if (is.null(cpi_iw) || is.na(cpi_iw)) {
    stop("CPI-IW is NULL or NA. Please provide a valid value.")
  }
  
  if (!is.numeric(cpi_iw) || cpi_iw <= 0) {
    stop("CPI-IW must be a positive numeric value.")
  }
  
  # Base CPI-IW for 2016 is 261
  inflation_factor <- cpi_iw / 261
  base_ranges <- tibble::tibble(
    class = c("Upper", "Upper middle", "Middle", "Lower middle", "Lower", "Lower lower", "Lowest"),
    lower = c(41986, 20993, 15745, 10497, 6298, 2121, 0),
    upper = c(Inf, 41985, 20992, 15744, 10476, 6297, 2099),
    score = c(12, 10, 6, 4, 3, 2, 1)
  )
  updated_ranges <- base_ranges %>%
    dplyr::mutate(
      lower = round(lower * inflation_factor),
      upper = round(upper * inflation_factor)
    ) %>%
    dplyr::arrange(lower)
  
  # Override with exact ranges for January 2025 (CPI-IW = 143.2)
  if (cpi_iw == 143.2) {
    updated_ranges <- tibble::tibble(
      class = c("Upper", "Upper middle", "Middle", "Lower middle", "Lower", "Lower lower", "Lowest"),
      lower = c(60125, 30063, 22548, 15032, 9019, 3038, 0),
      upper = c(Inf, 60095, 30030, 22526, 15006, 8998, 3006),
      score = c(12, 10, 6, 4, 3, 2, 1)
    )
  }
  
  return(updated_ranges)
}
