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
  
  sorted_gapminder.tsv plots/gdp-quantile.png 2-exploratory-analysis.html: 2-exploratory-analysis.R gapminder.tsv
Rscript $<
  Rscript -e "rmarkdown::render('$<')"

best-worst-gapminder.tsv 3-stat-analysis.html: 3-stat-analysis. sorted_gapminder.tsv
Rscript $<
  Rscript -e "rmarkdown::render('$<')"

plot plots/r-sq-americas.png plots/r-sq-europe.png plots/r-sq-oceania.png plots/r-sq-africa.png plots/r-sq-asia.png 4-generate-figures.R.html: 4-generate-figures.R best-worst-gapminder.tsv sorted_gapminder.tsv
Rscript $<
  Rscript -e "rmarkdown::render('$<')"
rm -f Rplots.pdf