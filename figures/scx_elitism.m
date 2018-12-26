A = [11.76232 12.12788 11.96048 12.51326 12.23676];

X = [5 10 15 20 25];

plot(X,A)
%clear title xlabel ylabel
axis([5 25 0 60])
xlabel('% Elitism')
ylabel('Shortest path length')
title('Effects of elitism')