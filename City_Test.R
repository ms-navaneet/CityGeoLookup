library(readxl)
library(ggmap)
library(tidyverse)
city<- read_excel("C:/Users/msnav/Downloads/city_test.xlsx")
View(city)

#intialise and register Google API
#register_google(key = "API")


#store location details via Google API in location_df dataframe

location_df <- data.frame()
for (i in seq_len(nrow(city))) {
  location <- geocode(city$citymain_[i], output = "more")
  location$citymain_ <- city$citymain_[i]  #Add "citymain_" value 
  location_df <- rbind(location_df, location)
  }

location_new <- location_df %>%
  separate(address, into = paste0("address", 1:3), sep = ",")


final_dataframe <- data.frame(city = character(),
                            district = character(),
                            state = character(),
                            country = character(),
                            stringsAsFactors = FALSE)

# Iterate over each row in the location_new dataframe
for (i in 1:nrow(location_new)) {
  # Check the value of the 'type' column
  if (location_new$type[i] == "country") {
    new_row <- data.frame(city = location_new$citymain_[i],
                          district = NA,
                          state = NA,
                          country = location_new$address1[i],
                          stringsAsFactors = FALSE)
  } else if (location_new$type[i] == "administrative_area_level_1") {
    new_row <- data.frame(city = location_new$citymain_[i],
                          district = NA,
                          state = location_new$address1[i],
                          country = location_new$address2[i],
                          stringsAsFactors = FALSE)
  } else {
    new_row <- data.frame(city = location_new$citymain_[i],
                          district = location_new$address1[i],
                          state = location_new$address2[i],
                          country = location_new$address3[i],
                          stringsAsFactors = FALSE)
  }
  
  # Append the new row to the new dataframe
 final_dataframe <- rbind(final_dataframe, new_row)
}

view(final_dataframe)
write.csv(final_dataframe, "C:/Users/msnav/Documents/cities.csv", row.names=FALSE)
