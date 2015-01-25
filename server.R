### ShinyServer function
shinyServer(function(input, output) {

  # Load data and packages
  setRegions = as.vector(unique(origDat$Region))
  setRegions = setNames(setRegions, setRegions)
  
  output$regionSelector = renderUI({
          selectInput("region", "Select a region", choices = setRegions)
  })
          
  output$region = renderText({input$region})

  output$text1 = renderUI({
    line1 = paste("Dots represent the yearly literacy rates for ",input$region, ".", sep="")
    line2 = paste("Lines represent the mean literacy rates across all regions with reported data.", sep="")
    HTML(paste(line1, line2, sep='<br/>'))
  })
    
  dataInput = reactive({
    subDat = allDat[allDat$Region==input$region,]
    subDat
  })

  output$table = renderTable({
    data.in = data.frame(dataInput())
    names(data.in) = c("Region", "Year", "gender", "ageGroup", "unit", "Literacy Rate", "meanlit")
    data.in[,"Literacy Rate"] = percent( round(data.in[,"Literacy Rate"], digits=0)/100 ) 
    data.in = data.in[order(data.in$Year),]
    xtable(data.in[data.in$gender=="All genders", c("Region", "Year", "Literacy Rate")])}, include.rownames=FALSE
)

   output$litplot = renderPlot( {
    theme_set = theme_grey()
    theme_literacy = theme(axis.text=element_text(size=14, face="bold"), 
                           axis.title.x=element_text(size=14, face="bold"), 
                           axis.title.y=element_text(size=14, face="bold"),
                           plot.title=element_text(size=16, face="bold"),
                           legend.text=element_text(size=12, face="bold"),
                           legend.title=element_text(size=14, face="bold"))
    subDat = dataInput()
    #Convert data frame from wide to long using reshape2 package commmand melt
    longdat = melt(subDat, id.vars=c("Region", "year", "gender", "ageGroup", "unit"), variable.name="group")
    longdat$group = factor(longdat$group, levels=c("litRate", "meanlit"), labels=c("Region", "UN Mean Rate"))
    dat = longdat[longdat$gender!="All genders",]  
    dat[,"value"] = dat[,"value"]/100
    dat$gender = factor(dat$gender)

    g = ggplot(dat, 
               aes(year, value, color=gender, linetype=gender)) + 
      geom_point(aes(x=year, y=value, color=gender), dat[dat$group=="Region",],size=5) + 
      theme_literacy + 
      labs(x="Year", y="Literacy Rate") + xlim(c(1975,2013)) +
      ggtitle(paste("Literacy Rates Among 15-24 Year-olds in", input$region, "\n Compared with Mean Literacy Rate")) +
      geom_line(aes(x=year, y=value, color=gender, linetype=gender), dat[dat$group=="UN Mean Rate",], lwd=2) +
      scale_linetype_manual("UN Mean Literacy Rate", breaks=c("Female", "Male"), values=c(1,1)) + 
      scale_color_manual(input$region, breaks=c("Female", "Male"), 
                         values=c("Female"= "#F8766D", "Male"= "#00BFC4")) +
      scale_y_continuous(labels=percent, limits=c(0,1)) +
      guides(color=guide_legend(override.aes=list(shape=c(16, 16), linetype=c(0,0)))) +
      guides(linetype=guide_legend(override.aes=list(colour=c("#F8766D", "#00BFC4"))))

    print(g)
  }, height=400)  #end renderPlot
  
})  #end shinyServer


