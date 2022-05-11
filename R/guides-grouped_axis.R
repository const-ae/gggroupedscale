
#' Guide that draws the group-wise labels for the x-axis
#'
#' @inheritParams ggplot2::guide_axis
#' @param ... passed on to `ggplot2::guide_axis`
#'
#' @export
guide_grouped_axis <- function(title = waiver(), ...){
  res <- guide_axis(title = title, ...)
  res$name <- "grouped_axis"
  res$available_aes <- c("x", "y")
  class(res) <- c("guide", "grouped_axis", "axis")
  res
}

#' @export
guide_gengrob.grouped_axis <- function(guide, theme) {
  axis_grobs <- NextMethod("guide_gengrob")
  aesthetic <- names(guide$key)[!grepl("^\\.", names(guide$key))][1]

  x <- guide$key[[aesthetic]]
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
  lines <- if(aesthetic == "x"){
    element_grob(line_element, x = do.call(grid::unit.c, line_range), y = rep(unit(c(0.3,0.3),"native"), times = length(group_names)), id.lengths = rep(2, times = length(group_names)))
  }else{
    element_grob(line_element, y = do.call(grid::unit.c, line_range), x = rep(unit(c(0.3,0.3),"native"), times = length(group_names)), id.lengths = rep(2, times = length(group_names)))
  }

  label_center <- lapply(seq_len(max(groups)), function(idx){
    unit(mean(range(x[groups == idx])), "native")
  })
  if(aesthetic == "x"){
    label_element <- calc_element("axis.grouping.label.x", theme) %||% calc_element("text", theme) %||% element_text(size = 12, color = "black", hjust = 0.5, vjust = 0.5)
    group_labels <- element_grob(label_element, label = group_names, x = do.call(grid::unit.c, label_center), y = rep(unit(0.5,"native"), times = length(group_names)))
  }else{
    label_element <- calc_element("axis.grouping.label.y", theme) %||% calc_element("text", theme) %||% element_text(size = 12, color = "black", hjust = 0.5, vjust = 0.5, angle = 90)
    group_labels <- element_grob(label_element, label = group_names, y = do.call(grid::unit.c, label_center), x = rep(unit(0.5,"native"), times = length(group_names)))
  }

  line_height <- calc_element("axis.grouping.line_height", theme) %||% unit(20, "points")
  grobs <- list(lines, group_labels)
  names(grobs) <- c("grouping_lines","grouping_labels")
  if(aesthetic == "x"){
    group_annotation <- gtable::gtable_col(name = "group_annotation", grobs = grobs, width = unit(1, "npc"), height = grid::unit.c(line_height, grid::grobHeight(group_labels)))
    gt <- gtable::gtable_col(name = "axis_with_annotation", grobs = list(axis_grobs, group_annotation), width = unit(1,"npc"), height = grid::unit.c(axis_grobs$height, group_annotation$height))
    justvp <- grid::viewport(
      y = unit(1, "npc"),
      height = gtable::gtable_height(gt),
      just = "top"
    )
    ggplot2:::absoluteGrob(
      # grid::gList(axis_grobs, gt),
      grid::gList(gt),
      width = gtable::gtable_width(gt),
      height = gtable::gtable_height(gt),
      vp = justvp
    )
  }else{
    # browser()
    group_annotation <- gtable::gtable_row(name = "group_annotation", grobs = rev(grobs),
                                           height = unit(1, "npc"), width = grid::unit.c(grid::grobWidth(group_labels), line_height))
    gt <- gtable::gtable_row(name = "axis_with_annotation", grobs = list(group_annotation, axis_grobs),
                             height = unit(1,"npc"), width = grid::unit.c(grid::grobWidth(group_annotation), grid::grobWidth(axis_grobs)))
    # create viewport
    justvp <- grid::viewport(
      x = unit(1, "npc"),
      width = gtable::gtable_width(gt),
      just = "right"
    )
    ggplot2:::absoluteGrob(
      grid::gList(gt),
      width = gtable::gtable_width(gt),
      height = gtable::gtable_height(gt),
      vp = justvp
    )
  }

}



