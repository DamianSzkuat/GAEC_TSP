%
% ObjVal = tspfun(Phen, Dist)
% Implementation of the TSP fitness function
%	Phen contains the phenocode of the matrix coded in adjacency
%	representation
%	Dist is the matrix with precalculated distances between each pair of cities
%	ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
%

function ObjVal = tspfun(Phen, Dist, REPRESENTATION);
    if isequal(REPRESENTATION,'path')
        for i=1:size(Phen,1)
            Phen(i,:) = path2adj(Phen(i,:));
        end
    elseif isequal(REPRESENTATION,'adj') == 0
        error('Representation not implemented!'); 
    end
    
	ObjVal=Dist(Phen(:,1),1);
	for t=2:size(Phen,2)
    	ObjVal=ObjVal+Dist(Phen(:,t),t);
    end
end
    % End of function

