import numpy as np
from copy import deepcopy
from sklearn.cluster import KMeans


class KMeansClustering:
    def __init__(self, num_culsters) -> None:
        # Number of clusters.
        self.num_culsters = num_culsters
        self.labels_ = None
        self.cluster_centers_ = None
        
    def fit(self, data):
        # Number of training data.
        self.num_observations = data.shape[0]
        # Number of features in the data.
        self.num_features = data.shape[1]

        # Generate random centers, here we use sigma and mean to ensure it represent the whole data.
        mean = np.mean(data, axis = 0)
        std = np.std(data, axis = 0)
        centers = np.random.randn(self.num_culsters, self.num_features) * std + mean

        centers_old = np.zeros(centers.shape) # to store old centers
        centers_new = deepcopy(centers) # Store new centers

        clusters = np.zeros(self.num_observations)
        distances = np.zeros((self.num_observations, self.num_culsters))

        error = np.linalg.norm(centers_new - centers_old)

        # When, after an update, the estimate of that center stays the same, exit loop
        while error != 0:
            # Measure the distance to every center
            for i in range(self.num_culsters):
                distances[:,i] = np.linalg.norm(data - centers[i], axis=1)
            # Assign all training data to closest center
            clusters = np.argmin(distances, axis = 1)
            
            centers_old = deepcopy(centers_new)
            # Calculate mean for every cluster and update the center
            for i in range(self.num_culsters):
                centers_new[i] = np.mean(data[clusters == i], axis=0)
            error = np.linalg.norm(centers_new - centers_old)

        self.cluster_centers_ =  centers_new 


if __name__ == "__main__":
    regions = ["Munster", "Bielefeld", "Duisburg", "Bonn", "Rhein-Main", "Dusseldorf"]

    data = np.array([
        [1524.8, 265.4, 272, 79, 24, 223.5],
        [1596.9, 323.6, 285, 87, 23, 333.9],
        [2299.7, 610.3, 241, 45, 9, 632.1],
        [864.1, 303.9, 220, 53, 11, 484.7],
        [2669.9, 645.5, 202, 61, 15, 438.6],
        [2985.2, 571.2, 226, 45, 16, 1103.9]
    ])

    names = ["Sklean KMeans", "Own implementaion of KMeans"]
    models = [
        KMeans(n_clusters=3, random_state=42),
        KMeansClustering(num_culsters=3)
    ]

    for name, model in zip(names, models):
        print(f"Model: {name}")
        model.fit(data)

        for region, label in zip(regions, model.labels_):
            print(f"Region: {region.ljust(15)}   Label: {label}")

        print("\n")