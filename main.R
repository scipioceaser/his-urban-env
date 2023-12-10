# install.packages("readxl")
library("readxl")

data = read_excel("data/Baltimore_1910_ScarletFever.xlsx");
print(data)

rstudio_clear_plots = function()
{
	# If RStudio has created any plots, clear them.
    if (exists("dev")) {
        x = dev.list()["RStudioGD"]
        if (!is.null(x)) { dev.off(x) }    
    }
}

rstudio_clear_plots()

install.packages(c("readxl", "data.table", "dplyr"))
library("readxl")
data = read_excel("/Users/robertjastrzebski/Desktop/Utrecht RMA/Methods - Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6141,_1890-Philadelphia,_Interments_July_1890,_pg_490-09.xls")
library("data.table")

water_borne <- rbind(data[44, ], data[45, ], data[76, ], data[88, ])
water_borne      
