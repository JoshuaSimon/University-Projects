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

# b)
plot(Ob)

# c)
n <- length(Ob$height)
alpha <- Ob$height[1:n - 1]

alpha_mean <- mean(alpha)
alpha_std <- sd(alpha)

alpha_scale <- (alpha - alpha_mean) / alpha_std

i <- 4
classes <- n + 1 - i
