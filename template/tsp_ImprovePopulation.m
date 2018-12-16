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
function newpop = tsp_ImprovePopulation(popsize,pop,improve,dists,x,y)

if (improve)
     for i=1:popsize
     if isequal(REPRESENTATION,'adj')
         result =   adj2path(pop(i,:));
         if isequal(HEURISTIC,'cross_elimination')     
            % untangle small crosses
            start = randi([1,ncities]);
            SMALL=7;
            for j= 0: ceil (ncities/SMALL) 
                result=Heuristic(x, y, result ,mod(start +SMALL*j,ncities),SMALL);
            end      
           %untangle large crosses 
           LARGE= 40;
           sniplength2=0;
           if( ncities >= LARGE) 
             sniplength2=randi([SMALL,LARGE]);
           else
             sniplength2= randi([SMALL,ncities]);
           end
           SampleAmount = ceil (ncities/LARGE); 
           for k= 0: SampleAmount
            start2 = randi([1,ncities]);
            result=Heuristic(x, y,result ,start2,sniplength2);     
           end
        end
        % remove loops
        result = improve_path(ncities,result ,dists);       
        % convert to adjacency representation
        pop(i,:) = path2adj(result); 
      elseif isequal(REPRESENTATION,'path')
            if isequal(HEURISTIC,'cross_elimination')
                result = pop(i,:);
                % untangle small crosses
                start = randi([1,ncities]);
                SMALL=7;
                for j= 0: ceil (ncities/SMALL) 
                    result=Heuristic(x, y,result ,mod(start +SMALL*j,ncities),SMALL);
                end 
                %untangle large crosses 
                LARGE= 40;
                sniplength2=0;
                if( ncities >= LARGE) 
                    sniplength2=randi([SMALL,LARGE]);
                else
                sniplength2= randi([SMALL,ncities]);             
                end
                SampleAmount = ceil (ncities/LARGE); 
                for k= 0: SampleAmount;
                    start2 = randi([1,ncities]);
                    result=Heuristic(x, y,result ,start2,sniplength2);     
                end
            end  
            % remove loops
            pop(i,:)= improve_path(ncities,result ,dists);  
      else
            error('Representation not implemented!'); 
      end        
  end  
  newpop = pop;    
end

