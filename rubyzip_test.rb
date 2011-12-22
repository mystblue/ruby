# -*- coding:utf-8 -*-

require 'rubygems'
require 'zip/zipfilesystem'


fileName = 'test.zip'
Zip::ZipFile.open(fileName,  Zip::ZipFile::CREATE) do |ar|
	ar.add("コメント投稿.pcap".encode("sjis"), "コメント投稿.pcap")
end
