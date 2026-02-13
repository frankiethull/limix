#' LimiX predictions
#'
#' @param object an object returned from limix_fit
#' @param X_test a set of predictors
#' @param task_type either `Classification` or `Regression`
#' @param ... pass through for prediction method
#'
#' @returns predictions
#'
#' @export
limix_predict <- \(object, X_test, task_type = "Classification", ...) {
  model <- object$model

  predictions <- model$predict(object$X_train, object$y_train, X_test, task_type = task_type, ...)
  if(task_type == "Regression"){
    predictions <- predictions$to('cpu')$numpy()
  }
  predictions
}

