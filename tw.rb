require "twitter"

# 1700 > x > 1500
#t = Twitter.user_timeline("myuj", {:count => 1, :page =>  1600})
t = Twitter.user_timeline("myuj", {:count => 50})
#t = Twitter.user_timeline("takara727", {:count => 100})
if t.size == 0 then
	puts "none"
	exit
end
open("tweet.txt", "wb") { |f|
	t.each { |l|
		f.puts l.text + "\r\n"
	}
}

=begin
C:\Python27\python tw30.py myuj
C:\Python27\python tw30.py takara727
C:\Python27\python tw30.py wakky8639
C:\Python27\python tw.py hatebu
C:\Python27\python tw.py t_daicho
C:\Python27\python tw30.py tenguyasiki
C:\Python27\python tw30.py kumepan
C:\Python27\python tw.py yu_yoshida
=end
