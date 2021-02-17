# Regression estimation.
# This R script contains fuctions for the calculation of
# the regression estimation known form survey sampling in
# statistics.
# Joshua Simon, 17.02.2020.


reg_estimation <- function(N, n, xu_mean, xk_sum, yk_sum, 
                  xk_squared_sum, yk_squared_sum, xk_yk_sum) {
  #' Functions takes sample values as input arguments to
  #' calculate different estimators. All results are returned
  #' as terminal output. Mean estimates and variance estimates
  #' are also returned as a matrix.
  sx_squared <- 1/(n-1) * (xk_squared_sum - n * (xk_sum/n)^2)
  sy_squared <- 1/(n-1) * (yk_squared_sum - n * (yk_sum/n)^2)
  sxy <- 1/(n-1) * (xk_yk_sum - n * (xk_sum/n) * (yk_sum/n))
  r_squared <- sxy^2/(sx_squared * sy_squared)
  
  # Regression estimators.
  bx <- sxy/sx_squared
  y_reg <- yk_sum/n + bx * (xu_mean - (xk_sum/n))
  t_reg <- y_reg * N
  var_y_reg <- (1/n - 1/N) * sy_squared * (1 - r_squared)
  
  # Difference estimators.
  y_diff <- yk_sum/n - xk_sum/n + xu_mean
  t_diff <- N * y_diff
  var_y_diff <- (1/n - 1/N) * (sx_squared + sy_squared - 2 * sxy)
  
  # Ratio estimators.
  y_ra <- (yk_sum/n) / (xk_sum/n) * xu_mean
  t_ra <- N * y_ra
  r_head <- (yk_sum/n) / (xk_sum/n)
  approx_var_y_ra <- (1/n - 1/N) * 
    (sy_squared + r_head^2 * sx_squared - 2 * r_head * sxy)
  
  # Output.
  print(paste("sx_squared:", sx_squared))
  print(paste("sy_squared:", sy_squared))
  print(paste("sxy:", sxy))
  print(paste("r_squared:", r_squared))
  print("")
  print("----- Regression estimation -----")
  print(paste("bx:", bx))
  print(paste("y_reg:", y_reg))
  print(paste("t_reg:", t_reg))
  print(paste("var(y_reg):", var_y_reg))
  print("")
  print("----- Difference estimation -----")
  print(paste("y_diff:", y_diff))
  print(paste("t_diff:", t_diff))
  print(paste("var_y_diff:", var_y_diff))
  print("")
  print("----- Ratio estimation -----")
  print(paste("y_ra:", y_ra))
  print(paste("t_ra:", t_ra))
  print(paste("r_head:", r_head))
  print(paste("approx_var(y_ra):", approx_var_y_ra))
  
  return(matrix(c(y_reg, y_diff, y_ra, 
                  var_y_reg, var_y_diff, approx_var_y_ra),
                  nrow = 3, ncol = 2))
}


ci_estimation <- function(alpha, n, y_mean, var__) {
  #' Calculates the confidence interval (CI) of given estimations.
  ci_lower <- y_mean - qt(1 - alpha/2, n) * var__
  ci_upper <- y_mean + qt(1 - alpha/2, n) * var__
  
  print(paste0("CI: [", ci_lower, " ,", ci_upper, "]"))
}

# ----- Main program. -----
# Set values.
N <- 2000
n <-  50
xu_mean <- 5.471
xk_sum <- 215.50
yk_sum <- 229.84
xk_squared_sum <- 4989.51
yk_squared_sum <- 6812.20
xk_yk_sum <- 5788.53

# Call functions.
estimators <- reg_estimation(N, n, xu_mean, xk_sum, yk_sum, 
      xk_squared_sum, yk_squared_sum, xk_yk_sum)

alpha <- 0.05
# CI for regression estimation.
ci_estimation(alpha, n, estimators[1,1], estimators[1,2])

# CI for difference estimation.
ci_estimation(alpha, n, estimators[2,1], estimators[2,2])

# CI for ratio estimation.
ci_estimation(alpha, n, estimators[3,1], estimators[3,2])
