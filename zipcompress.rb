# -*- coding: sjis -*-
require 'rubygems'
require 'zipruby'

dirs = Dir.entries(".").reject! do |file|
  File::ftype(file) != "directory" or file == "." or file == ".."
end

for dir in dirs
  fileName = dir + '.zip'
  files = Dir.entries(dir).reject! do |file|
    file == "." or file == ".."
  end
  Zip::Archive.open(fileName, Zip::CREATE) do |ar|
    puts dir
    ar.add_dir(dir)
    files.each { |file|
      puts dir + '/' + file
      ar.add_file(dir + '/' + file, dir + '/' + file)
    }
  end
end
