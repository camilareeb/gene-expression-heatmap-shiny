# Gene Expression Correlation Explorer
#
# Interactive Shiny app to explore correlation structure in a gene
# expression matrix. The user uploads a delimited file (genes x samples),
# picks how many of the most variable genes to include, and the app draws
# a correlation heatmap between those genes.
#
# Expected input format:
#   - Delimited text file (tab, comma or semicolon)
#   - One row per gene, one column per sample
#   - A column containing gene identifiers/names (position configurable)
#   - Remaining columns: numeric expression values
#
# Try it instantly with the bundled example: example_data/example_expression.tsv
# (defaults below already match it: separator = tab, skip = 0, gene name column = 2)

library(shiny)
library(shinythemes)
library(ggplot2)
library(reshape2)

options(shiny.maxRequestSize = 128 * 1024^2)

# ---- UI ----
ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Gene Expression Correlation"),

  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload file"),
      selectInput("sep", "Separator",
                  choices = c("tab" = "\t", "comma" = ",", "semicolon" = ";")),
      numericInput("skip", "Number of lines to skip", 0, min = 0),
      numericInput("gene_col", "Column with gene names", 2, min = 1),
      sliderInput("n_genes", "Number of genes to plot", 10, 400, 50),
      actionButton("go", "Generate Heatmap"),
      tags$hr(),
      tags$p(
        tags$small(
          "No file? Try the bundled example: example_data/example_expression.tsv"
        )
      )
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Preview", tableOutput("preview")),
        tabPanel("Heatmap", plotOutput("heatmap", height = "600px"))
      )
    )
  )
)

# ---- Server ----
server <- function(input, output) {

  # Read the uploaded file into a data frame
  data_raw <- reactive({
    req(input$file)
    read.table(input$file$datapath,
               sep = input$sep,
               header = TRUE,
               skip = input$skip,
               stringsAsFactors = FALSE,
               check.names = FALSE)
  })

  # Quick preview so the user can confirm the file was parsed correctly
  output$preview <- renderTable({
    head(data_raw())
  })

  # Correlation heatmap of the most variable genes
  output$heatmap <- renderPlot({
    req(input$go) # only (re)generate once the user clicks the button

    dat <- data_raw()
    genes <- dat[[input$gene_col]]         # gene identifier column
    expr <- dat[, -(1:input$gene_col)]     # remaining columns = expression values
    genes <- make.unique(as.character(genes)) # avoid duplicate row names

    rownames(expr) <- genes
    expr <- as.matrix(expr)
    mode(expr) <- "numeric"
    expr <- expr[complete.cases(expr), ]   # drop genes with missing values

    vars <- apply(expr, 1, var)
    top <- order(vars, decreasing = TRUE)[1:input$n_genes] # most variable genes
    expr_top <- expr[top, ]

    cor_mat <- cor(t(expr_top))
    cor_df <- melt(cor_mat)

    ggplot(cor_df, aes(Var1, Var2, fill = value)) +
      geom_tile() +
      scale_fill_gradient2(low = "blue", mid = "white", high = "red",
                            midpoint = 0, name = "Correlation") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1),
            axis.title = element_blank()) +
      ggtitle("Gene expression correlation heatmap")
  })
}

shinyApp(ui, server)
