function Offspring = sequential_constructive_cross(Parents, Distances)
    allele_count = size(Parents,2);

    % Initialize an offspring
    Offspring = zeros(1,allele_count);

    % 1) Start by selecting p = 1 as the first node 
    p = 1;
    Offspring(1) = p;

    for i=2:size(Offspring,2)
        % 2) Find the first legitimate (not yet visited) node after p in both parents
        p_1 = Parents(1,:);
        p_2 = Parents(2,:);
        a = get_next_legitimate_node(p, p_1, Offspring);
        b = get_next_legitimate_node(p, p_2, Offspring);
        % 3) See which node is closer
        d_p_a = Distances(p, a);
        d_p_b = Distances(p, b);
        if d_p_a < d_p_b 
            new_p = a;
        else 
            new_p = b;
        end
        % Assign the new new node and continue to the next node
        Offspring(i) = new_p;
        p = new_p;
    end
end

function Node = get_next_legitimate_node(p, Parent, Offspring)
    idx_p = find(Parent==p);
    Node = 0;
    for i=idx_p+1:size(Parent,2)
        if ismember(Parent(i),Offspring) == 0
            Node = Parent(i);
            break;
        end
    end   
    if Node == 0
        nodes = randperm(size(Parent,2));
        for i=1:size(Parent,2)
            if ismember(nodes(i),Offspring) == 0
                Node = nodes(i);
                break;
            end
        end
    end
end