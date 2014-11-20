RawBlameHistory   
all: plot

clean:
  rm -rf data plots 0*.md *.html *.pdf 2-exploratory-analysis 3-stat-analysis 4-generate-figures

.PHONY: all clean # all and clean are not file names
.DELETE_ON_ERROR: # delete any open files
  .SECONDARY: # don't delete all secondary files (not target)
  
  data/gm_data.tsv: 1-download-data.R
mkdir data plots
Rscript $<
  
  data/sorted_gm_data.txt plots/gdp-by-year.png 02_exploratory-analysis.html: 02_exploratory-analysis.R data/gm_data.tsv
Rscript $<
  Rscript -e "rmarkdown::render('$<')"

data/best_worst_data.txt data/gdp_rss_slope_data.txt plots/gdp-worst-fit.png plots/gdp-best-fit.png 03_statistical-analysis.html: 03_statistical-analysis.R data/sorted_gm_data.txt
Rscript $<
  Rscript -e "rmarkdown::render('$<')"

plot plots/best_worst_asia.png plots/best_worst_europe.png plots/best_worst_americas.png plots/best_worst_africa.png 04_plot.html: 04_plot.R data/best_worst_data.txt data/sorted_gm_data.txt
Rscript $<
  Rscript -e "rmarkdown::render('$<')"
rm -f Rplots.pdf