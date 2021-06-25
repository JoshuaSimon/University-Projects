rm(list = ls())


gibbs_sampler <- function(b, R, theta_1_start, theta_2_start, y1, y2, rho) {
  # Storage.
  THETA_1 <- numeric(b+R)
  THETA_2 <- numeric(b+R)
  
  # Set starting values.
  theta_1 <- theta_1_start
  theta_2 <- theta_2_start
  
  # Gibbs sampler.
  for (r in 1:(b+R)) {
    theta_1 <- rnorm(1, y1 + rho * (theta_2 - y2), sqrt(1 - rho^2))
    theta_2 <- rnorm(1, y2 + rho * (theta_1 - y1), sqrt(1 - rho^2))
    THETA_1[r] <- theta_1
    THETA_2[r] <- theta_2
  }
  
  return(matrix(data=c(THETA_1, THETA_2), ncol = 2))
}


# main function is used to wrap plots inside 
# and let R wait for user input.
main <- function() {
  print("Starting simulation...")
  
  # Setting up parameter vectors.
  theta_1_start <- c(100, 50, 10, 1, 0)
  theta_2_start <- c(100, 50, 10, 1, 0)
  y1 <- c(0, 0, 0, 0, 0)
  y2 <- c(0, 0, 0, 0, 0)
  rho <- c(0.5, 0.5, 0.5, 0.5, 0.5)
  b <- 500 # burn in
  R <- 100000 # GS iterations after burn in
  
  max_iter = length(theta_1_start)
  mean_1 <- numeric(max_iter)
  mean_2 <- numeric(max_iter)
  
  for (i in (1:max_iter)) {
    # Call gibbs sampler with different start values
    # in every iteration.
    THETA <- gibbs_sampler(b, R, theta_1_start[i], theta_2_start[i],
                           y1[i], y2[i], rho[i])
    
    # Compute the mean.
    mean_1[i] <- mean(THETA[(b+1):R, 1])
    mean_2[i] <- mean(THETA[(b+1):R, 2])
    
    # Plot theta draws.
    
    par(mfrow=c(1, 2))
    plot(1:(b+R),THETA[, 1], type="l", ylim=c(-10,50))
    abline(v=b,col="red")
    plot(1:(b+R),THETA[, 1], ylim=c(-10,50), type="l")
    abline(v=b,col="red")
    title(paste0("Simulation: ", i))
    
    # Wait for an input before the next 
    # iteration is calculated and ploted.
    inline <- readline(prompt="Press enter for next plot >> ")
  }
  
  # Plot the mean from every iteration.
  iterations <- 1:max_iter
  par(mfrow=c(1, 2))
  plot(iterations, mean_1, xlab = "Iteration", ylab = "Mean of theta 1")
  plot(iterations, mean_2, xlab = "Iteration", ylab = "Mean of theta 2")
  
  print("Finished simulation.")
}


# Call the main program.
main()
