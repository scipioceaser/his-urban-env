# Libraries

library(data.table)
library(sf)
library(viridis)
library(readxl)

# Utilities

clean_data_table = function(table)
{
	table[table == "….."] <- 0
	table[table == "....."] <- 0
	table[table == "......"] <- 0
	table[table == "…../..."] <- 0
	table[is.na(table)] <- 0
	table[table == "2....."] <- 2
	table[table == "......."] <- 0
	table[table == "...."] <- 0

	return(table)
}

load_1890_data = function()
{
	data1890jan = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6120,_1890-Philadelphia,_Interments_in_the_City_of_Philadelphia_January_1890,_p358-79.xls")
	data1890feb = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6121,_1890-Philadelphia,_Interments_in_the_City_of_Philadelphia_February_1890,_1890,_p382-01.xls")
	data1890mar = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6123,_1890-Philadelphia,_Interments_in_the_the_City_of_Philadelphia_March_1890,_p404-21.xls")
	data1890apr = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6124,_1890-Philadelphia,_Interments_in_the_City_of_Philadelphia_April_1890,_1890,_p424-42.xls")
	data1890may = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6125,_1890-Philadelphia,_Interments_in_the_City_of_Philadelphia_May_1890,_1890,_p446-65.xls")
	data1890jun = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6126,_1890-Philadelphia,_Interments_June_1890,_1890,_p468-87.xls")
	data1890jul = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6141,_1890-Philadelphia,_Interments_July_1890,_pg_490-09.xls")
	data1890aug = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6142,_1890-Philadelphia,_Interments_August_1890,_p512-29.xls")
	data1890sep = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6155,_1890-Philadelphia,_Interments_September_1890,_1890,_p532-47.xls")
	data1890oct = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6156,_1890-Philadelphia,_Interment_in_the_City_of_Philadelphia_October_1890,_1890,_p550-67.xls")
	data1890dec = read_excel("data/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6171,_1890-Philadelphia,_Interments_December_1890,_1890,_p590-07.xls")

	water_borne1890jan <- rbind(data1890jan[46, ], data1890jan[47, ], data1890jan[80, ], data1890jan[95, ])
	water_borne1890feb <- rbind(data1890feb[36, ], data1890feb[64, ], data1890feb[79, ], data1890feb[82, ])
	water_borne1890mar <- rbind(data1890mar[34, ], data1890mar[63, ], data1890mar[73, ], data1890mar[78, ])
	water_borne1890apr <- rbind(data1890apr[46, ], data1890apr[70, ], data1890apr[80, ], data1890apr[84, ])
	water_borne1890may <- rbind(data1890may[45, ], data1890may[74, ], data1890may[84, ], data1890may[87, ])
	water_borne1890jun <- rbind(data1890jun[36, ], data1890jun[37, ], data1890jun[67, ], data1890jun[81, ])
	water_borne1890jul <- rbind(data1890jul[44, ], data1890jul[45, ], data1890jul[76, ], data1890jul[88, ])
	water_borne1890aug <- rbind(data1890aug[37, ], data1890aug[38, ], data1890aug[62, ], data1890aug[74, ])
	water_borne1890sep <- rbind(data1890sep[34, ], data1890sep[35, ], data1890sep[62, ], data1890sep[70, ])
	water_borne1890oct <- rbind(data1890oct[44, ], data1890oct[45, ], data1890oct[70, ], data1890oct[80, ])
	water_borne1890dec <- rbind(data1890dec[35, ], data1890dec[36, ], data1890dec[63, ], data1890dec[72, ])

	object_list <- list(water_borne1890jan, water_borne1890feb, water_borne1890mar, 
						water_borne1890apr, water_borne1890may, water_borne1890jun, 
						water_borne1890jul, water_borne1890aug, water_borne1890sep, 
						water_borne1890oct, water_borne1890dec)

	water_borne = as.data.table(rbind(Reduce(function(x, y) merge(x, y, all=TRUE), object_list)))
	water_borne = clean_data_table(water_borne)
	water_borne_trans = t(water_borne[, 27:60])

	colnames(water_borne_trans) = water_borne$PHILADELPHIA
	water_borne_trans = water_borne_trans[c(-1), ]
	water_borne_numeric = apply(water_borne_trans, 2, as.numeric)
	water_borne_numeric = sapply(unique(colnames(water_borne_numeric)), function(x) rowSums(water_borne_numeric[, grepl(x, colnames(water_borne_numeric))]))

	colnames(water_borne_numeric) = gsub(" ", "_", colnames(water_borne_numeric))
	colnames(water_borne_numeric)[1] = "Malaria"
	colnames(water_borne_numeric)[2] = "Cholera_Morbus"
	colnames(water_borne_numeric)[3] = "Typhoid"
	water_borne_numeric = as.data.table(water_borne_numeric)

	water_borne_numeric[, Cholera := Cholera_Morbus + CHOLERA_INFANTUM]
	water_borne_numeric[, WaterBorne := as.numeric(Cholera) + as.numeric(Typhoid) + as.numeric(Malaria)]

	return(water_borne_numeric)
}

