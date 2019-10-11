require 'json'
require 'net/http'

Jekyll::Hooks.register :site, :after_reset do |site|
    projects_file = "./_data/projects.json"
    projects_rawtext = File.read(projects_file)
    projects_json = JSON.parse(projects_rawtext)

    citation_api = "https://api.semanticscholar.org/v1/paper"
    github_api = "https://api.github.com/repos"
    bitbucket_api = "https://api.bitbucket.org/2.0/repositories"
    projects_json.each do |project|
        citation_uri = URI(citation_api + "/" + project["citationSearchString"])
        http_response = JSON.parse(Net::HTTP.get(citation_uri))
        citations = http_response["citations"]
        # Converting count to string because that how original json has them
        if citations.nil?
            project["citationCount"] = "0"
        else
            project["citationCount"] = citations.length().to_s
        end

        repo_uri = URI.parse(project["repoURL"])
        puts project["repoURL"] # DEBUG
        if repo_uri.host.include? "github"
            github_uri = URI(github_api + repo_uri.path + "/branches/master")
            http_response = JSON.parse(Net::HTTP.get(github_uri))
            # Could use `date` module to parse this further
            last_commit_date = http_response["commit"]["commit"]["author"]["date"][0,10]
            project["dateSoftwareLastUpdated"] = last_commit_date

            github_uri = URI(github_api + repo_uri.path)
            http_response = JSON.parse(Net::HTTP.get(github_uri))
            num_stargazers = http_response["stargazers_count"].to_s
            project["stargazers"] = num_stargazers
        elsif repo_uri.host.include? "bitbucket"
            bitbucket_uri = URI(bitbucket_api + repo_uri.path)
            http_response = JSON.parse(Net::HTTP.get(bitbucket_uri))
            last_commit_date = http_response["updated_on"]
            project["dateSoftwareLastUpdated"] = last_commit_date
            # Bitbucket does not have any stars feature
            project["stargazers"] = "NA"
        else
            project["stargazers"] = "NA"
        end
    end

    File.open(projects_file, "w+") do |content|
        content.write(JSON.pretty_generate(projects_json))
    end
end
