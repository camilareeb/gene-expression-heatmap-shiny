# Gene Expression Correlation Explorer (R Shiny)

App interactiva en R Shiny para explorar la estructura de correlación de
una matriz de expresión génica: se sube un archivo, se elige cuántos de
los genes más variables incluir, y la app genera un heatmap de
correlación entre esos genes.

## Motivación

En análisis de expresión génica es habitual necesitar una primera vista
rápida de qué genes co-varían entre sí antes de pasar a un análisis más
formal (clustering, redes de co-expresión, etc.). Esta herramienta permite
hacer esa exploración de forma interactiva, sin escribir código cada vez
que se quiere probar con un nuevo archivo o un número distinto de genes.

## Capturas

**Vista previa del archivo cargado** (probado con datos de expresión de
tipo GEUVADIS):

![Preview](assets/preview_tab.png)

**Heatmap de correlación generado:**

![Heatmap](assets/heatmap_tab.png)

## Formato de entrada esperado

- Archivo delimitado (tabulador, coma o punto y coma)
- Una fila por gen, una columna por muestra
- Una columna con el identificador/nombre del gen (la posición es
  configurable en la interfaz)
- El resto de columnas: valores numéricos de expresión

## Pruébalo con el ejemplo incluido

No hace falta buscar un dataset propio para probar la app:
`example_data/example_expression.tsv` contiene una matriz sintética de 60
genes × 12 muestras (con 4 bloques de genes correlacionados entre sí, para
que el heatmap resultante sea interpretable). Los valores por defecto de
la interfaz (separador = tab, líneas a saltar = 0, columna de nombres = 2)
ya están configurados para funcionar directamente con este archivo.

## Cómo ejecutarlo

```r
install.packages(c("shiny", "shinythemes", "ggplot2", "reshape2"))
shiny::runApp("app.R")
```

## Tecnologías

R · Shiny · shinythemes · ggplot2 · reshape2
