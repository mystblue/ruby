# -*- coding:utf-8 -*-

require "thread"

m = Mutex.new

t1 = Thread.new("test1") do |param1|
	for i in 0..9
		m.lock
		puts i.to_s + ":" + param1
		m.unlock
	end
end

t2 = Thread.new("test2") do |param2|
	for i in 0..9
		m.lock
		puts i.to_s + ":" + param2
		m.unlock
	end
end

t3 = Thread.new("test3") do |param3|
	10.times do |i|
		m.lock
		puts i.to_s + ":" + param3
		m.unlock
	end
end

t1.join
t2.join
t3.join

puts "end."