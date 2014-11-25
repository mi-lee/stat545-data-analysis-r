all: HW9.html README.md

clean:
	rm -rf *.md *.html *.pdf plots

gapminder.tsv 1-download-data.html: 1-download-data.R
	Rscript 1-download-data.R
	Rscript -e 'rmarkdown::render("1-download-data.Rmd")'

sorted_gapminder.tsv gdp-quantile.png lifeExp-quantile.png lifeExp-density.png 2-exploratory-analysis.html: 2-exploratory-analysis.R gapminder.tsv
	Rscript 2-exploratory-analysis.R
	Rscript -e 'rmarkdown::render("2-exploratory-analysis.Rmd")'

best-worst-gapminder.tsv 3-stat-analysis.html: 3-stat-analysis.R sorted_gapminder.tsv
	Rscript 3-stat-analysis.R
	Rscript -e 'rmarkdown::render("3-stat-analysis.Rmd")'

plot r-sq-americas.png r-sq-europe.png r-sq-oceania.png r-sq-africa.png r-sq-asia.png 4-generate-figures.R.html: 4-generate-figures.R best-worst-gapminder.tsv sorted_gapminder.tsv
	Rscript 4-generate-figures.R
	Rscript -e 'rmarkdown::render("4-generate-figures.Rmd")'

HW9.html README.md: gdp-quantile.png lifeExp-density.png lifeExp-quantile.png r-sq-africa.png r-sq-americas.png r-sq-asia.png r-sq-europe.png r-sq-oceania.png README.rmd HW9.rmd
	Rscript -e 'rmarkdown::render("HW9.rmd")'
	Rscript -e 'rmarkdown::render("README.rmd")'