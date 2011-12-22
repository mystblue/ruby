# -*- coding:utf-8 -*-

require "thread"

m = Mutex.new

t1 = Thread.new("test1") do |param1|
	10.times do |i|
		sleep(0.01)
		m.synchronize {
			puts i.to_s + ":" + param1
		}
	end
end

t2 = Thread.new("test2") do |param2|
	10.times do |i|
		sleep(0.01)
		m.synchronize {
			puts i.to_s + ":" + param2
		}
	end
end

t3 = Thread.new("test3") do |param2|
	10.times do |i|
		sleep(0.02)
		m.synchronize {
			puts i.to_s + ":" + param2
		}
	end
end

t1.join
t2.join
t3.join

puts "end."