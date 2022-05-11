

.onLoad <- function(libname, pkgname){
  register_theme_elements(
    axis.grouping.line = element_line(),
    axis.grouping.line_padding = unit(20, "pt"),
    axis.grouping.label = element_text(),
    axis.grouping.line_height = unit(20, "pt"),
    element_tree = list(axis.grouping.line = el_def("element_line", "line"),
                        axis.grouping.line_padding = el_def("unit"),
                        axis.grouping.label = el_def("element_text", "text"),
                        axis.grouping.line_height = el_def("unit"))
  )
}
