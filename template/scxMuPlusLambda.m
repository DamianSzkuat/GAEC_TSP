% Sequenctial Constructive Crossover (PMX) for TSP 
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

function NewChrom = scxMuPlusLambda(OldChrom, XOVR, Distances,TABU,OffspringSize)
TABULENGTH = 2;
OldChromSize = size(OldChrom); 
rows = OldChromSize(1);
cols = OldChromSize(2);
CHROMOSOMELENGTH= cols-TABULENGTH;


maxrows = rows;
if rem(rows,2)~=0
    maxrows=maxrows-1;
end
NewChrom=zeros(rows,cols+1);


    
    %Randomly select two Offspring for mating
    % crossover of the two chromosomes
   	% results in 2 offsprings
   
    if isequal(TABU,'Yes')
           
            parent1 = OldChrom(row,:);
            parent2= OldChrom(row+1,:);
        
     
            if rand<XOVR
            % recombine with a given probability   
            % check whether the offspring will be tabu:
            % this occurs when the first allel of a parent occurs in the
            % tabu list of the other parent.
            % Tabu children -last index = -1 - are not allowed to survive (implemented in reins.m), 
            % unless their fitness value is greater than that of the best among
            % the parental generation.
                if( (ismember(OldChrom(row,CHROMOSOMELENGTH +1), OldChrom(row+1, CHROMOSOMELENGTH +1 :cols) )) || (ismember(OldChrom(row+1,CHROMOSOMELENGTH +1), OldChrom(row, CHROMOSOMELENGTH +1 :cols))))

                    NewChrom(row,cols+1)= -1;
                    NewChrom(row+1, cols+1)= -1;           
             
                else   %not tabu, last index = 0.
                   NewChrom(row,cols+1)= 0;
                   NewChrom(row+1, cols+1)= 0;
             
                end
            
                % mate
                NewChrom(row,1:CHROMOSOMELENGTH) = sequential_constructive_cross([parent1(1, 1:CHROMOSOMELENGTH);parent2(1, 1:CHROMOSOMELENGTH)], Distances);
                NewChrom(row+1,1:CHROMOSOMELENGTH)= sequential_constructive_cross([parent2(1, 1:CHROMOSOMELENGTH);parent1(1, 1:CHROMOSOMELENGTH)], Distances);
               
                %make tabulist for offspring
                NewChrom(row, CHROMOSOMELENGTH +1: CHROMOSOMELENGTH + TABULENGTH) = [parent1(CHROMOSOMELENGTH +1),parent2(CHROMOSOMELENGTH +1)];%,parent1(CHROMOSOMELENGTH +2),parent2(CHROMOSOMELENGTH +2)];                 
                NewChrom(row+1, CHROMOSOMELENGTH +1: CHROMOSOMELENGTH +TABULENGTH) = [parent2(CHROMOSOMELENGTH +1),parent1(CHROMOSOMELENGTH +1)];%,parent2(CHROMOSOMELENGTH +2),parent1(CHROMOSOMELENGTH +2)]; 
                
            else
              The folowing offspring are clones of the parents and thus labeled tabu. 
             NewChrom(row,:) = [OldChrom(row,:),-1];
             NewChrom(row+1,:) = [OldChrom(row+1,:),-1];
            end
    else    
        maxrows = rows;
        if rem(rows,2)~=0
            maxrows=maxrows-1;
        end
            if rand<XOVR	
                % mate
                NewChrom(row,:) = sequential_constructive_cross([parent1(1,:);parent2(1, :)], Distances);
                NewChrom(row+1,:)= sequential_constructive_cross([parent2(1, :);parent1(1, :)], Distances);              
            else
                NewChrom(row,:) = OldChrom(row,:);
                NewChrom(row+1,:) = OldChrom(row+1,:); 
            end     
    end        

end

