# sesIndia
[![Build Status](https://github.com/pk041199/sesIndia/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/pk041199/sesIndia/actions)
[![Issues](https://img.shields.io/github/issues/pk041199/sesIndia)](https://github.com/pk041199/sesIndia/issues)

An R package to update and apply the B.G. Prasad and Kuppuswamy socioeconomic scales in India using Consumer Price Index for Industrial Workers (CPI-IW) values. This package enables researchers and policymakers to adjust income thresholds for socioeconomic classification, accounting for inflation since the base year (2016, CPI-IW = 261), and classify datasets based on income, education, and occupation.

## Installation

Install the package from GitHub (CRAN submission pending):

```r
# Install devtools if not already installed
install.packages("devtools")

# Install sesIndia from GitHub
devtools::install_github("pk041199/sesIndia")
```

## Dependencies

- R (>= 3.5.0)
- dplyr: For data manipulation
- tibble: For modern data frame structures
- readxl: For reading Excel files
- tools, utils: For file handling
- knitr, rmarkdown (suggested): For vignette rendering

Install dependencies:

```r
install.packages(c("dplyr", "tibble", "readxl", "tools", "utils", "knitr", "rmarkdown"))
```

## Usage

The package provides five main functions:

- `validate_ses_data()`: Validates input data for SES calculations.
- `update_bg_prasad()`: Updates income ranges for the B.G. Prasad scale.
- `update_kuppuswamy()`: Updates income ranges for the Kuppuswamy scale.
- `calculate_ses_bg()`: Assigns SES using the B.G. Prasad scale.
- `calculate_ses_kuppuswamy()`: Assigns SES using the Kuppuswamy scale.

### Example: Validate and Classify Data for January 2025 (CPI-IW = 143.2)

```r
library(sesIndia)

# Load sample data
data(sample_ses_data)

# Validate data
validate_ses_data(sample_ses_data, income_column = "income", education_column = "education", occupation_column = "occupation")

# Update B.G. Prasad scale
bg_updated <- update_bg_prasad(cpi_iw = 143.2)
print(bg_updated)
```

**Output**:

```
# A tibble: 5 × 3
  class             lower upper
  <chr>             <dbl> <dbl>
1 I-upper            8592   Inf
2 II-upper middle    4296  8591
3 III-lower middle   2578  4295
4 IV-lower middle    1289  2577
5 V-lower               0  1288
```

```r
# Update Kuppuswamy scale
kup_updated <- update_kuppuswamy(cpi_iw = 143.2)
print(kup_updated)
```

**Output**:

```
# A tibble: 7 × 4
  class        lower upper score
  <chr>        <dbl> <dbl> <dbl>
1 Upper        60125   Inf    12
2 Upper middle 30063 60095    10
3 Middle       22548 30030     6
4 Lower middle 15032 22526     4
5 Lower         9019 15006     3
6 Lower lower   3038  8998     2
7 Lowest           0  3006     1
```

```r
# Calculate SES with B.G. Prasad
ses_bg <- calculate_ses_bg(sample_ses_data, income_column = "income", cpi_iw = 143.2)
print(ses_bg)
```

**Output**:

```
# A tibble: 5 × 4
  income education occupation SES              
   <dbl>     <dbl>      <dbl> <fct>            
1   5000         4          6 II-upper middle  
2  35000         6          9 I-upper          
3   3000         2          2 III-lower middle 
4  65000         7         10 I-upper          
5   1000         1          1 V-lower          
```

```r
# Calculate SES with Kuppuswamy
ses_kup <- calculate_ses_kuppuswamy(
  sample_ses_data,
  income_column = "income",
  education_column = "education",
  occupation_column = "occupation",
  cpi_iw = 143.2
)
print(ses_kup)
```

**Output**:

```
# A tibble: 5 × 8
  income education occupation income_score education_score occupation_score total_score SES          
   <dbl>     <dbl>      <dbl>        <dbl>           <dbl>            <dbl>       <dbl> <fct>        
1   5000         4          6            2               4                5          11 Lower middle 
2  35000         6          9           10               6                7          23 Upper middle 
3   3000         2          2            1               2                2           5 Upper lower  
4  65000         7         10           12               7                7          26 Upper        
5   1000         1          1            1               1                1           3 Lower        
```

## Obtaining CPI-IW

The package requires a CPI-IW value (e.g., 143.2 for Jan 2025). To obtain it manually:

1. Visit the [Labour Bureau Centre Index page](https://www.labourbureau.gov.in/centre-index).
2. Locate the table listing CPI-IW values by month and year.
3. Use the All-India General Index value for your analysis period.

## Features

- Updates income cutoffs using CPI-IW with base year 2016 (CPI-IW = 261).
- Classifies SES based on income (B.G. Prasad) or income, education, and occupation (Kuppuswamy).
- Supports data frames and CSV/Excel file inputs.
- Includes input validation and rounded income values.
- Provides comprehensive vignette and documentation.

## System Requirements

- R environment with standard package installation capabilities.
- No additional system dependencies beyond R and listed packages.

## Notes

- Ensure CPI-IW values are positive and numeric.
- Education codes must be 1-7, occupation codes 1-10 (see vignette for codebook).
- The base year is fixed at 2016 (CPI-IW = 261).

## License

MIT

## Contributing

Issues and pull requests are welcome at [https://github.com/pk041199/sesIndia](https://github.com/pk041199/sesIndia).
