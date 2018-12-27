A = [11.76232	11.86132	11.34732	11.432      11.17814
     11.79218	11.68314	11.43308	11.33232	11.1758
     12.21242	11.71414	11.5177     11.2487     11.0737
     12.1352	12.00256	11.67852	11.36856	11.18096
     13.29066	13.01446	12.5009     11.97114	12.06272];

X = [5 10 20 30 50];
Y = [95 90 80 70 50];

h = heatmap(X,Y,A, 'Colormap', parula, 'XLabel', '% Mutation', 'YLabel', '% Crossover')
h.Title = 'Best found tour length'