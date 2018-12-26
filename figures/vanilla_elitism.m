A = [64.22422 61.3487  61.78158 62.46978 62.37838  62.3578 60.7854 62.6025 61.6636 65.1567];
B = [60.52426 56.05846 55.26634 53.54884 53.224475 53.9716 55.4483 55.4912 57.1651 56.9415];

X = [5 10 15 20 25 30 35 40 45 50]

plot(X,A)
%clear title xlabel ylabel
xlabel('% Elitism')
ylabel('Shortest path length')
hold on
plot(X,B)
legend('50 individuals/100 generations','150 individuals/300 generations')
title('Effects of elitism')
hold off