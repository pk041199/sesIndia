#' @importFrom readxl read_excel
#' @importFrom tools file_ext
#' @importFrom utils read.csv
NULL

#' Validate SES Input Data
#'
#' Validates input data for SES calculations, ensuring correct column names and numeric codes.
#'
#' @param data Data frame with income, education, and occupation columns.
#' @param income_column Name of the income column.
#' @param education_column Name of the education column (optional).
#' @param occupation_column Name of the occupation column (optional).
#' @return Invisible TRUE if valid, else stops with an error.
#' @examples
#' data(sample_ses_data, package = "sesIndia")
#' validate_ses_data(sample_ses_data, "income", "education", "occupation")
#' @export
validate_ses_data <- function(data, income_column, education_column = NULL, occupation_column = NULL) {
  # Handle file input
  if (is.character(data)) {
    ext <- tools::file_ext(data)
    if (ext == "csv") {
      data <- utils::read.csv(data)
    } else if (ext == "xlsx") {
      data <- readxl::read_excel(data)
    } else {
      stop("Unsupported file type. Use CSV or Excel.")
    }
  }
  
  # Validate column names
  required_cols <- c(income_column, education_column, occupation_column)
  required_cols <- required_cols[!is.null(required_cols)]
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    stop("Missing columns: ", paste(missing_cols, collapse = ", "))
  }
  
  # Validate income
  if (any(is.na(data[[income_column]]))) {
    stop("Income column contains NA values.")
  }
  if (!is.numeric(data[[income_column]]) || any(data[[income_column]] < 0)) {
    stop("Income column must contain non-negative numeric values.")
  }
  
  # Validate education codes
  if (!is.null(education_column)) {
    valid_edu_codes <- 1:7
    if (!all(data[[education_column]] %in% valid_edu_codes)) {
      stop("Education column contains invalid codes. Use 1-7 (see vignette for codebook).")
    }
  }
  
  # Validate occupation codes
  if (!is.null(occupation_column)) {
    valid_occ_codes <- 1:10
    if (!all(data[[occupation_column]] %in% valid_occ_codes)) {
      stop("Occupation column contains invalid codes. Use 1-10 (see vignette for codebook).")
    }
  }
  
  invisible(TRUE)
}

#' Calculate SES Using B.G. Prasad Scale
#'
#' Assigns socioeconomic status (SES) to a dataset using the B.G. Prasad scale.
#'
#' @param data Data frame or file path (CSV/Excel) with income data.
#' @param income_column Name of the income column.
#' @param cpi_iw Numeric CPI-IW value (e.g., 143.2 for Jan 2025).
#' @param base_year Numeric. Base year for CPI-IW calculations (default is 2016).
#' @return Data frame with an added SES column.
#' @examples
#' data(sample_ses_data, package = "sesIndia")
#' calculate_ses_bg(sample_ses_data, "income", cpi_iw = 143.2)
#' @export
calculate_ses_bg <- function(data, income_column, cpi_iw, base_year = 2016) {
  # Validate input data
  validate_ses_data(data, income_column)
  
  # Handle file input
  if (is.character(data)) {
    ext <- tools::file_ext(data)
    if (ext == "csv") {
      data <- utils::read.csv(data)
    } else if (ext == "xlsx") {
      data <- readxl::read_excel(data)
    }
  }
  
  # Update ranges
  ranges <- update_bg_prasad(cpi_iw = cpi_iw, base_year = base_year)
  
  # Classify SES
  data <- data %>%
    dplyr::mutate(SES = cut(
      !!dplyr::sym(income_column),
      breaks = c(ranges$lower, Inf),
      labels = ranges$class,
      right = FALSE
    ))
  return(data)
}

#' Calculate SES Using Kuppuswamy Scale
#'
#' Assigns socioeconomic status (SES) to a dataset using the Kuppuswamy scale.
#'
#' @param data Data frame or file path (CSV/Excel) with income, education, and occupation data.
#' @param income_column Name of the income column.
#' @param education_column Name of the education column.
#' @param occupation_column Name of the occupation column.
#' @param cpi_iw Numeric CPI-IW value (e.g., 143.2 for Jan 2025).
#' @param base_year Numeric. Base year for CPI-IW calculations (default is 2016).
#' @return Data frame with added SES and score columns.
#' @examples
#' data(sample_ses_data, package = "sesIndia")
#' calculate_ses_kuppuswamy(sample_ses_data, "income", "education", "occupation", cpi_iw = 143.2)
#' @export
calculate_ses_kuppuswamy <- function(data, income_column, education_column, occupation_column, 
                                    cpi_iw, base_year = 2016) {
  # Validate input data
  validate_ses_data(data, income_column, education_column, occupation_column)
  
  # Handle file input
  if (is.character(data)) {
    ext <- tools::file_ext(data)
    if (ext == "csv") {
      data <- utils::read.csv(data)
    } else if (ext == "xlsx") {
      data <- readxl::read_excel(data)
    }
  }
  
  # Update income ranges
  income_ranges <- update_kuppuswamy(cpi_iw = cpi_iw, base_year = base_year)
  
  # Ensure income_ranges$lower is sorted and free of NAs
  if (any(is.na(income_ranges$lower))) stop("Income ranges contain NA values.")
  income_ranges <- income_ranges %>%
    dplyr::arrange(lower)
  
  # Assign income scores
  data <- data %>%
    dplyr::mutate(income_score = sapply(!!dplyr::sym(income_column), function(inc) {
      interval <- findInterval(inc, income_ranges$lower)
      if (interval == 0) NA
      else if (interval > nrow(income_ranges)) income_ranges$score[nrow(income_ranges)]
      else income_ranges$score[interval]
    }))
  
  # Map occupation codes (1-10) to Kuppuswamy scores (1-7)
  occupation_scores <- c(
    "1" = 1,  # Unemployed
    "2" = 2,  # Elementary occupation
    "3" = 3,  # Plant and machine operators
    "4" = 4,  # Craft and related trade workers
    "5" = 5,  # Skilled agricultural and fishery workers
    "6" = 6,  # Skilled worker, shop and market sales
    "7" = 7,  # Clerk
    "8" = 8,  # Technicians/associate professionals
    "9" = 9,  # Professional
    "10" = 10  # Legislators, senior officials, managers
  )
  
  # Assign education and occupation scores
  data <- data %>%
    dplyr::mutate(
      education_score = as.numeric(!!dplyr::sym(education_column)),
      occupation_score = occupation_scores[as.character(!!dplyr::sym(occupation_column))],
      total_score = income_score + education_score + occupation_score,
      SES = cut(
        total_score,
        breaks = c(0, 5, 11, 16, 26, 29),
        labels = c("Lower", "Upper lower", "Lower middle", "Upper middle", "Upper"),
        right = FALSE
      )
    )
  
  return(data)
}
