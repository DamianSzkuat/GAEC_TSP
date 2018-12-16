%
% path2ord(Path)
% function to convert between path and ordinal representation for TSP
% Path and Ord are row vectors


function Path = ord2path(Ord)

% C = ordered list of reference points
C = 1:size(Ord,2);
Path=zeros(size(Ord));
for t = 1:size(Ord,2)
    idx = Ord(t);
    Path(t) = C(idx);
    C(idx) = [];
    
end 
end


% End of function