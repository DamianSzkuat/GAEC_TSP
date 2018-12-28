function [newPop, newFitness] = tournamentSelection(candidates, candidateFitness, popSize)
  
newPop = [];
newFitness = [];

candidatesSize = size(candidates,1);
cols = size(candidates,2);

roundSize = int16(floor(candidatesSize/popSize));

tournamentIndices = randperm(candidatesSize);

groupedCandidates = candidates(tournamentIndices, 1:cols);
groupedFitness = candidateFitness(tournamentIndices);

i = 1;
while size(newPop,1) < popSize
    
    currentCandidates = groupedCandidates(1:roundSize,:);
    currentCandidateFitness = groupedFitness(1:roundSize);
    groupedCandidates = groupedCandidates((roundSize+1):size(groupedCandidates,1),:);
    groupedFitness = groupedFitness(roundSize+1:size(groupedFitness,1));

    [~, OffIx] = sort(currentCandidateFitness);
    sortedCandidates = currentCandidates(OffIx,:);
    newPop(i,:) = sortedCandidates(1,:);
    sortedFitness =  currentCandidateFitness(OffIx);
    newFitness(i,:) = sortedFitness(1);

    i = i + 1;
end

size(newPop)
size(newFitness)

if size(newPop,1) ~= size(newFitness,1)
    error('Sizes dont match');
end

end

