# Project 2: Air Pollution and Sickle Cell Disease in Durham County, NC

## Description

This project analyzes daily air quality measurements (CO, PM2.5, and O3) from the EPA monitor at RDU Airport for 2018–2020. The goal is to support a Duke hematologist's study of associations between air pollutants and sickle cell disease (SCD) health system utilization in Durham County, North Carolina. The project includes a data-processing function, summary tables of daily min/max concentrations by year, and exploratory plots of monthly pollutant patterns.

## Data Source

Air pollution data were obtained from the **EPA air pollution monitor at RDU Airport**, covering **2018, 2019, and 2020** (2020 data only through April). Data are stored as three yearly CSV files in the `data/` folder.

## File Structure
```
.
├── project2.Rproj # RStudio project file
├── project2.R # Functions: process_air(), make_summary()
├── project2.Rmd # R Markdown report (knits to Word)
├── project2.docx # Knitted Word report output
├── README.md # This file
└── data/
├── AQ_2018.csv # Daily air quality measurements, 2018
├── AQ_2019.csv # Daily air quality measurements, 2019
└── AQ_2020.csv # Daily air quality measurements, 2020 (through April)
```

## How to Reproduce

1. Open `project2.Rproj` in RStudio.
2. Install the required R packages (if not already installed):

   ```r
   install.packages(c("readr", "dplyr", "tidyr", "ggplot2", "lubridate", "knitr"))
   ```
   
3. Open project2.Rmd and click Knit (or press Ctrl+Shift+K) to render the report to project2.docx.
4. All functions are sourced from project2.R; data are read from the data/ folder.

Author
Zihan Sun
Date: 2026-11-10