# Libraries

library(data.table)
library(sf)
library(viridis)

# Ignore pipes where the length is unknown (recorded as 8888)
philly_sewer_shape = read_sf(dsn = "data/GIS/Philadelphia", layer = "CPE_Philadelphia_Sanitation_Infrastructure")
philly_sewer_table = as.data.table(philly_sewer_shape)[W_PipeLeng != 8888 & W_PipeLeng != 9999]
philly_sewer_shape = st_as_sf(philly_sewer_table)

balti_sewer_shape = read_sf(dsn = "data/GIS/Baltimore", layer = "CPE_Baltimore_Sanitation_Infrastructure")
balti_sewer_table = as.data.table(balti_sewer_shape)[W_PipeLeng != 8888 & W_PipeLeng != 9999]
balti_sewer_shape = st_as_sf(balti_sewer_table)

year_min = 1870
year_max = 1930

# Grab data (turn into function)
get_pipe_totals_by_decade = function(table)
{
	decades = seq(year_min, year_max, 10)
	decadePipeTotals = array(numeric(), length(decades))
	for (i in 1:length(decades)) {
		pipeTotal = sum(table[WaterDate >= year_min & WaterDate <= decades[i]]$W_PipeLeng)
		decadePipeTotals[i] = pipeTotal
	}

	return(data.table(Year = decades, Total_Piping = decadePipeTotals))
}

balti_decade_totals = get_pipe_totals_by_decade(balti_sewer_table)
philly_decade_totals = get_pipe_totals_by_decade(philly_sewer_table)

png(filename = "out/total_piping.png", width = 512, height = 512)
plot(balti_decade_totals$Year, balti_decade_totals$Total_Piping,
	 col = 'black', type = 'l',
	 xlab = "Year", ylab = "Total piping (Feet)")
lines(philly_decade_totals$Year, philly_decade_totals$Total_Piping, col = 'red')
legend(x = 'topleft', legend=c("Baltimore", "Philadelphia"), col=c('black', 'red'), pch = 15)
dev.off()
