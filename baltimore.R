library("data.table")
library("readxl")

clean_data_table = function(table)
{
	table[table == "….."] <- 0
	table[table == "....."] <- 0
	table[table == "......"] <- 0
	table[table == "…../..."] <- 0
	table[is.na(table)] <- 0
	table[table == "2....."] <- 2
	table[table == "......."] <- 0

	return(table)
}

read_clean = function(path)
{
	raw = as.data.table(read_excel(path))
	return(clean_data_table(raw))
}

# NOTE(Alex): Trying out 1895, 1905, 1915 data, because that includes disease specific information.
data_1895 = read_clean("data/baltimore/Baltimore_1895/1895_WL-SID184,_TID4378,_1895-Baltimore,_Health_Dept,_Table_II_Deaths_Zym_Dis_Consumption_Pneu_Each_Ward_1895,_pg_917.xls")

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

deaths_typhoid_1905 = read_clean("data/baltimore/Baltimore_1905/1905_WL-SID184,_TID4407,_1905-Baltimore,_Health_Dept,_Table_1_Deaths_Fm_Typhoid_Fev_By_Wards_Months_Color_&_Sex_1905,_pg_258-261.xlsx")
deaths_measles_1905 = read_clean("data/baltimore/Baltimore_1905/1905_WL-SID184,_TID4405,_1905-Baltimore,_Health_Dept,_Table_1_Deaths_Fm_Measles_By_Wards_Months_Color_&_Sex_1905,_pg_438-441.xlsx")
deaths_whoopch_1905 = read_clean("data/baltimore/Baltimore_1905/1905_WL-SID184,_TID4408,_1905-Baltimore,_Health_Dept,_Table_1_Deaths_Fm_Whooping_Cough_By_Wards_Months_Color_&_Sex_1905,_pg_374-377.xlsx")

deaths_typhoid_1915 = read_clean("data/baltimore/Baltimore_1915/SID184,_TID4634,_1915-Baltimore,_Health_Dept,_TYPHOID_FEVER_Deaths_Wards_Sex_Color_Months_1915,_pg_76-79.xlsx")
deaths_measles_1915 = read_clean("data/baltimore/Baltimore_1915/SID184,_TID4622,_1915-Baltimore,_Health_Dept,_MEASLES_Deaths_Wards_Sex_Color_Months_1915,_pg_108-111.xlsx")
deaths_whoopch_1915= read_clean("data/baltimore/Baltimore_1915/SID184,_TID4635,_1915-Baltimore,_Health_Dept,_WHOOPING_COUGH_Deaths_Wards_Sex_Color_Months_1915,_pg_100-103.xlsx")

# Order: Whooping Cough -- Measles -- Typhoid fever

whoopch_1915_total = sum(as.numeric(rev(deaths_whoopch_1915[BALTIMORE == "Total", ])[, 1:4]))
measles_1915_total = sum(as.numeric(rev(deaths_measles_1915[BALTIMORE == "Total", ])[, 1:4]))
typhoid_1915_total = sum(as.numeric(rev(deaths_typhoid_1915[BALTIMORE == "Total", ])[, 1:4]))

whoopch_1905_total = sum(as.numeric(rev(deaths_whoopch_1905[BALTIMORE == "Total", ])[, 1:4]))
measles_1905_total = sum(as.numeric(rev(deaths_measles_1905[BALTIMORE == "Total", ])[, 1:4]))
typhoid_1905_total = sum(as.numeric(rev(deaths_typhoid_1905[BALTIMORE == "Total", ])[, 1:4]))

totals_1895_extracted = c(as.numeric(disease_1895[nrow(disease_1895), "Whooping-cough"]),
						  as.numeric(disease_1895[nrow(disease_1895), "Measles"]),
						  as.numeric(disease_1895[nrow(disease_1895), "Fever--typhoid"]))

disease_table = data.table("Year" = c(1895, 1905, 1915),
						   "Whooping_Cough" = c(totals_1895_extracted[1], whoopch_1905_total, whoopch_1915_total),
						   "Measles" = c(totals_1895_extracted[2], measles_1905_total, measles_1915_total),
						   "Typhoid_Fever" = c(totals_1895_extracted[3], typhoid_1905_total, typhoid_1915_total))

# Exporting as an image because it is easier to insert into Google Docs, if only SVG were a standard format.
png(filename = "out/baltimore_plot%d.png", width = 512, height = 512)
plot(disease_table$Year, disease_table$Whooping_Cough, type = "l", ylim=c(0, 200), col = 1, xlab = "Year", ylab = "Fatalities")
lines(disease_table$Year, disease_table$Measles, col = 2)
lines(disease_table$Year, disease_table$Typhoid_Fever, col = 3)
legend(x = "topleft", legend=c("Whooping Cough", "Measles", "Typhoid Fever"), col=c(1, 2, 3), pch = 15)
dev.off()
