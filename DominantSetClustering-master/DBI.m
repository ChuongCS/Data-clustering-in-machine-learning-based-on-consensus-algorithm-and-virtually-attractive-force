% DBI evaluation
X1 = csvread('s1.csv');
E1 = evalclusters(X1,'kmeans','DaviesBouldin','klist',[1:20]);
X2 = csvread('s2.csv');
E2 = evalclusters(X2,'kmeans','DaviesBouldin','klist',[1:20]);
X3 = csvread('s3.csv');
E3 = evalclusters(X3,'kmeans','DaviesBouldin','klist',[1:20]);
figure; hold on
a1 = plot(E1.InspectedK,E1.CriterionValues,'-b','linewidth',2); S1 = "S1";
a2 = plot(E2.InspectedK,E2.CriterionValues,'-g','linewidth',2); S2 = "S2";
a3 = plot(E3.InspectedK,E3.CriterionValues,'-r','linewidth',2); S3 = "S3";

legend([a1; a2; a3], [S1; S2; S3]);
xlabel('Number of clusters')
ylabel('Davies-Bouldin Index')

X1 = csvread('a1.csv');
E1 = evalclusters(X1,'kmeans','DaviesBouldin','klist',[1:80]);
X2 = csvread('a2.csv');
E2 = evalclusters(X2,'kmeans','DaviesBouldin','klist',[1:80]);
X3 = csvread('a3.csv');
E3 = evalclusters(X3,'kmeans','DaviesBouldin','klist',[1:80]);
figure; hold on
a1 = plot(E1.InspectedK,E1.CriterionValues,'-b','linewidth',2); S1 = "A1";
a2 = plot(E2.InspectedK,E2.CriterionValues,'-g','linewidth',2); S2 = "A2";
a3 = plot(E3.InspectedK,E3.CriterionValues,'-r','linewidth',2); S3 = "A3";

legend([a1; a2; a3], [S1; S2; S3]);
xlabel('Number of clusters')
ylabel('Davies-Bouldin Index')




