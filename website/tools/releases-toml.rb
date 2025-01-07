#!/usr/bin/env ruby

=begin

BSD 2-Clause License
Copyright (c) 2020-2025, The FreeBSD Project
Copyright (c) 2020-2025, Sergio Carlavilla <carlavilla@FreeBSD.org>

This script converts common variables sourced from shared/releases.adoc
 to the toml format and stores them in data/releases.toml

=end

def getValueByKey(key, variables)
  return variables.fetch(key.gsub("{", "").gsub("}", "")).gsub("\"", "")
end

def mapVariables(path)
  variables = Hash.new

  File.foreach(path).with_index do |line|
    if line.match("^:{1}[^\n]+")
      variable = line.strip.sub(":", '')
      variable = variable.sub(": ", "=\"")
      variable << "\""
      data = variable.split("=")

      if data.length == 2
        variables.store(data[0], data[1])
      end
    end
  end

  return variables
end

# Main method
releasesTOMLFile = File.new("./data/releases.toml", "w")

releasesTOMLFile.puts("# Code @" + "generated by the FreeBSD Documentation toolchain. DO NOT EDIT.\n")
releasesTOMLFile.puts("# Please don't change this file manually but run `make` to update it.\n")
releasesTOMLFile.puts("# For more information, please read the FreeBSD Documentation Project Primer\n")
releasesTOMLFile.puts("\n")

variables = mapVariables("./shared/releases.adoc")

variables.each do |key, value|

  if keyToFind = value.match("\{.*?\}")
    releasesTOMLFile.puts(key + "=" + value.gsub(keyToFind[0], getValueByKey(keyToFind[0], variables)) + "\n")
  else
    releasesTOMLFile.puts(key + "=" + value + "\n")
  end

end

