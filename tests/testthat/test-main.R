test_that("multiplication works", {

  peng <- palmerpenguins::penguins
  peng$group <- paste0(peng$species, "-", peng$island)

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = function(x){
      sapply(strsplit(x, split = "-"), function(.x) .x[1])
    }, gap_size = 0.8)

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = function(x){
      c(1, 2, 3, 2, 1)
    }, gap_size = 0.7)

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = function(x){
      # c(1, 2, -1, 2, 1)
      c("n", "q", "a", "q", "n")
    }, gap_size = 0.7)

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_discrete(guide = guide_grouped_axis())


  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = function(x){
      sapply(strsplit(x, split = "-"), function(.x) .x[1])
    }, gap_size = 0.8, add_group_label = TRUE)

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = rep(c("A", "B"), length.out = 5),
                             gap_size = 0.8, add_group_label = TRUE)

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = ~ rep(c("A", "B"), length.out = length(.x)),
                             gap_size = 0.8, add_group_label = TRUE)

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = function(x){
      sapply(strsplit(x, split = "-"), function(.x) .x[1])
    }, gap_size = 0.8, add_group_label = TRUE,
    guide = guide_grouped_axis(angle = 45)) +
    cowplot::theme_minimal_grid() +
    theme_grouped_axis(axis.grouping.line = element_line(color = "red"))

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = function(x){
      sapply(strsplit(x, split = "-"), function(.x) .x[1])
    }, gap_size = 0.8, add_group_label = TRUE,
    guide = guide_grouped_axis(angle = 90)) +
    cowplot::theme_minimal_grid() +
    theme_grouped_axis(axis.grouping.line = element_line(linetype = 2),
                       axis.title.x = element_blank())
})



