# Stock Market prediction using ML and LDA on twitter data

Latent Dirichlet Allocation (LDA) and ANN used in an analysis of stock related tweets, to predict the movement of the Dow Jones index.

By aggregating stock related tweets on an hourly basis, LDA is able to discover latent topics. The latent topics are used in both a K-Nearest Neighbour and an Artificial Neural Network classifier.

Evaluating the classifiers through Kappa statistics and F1 score show no evidence of predictive performance. Aggregating tweets in shorter intervals as an approach to improve classifier performance is discussed, and so is the application of TF-iDF as an alternative method for weighting term importance.

Multidimensional Scaling is applied to provide a visual representation of the distances (euclidean) between the tweets (documents).

### This repository contains the R scripts used to obtain our results

