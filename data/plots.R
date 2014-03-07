require(ggplot2)
require(maps)
library(grid)
library(plyr)

setwd('~/work/tt/elections14//maps')
dems <- read.csv('dem-winners.csv')
reps <- read.csv('rep-winners.csv')

tx <- map("state", "texas", plot=FALSE, fill=TRUE, colour=I("#fcc10f"))
tx_counties <- map("county", "texas", plot=FALSE, fill=TRUE, colour=I("#fcc10f"))
counties = map_data("county", region="texas")

p = ggplot()

tx_plot <- p + geom_polygon(data=tx, aes(x=long, y=lat, group=group), fill=I("gray70"))

plot_theme = theme(line = element_blank(),
                   text = element_blank(),
                   title = element_blank(),
                   panel.background = element_rect(fill="transparent", colour=NA),
                   plot.background = element_rect(fill="transparent", colour=NA))

dems$COUNTY <- tolower(dems$COUNTY)
reps$COUNTY <- tolower(reps$COUNTY)

dem_candidates <- unique(dems$CANDIDATE)
rep_candidates <- unique(reps$CANDIDATE)


mergedems <- merge(counties, dems, by.x="subregion", by.y="COUNTY")
mergedems <- arrange(mergedems, order)
mergereps <- merge(counties, reps, by.x="subregion", by.y="COUNTY")
mergereps <- arrange(mergereps, order)


plot_candidate <- function(candidate, candidate_name, col) {
  filename <- paste("png/", gsub(" ","-", tolower(candidate_name)), ".png", sep="")
  png(filename, bg="transparent", width=360, height=360)
  
  candidate_plot = tx_plot +
    geom_polygon(data=candidate, aes(x=long, y=lat, group=group, fill=PCT), color="black", size=0.2) +
    scale_fill_gradient2(low = "#EEEEEE", high = col, space = "rgb", guide = "colourbar") +
    plot_theme
  
  gt <- ggplot_gtable(ggplot_build(candidate_plot))
  ge <- subset(gt$layout, name == "panel")
  
  grid.draw(gt[ge$t:ge$b, ge$l:ge$r])
  dev.off()
}

plot_retina <- function(candidate, candidate_name, col) {
  filename <- paste("png/", gsub(" ","-", tolower(candidate_name)), "@2.png", sep="")
  png(filename, bg="transparent", width=720, height=720)
  
  candidate_plot = tx_plot +
    geom_polygon(data=candidate, aes(x=long, y=lat, group=group, fill=PCT), color="black", size=0.2) +
    scale_fill_gradient2(low = "#EEEEEE", high = col, space = "rgb", guide = "colourbar") +
    plot_theme
  
  gt <- ggplot_gtable(ggplot_build(candidate_plot))
  ge <- subset(gt$layout, name == "panel")
  
  grid.draw(gt[ge$t:ge$b, ge$l:ge$r])
  dev.off()
}

plot_reps <- function() {
  for (i in 1:length(rep_candidates)) {
    candidate_name <- rep_candidates[i]
    candidate <- subset(mergereps, CANDIDATE == candidate_name)
    plot_candidate(candidate, candidate_name, "#FF0000")
    plot_retina(candidate, candidate_name, "#FF0000")
  }
}

plot_dems <- function() {
  for (i in 1:length(dem_candidates)) {
    candidate_name <- dem_candidates[i]
    candidate <- subset(mergedems, CANDIDATE == candidate_name)
    plot_candidate(candidate, candidate_name, "#0015ff")
    plot_retina(candidate, candidate_name, "#0015ff")
  }
}

plot_reps()
plot_dems()
