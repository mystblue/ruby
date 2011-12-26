# -*- coding: utf-8 -*-

f = open("0090.txt", "r:utf-8")
buf = f.read
f.close

r = ""
list = buf.scan(/<img src="([^\"]+)">(?!<\/a>)/)#.match(buf).to_a
list.each { |a|
	if a[0].start_with? "http" and (
	a[0].end_with? ".gif" or
	a[0].end_with? ".png" or
	a[0].end_with? ".jpg" ) then
		r += a[0] + "\n"
	end
}
list = buf.scan(/<a href="([^\"]+)"><img/)#.match(buf).to_a
list.each { |a|
	if a[0].start_with? "http" and (
	a[0].end_with? ".gif" or
	a[0].end_with? ".png" or
	a[0].end_with? ".jpg" ) then
		r += a[0] + "\n"
	end
}

f = open("img.txt", "w")
f.puts r
f.close
