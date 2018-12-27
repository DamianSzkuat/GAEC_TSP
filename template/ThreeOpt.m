function newtour = ThreeOpt(x,y,tour, i, j, k)
    %If reversing tour[i:j] would make the tour shorter, then do it."
    % Given tour [...A-B...C-D...E-F...]
    A=i-1; B=i; C=j-1; 
    D=j; E=k-1; 
    if k <= length(tour)
        F= k;
    else    
        F = mod(k,length(tour));
    end    
    NVAR= length(tour);
    distance=zeros(NVAR,NVAR);
    for a=1:size(x,1)
        for b=1:size(y,1)
            distance(a,b)=sqrt((x(a)-x(b))^2+(y(a)-y(b))^2);
        end
    end
    
    
    d0 = distance(A,B) + distance(C,D) + distance(E,F);
    d1 = distance(A,C) + distance(B,D) + distance(E,F);
    d2 = distance(A,B) + distance(C,E) + distance(D,F);
    d3 = distance(A,D) + distance(E,B) + distance(C,F);
    d4 = distance(F,B) + distance(C,D) + distance(E,A);
    
    distances= [d0,d1,d2,d3,d4];
    minDist= min(distances);
    if minDist == d1
        snippet = tour(i:j-1);
        reversedsnippet= snippet(length(snippet):-1:1);
        newtour = [tour(1:i-1),reversedsnippet, tour(j:length(tour))];
    elseif minDist== d2
        snippet = tour(j:k-1);

        reversedsnippet= snippet(length(snippet):-1:1);
        if k == length(tour)+1
            
            newtour = [tour(1:j-1), reversedsnippet]; 
        else

            newtour = [tour(1:j-1), reversedsnippet, tour(k:length(tour))];        
        end
        
    elseif minDist == d4
        snippet = tour(i:k-1);   
        reversedsnippet= snippet(length(snippet):-1:1);
        if k == length(tour)+1
         
            newtour = [tour(1:i-1), reversedsnippet];
        else 
           

            newtour = [tour(1:i-1), reversedsnippet, tour(k:length(tour))]; 
        end
    elseif minDist == d3
      if k == length(tour)+1  
         
         newtour = [tour(1:i-1),tour(j:k-1),tour(i:j-1)]; 
      else    
           

        newtour = [tour(1:i-1),tour(j:k-1),tour(i:j-1),tour(k:length(tour))];        
      end
    else 
       newtour = tour;
    end
end

