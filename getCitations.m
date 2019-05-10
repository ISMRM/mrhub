% getCitations.m
%%%%%%%%%%%%%%%%%%
%
% Quickly thrown together script to count the number of citations on
% Semantic Scholar for the paper associated with a particular software
% package. Requires that all packages have a valid .citationSearchString
% entry for Semantic Scholar.
%
% gallichand@cardiff.ac.uk, 10/5/19

jsonFile = 'mrhub_packages.json';
jsonFile_new = 'mrhub_packages_updated.json';

packageData = jsondecode(fileread(jsonFile));

nP = length(packageData);

fprintf('\n\n\nPackage \t nCitations_old \t nCitations_new\n')
fprintf('_________________________________________________________\n\n')

for iP = 1:nP
   
    thisCitationData = webread(['https://api.semanticscholar.org/v1/paper/' packageData(iP).citationSearchString]);
    
    nCitations_old = str2num(packageData(iP).citationCount);
    nCitations_new = length(thisCitationData.citations);
    
    thisName = packageData(iP).name;
    if length(thisName)>10
        thisName = thisName(1:10);
    end
    
    fprintf('%s \t %d \t %d \n\n\n',thisName,nCitations_old,nCitations_new);
    
    packageData(iP).citationCount = num2str(nCitations_new);
    
end

%%% This method works, but it reformats the whole json without spaces....
%%% :(
% fid = fopen(jsonFile_new,'w');
% fwrite(fid,jsonencode(packageData));
% fclose(fid);

%% Copy the original file line-by-line and replace with new citation count
% (this could be done in one line with regexprep, but it was going to take
% me too long to work out the regexp...)

fidIn = fopen(jsonFile,'r');
fidOut = fopen(jsonFile_new,'w');
iP = 1;
repeat = 1;
while repeat==1
    thisLine = fgetl(fid);
    if ~ischar(thisLine), break, end
    
    isLine = strfind(thisLine,'"citationCount"');
    if isLine
        thisLine = ['        "citationCount": "' packageData(iP).citationCount '"'];
        iP = iP + 1;
    end
    
    if ~ischar(thisLine)
        repeat = 0; 
    else
        fprintf(fidOut,'%s\n',thisLine);
    end
    
end

fclose(fidIn);
fclose(fidOut);


