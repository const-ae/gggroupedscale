test_that("multiplication works", {

  peng <- palmerpenguins::penguins
  peng$group <- paste0(peng$species, "-", peng$island)

  ggplot(peng, aes(x = group, y = bill_length_mm)) +
    geom_point() +
    scale_x_grouped_discrete(grouping = function(x){
      sapply(strsplit(x, split = "-"), function(.x) .x[1])
    }, gap_size = 0.2)

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


})
