# Aufgabe 6
x_1 <- c(55, 2500, 4)
x_2 <-  c(23, 1800, 3)
x_3 <-  c(31, 3500, 0)

X <- matrix(c(x_1, x_2, x_3), byrow = T, ncol = 3)
dist(X, method = "manhattan")
dist(X, method = "euclidean")

## Normierte Minkowski Metriken
Y <- X
q <- 2
for (i in 1:3) {
  mean <- mean(X[, i])
  #sd <- sd(X[, i])
  sd <- (1/length(X[, i]) * sum(abs(X[, i] - mean)^q))^(1/q)
  print(paste(i, mean, sd))
  Y[, i] <- (X[, i] - mean) / sd
}

dist(Y, method = "manhattan")
dist(Y, method = "euclidean")



# Aufgabe 7
# a)
D <- matrix(c(
  c(0.00, 0.80, 4.16, 3.28, 3.92, 4.69),
  c(0.80, 0.00, 4.14, 3.57, 4.00, 4.64),
  c(4.16, 4.14, 0.00, 2.71, 1.98, 2.15),
  c(3.28, 3.57, 2.71, 0.00, 3.16, 3.78),
  c(3.92, 4.00, 1.98, 3.16, 0.00, 2.52),
  c(4.69, 4.64, 2.15, 3.78, 2.52, 0.00)
), byrow = F, ncol = 6)

Ob <- hclust(as.dist(D), method="single")
Ob$height

copOb=cophenetic(Ob)

# b)
plot(Ob)

# c)
#n <- length(Ob$height)
#alpha <- Ob$height[1:n - 1]
alpha <- Ob$height

alpha_mean <- mean(alpha)
alpha_std <- sd(alpha)

alpha_scale <- (alpha - alpha_mean) / alpha_std

i <- 5
classes <- n + 1 - i

# d)
data <- matrix(c(
  c(1524.8, 265.4, 272, 79, 24, 223.5),
  c(1596.9, 323.6, 285, 87, 23, 333.9),
  c(2299.7, 610.3, 241, 45, 9, 632.1),
  c(864.1, 303.9, 220, 53, 11, 484.7),
  c(2669.9, 645.5, 202, 61, 15, 438.6),
  c(2985.2, 571.2, 226, 45, 16, 1103.9)
), byrow = T, ncol = 6)

KM=kmeans(data,2)
KM

plot(data, col = KM$cluster, lwd=2)
# Der Stern fur die Zentren:
points(KM$centers, col=1:2, pch=8, lwd=2)
points(fit[[2]], col="green")


########### k Means ###########
library("pracma")

euc_dist <- function(x1, x2){
  return(sqrt(sum((x1 - x2) ^ 2)))
} 

# Choose random observations as centroids
k <- 2
centers <- data[c(1,2), ]
dist <- matrix(nrow = nrow(data), ncol = k)
label <- matrix(nrow = nrow(data), ncol = k)

# Calculate distances from each observation to the selected centroids.
for (row in 1:nrow(data)) {
  for (clus in 1:k) {
    dist[row, clus] <- Norm(centers[clus, ] - data[row, ], p=2)
  }
  
  # Determine the minimum distance from each observation to a centroid.
  label[row, ] <- ifelse(dist[row, ] == min(dist[row, ]), 1, 0) 
  
}

dist
label

# Calculate new centroids.
for (i in 1:ncol(label)){
  #print(which(label[, i] == 1))
  #print(data[which(label[, i] == 1), ])
  centers[i, ] <- apply(data[which(label[, i] == 1), ], MARGIN = 2, FUN = mean)
}

centers




k_means <- function(data, k=3, center_idx = NULL, output = FALSE, max_iter = 10) {
  iter <- 0
  error <- 0
  while (iter < max_iter) {
    # Set starting centroids. If no starting values are
    # provided within the function call, random starting
    # values are chosen. 
    if (iter == 0) {
      if (is.null(center_idx)) {
        centers <- data[sample(1:nrow(data), size = k, replace = FALSE), ]
      } else {
        centers <- data[center_idx, ]
      }
    }
    
    centers_before <- centers
    
    # Containers for distances and cluster labels.
    dist <- matrix(nrow = nrow(data), ncol = k)
    label <- matrix(nrow = nrow(data), ncol = k)
    
    # Calculate distances from each observation to the selected centroids.
    for (row in 1:nrow(data)) {
      for (clus in 1:k) {
        dist[row, clus] <- Norm(centers[clus, ] - data[row, ], p=2)
      }
      
      # Determine the minimum distance from each observation to a centroid.
      label[row, ] <- ifelse(dist[row, ] == min(dist[row, ]), 1, 0) 
    }
    
    # Calculate new centroids.
    for (i in 1:ncol(label)){
      centers[i, ] <- apply(data[which(label[, i] == 1), ], MARGIN = 2, FUN = mean)
    }
    
    # Print output for every iteration.
    if (output) {
      print(paste("Iteration: ", iter))
      print("------------------------")
      print("Distance matrix:")
      print(dist)
      print("Cluster labels (by column):")
      print(label)
      print("Center coordinates:")
      print("Center:")
      print(centers)
      print("")
    }
    
    # If the distance between the new and the old center is equal to
    # zero, convergence is reached and we can exit the loop. 
    error <- norm(abs(centers - centers_before))
    if (error == 0) {
      print(paste0("Converged after ", iter, " iterations."))
      break
    }
    
    iter <- iter + 1
  }
  
  return(list(label, centers))
}

# Fit with random starting values.
fit <- k_means(data, k = 2, center_idx = NULL, output = TRUE, max_iter = 10)
fit

# Fit with fixed starting values.
fit <- k_means(data, k = 2, center_idx = c(1,3), output = TRUE, max_iter = 10)
fit
