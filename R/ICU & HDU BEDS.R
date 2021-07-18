#loading packages
library(RSelenium)
library(XML)
library(dplyr)

#url to scrape data from
url <- 'https://www.anesthesiaug.org/build'


driver <-
  rsDriver(
    browser = c("chrome"),
    chromever = "91.0.4472.101",
    verbose = FALSE,
    extraCapabilities = list("chromeOptions" = list(args = list('--headless')))
  )
remote_driver <- driver[["client"]]
remote_driver$navigate(url)
Sys.sleep(10)
html1 <- remote_driver$findElement(using = 'xpath', '//*[@id="root"]/div/div/div[2]/div/table')

data <- html1$getElementAttribute('outerHTML')[[1]]

data <- readHTMLTable(data, header = TRUE, as.data.frame = TRUE)[[1]]

data <- data %>% mutate(Date = paste0(Sys.time()))

data <- data[, c(6, 1:5)]

original_data <- read.csv('./Datasets/Dataset.csv')

colnames(original_data) <-
  c(
    "Date",
    "Hospital",
    "Respiratory support offered",
    "Bed capacity",
    "Beds available",
    "Waiting numbers"
  )

updated <- rbind(original_data, data)

write.csv(data, './Datasets/update.csv', row.names = FALSE)

write.csv(updated, './Datasets/Dataset.csv', row.names = FALSE)
