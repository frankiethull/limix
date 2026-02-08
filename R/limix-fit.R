#' LimiX Fit Interface
#'
#' @param X_train a set of predictors
#' @param y_train a outcome variable
#' @param device either 'cuda' or 'cpu'
#' @param limix_model this should be "16M" or "2M"
#' @param limix_dir based on where you have a clone of LimiX (should be cloned `here::here()``)
#' @param limix_config this is a string name of one of the special json of LDM defaults
#' something like 'cls_default_2M_retrieval', 'reg_default_16M_retrieval', or '{type}_default_{size}_(no)retrieval'
#'
#' @returns a limix model fit spec object
#'
#' @export
limix_fit <- \(
  X_train,
  y_train,
  device = "cuda",
  limix_model = "16M",
  limix_dir = paste0(here::here(), "/LimiX"),
  limix_config = "cls_default_noretrieval"
) {
  LimiXPredictor <- reticulate::import_from_path(
    "inference.predictor",
    path = limix_dir
  )

  # either 16M or 2M
  model_file = hf_hub$hf_hub_download(
    repo_id = paste0("stableai-org/LimiX-", limix_model),
    filename = paste0("LimiX-", limix_model, ".ckpt"),
    local_dir = "./cache"
  )

  config_dir <- paste0(limix_dir, '/config/', limix_config, '.json')

  model = LimiXPredictor$LimiXPredictor(
    device = torch$device(device),
    model_path = model_file,
    inference_config = config_dir
  )

  fit_spec <- list(model = model, X_train = X_train, y_train = y_train)

  class(fit_spec) <- c(class(fit_spec), "limix_model_object")

  fit_spec
}
