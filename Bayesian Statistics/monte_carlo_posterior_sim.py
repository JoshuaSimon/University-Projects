# Posterior computations for the binomial model.

import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Given data from example.
n_1 = 10
n_2 = 20
y_1 = 6
y_2 = 10

# Parameters for Beta prior distribution.
a_1 = 1
b_1 = 1
a_2 = 1
b_2 = 1

# Parameters for Beta posterior distribution.
alpha_1 = a_1 + y_1
beta_1 = b_1 + n_1 - y_1
alpha_2 = a_2 + y_2
beta_2 = b_2 + n_2 - y_2

# Simulation to approximate the posterior 
# distribution p(p_1 - p_2 | y_1, y_2) using Monte Carlo.
draws = 500000
delta = []
for r in range(draws):
    p_1 = (np.random.beta(alpha_1, beta_1))
    p_2 = (np.random.beta(alpha_2, beta_2))
    delta.append(p_1 - p_2)

# PLot the result.
sns.distplot(delta, hist=True, kde = True, color="red",  
            hist_kws={'edgecolor':'black'},
            kde_kws={'linewidth': 4})
plt.show()

# Calculate the expectation for delta.
#delta_expect = 1/draws * sum(delta)
delta_expect = np.mean(delta)
print(f"Mean for p_1 - p_2 = {delta_expect}")

# Calculate a 95% posterior interval, e.g. [q_0.025, q_0.975].
delta_sorted = np.sort(delta)
lower_bound = delta_sorted[int(0.025 * draws)]
upper_bouod = delta_sorted[int(0.975 * draws)]
print(f"95% posterior interval: [{lower_bound}, {upper_bouod}]")

quantile_bounds = np.quantile(delta_sorted, [0.025, 0.975])
print(f"95% posterior interval: [{quantile_bounds[0]}, {quantile_bounds[1]}]")

# Calculate the posterior probability that p1 > p2.
delta = np.array(delta)
prob = len(delta[delta > 0]) / len(delta)
print(f"Posterior probability that p1 > p2: {prob}")

