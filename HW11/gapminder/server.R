library(ggplot2)
library(ggthemes)
gDat <- read.delim("gapminderDataFiveYear.txt") 

shinyServer(function(input, output) {
	
	# Drop-down selection box generated from Gapminder dataset
	output$choose_country <- renderUI({
		if(input$multipleBox){
			text = "Countries:"
		}
		else{
			text = "Country:"
		}
		selectInput("country_from_gapminder", text, as.list(levels(gDat$country)), multiple = input$multipleBox, selected = levels(gDat$country)[1])
	})
	
	# Selecting the variable for the X axis
	output$choose_x_axis <- renderUI({
		selectInput("x_var", "X axis", as.list(names(gDat)[c(2,3,5,6)]))
	})
	
	# Selecting the variable for the Y axis
	output$choose_y_axis <- renderUI({
		selectInput("y_var", "Y axis", as.list(names(gDat)[c(5,2,3,6)]))
	})
	
	# Country data for selected country
	one_country_data  <- reactive({
		if(is.null(input$country_from_gapminder)) {
			return(NULL)
		}
		subset(gDat, country  %in% input$country_from_gapminder & year >= input$year_range[1] & year <= input$year_range[2] )
	})
	
	# Header: country names
	output$output_country <- renderText({
		if(input$multipleBox){
			paste0(input$country_from_gapminder, sep=" | ")
		}
		else{
			paste(input$country_from_gapminder)
		}
	})
	
	# Header: variables chosen
	output$output_vars <- renderText({
		paste(input$x_var, " vs. ", input$y_var)
	})
	
	# Header: Years chosen
	output$output_years <- renderText({
		paste("The years selected are between", input$year_range[1], "and", input$year_range[2])
	})
	
	
	
	######## Data tab
	
	# Blurb for data table
	output$table_about <- renderText({
		paste0("The data table for the selected country and variables are below: ")
	})
	
	# Data table for selected country
	output$gapminder_table <- renderTable({ 
		one_country_data()
	})
	
	
	####### About tab
	
	# About blurb
	output$about <- renderText({
		paste0("This was made by Michelle Lee for STAT 547M Homework 12. Credits to RStudio tutorials, Dr Jenny Bryan and Ms. Julia Gustavsen's tutorial, and Hans Rosling, the creator of Gapminder!")
	})
	
	# Hans Rosling image
	output$hans_rosling <- renderImage({
		filename <- normalizePath(file.path("www/hans_rosling_bbc.jpg"))
		list(src = filename,
				 alt = "This is Hans Rosling, creator of Gapminder!")},
		deleteFile = FALSE)
	

	###### Plots	
	output$ggplot <- renderPlot({
		
		if(is.null(one_country_data())) {
			return(NULL)
		}
		if(input$x_var == "pop") {
			if(input$y_var == "pop") {
				p <-  ggplot(one_country_data(), aes(x = pop, y = pop))
			}
			else if(input$y_var == "lifeExp") {
				p <-  ggplot(one_country_data(), aes(x = pop, y = lifeExp))
			}
			else if(input$y_var == "gdpPercap") {
				p <-  ggplot(one_country_data(), aes(x = pop, y = gdpPercap))
			}
			else if(input$y_var == "year") {
				p <-  ggplot(one_country_data(), aes(x = pop, y = year))
			}
		}
		else if(input$x_var == "lifeExp") {
			if(input$y_var == "pop") {
				p <-  ggplot(one_country_data(), aes(x = lifeExp, y = pop))
			}
			else if(input$y_var == "lifeExp") {
				p <-  ggplot(one_country_data(), aes(x = lifeExp, y = lifeExp))
			}
			else if(input$y_var == "gdpPercap") {
				p <-  ggplot(one_country_data(), aes(x = lifeExp, y = gdpPercap))
			}
			else if(input$y_var == "year") {
				p <-  ggplot(one_country_data(), aes(x = lifeExp, y = year))
			}
		}
		else if(input$x_var == "gdpPercap") {
			if(input$y_var == "pop") {
				p <-  ggplot(one_country_data(), aes(x = gdpPercap, y = pop))
			}
			else if(input$y_var == "lifeExp") {
				p <-  ggplot(one_country_data(), aes(x = gdpPercap, y = lifeExp))
			}
			else if(input$y_var == "gdpPercap") {
				p <-  ggplot(one_country_data(), aes(x = gdpPercap, y = gdpPercap))
			}
			else if(input$y_var == "year") {
				p <-  ggplot(one_country_data(), aes(x = gdpPercap, y = year))
			}
		}
		
		else if(input$x_var == "year") {
			if(input$y_var == "pop") {
				p <-  ggplot(one_country_data(), aes(x = year, y = pop))
			}
			else if(input$y_var == "lifeExp") {
				p <-  ggplot(one_country_data(), aes(x = year, y = lifeExp))
			}
			else if(input$y_var == "gdpPercap") {
				p <-  ggplot(one_country_data(), aes(x = year, y = gdpPercap))
			}
			else if(input$y_var == "year") {
				p <-  ggplot(one_country_data(), aes(x = year, y = year))
			}
		}
		p + geom_point(aes(colour=country)) + geom_line(aes(colour=country)) + theme_minimal()
	})
})