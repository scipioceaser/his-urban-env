library(ggmap)
library(ggplot2)
library(sf)
library("data.table")

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

ward_shape = read_sf(dsn = "data/GIS/Baltimore", layer = "baltimore_wards_1919_1930")

water_shape_frame = as.data.table(water_shape)
water_shape_frame = water_shape_frame[WaterDate > 0]

ggplot() +
    geom_sf(data = ward_shape, alpha = 0.8, aes(fill = Ward_Num)) +
    # geom_sf_label(data = ward_shape, aes(label = Ward_Num)) +
    geom_sf(data = water_shape) +
    geom_sf(data = st_as_sf(water_shape_frame[WaterDate > 1890 & WaterDate <= 1900]), color = "green") +
    geom_sf(data = st_as_sf(water_shape_frame[WaterDate > 1900]), color = "yellow") +
    geom_sf(data = st_as_sf(water_shape_frame[WaterDate <= 1890]), color = "red")
