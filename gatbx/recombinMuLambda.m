% RECOMBIN.M       (RECOMBINation high-level function)
%
% This function performs recombination between pairs of individuals
% and returns the new individuals after mating. The function handles
% multiple populations and calls the low-level recombination function
% for the actual recombination process.
%
% Syntax:  NewChrom = recombin(REC_F, OldChrom, Distances, RecOpt, SUBPOP)
%
% Input parameters:
%    REC_F     - String containing the name of the recombination or
%                crossover function
%    Chrom     - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual
%    Distances - The distances between any two cities
%    RecOpt    - (optional) Scalar containing the probability of 
%                recombination/crossover occurring between pairs
%                of individuals.
%                if omitted or NaN, 1 is assumed
%    SUBPOP    - (optional) Number of subpopulations
%                if omitted or NaN, 1 subpopulation is assumed
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after recombination in the same format as OldChrom.


function NewChrom = recombinMuLambda(REC_F, Chrom, Distances, RecOpt,TABU)


% % Check parameter consistency
%    if nargin < 2, error('Not enough input parameter'); end
% 
%    % Identify the population size (Nind)
%    [Nind,Nvar] = size(Chrom);
%  
%    if nargin < 6, SUBPOP = 1; end
%    if nargin > 5,
%       if isempty(SUBPOP), SUBPOP = 1;
%       elseif isnan(SUBPOP), SUBPOP = 1;
%       elseif length(SUBPOP) ~= 1, error('SUBPOP must be a scalar'); end
%    end
% 
%    if (Nind/SUBPOP) ~= fix(Nind/SUBPOP), error('Chrom and SUBPOP disagree'); end
%    Nind = Nind/SUBPOP;  % Compute number of individuals per subpopulation
% 
%    if nargin < 4, RecOpt = 0.7; end
%    if nargin > 3,
%       if isempty(RecOpt), RecOpt = 0.7;
%       elseif isnan(RecOpt), RecOpt = 0.7;
%       elseif length(RecOpt) ~= 1, error('RecOpt must be a scalar');
%       elseif (RecOpt < 0 | RecOpt > 1), error('RecOpt must be a scalar in [0, 1]'); end
%    end


% Select individuals of one subpopulation and call low level function
   NewChrom = [];
        %Make three times more children than there are parents.
      if isequal(REC_F,'scxMuLambda')
        NewChromSub = feval(REC_F, Chrom, RecOpt, Distances,TABU);
      else  
        NewChromSub = feval(REC_F, Chrom, RecOpt);
      end
      NewChrom=[NewChrom; NewChromSub];
   end


% End of function