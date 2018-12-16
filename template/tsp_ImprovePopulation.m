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

function newpop = tsp_ImprovePopulation(popsize, ncities, pop, improve, dists, REPRESENTATION, x, y, HEURISTIC)

if (improve)
   for i=1:popsize
     if isequal(REPRESENTATION,'adj')
        result = improve_path(ncities, adj2path(pop(i,:)),dists);
        if isequal(HEURISTIC,'cross_elimination')
            result = Heuristic(x,y,result);
        end
        pop(i,:) = path2adj(result);
     elseif isequal(REPRESENTATION,'path')
        result = improve_path(ncities, pop(i,:),dists);
        if isequal(HEURISTIC,'cross_elimination');
            result = Heuristic(x,y,result)
        end
        pop(i,:) = result;
     else
        error('Representation not implemented!'); 
    end 
   end
end

newpop = pop;