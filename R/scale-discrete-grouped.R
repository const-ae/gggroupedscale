



#' @import ggplot2
NULL

#' @import rlang
NULL

#' @import tibble
NULL

#' @import scales
NULL


#' A modified discrete scale that inserts a gap between groups
#'
#' @inheritParams ggplot2::scale_x_discrete
#' @param grouping a function that gets the names of the discrete elements
#'   and returns the corresponding grouping
#' @param gap_size the gap between the groups
#' @param add_group_label boolean whether the group is added as an extra line
#'   below the axis labels
#'
#'
#' @export
scale_x_grouped_discrete <- function(..., grouping = function(x) 1, gap_size = 0.3, expand = waiver(),
                                     guide = waiver(), position = "bottom", add_group_label = FALSE) {

  if(add_group_label && inherits(guide, "waiver")){
    guide <- guide_grouped_axis()
  }

  sc <- discrete_scale(c("x", "xmin", "xmax", "xend"), "position_d", identity, ...,
                       expand = expand, guide = guide, position = position, super = ScaleGroupedDiscretePosition)

  sc$range_c <- ggplot2:::continuous_range()
  sc$grouping <- grouping
  sc$gap_size <- gap_size

  if(add_group_label && inherits(guide, "waiver")){
    list(sc, theme_grouped_axis())
  }else{
    sc
  }
}

#' @rdname scale_x_grouped_discrete
#' @export
scale_y_grouped_discrete <- function(..., grouping = function(x) 1, gap_size = 0.3, expand = waiver(),
                                     guide = waiver(), position = "left", add_group_label = FALSE) {

  if(add_group_label && inherits(guide, "waiver")){
    guide <- guide_grouped_axis()
  }

  sc <- discrete_scale(c("y", "ymin", "ymax", "yend"), "position_d", identity, ...,
                       expand = expand, guide = guide, position = position, super = ScaleGroupedDiscretePosition)

  sc$range_c <- ggplot2:::continuous_range()
  sc$grouping <- grouping
  sc$gap_size <- gap_size

  if(add_group_label && inherits(guide, "waiver")){
    list(sc, theme_grouped_axis())
  }else{
    sc
  }
}


#' @format NULL
#' @usage NULL
#' @export
ScaleGroupedDiscretePosition <- ggproto("ScaleGroupedDiscretePosition", ScaleDiscrete,
  grouping = function(x){
    1
  },
  gap_size = 1,
  train = function(self, x) {
    if (is.discrete(x)) {
      self$range$train(x, drop = self$drop, na.rm = !self$na.translate)
    } else {
      self$range_c$train(x)
    }
  },

  get_limits = function(self) {
    # if scale contains no information, return the default limit
    if (self$is_empty()) {
      return(c(0, 1))
    }

    # if self$limits is not NULL and is a function, apply it to range
    limits <- if (is.function(self$limits)){
      self$limits(self$range$range)
    }else{
      # self$range$range can be NULL because non-discrete values use self$range_c
      self$limits %||% self$range$range %||% integer()
    }

    groups <- if(is.vector(self$grouping)){
      rep_len(self$grouping, length(limits))
    }else{
      as_function(self$grouping)(limits)
    }
    stopifnot(length(groups) == 1 || length(groups) == length(limits))
    num_groups <- as.numeric(droplevels(as.factor(rep_len(groups, length(limits)))))

    limits <- limits[order(num_groups)]
    group_names <- unique(groups[order(num_groups)])
    num_groups <- sort(num_groups)
    # The trick is that expand_limits_discrete_trans uses
    # length(limits) to figure out how wide the plot should be
    # https://github.com/tidyverse/ggplot2/blob/1a72f581ce651b36c16cb2dd3c7ab0463ae7a188/R/scale-expansion.r#L204
    # I hack the length function to incorporate the information about the gap_size
    new_grouped_limits(limits, num_groups, group_names, self$gap_size)
  },

  is_empty = function(self) {
    is.null(self$range$range) && is.null(self$limits) && is.null(self$range_c$range)
  },

  reset = function(self) {
    # Can't reset discrete position scale because no way to recover values
    self$range_c$reset()
  },

  map = function(self, x, limits = self$get_limits()) {
    groups <- if(is.null(attr(limits, "group"))){
      rep(1, length(limits))
    }else{
      attr(limits, "group")
    }
    group_names <- if(is.null(attr(limits, "group_names"))){
      seq_len(length(unique(unique(groups))))
    }else{
      attr(limits, "group_names")
    }
    if(is.discrete(x)){
      extra_gap <- cumsum(c(0, diff(groups)) * self$gap_size)
      x <- (seq_along(unclass(limits)) + extra_gap)[match(as.character(x), limits)]
    }
    new_grouped_mapped_discrete(x, groups, group_names)
  },

  rescale = function(self, x, limits = self$get_limits(), range = self$dimension(limits = limits)) {
    range <- self$dimension(expand = ggplot2:::default_expansion(self, expand = TRUE), limits = limits)
    rescale(self$map(x, limits = limits), from = range)
  },

  dimension = function(self, expand = expansion(0, 0), limits = self$get_limits()) {
    ggplot2:::expand_limits_scale(self, expand, limits)
  },

  clone = function(self) {
    new <- ggproto(NULL, self)
    new$range <- ggplot2:::discrete_range()
    new$range_c <- ggplot2:::continuous_range()
    new
  }
)



is.discrete <- function (x) {
  is.factor(x) || is.character(x) || is.logical(x)
}


# TODO: This is a clear candidate for vctrs once we adopt it
new_grouped_mapped_discrete <- function(x, groups, group_names) {
  if (is.null(x)) {
    return(x)
  }
  if (!is.numeric(x)) {
    abort("`mapped_discrete` objects can only be created from numeric vectors")
  }
  stopifnot(max(groups) == length(group_names))
  attr(x, "groups") <- groups
  attr(x, "group_names") <- group_names
  class(x) <- c("groupedmapped_discrete", "mapped_discrete", "numeric")
  x
}



# is_mapped_discrete <- function(x) inherits(x, "mapped_discrete")




new_grouped_limits <- function(x, group, group_names, gap_size) {
  if (is.null(x)) {
    return(x)
  }
  stopifnot(length(x) == length(group))
  stopifnot(max(group) == length(group_names))
  stopifnot(length(gap_size) == 1)
  class(x) <- c("grouped_limits", class(x))
  attr(x, "group") <- group
  attr(x, "group_names") <- group_names
  attr(x, "gap_size") <- gap_size
  x
}

#' @export
length.grouped_limits <- function(x){
  len <- NextMethod("length")
  len + (length(unique(attr(x, "group")))-1) * attr(x, "gap_size")
}




