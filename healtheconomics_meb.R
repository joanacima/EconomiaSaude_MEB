# --- Section 1: Loading Libraries ---
# Load necessary R libraries required for the analysis

library(here)   # Simplifies the way to specify file paths that work well across different operating systems.
library(readxl) # Used for reading Excel files.
library(dplyr)  # A powerful data manipulation library in R, part of the 'tidyverse'.
# Provides functions to efficiently perform common data operations such as:
# - filter(): for subsetting rows based on logical conditions.
# - select(): for selecting specific columns.
# - arrange(): for sorting data.
# - mutate(): for creating new columns from existing ones.
# - summarise(): for generating statistical summaries.
# - group_by(): for grouping data to perform group-wise analyses.
library(car)    # Includes tools for regression diagnostics, hypothesis testing of regression coefficients, and other advanced analyses.
library(stargazer) # # The 'stargazer' package is used for creating well-formatted tables of statistical model outputs.
library(ggplot2)  # for creating plots
library(panelr) # Load the panelr package to use specialized functions for panel data
library(writexl) # library in R is a package used to write data frames to Excel files.


# --- Section 2: Setting and Displaying Current Working Directory ---
# Set and print the current working directory to ensure file paths are correctly set.

current_directory <- getwd()
print(current_directory)

# --- Section 3: Data Loading ---
# Load the data from the specified Excel file located within a 'data' subfolder.

health_expenditure_pc <- as.data.frame(read_excel("data/health_expenditure_pc.xlsx", 
                                    na = ":"))

gdp_pc <- as.data.frame(read_excel("data/gdp_pc.xlsx", 
                     na = ":"))


# --- Section 4: Reshaping Data ---
# Reshape the health expenditure data to a long format, specifying columns 2 to 11 as variables that vary over time.

panel_health_expenditure <- reshape(health_expenditure_pc,
                                    idvar="country",
                                    varying = list(2:11),
                                    timevar= "year",
                                    times = seq(from = 2014, to = 2023),
                                    new.row.names= 1:10000, 
                                    direction = "long"
)


# Rename the third column of the resulting dataframe to 'health_expenditure_pc'.
names(panel_health_expenditure)[3] <- "health_expenditure_pc"

# Reshape the GDP per capita data to a long format, similarly to the health data reshaping above.
panel_gdp_pc <- reshape(gdp_pc,
                        idvar="country",
                        varying = list(2:25),  
                        timevar = "year",
                        times = seq(from = 2000, to = 2023),
                        new.row.names = 1:10000,
                        direction = "long"
)

# Rename the third column of the resulting dataframe to 'gdp_pc'.
names(panel_gdp_pc)[3] <- "gdp_pc"

# --- Section 5: Merging Data ---
# Merge the two dataframes, 'panel_health_expenditure' and 'panel_gdp_pc',
# based on the columns 'country' and 'year'. The 'all = TRUE' indicates a 'full join',
# meaning it includes all rows from both dataframes, filling with NA where there is no match.
bd_final <- merge(panel_health_expenditure, panel_gdp_pc, by = c("country", "year"), all = TRUE)

# Additional comments on merge parameters not used in this example:
# all.x = TRUE would function as a left join; all.y = TRUE would function as a right join.

bd_final <- merge(panel_health_expenditure, panel_gdp_pc, by = c("country", "year"), all.x = TRUE)

# --- Section 6: Exporting Data to Exce ---

write_xlsx(bd_final, "bd_final.xlsx")
