% Sequenctial Constructive Crossover (SCX) for TSP 
% 
% Syntax: NewChrom = pmx(OldChrom, XOVR, OffspringSize)
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

function NewChrom = scxMuLambda(OldChrom, XOVR, Distances,TABU)
TABULENGTH = 4;
OldChromSize = size(OldChrom) ;
rows = 7*OldChromSize(1);
cols = OldChromSize(2);
CHROMOSOMELENGTH= cols-TABULENGTH;
%[rows,cols]=size(OldChrom);



NewChrom=[];
counter= 1;
if isequal(TABU,'Yes')
    while counter < rows
    %Randomly select two Offspring for mating
    % crossover of the two chromosomes
   	% results in 2 offsprings
            parentindex1 = randi([1,OldChromSize(1)]);
            parentindex2 =  randi([1,OldChromSize(1)]);
            parent1 = OldChrom(parentindex1,:);
            parent2= OldChrom(parentindex2,:);        
            if( (ismember(OldChrom(parentindex1,CHROMOSOMELENGTH +1), OldChrom(parentindex2, CHROMOSOMELENGTH +1 :cols) )) || (ismember(OldChrom(parentindex2,CHROMOSOMELENGTH +1), OldChrom(parentindex1, CHROMOSOMELENGTH +1 :cols))))
                bar = XOVR/10;
            else
                bar = XOVR;
            end    
            if rand<bar			
            % recombine with a given probability   
            % check whether the offspring will be tabu:
            % this occurs when the first allel of a parent occurs in the
            % tabu list of the other parent.
            % Tabu children -last index = -1 - are not allowed to survive (implemented in reins.m), 
            % unless their fitness value is greater than that of the best among
            % the parental generation.
                if( (ismember(OldChrom(parentindex1,CHROMOSOMELENGTH +1), OldChrom(parentindex2, CHROMOSOMELENGTH +1 :cols) )) || (ismember(OldChrom(parentindex2,CHROMOSOMELENGTH +1), OldChrom(parentindex1, CHROMOSOMELENGTH +1 :cols))))
                    NewChrom(counter,cols+1)= -1;
                    if(counter ~= rows-1)
                        NewChrom(counter+1, cols+1)= -1;           
                    end    
                else   %not tabu, last index = 0.
                   NewChrom(counter,cols+1)= 0;
                    if(counter ~= rows-1)
                        NewChrom(counter+1, cols+1)= 0;
                    end    
                end           
                % mate
                NewChrom(counter,1:CHROMOSOMELENGTH) = sequential_constructive_cross([parent1(1, 1:CHROMOSOMELENGTH);parent2(1, 1:CHROMOSOMELENGTH)], Distances);
                if(counter ~= rows-1)
                    NewChrom(counter+1,1:CHROMOSOMELENGTH)= sequential_constructive_cross([parent2(1, 1:CHROMOSOMELENGTH);parent1(1, 1:CHROMOSOMELENGTH)], Distances);
                end    
                %make tabulist for offspring
                NewChrom(counter, CHROMOSOMELENGTH +1: CHROMOSOMELENGTH + TABULENGTH) = [parent1(CHROMOSOMELENGTH +1),parent2(CHROMOSOMELENGTH +1),parent1(CHROMOSOMELENGTH +2),parent2(CHROMOSOMELENGTH +2)]; 
                 if(counter ~= rows-1)
                    NewChrom(counter+1, CHROMOSOMELENGTH +1: CHROMOSOMELENGTH +TABULENGTH) = [parent2(CHROMOSOMELENGTH +1),parent1(CHROMOSOMELENGTH +1),parent2(CHROMOSOMELENGTH +2),parent1(CHROMOSOMELENGTH +2)]; 
                 end            
                counter = counter +2;
            end   
    end
    
else    
    while counter < rows
            parentindex1 =  randi([1,OldChromSize(1)]);
            parentindex2 =  randi([1,OldChromSize(1)]);
            parent1 = OldChrom(parentindex1,:);
            %if round(rand)
                parent2 = OldChrom(parentindex2,:);  
            %else 
            %    parent2 = randperm(cols);
        % crossover of the two chromosomes
        % results in 2 offsprings
        if rand<XOVR			% recombine with a given probability
               % mate
                NewChrom(counter,:) = sequential_constructive_cross([parent1(1, :);parent2(1,:)], Distances);
                if(counter ~= rows-1)
                    NewChrom(counter+1,:)= sequential_constructive_cross([parent2(1, :);parent1(1,:)], Distances);
                end    
                counter = counter +2;
        end    
    end
end

end

