library(ggmap)
library(ggplot2)
library(sf)
library(data.table)
library(readxl)
library(viridis)

# TODO: Put this into a common utility script.
rstudio_clear_plots = function()
{
    # If RStudio has created any plots, clear them.
    if (exists("dev")) {
        x = dev.list()["RStudioGD"]
        if (!is.null(x)) { dev.off(x) }    
    }
}

working_dir_setlocal = function()
{
	# From: https://stackoverflow.com/questions/13672720/
	setwd(getSrcDirectory(function(){})[1])
}

rstudio_clear_plots()
# working_dir_setlocal()

# NOTE: Png draws faster than plot or PDF
# NOTE: Line width?
# NOTE: sf_intersection, st_length helps with intersecting wards and streets, work on ward geometry
# sf_intersection(pipes, wards)
# Draw over, ADD = TRUE and RESET = FALSE

water_shape = read_sf(dsn = "data/GIS/Baltimore",
                      layer = "CPE_Baltimore_Sanitation_Infrastructure")

# TODO: Check and make sure that the ward *numbers* remain consistent.
ward_shape = read_sf(dsn = "data/GIS/Baltimore", layer = "baltimore_wards_1902_1918")

# png(width = 2000, height = 2000)
# plot(ward_intersect[, "W_PipeLeng", "geometry"])
# dev.off()

water_shape_frame = as.data.table(water_shape)
water_shape_frame = water_shape_frame[WaterDate > 0 & WaterDate < 1918]

# So far so good, GIS data seems to be a bit better organized than Excel data.
shape_table = as.data.table(ward_shape)
shape_table = shape_table[order(Ward_Num)]

plot_pipe_density_slice = function(water)
{
    ws = as.data.table(ward_shape)
    ws = ws[order(Ward_Num)]
 	   
    intersection = as.data.table(st_intersection(ward_shape, st_as_sf(water)))
    intersection[W_PipeLeng == 8888] = 0
    
    by_ward_size = aggregate(intersection$W_PipeLeng, list(intersection$Ward_Num), sum)
    by_ward_size = as.data.table(by_ward_size)
    
    # First is zero (for some reason), ignore that
    ws$W_PipeLeng = by_ward_size$x[2:25]
    ws$Density = ws$W_PipeLeng / ws$SHAPE_Leng
    
    sf = st_as_sf(ws[, c("Density", "geometry")])
    
    plot(sf, pal = gray.colors)
}

plot_pipe_waterdate = function(water, ward)
{
    frame = as.data.table(water)[between(WaterDate, 1890, 1910)]
    plot(st_as_sf(frame[, c("WaterDate", "geometry")]), pal = viridis::magma, reset = F)

    frame = as.data.table(water)[WaterDate < 1890 | WaterDate > 1910]
    plot(st_as_sf(frame[, c("WaterDate", "geometry")]), pal = viridis::cividis, add = T)
    
    frame = as.data.table(ward)
    plot(ward[, "geometry"], pal = gray.colors, add = T)
}

plot_pipe_changing = function(water)
{
	frame = as.data.frame(water)

	plot(rep(1, 1000), type = 'l')
}

plot_pipe_disease = function(ward, water)
{
    ws = as.data.table(ward)
    ws = ws[order(Ward_Num)]

	raw_ward_data = read_excel("data/Baltimore_1910_ScarletFever.xlsx")
	get_fever_row_sum = function(offset)
	{
		# TODO: There has to be some sort of way that we can optimize this.
		ward = lapply(raw_ward_data[6 + offset, 50:53], gsub, pattern=".....", replacement=0)
		ward = sum(as.numeric(ward))
		return(ward)
	}

	ws$fever = seq(from = 1, to = 24)
	for (i in 0:23) {
		ws$fever[i + 1] = get_fever_row_sum(i)
	}

    plot(st_as_sf(ws[, c("fever", "geometry")]), pal = gray.colors, reset = F)

	frame = as.data.table(water)[WaterDate != 0 & WaterDate <= 1910]

    plot(st_as_sf(frame[, "geometry"]), add = T)
}

# Emit plots
shape = as.data.table(water_shape)
png(filename = "out/plot%d.png", width = 2000, height = 2000)
plot_pipe_density_slice(shape[WaterDate != 0])
plot_pipe_waterdate(water_shape, ward_shape)
plot_pipe_disease(ward_shape, water_shape)
# plot_pipe_changing(water_shape)
dev.off()
