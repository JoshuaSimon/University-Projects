# Aufgabe 6
x_1 <- c(55, 2500, 4)
x_2 <-  c(23, 1800, 3)
x_3 <-  c(31, 3500, 0)

X <- matrix(c(x_1, x_2, x_3), byrow = T, ncol = 3)
dist(X, method = "manhattan")
dist(X, method = "euclidean")


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

