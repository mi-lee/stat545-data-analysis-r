shinyUI(fluidPage(
	theme = "bootstrap.css",
	titlePanel("Shiny: Exploring Gapminder Data"),
	
	sidebarLayout(
		sidebarPanel(uiOutput("choose_country"),
								 checkboxInput("multipleBox", label = "Multiple countries?", value = FALSE),
								 uiOutput("choose_x_axis"),
								 uiOutput("choose_y_axis"),
								 sliderInput("year_range", 
								 						label = "Range of years:",
								 						min = 1952, max = 2007, 
								 						value = c(1955, 2005),
								 						format = "####")
		),
		mainPanel(
			tabsetPanel(type="tabs",
									### Plot tab
									tabPanel("Plots",
													 h3(textOutput("output_country")),
													 h4(textOutput("output_vars")),
													 textOutput("output_years"),
													 plotOutput("ggplot")),
									### Data table tab
									tabPanel("Data", textOutput("table_about"), tableOutput("gapminder_table")),
									### About tab
									tabPanel("About", textOutput("about"), imageOutput("hans_rosling"))
			)
		)
	)
))
