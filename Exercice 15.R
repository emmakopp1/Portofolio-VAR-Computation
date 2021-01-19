rm(list = ls())
par(mfrow = c(2, 2))
library(viridisLite)
c.pal <- viridis(3)
# ---- Question 1 -----
f <- function(x) {
  exp(-x^2)
}
I <- sqrt(pi) * (pnorm(2, sd = 1 / sqrt(2)) - pnorm(0, sd = 1 / sqrt(2)))
# ---- Question 2 -----
# On intègre le code pour avoir l'estimateur et l'intervalle de confiance (cf exo9)

mc_estim_evol <- function(y, level = 0.95) {
  n <- length(y)
  # Évolution de l'estimateur
  delta <- cumsum(y) / (1:n)
  # Évolution de l'estimateur de la variance
  # sigma <- (cumsum((y - delta)^2)) / (0:(n-1)) (marche pas)
  s2 <- (cumsum(y^2) - (1:n) * delta^2) / (0:(n - 1))
  # Erreur quadratique moyenne
  # [-1] signifie qu'on affiche la liste sans l'élément 1 (on retrouve les bonnes dimensions)
  mse <- c(0, s2[-1]) / (1:n)
  # Demi longueur de l'intervalle de confiance
  tol <- qnorm(0.5 * (level + 1)) * sqrt(mse)
  return(data.frame(
    n = 1:n, value = delta, sigma = s2, mse = mse,
    ic_inf = delta - tol, ic_sup = delta + tol, tol = tol, level = level
  ))
}
mc_estim <- function(y, level = .95) {
  # level représente le niveau. Donc si alpha représente le seuil, level = 1- alpha
  # On évalue le quantile q((level +1)/2) de la loi normale (0,1)

  # Estimation
  delta <- mean(y)
  s2 <- var(y)
  # Demi longueur de l'intervalle de confiance
  tol <- qnorm(0.5 * (1 + level)) * sqrt(s2 / length(y))

  # sigma = estimateur de var(y)
  # mse = erreur quadratique moyenne
  return(data.frame(
    n = n, value = delta, sigma2 = s2, mse = s2 / length(y),
    ic_inf = delta - tol, ic_sup = delta + tol, tol = tol, level = level
  ))
}

# Premier estimateur
n <- 10000
x <- runif(n, 0, 2)
delta_hat1 <- mc_estim(2 * exp(-x^2))

# Deuxième estimateur
y <- rnorm(n, 0, 1 / sqrt(2))
delta_hat2 <- mc_estim(sqrt(pi) * (0 <= y & y <= 2))

# Question 3
# Fonction des variables antithétiques
A1 <- function(x) {
  return(2 - x)
}
A2 <- function(x) {
  return(-x)
}

delta_hat3 <- mc_estim(0.5 * (2 * exp(-x^2) + 2 * exp(-A1(x)^2)))
delta_hat4 <- mc_estim(sqrt(pi) * 0.5 * ((0 <= abs(y) & abs(y) <= 2)))

delta_hat1$sigma2
delta_hat2$sigma2
delta_hat3$sigma2
delta_hat4$sigma2


(delta_hat1$sigma2/delta_hat3$sigma2)
(delta_hat2$sigma2/delta_hat4$sigma2)