% MUTATETSP.M       (MUTATion for TSP high-level function)
%
% This function takes a matrix OldChrom containing the 
% representation of the individuals in the current population,
% mutates the individuals and returns the resulting population.
%
% Syntax:  NewChrom = mutate(MUT_F, OldChrom, MutOpt)
%
% Input parameter:
%    MUT_F     - String containing the name of the mutation function
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual.
%    MutOpt    - mutation rate
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mutation in the same format as OldChrom.


function NewChrom = mutateTSP(MUT_F, OldChrom, MutOpt, REPRESENTATION,TABU)
% Check parameter consistency
   if nargin < 2,  error('Not enough input parameters'); end

TABULENGTH = 2;
OldChromSize = size(OldChrom); 
rows = OldChromSize(1);
cols = OldChromSize(2);
CHROMOSOMELENGTH= cols-TABULENGTH-1;

NewChrom=OldChrom;

for r=1:rows
    if rand<MutOpt
        if isequal(TABU,'Yes')  
            if isequal(REPRESENTATION,'adj')
                NewChrom(r,:) = [feval(MUT_F, OldChrom(r,1:CHROMOSOMELENGTH),1),OldChrom(r,CHROMOSOMELENGTH+1: cols) ];
            elseif isequal(REPRESENTATION,'path')
                NewChrom(r,:) = [feval(MUT_F, OldChrom(r,1:CHROMOSOMELENGTH),2), OldChrom(r,CHROMOSOMELENGTH+1: cols)];
            else
                error('Representation not implemented!'); 
            end
        else
            if isequal(REPRESENTATION,'adj')
                NewChrom(r,:) = feval(MUT_F, OldChrom(r,:),1);
            elseif isequal(REPRESENTATION,'path')
                NewChrom(r,:) = feval(MUT_F, OldChrom(r,:),2);
            else
                error('Representation not implemented!'); 
            end
        end
    end
end

% End of function
end
