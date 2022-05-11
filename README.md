
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gggroupedscale

<!-- badges: start -->
<!-- badges: end -->

The goal of gggroupedscale is to …

## Installation

You can install the released version of gggroupedscale from
[Github](https:://github.com/const-ae/gggroupedscale) with:

``` r
devtools::install_github("const-ae/gggroupedscale")
```

## Example

I plot the `bill_length_mm` of the palmer penguins for the different
combinations of species and island. The breaks on the x-axis are grouped
by island

``` r
library(ggplot2)
library(gggroupedscale)
library(palmerpenguins)

ggplot(penguins, 
       aes(x = paste0(island, "-", species), y = bill_length_mm)) +
  geom_boxplot() +
  scale_x_grouped_discrete(grouping = function(x){
    sapply(strsplit(x, split = "-"), function(.x) .x[1])
  }, gap_size = 1, add_group_label = TRUE)
#> Warning: Removed 2 rows containing non-finite values (stat_boxplot).
```

<img src="man/figures/README-example-1.png" width="100%" />

Setting `add_group_label = FALSE` suppresses the additional labels

``` r
ggplot(penguins, 
       aes(x = paste0(island, "-", species), y = bill_length_mm)) +
  geom_boxplot() +
  scale_x_grouped_discrete(grouping = function(x){
    sapply(strsplit(x, split = "-"), function(.x) .x[1])
  }, gap_size = 1, add_group_label = FALSE)
#> Warning: Removed 2 rows containing non-finite values (stat_boxplot).
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

You can also define the grouping using a regular vector or a formula
style function

``` r
ggplot(penguins, aes(x = paste0(island, "-", species), y = bill_length_mm)) +
  geom_boxplot() +
  scale_x_grouped_discrete(grouping = c("A", "B", "A", "B", "C"), add_group_label = TRUE)
#> Warning: Removed 2 rows containing non-finite values (stat_boxplot).
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r
ggplot(penguins, aes(x = paste0(island, "-", species), y = bill_length_mm)) +
  geom_boxplot() +
  scale_x_grouped_discrete(grouping = ~ stringr::str_split_fixed(.x, "-", n=2)[,2], 
                           gap_size = 1, add_group_label = TRUE)
#> Warning: Removed 2 rows containing non-finite values (stat_boxplot).
```

<img src="man/figures/README-unnamed-chunk-3-2.png" width="100%" />

# Disclaimer

Note that this is not a polished package. For example, the package uses
internal functions from `ggplot2` and has a hack to extend the range, so
it might break with any new release of `ggplot2`. However, it seems to
get the job done, so it’s good enough for me. I am currently not
planning to submit to CRAN and it should probably be rather added to one
of the existing ggplot extension packages that provide custom scales.
