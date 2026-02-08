#' LimiX predictions
#'
#' @param object an object returned from limix_fit
#' @param X_test a set of predictors
#' @param ... pass through for prediction method
#'
#' @returns predictions
#'
#' @export
limix_predict <- \(object, X_test, ...) {
  model <- object$model

  predictions <- model$predict(object$X_train, object$y_train, X_test, ...)
  predictions
}
