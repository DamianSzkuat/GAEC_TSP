%
% path2ord(Path)
% function to convert between path and ordinal representation for TSP
% Path and Ord are row vectors


function Ord = path2ord(Path)

% C = ordered list of reference points
C = 1:size(Path,2);
Ord=zeros(size(Path));
% Ordinal Representation 
for t = 1:size(Path,2)-1
    idx = find(C==Path(t));
    Ord(t) = idx;
    C(idx) = [];
    
end 
Ord(size(Path,2))=1;    
end


% End of function