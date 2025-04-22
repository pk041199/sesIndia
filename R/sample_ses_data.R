#' Sample SES Data
#'
#' A dataset for socioeconomic status (SES) calculations using the B.G. Prasad and Kuppuswamy scales.
#' Columns include income (INR), education (numeric code), and occupation (numeric code).
#'
#' @format A data frame with 5 rows and 3 columns:
#' \describe{
#'   \item{income}{Monthly family income in INR (numeric).}
#'   \item{education}{Education level (numeric code: 1 = Illiterate, 2 = Primary school,
#'     3 = Middle school, 4 = High school, 5 = Intermediate or diploma, 6 = Graduate,
#'     7 = Professional degree).}
#'   \item{occupation}{Occupation type (numeric code: 1 = Unemployed, 2 = Elementary occupation,
#'     3 = Plant and machine operators and assemblers, 4 = Craft and related trade workers,
#'     5 = Skilled agricultural and fishery workers, 6 = Skilled worker, shop and market sales workers,
#'     7 = Clerk, 8 = Technicians/associate professionals, 9 = Professional,
#'     10 = Legislators, senior officials, managers).}
#' }
#' @source Simulated data for demonstration.
#' @examples
#' data(sample_ses_data)
#' head(sample_ses_data)
"sample_ses_data"