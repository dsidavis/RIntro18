
boxplot(davis$price ~ davis$bedrooms)

# davis is the DavisRaw.rds

# Price related to the number of bedrooms
ggplot(davis, aes(bedrooms, price, group = bedrooms)) + geom_boxplot()


# Change the horizontal axis label
ggplot(davis, aes(bedrooms, price, group = bedrooms)) + geom_boxplot() + xlab("Number of Bedrooms")



# price versus bedrooms, but color each point with the number of baths.

ggplot(davis) + geom_point(aes(bedrooms, price, shape = bath)) # error

ggplot(davis) + geom_point(aes(bedrooms, price, shape = ordered(bath)))
ggplot(davis) + geom_point(aes(bedrooms, price, color = ordered(bath))) # use colors

# Wrong title on the legend, so let's specify this.
# Look at stack overflow and learn how to find the answer.
# Google
#     ggplot change legend title
# https://stackoverflow.com/questions/14622421/how-to-change-legend-title-in-ggplot

ggplot(davis) + geom_point(aes(bedrooms, price, color = ordered(bath))) + labs(color = "Baths")



# Price versus sqft by type of unit.
ggplot(davis, aes(sqft, price)) + geom_point(aes(shape = type))

# Show the number of bedrooms.
ggplot(davis, aes(sqft, price)) + geom_point(aes(color = ordered(bedrooms), shape = type)) + labs(color = "Bedrooms")


# Split into a separate panel for each level of type
ggplot(davis, aes(sqft, price)) + geom_point(aes(color = ordered(bath))) + labs(color = "Bedrooms") + facet_grid( ~ type)

# Arrange in a 2 x 3 grid by wrapping the facets by type and specifying the number of columns.
ggplot(davis, aes(sqft, price)) + geom_point(aes(color = ordered(bath))) + labs(color = "Bedrooms") + facet_wrap(~ type, ncol = 3)


# We are repeating the same plot and layers and arranging the result differently
# So create it once and rearrange
p = ggplot(davis, aes(sqft, price)) + geom_point(aes(color = ordered(bath))) + labs(color = "Bedrooms")

p + facet_wrap(~ type, ncol = 3)
p + facet_grid( ~ type)

ggplot(davis[!is.na(davis$type),], aes(sqft, price)) + geom_point(aes(color = ordered(bath))) + labs(color = "Bedrooms") + facet_wrap(~ type, ncol = 3)



# Show a smoothed average of price as sqft change.
ggplot(davis, aes(sqft, price)) + geom_point() + geom_smooth()

ggplot(davis, aes(sqft, price)) + geom_point() + geom_smooth(method = "lm")

# Don't show the confidence envelope
ggplot(davis, aes(sqft, price)) + geom_point() + geom_smooth(method = "lm", se = FALSE)

# Show two fitted lines, one for those units <= 2000 sqft and another for > 2000
davis$big = davis$sqft > 2000
ggplot(davis, aes(sqft, price)) + geom_point() + geom_smooth(method = "lm", aes(group = big))


# Two lines - one for houses and one for the rest
ggplot(davis, aes(sqft, price)) + geom_point() + geom_smooth(method = "lm", aes(group = type == "house"))
