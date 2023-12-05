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
12
