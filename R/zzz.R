

.onLoad <- function(libname, pkgname){
  register_theme_elements(
    axis.grouping.line = element_line(),
    axis.grouping.line_padding = unit(20, "pt"),
    axis.grouping.label.x = element_text(),
    axis.grouping.label.y = element_text(angle = 90),
    axis.grouping.line_height = unit(20, "pt"),
    element_tree = list(axis.grouping.line = el_def("element_line", "line"),
                        axis.grouping.line_padding = el_def("unit"),
                        axis.grouping.label.x = el_def("element_text", "text"),
                        axis.grouping.label.y = el_def("element_text", "text"),
                        axis.grouping.line_height = el_def("unit"))
  )
}
