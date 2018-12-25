% This function applies cross-elimination to the result
function result = cross_elimination(x, y, result, ncities)
    % untangle small crosses
    start = randi([1,ncities]);
    SMALL=7;
    for j= 0: ceil (ncities/SMALL) 
        result=Heuristic(x, y, result ,mod(start +SMALL*j,ncities),SMALL);
    end   
    
    %untangle large crosses 
    LARGE= 40;
    % sniplength2=0;
    if( ncities >= LARGE) 
        sniplength2=randi([SMALL,LARGE]);
    else
        sniplength2= randi([SMALL,ncities]);
    end
    SampleAmount = ceil (ncities/LARGE); 
    for k= 0: SampleAmount
        start2 = randi([1,ncities]);
        result=Heuristic(x, y, result  ,start2, sniplength2);     
    end
end

