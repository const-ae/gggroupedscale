
#' Theme elements specifically for the grouped axis
#'
#' @param axis.grouping.line a line element
#' @param axis.grouping.line_padding by how much should each line be extended in each direction
#' @param axis.grouping.label a text element
#' @param axis.grouping.line_height how much space should there be around the line
#' @param ... additional parameters that are passed on to `theme`
#'
#' @export
theme_grouped_axis <- function(
  axis.grouping.line = NULL,
  axis.grouping.line_padding = unit(20, "points"),
  axis.grouping.label = NULL,
  axis.grouping.line_height = unit(20, "points"),
  ...
){
  theme(
    axis.grouping.line = axis.grouping.line,
    axis.grouping.line_padding = axis.grouping.line_padding,
    axis.grouping.label = axis.grouping.label,
    axis.grouping.line_height = axis.grouping.line_height,
    ...,
    validate = FALSE
  )
}



