
<!-- README.md is generated from README.Rmd. Please edit that file -->

# limix

## Setup

``` r
pak::pak("frankiethull/limix")

limix::create_limix_env()
limix::use_limix_env()
limix::install_limix_dependencies()
```

## Example

``` r
library(limix)
library(rsample)
limix::use_limix_env()

corn_data <- maize::corn_data

corn_splits <- initial_validation_split(corn_data)
train <- training(corn_splits)
validate <- validation(corn_splits)
test <- testing(corn_splits)
```

### Classification

``` r
# LimiX fit interface defaults to 16M and classifier configuration:
fit_cls <- limix_fit(
  train |> dplyr::select(-type),
  train$type,
  device = "cpu"
)
#> Mixed precision is not supported for CPU inference, so it has been automatically disabled

class_preds <- limix_predict(fit_cls, test |> dplyr::select(-type))

# LimiX supports proba and only proba by default:
class_preds |> head()
#>              [,1]        [,2]      [,3]
#> [1,] 8.402291e-04 0.110404290 0.8887555
#> [2,] 2.314303e-05 0.018211735 0.9817652
#> [3,] 7.050652e-05 0.006104911 0.9938246
#> [4,] 8.610082e-04 0.524374008 0.4747650
#> [5,] 8.368500e-05 0.171628073 0.8282883
#> [6,] 2.355176e-05 0.006777341 0.9931991
```

### Regression

``` r
# setting to a different config
fit_reg <- limix_fit(
  train |> dplyr::select(-height),
  train$height,
  device = "cpu",
  limix_model = "2M",
  limix_config = "reg_default_noretrieval"
)
#> Mixed precision is not supported for CPU inference, so it has been automatically disabled

predictions <- limix_predict(
  fit_reg,
  test |> dplyr::select(-height),
  task_type = "Regression"
)

predictions |> head()
#> [1] 5.728313 5.112232 5.310159 5.067317 5.078305 5.267260
```