load_1910_data = function()
{
	data1910fy = read_excel("data/philadelphia/Philadelphia_1910/1910_WL-SID314,_TID3344,_1910-Philadelphia,_Causes_of_Death_Distributed_By_Ward_1910,_pgs_unknown.xlsx")

	water_borne = clean_data_table(as.data.table(data1910fy)[, c(1, 41:87)])
	water_borne = water_borne[c(-1:-3)]
	water_borne = water_borne[c(-2:-4)]
	water_borne = t(water_borne)

	colnames(water_borne) = water_borne[1, ]
	water_borne = water_borne[c(-1), ]
	rownames(water_borne) = NULL
	water_borne = water_borne[, c(-1)]
	colnames(water_borne) = gsub(" ", "_", colnames(water_borne))
	lapply(water_borne, as.numeric)
	water_borne = as.data.table(water_borne)

	water_borne[, WaterBorne := as.numeric(CHOLERA_NOSTRAS) + as.numeric(TYPHOID_FEVER) + as.numeric(MALARIAL_FEVER)]

	return(water_borne)
}

# Main

draw_1910_plot = function()
{
	sewer_shape = read_sf(dsn = "data/GIS/Philadelphia", layer = "CPE_Philadelphia_Sanitation_Infrastructure")
	ward_shape = read_sf(dsn = "data/GIS/Philadelphia", layer = "philadelphia_wards_1907_1913")

	sewer_table = as.data.table(sewer_shape)[WaterDate != 0 & WaterDate <= 1910]
	sewer_shape = st_as_sf(sewer_table)

# TODO: Maybe also divide incidence by total piping?
	water_borne_1910 = load_1910_data()

	ward_table = as.data.table(ward_shape)
	ward_table = ward_table[order(Ward_Num)]

	ward_table$Water_Borne_1910 = water_borne_1910$WaterBorne

	plot(st_as_sf(ward_table[, c("Water_Borne_1910", "geometry")]), reset = F, main = "Deaths from Cholera, Typhoid, and Malaria in 1890")
	plot(sewer_shape[, "geometry"], add = T, xaxt = "n")
}

draw_1890_plot = function()
{
	sewer_shape = read_sf(dsn = "data/GIS/Philadelphia", layer = "CPE_Philadelphia_Sanitation_Infrastructure")
	ward_shape = read_sf(dsn = "data/GIS/Philadelphia", layer = "philadelphia_wards_1888")

	sewer_table = as.data.table(sewer_shape)[WaterDate != 0 & WaterDate <= 1890]
	sewer_shape = st_as_sf(sewer_table)

	water_borne_1890 = load_1890_data()

	ward_table = as.data.table(ward_shape)
	ward_table = ward_table[order(Ward_Num)]
	
	ward_table$Water_Borne_1890 = water_borne_1890$WaterBorne

	ward_shape = st_as_sf(ward_table)

	plot(ward_shape[, c("Water_Borne_1890", "geometry")], reset = F, main = "Deaths from Cholera, Typhoid, and Malaria in 1910")
	plot(sewer_shape[, "geometry"], add = T)
}

png(filename = "out/philadelphia_gis_plot%d.png", width = 2000, height = 2000)
draw_1890_plot()
draw_1910_plot()
dev.off()
