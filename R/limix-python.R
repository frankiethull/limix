# binders between Python, R, and venv dependency helpers
# ------------------------------------------------------

#' Create Virtual Environment Wrapper
#'
#' @param envname virtual environment to create
#' @param ... additional passes for `create_virtualenv`
#'
#' @return creation of virtual environment
#' @export
create_limix_env <- \(envname = "limix", ...) {
  reticulate::virtualenv_create(envname, ...)
}

#' Use Virtual Environment Wrapper
#'
#' @param envname virtual environment to use
#' @param ...  additional passes for `use_virtualenv`
#'
#' @return sets environment to virtualenv
#' @export
use_limix_env <- \(envname = "limix", ...) {
  reticulate::use_virtualenv(envname, ...)
}

#' Install limix
#' @description
#' LimiX itself is not a package so this is a very experimental binding.
#' Install LimiX dependencies will install all python dependencies and clone LimiX.
#' LimiX should be cloned to the working directory.
#'
#'
#' @param envname  virtual environment name
#' @param method   method defaults to "auto"
#' @param flash_whl logical, whether to try installing flash-attn wheel
#' @param ...      additional passes for `py_install`
#'
#' @return installs to "limix" env by default
#' @export
install_limix_dependencies <- \(
  envname = "limix",
  method = "auto",
  flash_whl = FALSE,
  ...
) {
  # 1. Core torch stack
  reticulate::py_install(
    packages = c(
      "torch==2.7.1",
      "torchvision==0.22.1",
      "torchaudio==2.7.1"
    ),
    envname = envname,
    method = method,
    pip = TRUE,
    ...
  )

  # 2. optionally try flash-attn wheel
  if (isTRUE(flash_whl)) {
    flash_url <- paste0(
      "https://github.com/Dao-AILab/flash-attention/releases/download/",
      "v2.8.0.post2/",
      "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiTRUE-",
      "cp312-cp312-linux_x86_64.whl"
    )

    flash_file <- basename(flash_url)

    tryCatch(
      {
        if (!file.exists(flash_file)) {
          download.file(flash_url, destfile = flash_file, mode = "wb")
        }

        reticulate::py_install(
          packages = flash_file,
          envname = envname,
          method = method,
          pip = TRUE
        )
      },
      error = function(e) {
        message(
          "flash-attn installation failed (continuing without it): ",
          conditionMessage(e)
        )
      }
    )
  }

  # 3. Remaining Python libs
  reticulate::py_install(
    packages = c(
      "scikit-learn",
      "einops",
      "huggingface-hub",
      "matplotlib",
      "networkx",
      "numpy",
      "pandas",
      "scipy",
      "tqdm",
      "typing_extensions",
      "xgboost",
      "kditransform",
      "hyperopt"
    ),
    envname = envname,
    method = method,
    pip = TRUE
  )

  # 4. Clone LimiX repo (only once)
  if (!dir.exists("LimiX")) {
    system("git clone https://github.com/limix-ldm/LimiX.git")
  }
}
