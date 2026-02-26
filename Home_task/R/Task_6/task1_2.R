library(dplyr)
library(leaflet)

# Прочитати дані про дитячі садки. Записати у файл ті, що мають більше трьох груп. Відобразити на карті всі садки з можливістю фільтрації по кількості груп (максимум може бути 5 груп).

dnz_data <- read.csv('sadky_real.txt', sep = ';', header = TRUE)
View(dnz_data)


dnz_filtered_file <- dnz_data %>%
  filter(lotQuantity > 3) %>%
  select(name, Address, lotQuantity,status)
View(dnz_filtered_file)

output_file_name <- "dnz_groups_more_than_3.txt"
write.table(
  x = dnz_filtered_file, 
  file = output_file_name, 
  sep = "\t",          
  col.names = TRUE,    
  row.names = FALSE,   
  quote = FALSE        
)
cat("дані про садки з > 3 групами успішно записано у файл:", output_file_name, "\n")



groups_1<-filter(dnz_data, lotQuantity ==1)
groups_2<-filter(dnz_data, lotQuantity ==2)
groups_3<-filter(dnz_data, lotQuantity ==3)
groups_4<-filter(dnz_data, lotQuantity >=4)

leaflet() %>% 
  addTiles() %>%
  addCircleMarkers(
    lng = groups_1$lon,
    lat = groups_1$lat,
    radius =  10,
    color = 'green',
    
    popup = paste0(
      'Address: ', groups_1$Address,
      '<br>Quantity: ', groups_1$lotQuantity,
      '<br>status: ', groups_1$status
    ),
    group = 'groups_1'
  ) %>%
  addCircleMarkers(
    lng = groups_2$lon,
    lat = groups_2$lat,
    radius =  10,
    color = 'red',
    
    popup = paste0(
      'Address: ', groups_2$Address,
      '<br>Quantity: ', groups_2$lotQuantity,
      '<br>status: ', groups_2$status
    ),
    group = 'groups_2'
  ) %>%
  addCircleMarkers(
    lng = groups_3$lon,
    lat = groups_3$lat,
    radius =  10,
    color = 'orange',
    
    popup = paste0(
      'Address: ', groups_3$Address,
      '<br>Quantity: ', groups_3$lotQuantity,
      '<br>status: ', groups_3$status
    ),
    group = 'groups_3'
  ) %>%
  addCircleMarkers(
    lng = groups_4$lon,
    lat = groups_4$lat,
    radius =  10,
    color = 'blue',
    
    popup = paste0(
      'Address: ', groups_4$Address,
      '<br>Quantity: ', groups_4$lotQuantity,
      '<br>status: ', groups_4$status
    ),
    group = 'groups_4'
  ) %>%
  addLayersControl(
    overlayGroups = c('groups_1', 'groups_2', 'groups_3', 'groups_4')
  )




#task 1
# Створити інфіксну функцію *, що прийманє два булеві елементи  та виконує логічну операцію AND

'*'<- function(a,b) {
  return(a&b)
}

TRUE*TRUE
TRUE*FALSE
FALSE*FALSE







































leaflet(dnz_data) %>% 
  addTiles() %>%
  addMarkers(
    lng = dnz_data$lon,
    lat = dnz_data$lat,
    label = '  ',
    popup = paste0(
      'Address: ', dnz_data$Address,
      '<br>Quantity: ', dnz_data$lotQuantity,
      '<br>status: ', dnz_data$status
    )
  )
