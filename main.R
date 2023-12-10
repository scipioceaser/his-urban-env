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

library("data.table")



data1890jan = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ - Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6120,_1890-Philadelphia,_Interments_in_the_City_of_Philadelphia_January_1890,_p358-79.xls")
data1890feb = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ -\ Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6121,_1890-Philadelphia,_Interments_in_the_City_of_Philadelphia_February_1890,_1890,_p382-01.xls")
data1890mar = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ -\ Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6123,_1890-Philadelphia,_Interments_in_the_the_City_of_Philadelphia_March_1890,_p404-21.xls")
data1890apr = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ -\ Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6124,_1890-Philadelphia,_Interments_in_the_City_of_Philadelphia_April_1890,_1890,_p424-42.xls")
data1890may = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ -\ Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6125,_1890-Philadelphia,_Interments_in_the_City_of_Philadelphia_May_1890,_1890,_p446-65.xls")
data1890jun = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ -\ Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6126,_1890-Philadelphia,_Interments_June_1890,_1890,_p468-87.xls")
data1890jul = read_excel("/Users/robertjastrzebski/Desktop/Utrecht RMA/Methods - Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6141,_1890-Philadelphia,_Interments_July_1890,_pg_490-09.xls")
data1890aug = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ -\ Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6142,_1890-Philadelphia,_Interments_August_1890,_p512-29.xls")
data1890sep = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ -\ Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6155,_1890-Philadelphia,_Interments_September_1890,_1890,_p532-47.xls")
data1890oct = read_excel("/Users/robertjastrzebski/Desktop/Utrecht RMA/Methods - Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6156,_1890-Philadelphia,_Interment_in_the_City_of_Philadelphia_October_1890,_1890,_p550-67.xls")

#We are missing data for November - Likely does not make a huge difference as waterborne illnesses generally peak during periods of warm weather#
data1890dec = read_excel("/Users/robertjastrzebski/Desktop/Utrecht\ RMA/Methods\ -\ Quantitative/Project/philadelphia/Philadelphia_1890/1890_WL-SID452,_TID6171,_1890-Philadelphia,_Interments_December_1890,_1890,_p590-07.xls")

water_borne1890jan <- rbind(data1890jan[46, ], data1890jan[47, ], data1890jan[80, ], data1890jan[95, ])
water_borne1890feb <- rbind(data1890feb[36, ], data1890feb[64, ], data1890feb[82, ])
water_borne1890mar <- rbind(data1890mar[34, ], data1890mar[63, ], data1890mar[78, ])
water_borne1890apr <- rbind(data1890apr[46, ], data1890apr[70, ], data1890apr[84, ])
water_borne1890may <- rbind(data1890may[45, ], data1890may[74, ], data1890may[87, ])
water_borne1890jun <- rbind(data1890jun[36, ], data1890jun[37, ], data1890jun[67, ], data1890jun[81, ])
water_borne1890jul <- rbind(data1890jul[44, ], data1890jul[45, ], data1890jul[76, ], data1890jul[88, ])
water_borne1890aug <- rbind(data1890aug[37, ], data1890aug[38, ], data1890aug[62, ], data1890aug[74, ])
water_borne1890sep <- rbind(data1890sep[34, ], data1890sep[35, ], data1890sep[62, ], data1890sep[70, ])
water_borne1890oct <- rbind(data1890oct[44, ], data1890oct[45, ], data1890oct[70, ], data1890oct[80, ])
water_borne1890dec <- rbind(data1890dec[35, ], data1890dec[36, ], data1890dec[63, ], data1890dec[72, ])

water_borne1890dec

data1900 = read_excel("")


