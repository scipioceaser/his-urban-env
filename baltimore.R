library("data.table")
library("readxl")

# NOTE(Alex): Trying out 1895, 1905, 1915 data, because that includes disease specific information.
data_1895 = read_excel("data/baltimore/Baltimore_1895/1895_WL-SID184,_TID4378,_1895-Baltimore,_Health_Dept,_Table_II_Deaths_Zym_Dis_Consumption_Pneu_Each_Ward_1895,_pg_917.xls")

# Process the data into a more usable format
data_1895_trans = data_1895[4:nrow(data_1895), ]
data_1895_trans = t(data_1895_trans)
colnames(data_1895_trans) = data_1895$BALTIMORE[4:nrow(data_1895)]
data_1895_trans = data_1895_trans[c(-1), ]
rownames(data_1895_trans) = as.character(data_1895_trans[, 1])
data_1895_trans = data_1895_trans[, c(-1)]
data_1895_trans = apply(data_1895_trans, 2, as.numeric)
colnames(data_1895_trans) = gsub(" ", "_", colnames(data_1895_trans))

# Using a data table, make more usable columns
disease_1895 = as.data.table(data_1895_trans)
disease_1895[is.na(disease_1895)] = 0
disease_1895[, Cholera_Total := Cholera + Cholera_infantum + Cholera_morbus]

deaths_bronchitis_1905 = read_excel("data/baltimore/Baltimore_1905/1905_WL-SID184,_TID4403,_1905-Baltimore,_Health_Dept,_Table_1_Deaths_Fm_Bronchitis_By_Wards_Months_Color_&_Sex_1905,_pg_142-145.xls")
deaths_typhoid_1905 = read_excel("data/baltimore/Baltimore_1905/1905_WL-SID184,_TID4407,_1905-Baltimore,_Health_Dept,_Table_1_Deaths_Fm_Typhoid_Fev_By_Wards_Months_Color_&_Sex_1905,_pg_258-261.xlsx")
deaths_measles_1905 = read_excel("data/baltimore/Baltimore_1905/1905_WL-SID184,_TID4405,_1905-Baltimore,_Health_Dept,_Table_1_Deaths_Fm_Measles_By_Wards_Months_Color_&_Sex_1905,_pg_438-441.xlsx")

deaths_typhoid_1905 = as.data.table(deaths_typhoid_1905)

# TODO: Turn this into a global function.
deaths_typhoid_1905[deaths_typhoid_1905 == "….."] <- 0
deaths_typhoid_1905[deaths_typhoid_1905 == "....."] <- 0
deaths_typhoid_1905[deaths_typhoid_1905 == "......"] <- 0
deaths_typhoid_1905[deaths_typhoid_1905 == "…../..."] <- 0
deaths_typhoid_1905[is.na(deaths_typhoid_1905)] <- 0
deaths_typhoid_1905[deaths_typhoid_1905 == "2....."] <- 2

# Applies to Philly as well
# TODO: Get all the tables into one, then plot disease rates over time. Then plot Philly GIS, then we're done.
# 		Make sure to export all graphs as SVG.

View(deaths_typhoid_1905)
