
#' Guide that draws the group-wise labels for the x-axis
#'
#' @inheritParams ggplot2::guide_axis
#' @param ... passed on to `ggplot2::guide_axis`
#'
#' @export
guide_grouped_axis <- function(title = waiver(), ...){
  res <- guide_axis(title = title, ...)
  res$name <- "grouped_axis"
  res$available_aes <- "x"
  class(res) <- c("guide", "grouped_axis", "axis")
  res
}

#' @export
guide_gengrob.grouped_axis <- function(guide, theme) {
  axis_grobs <- NextMethod("guide_gengrob")
  x <- guide$key$x
  if(! is.null(attr(x, "groups")) && ! is.null(attr(x, "group_names"))){
    groups <- attr(x, "groups")
    group_names <- attr(x, "group_names")
  }else{
    groups <- rep(1, length.out = length(x))
    group_names <- ""
  }


  line_element <- calc_element("axis.grouping.line", theme) %||% calc_element("line", theme) %||% element_line(color = "black", size = 0.8, linetype = 1, lineend = "butt", arrow = FALSE)
  line_range <- lapply(seq_len(max(groups)), function(idx){
    unit(range(x[groups == idx]), "native") + (calc_element("axis.grouping.line_padding", theme) %||% unit(20, "points")) * c(-1, 1)
  })
  lines <- element_grob(line_element, x = do.call(grid::unit.c, line_range), y = rep(unit(c(0.3,0.3),"native"), times = length(group_names)), id.lengths = rep(2, times = length(group_names)))

  label_center <- lapply(seq_len(max(groups)), function(idx){
    unit(mean(range(x[groups == idx])), "native")
  })
  label_element <- calc_element("axis.grouping.label", theme) %||% calc_element("text", theme) %||% element_text(size = 12, color = "black", hjust = 0.5, vjust = 0.5)
  group_labels <- element_grob(label_element, label = group_names, x = do.call(grid::unit.c, label_center), y = rep(unit(0.5,"native"), times = length(group_names)))

  line_height <- calc_element("axis.grouping.line_height", theme) %||% unit(20, "points")
  grobs <- list(lines, group_labels)
  names(grobs) <- c("grouping_lines","grouping_labels")
  group_annotation <- gtable::gtable_col(name = "group_annotation", grobs = grobs, width = unit(1, "npc"), height = grid::unit.c(line_height, grid::grobHeight(group_labels)))

  gt <- gtable::gtable_col(name = "axis_with_annotation", grobs = list(axis_grobs, group_annotation), width = unit(1,"npc"), height = grid::unit.c(axis_grobs$height, group_annotation$height))

  # create viewport
  justvp <- grid::viewport(
    y = unit(1, "npc"),
    height = gtable::gtable_height(gt),
    just = "top"
  )

  ggplot2:::absoluteGrob(
    grid::gList(axis_grobs, gt),
    width = gtable::gtable_width(gt),
    height = axis_grobs$height + gtable::gtable_height(gt),
    vp = justvp
  )
}



