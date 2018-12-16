function Offspring = cross_partially_mapped(Parents)
    
    allele_count = size(Parents,2);

    % 1) Set up swap segment 
    % Initialize size of swap segment
    % A segment of size 1 is useless so w start at 2
    % A segment of size == allele count is also useless so 
    % we max out at allele count - 1
    %segment_size = randi([2 allele_count-1],1);
    segment_size = 4;

    % idx_l refers to the left index of the segment 
    % idx_r refers to the right index of the segment 
    % idx_l = randi([1 allele_count-segment_size+1],1);
    idx_l = 4;
    idx_r = idx_l + segment_size - 1;
    
    % 2) Initialize offspring 
    Offspring = zeros(1,allele_count);
    Offspring(1,idx_l:idx_r) = Parents(1,idx_l:idx_r);
    
    % 3) Create mapping of values in the segments of both parents
    mapping(1,1:segment_size) = Parents(1,idx_l:idx_r);
    mapping(2,1:segment_size) = Parents(2,idx_l:idx_r);
    
    % 4) Copy non-conflict values 
    for i = 1:allele_count
        % Outside of the swap segment
        if i<idx_l || i>idx_r
            % The value of parent 2 at index i is not in the swap segment
            % of parent 1
            if ismember(Parents(2,i), Parents(1,idx_l:idx_r)) == 0
                Offspring(1,i) = Parents(2,i);
            end 
        end
    end
    % 5) Use mappings to fill the remaining values: 
    for i = 1:size(mapping,2)
        % Value not yet in offspring
        if ismember(mapping(2,i), Offspring) == 0
            flag = 1;
            % nb is the value in Parent 1 at the index of the 
            % value we want to add from Parent 2
            nb = mapping(1,i);
            while flag
                % Find the index where nb occurs in Parent 1
                idx = find(Parents(2,:)==nb);
                if idx < idx_l || idx > idx_r
                    % If this index is outside the swap segment, add the
                    % value that we wanted to add to the offspring at the
                    % current index and stop the loop (flag = 0)
                    Offspring(idx) = mapping(2,i);
                    flag = 0;
                else
                    % If the index is inside the swap segment, find the
                    % number that belongs to that index in Parent 2 and
                    % repeat the loop for this number.
                    nb = Parents(1,idx);
                end
            end
        end
    end
end

