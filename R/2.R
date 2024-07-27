#print("Hello R!")
import(readxl)
import(dplyr)

library(readxl)
library(dplyr)

# Specify the path to your Excel file
file_path <- "/Users/Aman/Downloads/dummy_sales_data_with_prices.xlsx"

# Get the names of all sheets in the Excel file
sheet_names <- excel_sheets(file_path)

# Read all sheets into a list of data frames
all_sheets <- lapply(sheet_names, function(sheet) {
  read_excel(file_path, sheet = sheet)
})
#print(all_sheets)


primary_key <- "id"
selected_columns <- c(primary_key, "Quantity", "Price", "Region","Salesperson",)

# Ensure the primary key column exists in all sheets
if (all(sapply(all_sheets, function(df) primary_key %in% colnames(df)))) {
# Perform an inner join on all data frames using the primary key
common_data <- Reduce(function(x, y) {
inner_join(x, y, by = primary_key)}, all_sheets)

# Calculate the new column "Cost" by multiplying "Quantity" and "Price"
common_data <- common_data %>%
mutate(Cost = Quantity * Price)

# Select only the desired columns
common_data <- select(common_data, all_of(selected_columns))

# Output the common data
print(common_data)
}else{ cat("The primary key column is not present in all sheets.")}

View(common_data)

