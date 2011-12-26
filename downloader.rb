# -*- coding: utf-8 -*-

require 'open-uri'

def wget(src, dst)
	puts "> " + src
	f = open(src)
	w = File.open(dst,'wb')
	w.puts f.read
	w.close
	f.close
end

f = open("img.txt", "r:utf-8")
lines = f.readlines
f.close

list1 = []
list2 = []
list3 = []
counter = 0
lines.each { |line|
	line = line.chomp
	if counter %3 == 0 then
		list1 << line
	elsif counter % 3 == 1 then
		list2 << line
	else
		list3 << line
	end
	counter += 1
	if counter == 3 then
		counter == 0
	end
}


t1 = Thread.new(list1) do |list|
	list.each { |item|
		idx = item.rindex "/"
		name = item[idx + 1, item.size]
		wget(item, name)
	}
end

t2 = Thread.new(list2) do |list|
	list.each { |item|
		idx = item.rindex "/"
		name = item[idx + 1, item.size]
		wget(item, name)
	}
end

t3 = Thread.new(list3) do |list|
	list.each { |item|
		idx = item.rindex "/"
		name = item[idx + 1, item.size]
		wget(item, name)
	}
end

t1.join
t2.join
t3.join

puts "end."
