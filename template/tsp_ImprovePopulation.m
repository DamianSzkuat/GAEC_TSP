% tsp_ImprovePopulation.m
% Author: Mike Matton
% 
% This function improves a tsp population by removing local loops from
% each individual.
%
% Syntax: improvedPopulation = tsp_ImprovePopulation(popsize, ncities, pop, improve, dists)
%
% Input parameters:
%   popsize           - The population size
%   ncities           - the number of cities
%   pop               - the current population (adjacency representation)
%   improve           - Improve the population (0 = no improvement, <>0 = improvement)
%   dists             - distance matrix with distances between the cities
%
% Output parameter:
%   improvedPopulation  - the new population after loop removal (if improve
%                          <> 0, else the unchanged population).
function newpop = tsp_ImprovePopulation(popsize,NVAR,pop,improve,dists,REPRESENTATION,x,y, HEURISTIC)
ncities= NVAR; 
SMALL=30;
LARGE = 40;

     for i=1:popsize       
        if isequal(REPRESENTATION,'adj')
            result =   adj2path(pop(i,:));

        elseif isequal(REPRESENTATION,'path')
            result = pop(i,:);
        else
            error('Representation not implemented!'); 
        end    
        if isequal(HEURISTIC,'cross_elimination')     
            % untangle small crosses
            start = randi([1,ncities]);         
            for j= 0: ceil (ncities/SMALL) 
                result=Heuristic(x, y, result ,mod(start +SMALL*j,ncities),SMALL);
            end      
%            %untangle large crosses 
%            sniplength2=0;
%            if( ncities >= LARGE) 
%              sniplength2=randi([SMALL,LARGE]);
%            else
%              sniplength2= randi([SMALL,ncities]);
%            end
%            SampleAmount = ceil (ncities/LARGE); 
%            for k= 0: SampleAmount
%             start2 = randi([1,ncities]);
%             result=Heuristic(x, y,result ,mod(start2+sniplength2*k,ncities),sniplength2);     
%            end
        end
        if (improve)
            % remove loops
            result = improve_path(ncities,result ,dists);
            % three opt 
            irand = randi([2,ncities-4]); 
            for j = irand+2 : ncities-2
                for k= j+2 : ncities+1
                    ThreeOpt(x,y,result,irand,j,k);
                end
            end    
            %jrand = randi([irand+2,ncities-2]);      end
            %krand =  randi([jrand+2,ncities+1]
            %ThreeOpt(x,y,result,irand,jrand,krand);
            % reconvert to adjacency representation
        end
        if isequal(REPRESENTATION,'adj')
            pop(i,:) = path2adj(result);    
        
        else 
           pop(i,:) = result;  
        end        
     end
newpop = pop;    
end

