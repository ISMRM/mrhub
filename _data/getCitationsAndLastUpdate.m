% getCitationsAndLastUpdate.m
%
% NB. As of 15/10/19 this script is deprecated, and use of the Ruby script 'update.rb' is preferred, 
%     as this will also upate info.json with the total counts for each software category.
%%%%%%%%%%%%%%%%%%
%
% Quickly thrown together script to:
%
% 1. Count the number of citations on Semantic Scholar for the paper associated 
%    with a particular software package. Requires that all packages have a valid 
%    .citationSearchString entry for Semantic Scholar.
%
% 2. Get the last commit date to the main repo (works so far for GitHub and
%    BitBucket - others need to be added manually at the moment!)
%
%
%
% gallichand@cardiff.ac.uk, 10/5/19

clear
close all

jsonFile = 'projects.json';
jsonFile_new = 'projects_updated.json';

packageData = jsondecode(fileread(jsonFile));
nP = length(packageData);

if iscell(packageData) % this means that the fields of the packages don't all match somehow...
    % display the number of fields in each package:
    
    fprintf('*************\n\n')
    for iP = 1:nP
        thisPackage = packageData{iP};
        fprintf('%s nFields: %d\n',thisPackage.name,length(fieldnames(thisPackage)));
    end
    
end
    

fprintf('\n\n\nPackage \t nCitations_old \t nCitations_new\n')
fprintf('_________________________________________________________\n\n')

for iP = 1:nP
   
    %%% Find the number of citations in Semantic Scholar:
    
    nCitations_old = str2num(packageData(iP).citationCount);
    try
        thisCitationData = webread(['https://api.semanticscholar.org/v1/paper/' packageData(iP).citationSearchString]);
        
        nCitations_new = length(thisCitationData.citations);
    catch
        nCitations_new = nCitations_old;
    end
    
    thisName = packageData(iP).name;
    if length(thisName)>10
        thisName = thisName(1:10);
    end
    
    fprintf('%s \t %d \t %d ',thisName,nCitations_old,nCitations_new);
    
    packageData(iP).citationCount = num2str(nCitations_new);
    
        
    %%% Find the date of last commit to the repo:
    thisRepo = packageData(iP).repoURL;
    
    if strncmp(thisRepo(end),'/',1) % remove end slash if present
        thisRepo = thisRepo(1:end-1);
    end
    
    repoParts = split(thisRepo,'/');
    
    repoName = char(repoParts{end});
    repoUsername = char(repoParts{end-1});
    

    if contains(thisRepo,'github')
        
        thisGithubInfo = webread(['https://api.github.com/repos/' repoUsername '/' repoName '/branches/master']);
        thisDate = datetime(thisGithubInfo.commit.commit.author.date(1:10));
        
    elseif contains(thisRepo,'bitbucket')
        
        thisBitbucketInfo = webread(['https://api.bitbucket.org/2.0/repositories/' repoUsername '/' repoName]);
        thisDate = datetime(thisBitbucketInfo.updated_on(1:10));
        
    else
        thisDate = [];
    end
    
    oldDate = packageData(iP).dateSoftwareLastUpdated;    
    if ~isempty(thisDate)        
        thisDate.Format = 'yyyyMMdd';
        newDate = char(thisDate);
        packageData(iP).dateSoftwareLastUpdated = newDate;
    else
        newDate = oldDate;
    end
   
    fprintf('\t %s \t %s \n\n\n',oldDate,newDate);

end


%% This method works, but it reformats the whole json without spaces....
%% :(
% fid = fopen(jsonFile_new,'w');
% fwrite(fid,jsonencode(packageData));
% fclose(fid);

%% Copy the original file line-by-line and replace with new citation count and update date
% (this could be done in one line with regexprep, but it was going to take
% me too long to work out the regexp...)

fidIn = fopen(jsonFile,'r');
fidOut = fopen(jsonFile_new,'w');
iP = 1;
repeat = 1;
while repeat==1
    thisLine = fgetl(fidIn);
    if ~ischar(thisLine), break, end
    
    isLine = strfind(thisLine,'"dateSoftwareLastUpdated"');
    if isLine
        thisLine = ['        "dateSoftwareLastUpdated": "' packageData(iP).dateSoftwareLastUpdated '",'];
    end
    
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


