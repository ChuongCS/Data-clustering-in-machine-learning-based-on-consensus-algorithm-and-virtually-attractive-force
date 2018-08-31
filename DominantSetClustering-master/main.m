%DATA=DATA4(:,1:3);
DATA=csvread('unbalance.csv'); DATA=DATA(:,1:2);
X=consensus(DATA);
S = create_sim_matrix(X);
[clusters charVectors prototypeIndices payoffs nCluster] = clusterDS(S, [], []);
plot_data(DATA(:,1:end), clusters);
