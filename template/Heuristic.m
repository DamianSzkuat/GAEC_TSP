function [Betterpath] = Heuristic(X, Y, Path)
% INPUT= x,y coordinates, path representation, OUTPUT = pathrepresentation.
%HEURISTIC
%   This heuristic reduces the cost of a path by removing the crossing (if any)
%   with the largest cost attached to it.
OriginalPath = Path;
% Number of Cities
Nvar =length(X);
% We orden the coordinates according to the given path.

Xpath = X(Path); Ypath= Y(Path);

% Find the intersecting segments.
[~,~, Segments]=selfintersect(Xpath,Ypath); % returns intersecting segments in path order.

if( size(Segments,1) >0)
    % Initialize list of paths with a crossing undone
    Uncross=zeros(size(Segments,1),Nvar);

    % Distance matrix

    Dist=zeros(Nvar,Nvar);
    for i=1:size(X,1)
        for j=1:size(Y,1)
            Dist(i,j)=sqrt((X(i)-X(j))^2+(Y(i)-Y(j))^2);
        end
    end    
    
    % Cost of the original path
    W = path2adj(OriginalPath);
    Objvalue = Dist(W(1),1);
    for t= 2:length(W)
        Objvalue= Objvalue + Dist(W(t),t);
    end   
    OriginalCost = Objvalue; 

    % list of cost reductions associated with the uncrossings. 
    CostReduction = zeros(1, size(Segments,1));    
    

    for i = 1: size(Segments,1)
        A= Segments(i,1); C= Segments(i,2);
         % find the order of appearence in the path.
        if ( A == Nvar)
            B=1;
        else 
            B= A+1;
        end
        % We now have two line segments determined by the points(A,B) and the points (C,D)
        % ordened according to the path representation.

        % We set out to resolve the crossing (possibly creating a new one in the process).

        % Two points are connected if after removal of the crossing there still exists a path.
        % Given that we used the path representation the order of the tour necessarily is 
        % Start,....A,B....C,D. Where AB crosses with CD. A is connected to D so we connect A to C now.

        %connect A to C.
        Order= [1: Nvar];
        temp= Order(B);        
        Order(B)= Order(C);
        Order(C)= temp;
        
        Uncross(i,:) = Path(Order);


        %evaluate objective function

        R  = path2adj(Uncross(i,:));
        Objval = Dist(R(1),1);
        for t= 2:length(R)
            Objval= Objval + Dist(R(t),t);
        end   
        CostReduction(i) = OriginalCost-Objval; 

    end 
    [~, Pos]= max(CostReduction);
    % pick the path with the greatest cost reduction.
    if ( max(CostReduction) >0 )
        Betterpath = Uncross(Pos,:);
    else 
        Betterpath = OriginalPath;
    end    
else 
    Betterpath = OriginalPath;
end
end