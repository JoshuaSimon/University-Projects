import numpy as np
from math import sqrt

# Ex 6a)
def minkowski_norm(x_k, q):
    mean = np.mean(x_k)
    s = (1/len(x_k) * sum([abs(x - mean)**q for x in x_k]))**(1/q)
    return (np.array(x_k) - mean) / s

def minkowski_metric(x_i, x_j, q=2, norm=False):
    if norm:
        x_i = minkowski_norm(x_i, q)
        x_j = minkowski_norm(x_j, q)
    return sum([abs(i - j)**q for i, j in zip(x_i, x_j)])**(1/q)


x_1 = [55, 2500, 4]
x_2 = [23, 1800, 3]
x_3 = [31, 3500, 0]


print("Minkowski distance for q = 1:")
print(minkowski_metric(x_1, x_2, 1))
print(minkowski_metric(x_1, x_3, 1))
print(minkowski_metric(x_2, x_3, 1))
print("\n")

print("Minkowski distance for q = 2:")
print(minkowski_metric(x_1, x_2, 2))
print(minkowski_metric(x_1, x_3, 2))
print(minkowski_metric(x_2, x_3, 2))
print("\n")


# Ex. 6b)
def mahalanobis_metric(X, x_i, x_j):
    #S = 1/len(X) * np.transpose(X - np.mean(X)) * (X - np.mean(X))
    S = np.cov(X)
    #return sqrt(np.transpose(x_i - x_j) * np.linalg.inv(S) * (x_i - x_j))
    return sqrt(np.transpose(x_i - x_j) * np.linalg.pinv(S) * (x_i - x_j))

x_1 = np.array(x_1)
x_1 = np.array(x_2)
x_1 = np.array(x_3)
X = [x_1, x_2, x_3]

#print(mahalanobis_metric(X, x_1, x_2))
#print(mahalanobis_metric(X, x_1, x_3))
#print(mahalanobis_metric(X, x_2, x_3))

print(np.cov(X))
print(np.linalg.det(np.cov(X)))

print("Normed Minkowski distance for q = 1:")
print(minkowski_metric(x_1, x_2, 1, norm=True))
print(minkowski_metric(x_1, x_3, 1, norm=True))
print(minkowski_metric(x_2, x_3, 1, norm=True))
print("\n")

print("Normed Minkowski distance for q = 2:")
print(minkowski_metric(x_1, x_2, 2, norm=True))
print(minkowski_metric(x_1, x_3, 2, norm=True))
print(minkowski_metric(x_2, x_3, 2, norm=True))
print("\n")


# Ex 6c)
def m_s_coeff(x_i, x_j, gamma=0.5, coeff="m"):
    a = 0
    b = 0 
    c = 0
    d = 0

    for i, j in zip(x_i, x_j):
        if i == 1 and j == 1:
            a += 1
        elif i == 1 and j == 0:
            b += 1
        elif i == 0 and j == 1:
            c += 1
        elif i == 0 and j == 0:
            d += 1

    print(f"Table: a = {a}, b = {b}, c = {c}, d = {d}")

    if coeff == "m":
        s_ij = gamma * (a + d) / (gamma * (a + d) + (1 - gamma) * (b + c))
    elif coeff == "s":
        s_ij = gamma * a / (gamma * a + (1 - gamma) * (b + c))

    return s_ij


x_1 = [1, 1, 0]
x_2 = [0, 0, 0]
x_3 = [0, 1, 1]

# Test data from lecture.
#x_1 = [1, 0, 1, 1]
#x_2 = [1, 0, 1, 0]
#x_3 = [0, 0, 0, 1]

print("M-Coefficients")
print("--------------")
print("Simple-Matching-Coefficient")
print(m_s_coeff(x_1, x_2, gamma=0.5))
print(m_s_coeff(x_1, x_3, gamma=0.5))
print(m_s_coeff(x_2, x_3, gamma=0.5))
print("\n")

print("Rogers and Tanimoto")
print(m_s_coeff(x_1, x_2, gamma=1/3))
print(m_s_coeff(x_1, x_3, gamma=1/3))
print(m_s_coeff(x_2, x_3, gamma=1/3))
print("\n")

print("Sokal and Sneath")
print(m_s_coeff(x_1, x_2, gamma=2/3))
print(m_s_coeff(x_1, x_3, gamma=2/3))
print(m_s_coeff(x_2, x_3, gamma=2/3))
print("\n")

print("S-Coefficients")
print("--------------")
print("Jaccard-Coefficient")
print(m_s_coeff(x_1, x_2, gamma=0.5, coeff="s"))
print(m_s_coeff(x_1, x_3, gamma=0.5, coeff="s"))
print(m_s_coeff(x_2, x_3, gamma=0.5, coeff="s"))
print("\n")

print("Sokal und Sneath")
print(m_s_coeff(x_1, x_2, gamma=1/3, coeff="s"))
print(m_s_coeff(x_1, x_3, gamma=1/3, coeff="s"))
print(m_s_coeff(x_2, x_3, gamma=1/3, coeff="s"))
print("\n")


# Ex 6d)
x_1 = [0, 1, 0]
x_2 = [1, 0, 0]
x_3 = [1, 1, 1]

print("M-Coefficients")
print("--------------")
print("Simple-Matching-Coefficient for m = 1")
print(m_s_coeff(x_1, x_2, gamma=0.5))
print(m_s_coeff(x_1, x_3, gamma=0.5))
print(m_s_coeff(x_2, x_3, gamma=0.5))
print("\n")

print("M-Coefficients")
print("--------------")
print("Simple-Matching-Coefficient for w = 1")
print(m_s_coeff(x_1, x_2, gamma=0.5))
print(m_s_coeff(x_1, x_3, gamma=0.5))
print(m_s_coeff(x_2, x_3, gamma=0.5))
print("\n")