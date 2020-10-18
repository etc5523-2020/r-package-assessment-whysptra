library(shiny)
library(tidyverse)
library(coronavirus)
library(plotly)
library(scales)
library(htmltools)
library(lubridate)
library(shinyWidgets)
library(shinydashboard)
library(dashboardthemes)
library(data.table)
library(shinyjs)
library(DT)
# update_dataset()

#==============================================================================================#
##                                             Global                                         ##
#==============================================================================================#

# southeast <- coronavirus %>%
#   filter(
#     country %in% c(
#       "Indonesia",
#       "Singapore",
#       "Malaysia",
#       "Thailand",
#       "Laos",
#       "Vietnam",
#       "Philippines",
#       "Myanmar",
#       "Cambodia",
#       "Brunei",
#       "Timor-Leste"
#     ),
#     date <= "2020-09-25"
#   ) %>%
#   select(-province) %>%
#   drop_na()

our_theme <- theme_classic() + theme(
  rect = element_rect(fill = NA),
  text = element_text(color = "white", size = 10),
  panel.background = element_rect(fill = NA),
  axis.text = element_text(color = "white"),
  panel.border = element_rect(color = "white", size = 0.8),
  plot.title = element_text(
    size = 12,
    face = "bold",
    colour = "white"
  ),
  plot.subtitle = element_text(
    size = 15,
    face = "italic",
    colour = "white"
  ),
  axis.ticks = element_line(colour = "white")
)

#==============================================================================================#
##                                      User Interface                                        ##
#==============================================================================================#

ui <- dashboardPage(
  dashboardHeader(title = "COVID-19"),
  dashboardSidebar(width = 150,
                   sidebarMenu(
                     menuItem("About",
                              tabName = "dashboard",
                              icon = icon("question")),
                     menuItem(
                       "Resources",
                       icon = icon("database"),
                       tabName = "rdb",
                       startExpanded = TRUE,
                       menuSubItem("Continent", icon = icon("globe"), tabName = "rdbi"),
                       menuSubItem("Countries", icon = icon("flag"),  tabName = "rdbe"),
                       menuSubItem("References",icon = icon("book"),  tabName = "rdbo")
                     )
                   )),
  dashboardBody(
    tags$head(tags$style(
      HTML(
        ".well {
    background-color: rgba(0,0,0,.05)
}",
        ".selectize-dropdown, .selectize-input, .selectize-input input {
    color: #ffffff;
}",

        ".dataTables_wrapper .dataTables_paginate .paginate_button.disabled, .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover, .dataTables_wrapper .dataTables_paginate .paginate_button.disabled:active {
    cursor: default;
    box-shadow: none;
    color: #ffffff;
        }",

        "#DataTables_Table_0 thead,
        #DataTables_Table_0 th {
        text-align: center;
        }",

        "caption {
    padding-top: 8px;
    padding-bottom: 8px;
    color: rgb(128,177,221) !important;
    text-align: center;
}"
      )
    )),
    shinyDashboardThemes(theme = "purple_gradient"),
    tabItems(
      tabItem(tabName = "rdbo",
              mainPanel(htmlOutput("package_citation"), width = 100)),
      tabItem("dashboard",
              htmlOutput("about")),
      tabItem(
        "rdbi",
        titlePanel("COVID-19 in Southeast Asia"),
        fluidRow(
          valuebox("confirmed"),
          valuebox("death"),
          valuebox("recovered"),
          valuebox("activecases")
        ),
        sidebarLayout(
          sidebarPanel(
            dateRangeInput(
              inputId = "range",
              label = "Select date range",
              start = "2020-03-01",
              min = "2020-03-01",
              end = "2020-09-27",
              max = "2020-09-27",
              format = "dd/mm/yyyy",
              separator = " - "
            ),

            pickerInput(
              inputId = "country_choice",
              label = "Select country to compare :",
              choices = unique(southeast$country),
              options = list(
                `actions-box` = TRUE,
                `selected-text-format` = "count > 2",
                `count-selected-text` = "{0}/{1} country"
              ),
              multiple = TRUE,
              selected = c(
                "Indonesia",
                "Singapore",
                "Malaysia",
                "Thailand",
                "Laos",
                "Vietnam",
                "Philippines",
                "Myanmar",
                "Cambodia",
                "Brunei",
                "Timor-Leste"
              )
            ),
            selectInput(
              inputId = "type",
              label = "Select cases type",
              choices = unique(southeast$type),
            )
          ),
          mainPanel(tabsetPanel(
            type = "tabs",
            tabPanel(
              "Plot",
              plotlyOutput("covidplotly"),
              htmlOutput("hoverDataOut"),
              htmlOutput("clickDataOut")
            ),
            tabPanel("Help", verbatimTextOutput("helptab1"))
          ))
        )
      ),
      tabItem(
        tabName = "rdbe",
        fluidRow(
          valuebox("confirmed_country"),
          valuebox("death_country"),
          valuebox("recovered_country"),
          valuebox("activecases_country")
        ),
        sidebarLayout(sidebarPanel(
          selectInput(
            inputId = "country",
            label = "Select country ",
            choices = unique(southeast$country),
            width = 200
          ),
          width = 3
        ),
        mainPanel(
          tabsetPanel(
            type = "tabs",
            tabPanel("Plot", plotlyOutput("covidplotly2")),
            tabPanel("Table", DT::dataTableOutput("tablecovid2")),
            tabPanel("Help", verbatimTextOutput("helptab2"))
            # splitLayout(style = "border: 1px solid silver:", cellWidths = c("600","500")
          )
        ))
      )
    )
  )
)

