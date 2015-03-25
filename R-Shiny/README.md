HW11: Shiny
==========================

## Accessing the app

The app has been deployed to shinyapps.io. The link is **[here!](https://mmlee.shinyapps.io/gapminder)**

## Some features I added to the assignment

* Drop down menu for X and Y axis in choosing variables
* Tabs to separate graphs, tables, and an about page
* Using [bootstrap.css](https://github.com/STAT545-UBC/zz_michelle_lee-coursework/blob/master/HW11/gapminder/www/bootstrap.css) for nicer-looking format
* Plotting data points for multiple countries, through different colour schemes 
* Informative (reactive) title to describe the graph


## Summary of files

* [ui.r](https://github.com/STAT545-UBC/zz_michelle_lee-coursework/blob/master/HW11/gapminder/ui.R),
* [server.r](https://github.com/STAT545-UBC/zz_michelle_lee-coursework/blob/master/HW11/gapminder/server.R), 
* [bootstrap.css](https://github.com/STAT545-UBC/zz_michelle_lee-coursework/blob/master/HW11/gapminder/www/bootstrap.css), 
* [shinyapps folder](https://github.com/STAT545-UBC/zz_michelle_lee-coursework/tree/master/HW11/gapminder/shinyapps/mmlee), 
* and the [data](https://github.com/STAT545-UBC/zz_michelle_lee-coursework/blob/master/HW11/gapminder/gapminderDataFiveYear.txt). 

## Reflections

* Shiny is slow, and on my (very old) laptop, running and deploying the app took a lot of time - enough time for tea and coffee runs...

* It's great that I can create a web app without knowledge of Javascript, but apps on Shiny can be clunky. Honestly looking forward to learning JS so I can make nicer ones. 

### Unsolved issues

* I am certain there is someone who knows how to do this, but after a long time I still couldn't figure it out:
	+ What is the best way to use a variable such as `input$x_var` and use it within the context of ggplot, such as `ggplot(aes(x=input$x_var, y=input$y_var))`?  This will return a message like `input cannot be found`.
	+ I tried all sorts of tricks such as `as.character`, `eval(parse(text = var))`, etc... 
	
* A more general question related to the above problem: When creating custom functions and a desired input is the column name (e.g. variable), how can you convert that string into calling the data? For example something very simple such as

```
fun <- function(data, var) {
	data$var
}
```

This returns `NULL`. I saw that Hadley Wickham's functions will use `.variables` and `.variables <- as.quoted(.variables)`, but I can't seem to get it to work... I would *very* much appreciate some guidance!
 

Enjoy!

![hansrosling](http://lh6.ggpht.com/_H14qvQBzS-Y/TSU1RmdCHNI/AAAAAAAALpE/oHD8MWY_-5Y/hans_rosling_bbc.jpg)