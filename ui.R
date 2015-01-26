### UI function
shinyUI(pageWithSidebar(
  
#  setRegions = unique(origDat$Region),
#  names(setRegions) = setRegions
          
  ###  Application title
  headerPanel("Literacy Rates Across the Globe"),
  
  ### Sidebar with sliders 
  sidebarPanel(
    # Choose region  - ONLY 2nd one works and displays text; others diplay numeric
    # selectInput(inputId="region", label="Select a region", choices=setRegions)),
        uiOutput("regionSelector")
  ),
  
  ### Main Panel
  mainPanel(

    tabsetPanel(
            tabPanel("Plot", plotOutput("litplot")),
            tabPanel("Table", 
                h3("Reported Literacy Rates by Year"),
                p("(Ages 15-24, genders combined)"), br(),
                tableOutput("table")),
            tabPanel("About", 
                p("This app explores the literacy rates for ages 15-24 in more than 100 countries and territories using 
                UNESCO data.  Data are presented by country as well as by twelve Millenium 
                Development Goal (MDG) regions."), br(),
                p("Select a region in the sidebar panel window to update the Plot and Table tabs."), br(),
                p("The lines in the graph represent the mean literacy rate of all of the regions reporting to the UN at each 
                  year.  The number of countries reporting varies by year, so the mean is subject to underreporting bias.  In eight 
                  of the thirty-nine reporting years, under ten regions reported data.  In contrast, the UN reached a high of 84 
                  reporting regions in 2012."), br(),
                p("In order for this application to run on your local system, the set of files ui.R, server.R, and global.R
                   will need to be available in your working directory and the data set UNdata.csv in a subdirectory named Data."),
                br(),
                p("The data can be downloaded directly from UNESCO at 
                http://data.un.org/Data.aspx?d=UNESCO&f=series%3aLR_AG15T24.  The United Nations Educational, Scientific and Cultural Organization (UNESCO) Institute for Statistics 
                produces and manages data to monitor global tends on topics relevant for policy planning; one component of 
                their mission is to make the data easily accessible to the public.  See http://www.uis.unesco.org for more 
                information and to access data.")
)

    )    #tabsetPanel
  )      #mainPanel
  
))