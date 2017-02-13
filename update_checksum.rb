#!/usr/bin/env ruby
#

require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.on("--package [PACKAGE]", String, "Get package name") do |g|
    options[:package] = g
  end
end.parse!(ARGV)

def list_files options
  find_files_cmd = "ls | grep #{options[:package]} | grep -P '.*(changes|dsc)$'"
  file_list = `#{find_files_cmd}`.split("\n")
  file_list.each {|f| update_checksum f }
end

def update_checksum name
  content = File.open(name).read
  sha1_array = content[/Checksums-Sha1:(.*)Checksums-Sha256:/m, 1].split(" ")
  sha256_array = content[/Checksums-Sha256:(.*)Files:/m, 1].split(" ")
  md5_array = content[/Files:(.*)-----BEGIN/m, 1].split(" ")

  sha1_checked_list = find_checked_file sha1_array
  sha256_checked_list = find_checked_file sha256_array
  md5_checked_list = []

  if name =~ /.*dsc$/
    md5_checked_list = find_checked_file md5_array
  else
    i = 1
    while i <= md5_array.length do
      md5_checked_list << md5_array[i] if i % 5 == 4
      i += 1
    end
  end

  
  sha1_content = "\n"
  sha256_content = "\n"
  md5_content = "\n"

  sha1_checked_list.each do |file|
    sha1_content += regenate_sum(file, "sha1sum", name)
  end

  sha256_checked_list.each do |file|
    sha256_content += regenate_sum(file, "sha256sum", name)
  end

  md5_checked_list.each do |file|
    md5_content += regenate_sum(file, "md5sum", name)
  end

  sha1_content += "\n"
  sha256_content += "\n"
  md5_content += "\n"

  origin_content = File.read(name)
  new_content = origin_content.gsub(/(?<=Checksums-Sha1:).*(?=Checksums-Sha256:)/m, sha1_content)
  new_content = origin_content.gsub(/(?<=Checksums-Sha256:).*(?=Files:)/m, sha256_content)
  new_content = origin_content.gsub(/(?<=Files:).*(?=-----BEGIN)/m, md5_content)
  
  File.open(name, "w") {|file| file.puts new_content }
end


def regenate_sum name, type, file_name
  checksum_content = `#{type} #{name}`.split(" ")
  file_length = `ls -l | grep #{name} | awk '{print $5}'`

  if file_name =~ /.*dsc$/ or type != "md5sum"
    checksum_content[2] = checksum_content[1]
    checksum_content[1] = file_length
  elsif file_name =~ /.*changes$/ and type == "md5sum"
    checksum_content[4] = checksum_content[1]
    checksum_content[1] = file_length
    checksum_content[2] = "misc"
    checksum_content[3] = "optional"
  end

  checksum_content.each {|i| i.chomp! }

  content = checksum_content.join(" ")

  return " " + content + "\n"
end

def find_checked_file array
  checked_file_list = []
  i = 1
  while i <= array.length do
    checked_file_list << array[i] if i % 3 == 2
    i += 1
  end

  return checked_file_list
end

list_files options