#==============================================================================================#
##                                           Server                                           ##
#==============================================================================================#

#==============================================================================================#
##                                      Tab : Continent                                       ##
#==============================================================================================#
server <- function(input, output, session) {
  
  # newdate <- reactive({
  #   southeast %>% filter(between(date, input$range[1], input$range[2]))
  # })
  #   

  output$covidplotly <- renderPlotly({
    plot <- newdate(input)() %>%
      filter(country %in% c(input$country_choice),
             type == input$type) %>%
      ggplot(aes(x = date,
                 y = cases,
                 color = country)) +
      geom_point(alpha = 0.5, size = 0.5) +
      geom_line() +
      # scale_color_manual(values=c("#FF9933","#FF6666", "#00CCCC"))+
      our_theme +
      theme(legend.position = "none",
            axis.text.x = element_text(angle = 45)) +
      xlab("") +
      ylab("Number of cases") +
      ggtitle(paste0('Graph of ', input$type , ' cases in Southeast Asia countries')) +
      scale_x_date(date_breaks = "1 month",
                   labels = date_format("%b-%Y"))
    #              limits= as.Date(c('2020-03-01','2020-09-28')))
    ggplotly(plot, source = "link")  %>%
      layout(legend = list(
        orientation = "h",
        x = 0.3,
        y = -0.2
      )) %>%
      config(displayModeBar = FALSE)
 })
  
  output$confirmed <- valueboxprint(input = input,
                                    df = newdate(input)(),
                                    x = 5,
                                    label = "confirmed",
                                    colors = "orange")
  output$death <- valueboxprint(input = input,
                                df = newdate(input)(),
                                x = 6,
                                label = "death",
                                colors = "red")
  output$recovered <- valueboxprint(input = input,
                                    df = newdate(input)(),
                                    x = 7,
                                    label = "recovered",
                                    colors = "aqua")
  
  output$activecases <- renderValueBox({
    activecases <- newdate(input)() %>%
      filter(country %in% c(input$country_choice)) %>%
      pivot_wider(names_from = "type", values_from = "cases") %>%
      summarise(total_confirmed = format(sum(confirmed, na.rm = TRUE)-sum(death, na.rm=TRUE)-sum(recovered, na.rm = TRUE),
        big.mark = ",",
        scientific = FALSE
      ))
    valueBox(activecases, "Active Cases", color = "lime")
  })

  
  hoverData <- reactive({
    currentEventData <-
      unlist(event_data(
        event = "plotly_hover",
        source = "link",
        priority = "event"
      ))
  })
  
  clickData <- reactiveVal()
  
  observe({
    clickData(unlist(
      event_data(
        event = "plotly_click",
        source = "link",
        priority = "event"
      )
    ))
  })
  
  onclick(id = "covidplotly", expr = {
    clickData(hoverData())
  })
  
  output$hoverDataOut <- renderText({
    paste("Hover | Date:", paste(
      as.Date(hoverData()["x"], origin = "1970-01-01"),
      "Cases: ",
      paste(hoverData()["y"])
    ))
  })
  
  output$clickDataOut <- renderText({
    # paste("Click data:", paste(names(clickData()), unlist(clickData()), sep = ": ", collapse = " | "))
    paste("Click | Date:", paste(
      as.Date(clickData()["x"], origin = "1970-01-01"),
      "Cases: ",
      paste(clickData()["y"])
    ))
  })
  
  
  #==============================================================================================#
  ##                                      TAB : Countries                                       ##
  #==============================================================================================#
  
  summary_country <- reactive({
    southeast %>%
      pivot_wider(names_from = "type", values_from = "cases") %>%
      filter(country == input$country) %>%
      group_by(country) %>%
      summarise(
        total_confirmed = sum(confirmed, na.rm = TRUE),
        total_death = sum(death, na.rm = TRUE),
        total_recovered = sum(recovered, na.rm = TRUE)
      ) %>%
      mutate(active_cases = total_confirmed - total_death - total_recovered)
  })
  
  output$confirmed_country <- renderValueBox({
    valueBox(
      format(
        summary_country()$total_confirmed,
        big.mark = ",",
        scientific = FALSE
      ),
      "Total Confirmed",
      color = "orange"
    )
  })
  
  output$death_country <- renderValueBox({
    valueBox(
      format(
        summary_country()$total_death,
        big.mark = ",",
        scientific = FALSE
      ),
      "Total Death",
      color = "red"
    )
  })
  
  output$recovered_country <- renderValueBox({
    valueBox(
      format(
        summary_country()$total_recovered,
        big.mark = ",",
        scientific = FALSE
      ),
      "Total Recovered"
    )
  })
  
  output$activecases_country <- renderValueBox({
    valueBox(
      format(
        summary_country()$active_cases,
        big.mark = ",",
        scientific = FALSE
      )
      ,
      "Active Cases",
      color = "lime"
    )
  })
  
  
  output$covidplotly2 <- renderPlotly({
    plot2 <- southeast %>%
      filter(country == input$country) %>%
      ggplot(aes(x = date,
                 y = cases,
                 color = type)) +
      geom_line() +
      scale_color_manual(values = c("#FF9933", "#FF6666", "#00CCCC")) +
      our_theme +
      theme(legend.position = "bottom") +
      ggtitle(paste0('Graph of COVID-19 cases in ', input$country))  +
      scale_x_date(
        date_breaks = "1 month",
        labels = date_format("%b-%Y"),
        limits = as.Date(c('2020-03-01', '2020-09-28'))
      ) +
      xlab("") +
      ylab("Number of cases")
    ggplotly(plot2, source = "link") %>%
      layout(legend = list(
        orientation = "h",
        x = 0.3,
        y = -0.2
      )) %>%
      config(displayModeBar = FALSE)
  })
  
  output$tablecovid2 <- renderDataTable({
    summary <- southeast %>%
      pivot_wider(names_from = "type", values_from = "cases") %>%
      filter(country == input$country) %>%
      select(-lat,-long) %>%
      rename(
        "Date" = "date",
        "Country" = "country",
        "Confirmed" = "confirmed",
        "Death" = "death",
        "Recovered" = "recovered"
      )

    DT::datatable(
      summary,
      style = "bootstrap",
      caption = paste0('Table of COVID-19 cases in ', input$country)
    )
  })
  
  output$about <- renderText({
    paste(
      "This shiny app made by Putu Saputra (31161278) <br>",
      "This is the dashboard for analysing COVID-19 in Southeast Asia. The data taken from the coronavirus dataset from CRAN until 2020-09-25. <br>",
      "South East Asian countries include: <br>",
      "- Indonesia, <br>",
      "- Singapore, <br>",
      "- Malaysia, <br>",
      "- Thailand, <br>",
      "- Laos, <br>",
      "- Vietnam, <br>",
      "- Philippines, <br>",
      "- Myanmar, <br>",
      "- Cambodia, <br>",
      "- Brunei, <br>",
      "- Timor-Leste. <br>",
      "With this application you can see the progress of cases (confirmed, death, and recovered) in each region. <br>",
      "The application is equipped with interactive features for the user so you can explore each observation country."
    )
  })
  
  output$helptab1 <- renderText({
    paste(
      "In this tab, there is a line graph showing the progress of cases in all South East Asia countries.
    The x-axis shows the date, while the y-axis shows the number of cases.
    Each line represents one country.
    The features available in the sidebar are :

      - Date range        : date range from 01/03/2020 to 27/09/2020. When pressing this field,
                            a calendar will appear to select the minimum and maximum date ranges as desired.
      - Country selection : contains ten countries that can be selected multiple times.
                            This feature can be used to compare one country to another.
      - Type of cases     : There are three types of cases, namely confirmed, death, and recovered.
                            Can only select one case to visualize.
      - ValueBox          : shows the total of each case according to the Date Range and Country options.

    The graph will adjust according to the selected date, country selection and type of cases.

    At the bottom there is Hover Data and Click Data.
    Hover data will show the date and number of cases dynamically when the cursor hover the line graph.
    Meanwhile, Click Data will show the date data and the number of cases at a point when the line graph is clicked.
    This section useful when you want to compare the number of one individual cases in multiple country."
    )
  })
  
  output$helptab2 <- renderText({
    paste(
      "In this tab, there is a line graph showing the progress of cases in one country.
    On the x-axis it shows the date, while on the y-axis it shows the number of cases.
    Each line represents the type of case (confirmed, death, and recovered).
    The features available on the sidebar are:

    - Country selection : contains ten countries which can only be selected once.
    - Interactive Table : shows the country's daily case data.
    - ValueBox          : shows the total of each case and active cases according to the Country selection.

    The element of dashboard will change according to the country selection
    This section can be used to compare the number of all cases in a country."
    )
  })
  
  output$package_citation <- renderText({
    paste(
      "Chang et al. (2020) Wickham et al. (2019) Krispin and Byrnes (2020) Sievert (2020) Wickham and Seidel (2020) Cheng et al. (2020) Grolemund and Wickham (2011) Perrier, Meyer, and Granjon (2020) Chang and Borges Ribeiro (2018) Lilovski (2020) Dowle and Srinivasan (2020) Attali (2020) <br>",
      
      "Attali, Dean. 2020. Shinyjs: Easily Improve the User Experience of Your Shiny Apps in Seconds. https://CRAN.R-project.org/package=shinyjs.<br>",
      
      "Chang, Winston, and Barbara Borges Ribeiro. 2018. Shinydashboard: Create Dashboards with ’Shiny’. https://CRAN.R-project.org/package=shinydashboard.<br>",
      
      "Chang, Winston, Joe Cheng, JJ Allaire, Yihui Xie, and Jonathan McPherson. 2020. Shiny: Web Application Framework for R. https://CRAN.R-project.org/package=shiny.<br>",
      
      "Cheng, Joe, Carson Sievert, Winston Chang, Yihui Xie, and Jeff Allen. 2020. Htmltools: Tools for Html. https://CRAN.R-project.org/package=htmltools.<br>",
      
      "Grolemund, Garrett, and Hadley Wickham. 2011. “Dates and Times Made Easy with lubridate.” Journal of Statistical Software 40 (3): 1–25. http://www.jstatsoft.org/v40/i03/.<br>",
      
      "Krispin, Rami, and Jarrett Byrnes. 2020. Coronavirus: The 2019 Novel Coronavirus Covid-19 (2019-nCoV) Dataset. https://github.com/RamiKrispin/coronavirus.<br>",
      
      "Lilovski, Nik. 2020. Dashboardthemes: Customise the Appearance of ’Shinydashboard’ Applications Using Themes. https://CRAN.R-project.org/package=dashboardthemes.<br>",
      
      "Perrier, Victor, Fanny Meyer, and David Granjon. 2020. ShinyWidgets: Custom Inputs Widgets for Shiny. https://CRAN.R-project.org/package=shinyWidgets.<br>",
      
      "Sievert, Carson. 2020. Interactive Web-Based Data Visualization with R, Plotly, and Shiny. Chapman; Hall/CRC. https://plotly-r.com.<br>",
      
      "Wickham, Hadley, Mara Averick, Jennifer Bryan, Winston Chang, Lucy D’Agostino McGowan, Romain François, Garrett Grolemund, et al. 2019. “Welcome to the tidyverse.” Journal of Open Source Software 4 (43): 1686. https://doi.org/10.21105/joss.01686.<br>",
      
      "Wickham, Hadley, and Dana Seidel. 2020. Scales: Scale Functions for Visualization. https://CRAN.R-project.org/package=scales. <br>",
      
      "Yihui Xie, Joe Cheng and Xianying Tan (2020). DT: A Wrapper of the JavaScript Library 'DataTables'. R package version 0.15. https://CRAN.R-project.org/package=DT"
    )
  })
  
}


#==============================================================================================#
##                                      Run the application                                   ##
#==============================================================================================#
shinyApp(ui = ui, server = server)
