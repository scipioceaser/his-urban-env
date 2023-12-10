library(ggmap)
library(ggplot2)
library(sf)
library(data.table)
library(readxl)

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
working_dir_setlocal()

water_shape = read_sf(dsn = "data/GIS/Baltimore",
                      layer = "CPE_Baltimore_Sanitation_Infrastructure")

# TODO: Check and make sure that the ward *numbers* remain consistent.
ward_shape = read_sf(dsn = "data/GIS/Baltimore", layer = "baltimore_wards_1902_1918")

water_shape_frame = as.data.table(water_shape)
water_shape_frame = water_shape_frame[WaterDate > 0 & WaterDate < 1918]

raw_ward_data = read_excel("data/Baltimore_1910_ScarletFever.xlsx")

# So far so good, GIS data seems to be a bit better organized than Excel data.

get_fever_row_sum = function(offset)
{
	# TODO: There has to be some sort of way that we can optimize this.
	ward = lapply(raw_ward_data[6 + offset, 50:53], gsub, pattern=".....", replacement=0)
	ward = sum(as.numeric(ward))
	return(ward)
}

ws = as.data.table(ward_shape)
ws = ws[order(Ward_Num)]

ws$fever = seq(from = 1, to = 24)
for (i in 0:23) {
	ws$fever[i + 1] = get_fever_row_sum(i)
}

ggplot() +
    geom_sf(data = ward_shape, alpha = 0.8) +
    scale_fill_viridis_c() +
    geom_sf(data = st_as_sf(ws), aes(fill = fever)) +
    geom_sf(data = st_as_sf(water_shape_frame), aes(color = WaterDate))

    # geom_sf_label(data = ward_shape, aes(label = Ward_Num)) +
    # geom_sf(data = water_shape) +

    # geom_sf(data = st_as_sf(water_shape_frame[WaterDate > 1890 & WaterDate <= 1900]), color = "green") +
    # geom_sf(data = st_as_sf(water_shape_frame[WaterDate > 1900]), color = "yellow") +
    # geom_sf(data = st_as_sf(water_shape_frame[WaterDate <= 1890]), color = "red")
