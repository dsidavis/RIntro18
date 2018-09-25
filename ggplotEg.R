
boxplot(davis$price ~ davis$bedrooms)

# davis is the DavisRaw.rds
ggplot(davis, aes(bedrooms, price, group = bedrooms)) + geom_boxplot()


ggplot(davis, aes(bedrooms, price, group = bedrooms)) + geom_boxplot() + xlab("Number of Bedrooms")




ggplot(davis) + geom_point(aes(bedrooms, price, shape = bath) # error

ggplot(davis) + geom_point(aes(bedrooms, price, shape = ordered(bath)))
ggplot(davis) + geom_point(aes(bedrooms, price, color = ordered(bath))) # use colors

# Wrong title on the legend, so let's specify this.
# Look at stack overflow and learn how to find the answer.
# Google
#     ggplot change legend title
# https://stackoverflow.com/questions/14622421/how-to-change-legend-title-in-ggplot

ggplot(davis) + geom_point(aes(bedrooms, price, color = ordered(bath))) + labs(color = "Baths")


