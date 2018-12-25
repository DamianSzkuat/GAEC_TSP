% Sequenctial Constructive Crossover (PMX) for TSP 
% 
% Syntax: NewChrom = pmx(OldChrom, XOVR)
%
% Input parameters: 
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual
%                (in any form, not necessarily real values).
%    XOVR      - Probability of recombination occurring between pairs
%                of individuals.
%    Distances - The distances between every two cities.
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mating, ready to be mutated and/or evaluated,
%                in the same format as OldChrom.
%

function NewChrom = scx(OldChrom, XOVR, Distances)

[rows,cols]=size(OldChrom);
maxrows = rows;
if rem(rows,2)~=0
    maxrows=maxrows-1;
end

for row = 1:2:maxrows 
    % crossover of the two chromosomes
   	% results in 2 offsprings
	if rand<XOVR			% recombine with a given probability
		NewChrom(row,:) = sequential_constructive_cross([OldChrom(row,:);OldChrom(row+1,:)], Distances);
        NewChrom(row+1,:)= sequential_constructive_cross([OldChrom(row+1,:);OldChrom(row,:)], Distances);
        
        % Since the order of parents does not matter for scx we avoid
        % making two of the same offpsring and randomly keep one of the
        % parents in the population 
		%NewChrom(row+1,:)= OldChrom(row+round(rand),:);
        
        % Use pmx to create a second offspring, order of parents is chosen
        % randomly 
        % if round(rand)
        %     NewChrom(row+1,:) = cross_partially_mapped([OldChrom(row,:);OldChrom(row+1,:)]);
        % else 
        %     NewChrom(row+1,:) = cross_partially_mapped([OldChrom(row+1,:);OldChrom(row,:)]);
        % end 
    else
		NewChrom(row,:) = OldChrom(row,:);
		NewChrom(row+1,:) = OldChrom(row+1,:);
	end
end 

end