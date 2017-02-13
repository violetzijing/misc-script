#!/usr/bin/env ruby

require 'optparse'
require 'rest-client'
require 'json'

options = {}

OptionParser.new do |opts|
  opts.on("--group [GROUP]", String, "Get repos group") do |g|
    options[:group] = g
  end

  opts.on("--token [TOKEN]", String, "Get private token") do |t|
    options[:token] = t
  end

  opts.on("--api_token [API_TOKEN]", String, "Get api token for metadata") do |t|
    options[:api_token] = t
  end

  opts.on("--metadata_host [METADATA_HOST]", String, "Get host of metadata") do |m|
    options[:metadata_host] = m
  end
end.parse!(ARGV)

def post_repo options, repo_json
  repo_json["description"] = "This repo is for testing #{repo_json["name"]}" if repo_json["description"].empty?
  metadata_api = options[:metadata_host] + "/api/v1/repositories"
  existed_repo = get_existed_repo metadata_api

  puts repo_json
  unless existed_repo.include? repo_json["url"]
    res = RestClient.post metadata_api, repo_json, {:api_token => options[:api_token]}
    puts res
  else
    return
  end
end

def get_existed_repo metadata_api
  existed_repo = []
  res = RestClient.get metadata_api
  res = JSON.parse(res)
  res.each {|repo| existed_repo << repo["url"] }
  return existed_repo
end

# Get repo from upstream
# Multi repos in a group
res = RestClient::Request.execute(:url => options[:group],
                                  :method => :get,
                                  :verify_ssl => false,
                                  :headers => {
                                    :accept => :json, :content_type => :json, :private_token => options[:token]
                                  })
res = JSON.parse(res)
puts "=========================all repos================================="
puts JSON.pretty_generate(res)
puts "============#{res.length}=========================================="
puts "=============================end==================================="
res.each do |repo|
  puts repo["name"]
  repo_json = {
    "name" => repo["name"],
    "description" => repo["description"],
    "url" => "ssh:#{repo["ssh_url_to_repo"]}",
    "branch" => repo["default_branch"]
  }
  puts "===== start to create repo #{repo["name"]}"
  post_repo options, repo_json
end
