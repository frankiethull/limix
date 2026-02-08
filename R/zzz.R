LimiXPredictor <- NULL
hf_hub <- NULL
torch <- NULL

.onLoad <- function(libname, pkgname) {
  hf_hub <<- reticulate::import("huggingface_hub", delay_load = TRUE)
  torch <<- reticulate::import("torch", delay_load = TRUE)
  LimiXPredictor <<- reticulate::import_from_path(
    "inference.predictor",
    # this should be the git clone location
    path = paste0(here::here(), "/LimiX"),
    delay_load = TRUE
  )

  # based on limix working examples,
  # setting these variables onload:
  Sys.setenv(
    RANK = "0",
    WORLD_SIZE = "1",
    MASTER_ADDR = "127.0.0.1",
    MASTER_PORT = "29500"
  )
}
