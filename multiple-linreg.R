# load libraries
library(stargazer) # for summary statistics and regression output
library(car) # to check VIF

# load MyAnimeList dataset into R
mal <- read.csv(file.choose(), header = T, encoding = "UTF-8")

# view categories
summary(mal$type)

# subset data to anime movies that have scores and ranks
movie.list <- subset(mal, mal$type=="Movie" &
                       mal$score > 0 &
                       mal$rank > 0)
movie.list$type <- droplevels(movie.list$type)
summary(movie.list$type) # check subset for types

# obtain summary statistics
stargazer(movie.list[c("popularity","rank","favorites","members","score")], type = "text",
          summary.stat = c("n", "min", "max", "median", "mean", "sd"),
          title="Descriptive Statistics", digits=2, out="pr4_desc_stats.txt",
          covariate.labels=c("Popularity","Rank","Favorites","Members","Score"))

# save regression model as an object
movie.mlr <- lm(score ~ popularity + rank + members + favorites, data = movie.list)

# check regression assumptions with diagnostic plots
par(mfrow = c(2,2)) # view on all on a 2x2 grid
plot(movie.mlr)
par(mfrow = c(1,1)) # return plot viewing to default

# obtain VIF scores for each IV
vif(movie.mlr) 
mean(vif(movie.mlr))

# if popularity is removed, VIF scores improve
vif(lm(score ~ rank + members + favorites, data = movie.list))

# view regression analysis
summary(movie.mlr)

# calculate cohen's f^2
0.6458 / (1-0.6458) # 1.8, huge eff sz

# generate stargazer regression output
stargazer(movie.mlr, type="html",
          title = "Regression Results",
          dep.var.labels = "Average Anime Movie Score",
          covariate.labels = c("Popularity","Rank","Members","Favorites"),
          out="pr4_reg_results.html")