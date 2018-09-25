lines = readLines("data.csv")

comments = grepl("!", lines)

lines = lines[ ! comments ]

unit = grepl("Unit", lines)
lines = lines[ ! unit ]

flow = read.csv(textConnection(lines), header = FALSE, stringsAsFactors = FALSE)
