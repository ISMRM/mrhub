require 'json'
require 'net/http'

#################
# Functions

def get_api_response(url, username="", password="")
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.path)
    if !username.empty? && !password.empty?
        request.basic_auth(username, password)
    end
    response = http.request(request)
    return JSON.parse(response.body)
end

def get_num_citations(project, citation_api)
    url = citation_api + "/" + project["citationSearchString"]
    response = get_api_response url
    if response["citations"].nil?
        num_citations = "0"
    else
        num_citations = response["citations"].length().to_s
    end
    # Check if citation count changed
    if project["citationCount"] == num_citations
        puts "Number of citations remained the same at: " + num_citations
    else
        puts "Number of citations changed from " + project["citationCount"] + " to " + num_citations
    end
    return num_citations
end

def get_update_time_from_github(project, github_api, username, password)
    repo_uri = URI.parse(project["repoURL"])
    url = github_api + repo_uri.path + "/branches/master"
    response = get_api_response url, username, password
    return response["commit"]["commit"]["author"]["date"][0,10]
end

def get_update_time_from_bitbucket(project, bitbucket_api)
    repo_uri = URI.parse(project["repoURL"])
    url = bitbucket_api + repo_uri.path
    response = get_api_response url
    return response["updated_on"][0,10]
end

#################
# Get github username/password from input arguments

if ARGV.length < 2
    puts "INFO: Using unauthenticated github api requests."
    github_username = ""
    github_password = ""
else
    puts "INFO: Using authenticated github api requests"
    github_username = ARGV[0]
    github_password = ARGV[1]
end

# Let the user know their quota
limit_url = "https://api.github.com/rate_limit"
limit_json = get_api_response limit_url, github_username, github_password
puts "Github API Quota: " + limit_json["resources"]["core"]["limit"].to_s
puts "Amount available: " + limit_json["resources"]["core"]["remaining"].to_s
puts

# Projects file is loaded and then updated
projects_file = "./projects.json"
projects_rawtext = File.read(projects_file)
projects = JSON.parse(projects_rawtext)

# Info file is re-generated/overwritten
info_file = "./info.json"
category_count = {
    "all" => projects.length().to_s
}

# List of API hosts. Do not append a trailing slash to any of them.
# [These could be made global variables for simplicity]
citation_api = "https://api.semanticscholar.org/v1/paper"
github_api = "https://api.github.com/repos"
bitbucket_api = "https://api.bitbucket.org/2.0/repositories"

# Main loop 
projects.each do |project|
    # Print repo url of current project
    repo_uri = URI.parse(project["repoURL"])
    puts project["repoURL"]

    project["citationCount"] = get_num_citations project, citation_api
    if repo_uri.host.include? "github"
        project["dateSoftwareLastUpdated"] = get_update_time_from_github project, github_api, github_username, github_password
    elsif repo_uri.host.include? "bitbucket"
        project["dateSoftwareLastUpdated"] = get_update_time_from_bitbucket project, bitbucket_api
    else
        puts "Repo is neither Github nor Bitbucket"
    end

    category = project["category"]
    if category_count.key?(category)
        category_count[category] = category_count[category] + 1
    else
        category_count[category] = 1
    end
    puts
end

puts "Writing to " + projects_file
File.open(projects_file, "w+") do |content|
    content.write(JSON.pretty_generate(projects))
end

puts "Writing to " + info_file
File.open(info_file, "w+") do |content|
    content.write(JSON.pretty_generate(category_count))
end
puts

puts "INFO: Update script completed"
limit_url = "https://api.github.com/rate_limit"
limit_json = get_api_response limit_url, github_username, github_password
puts "Github API Quota: " + limit_json["resources"]["core"]["limit"].to_s
puts "Amount available: " + limit_json["resources"]["core"]["remaining"].to_s
