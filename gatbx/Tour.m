

function NewChrIx = Tour(FitnV,Nsel)

% Identify the population size (Nind)
   [Nind,~] = size(FitnV);

% Perform Tournament selection

Matepool=randi(Nind,Nind,2);
%select two individuals randomly for tournament and chooose the one with best fitness value %
%number of tournament is equal to the number of population size 

Selected = [];
for i=1:Nind
    if FitnV(Matepool(i,1))>= FitnV(Matepool(i,2))
        Selected= [Selected;Matepool(i,1)]; 
    else
        Selected= [Selected;Matepool(i,2)]; 
    end
end



% Shuffle new population
   [~, shuf] = sort(rand(Nind, 1));
   NewChrIx = Selected(shuf);


% End of function

