# -*- coding:utf-8 -*-

require 'open-uri'
require "FileUtils"
require 'rubygems'
require 'zip/zipfilesystem'
#require 'zipruby'

SETTING_LIST = [['http://alfalfalfa.com/','<div class="main">','<div id="ad2">'],
['http://blog.livedoor.jp/samplems-bakufu/','<div class="article-body-inner">','<TABLE width="100%" cellspacing="1" border="0" cellpadding="0" bgcolor="#dfdfdf">'],
['http://morinogorira.seesaa.net/','<div class="blogbody">','<div id="article-ad"'],
['http://blog.livedoor.jp/nwknews/','<div class="article-title-outer">','<div class="related-articles">'],
['http://blog.livedoor.jp/nicovip2ch/','<h2 class="article-title entry-title">','<div id="ad2">'],
['http://rajic.2chblog.jp/','<div class="article-outer hentry">','<div id="rss-under">'],
['http://blog.livedoor.jp/insidears/','<div id="ad_rs" class="ad_rs_b">','<b><最新記事></b>'],
['http://blog.livedoor.jp/kinisoku/','<div class="article_body">','<h3>コメント</h3>'],
['http://minkch.com/','<div class="article-outer-2" style="text-align:center;">','《オススメ記事》<br />'],
['http://hamusoku.com/','<div class="article-outer hentry">','<div class="article-option" id="comments-list">'],
['http://news.2chblog.jp/','<div class="article-title-outer">','<div class="article-option" id="comments-list">'],
['http://vippers.jp/','<div id="article">','<div id="oneText">'],
['http://nantuka.blog119.fc2.com/','<!--▼ エントリー（記事）▼-->','<div class="bottom_navi">'],
['http://blog.esuteru.com/','<div id="entry">','<div class="clearfix">'],
['http://news4vip.livedoor.biz/','<div class="ently_navi_top">','<div class="related-articles">'],
['http://blog.livedoor.jp/news23vip/','<div class="article-outer hentry">','<div class="article-footer">'],
['http://neetetsu.com/','<div class="article-outer hentry">','<a name="comment-form"></a>'],
['http://nanntokasokuhou.blog.fc2.com/','<!--▼ エントリー（記事）▼-->','<!--▲ エントリー（記事）▲-->'],
['http://blog.livedoor.jp/himasoku123/','<div class="article-body entry-content">','<div class="dashed2">'],
['http://2chcopipe.com/','<div class="article-outer-3">','<div class="article-footer">'],
['http://blog.livedoor.jp/goldennews/','<div class="blogbody">','<div class="formbodytop"></div>'],
['http://yutori2ch.blog67.fc2.com/','<div class="entry">','<div class="form">'],
['http://blog.livedoor.jp/nonvip/','<div class="entry">','<h3>コメント一覧</h3>'],
['http://brow2ing.doorblog.jp/','<div class="article_title">','<div class="article_info">'],
['http://blog.livedoor.jp/negigasuki/','<div class="article-body entry-content">','<div class="article-footer">'],
['http://mudainodqnment.ldblog.jp/','<div class="article-header">','<div class="article-footer">'],
['http://chaos2ch.com/archives/','<div class="article-body entry-content">','<div class="article-footer">'],
['http://news.2chblog.jp/archives/','<div class="article-body entry-content">','<div class="article-option" id="comments-list">'],
['http://mamesoku.com/archives/','<div class="entrybody">','<div class="commentbody">'],
['http://itaishinja.com/archives/','<div class="article-body entry-content">','<div class="sbm">'],
['http://michaelsan.livedoor.biz/archives/','<div class="blogbody">','<div id="ad2"></div>'],
['http://digital-thread.com/archives/','<div class="top-contents">','<h3>コメント一覧</h3>'],
['http://jin115.com/archives/','<div class="article_header">','<div id="comment_list">'],
['http://umashika-news.jp/archives/','<div class="contents-in">','<div class="article-option" id="comment-form">'],
['http://yukkuri.livedoor.biz/archives/','<div class="article-body-more">','<!-- articleBody End -->'],
['http://lifehack2ch.livedoor.biz/archives/','<div class="posted1p">','<div id="commenttop"></div>']]


def getHtml(src, dst)
	open(src) do |uri|
		File.open(dst, "wb") do |fwp|
			fwp.puts uri.read
		end
	end
end

def getEncoding(filename)
	f = open(filename, "r:ISO-8859-1")
	buf = f.read
	f.close
	
	if /charset[ ]*=[ ]*\"?([0-9a-zA-Z|\-|_]+)\"?/ =~ buf then
		return $1
	else
		puts "no match."
	end
	return nil
end

def read(src, dst)
	encoding = getEncoding(src)
	
	if encoding.nil? then
		puts "Unknown encoding."
		exit
	else
		f = open(src, "r:" + encoding)
		buf = f.read
		f.close

#		ubuf = buf.encode("utf-8")
		ubuf = buf.encode("utf-8", :undef=>:replace)

		f = open(dst, "w")
		f.puts ubuf
		f.close
		
		File.delete(src)
	end
end

def scraping(src, dst, url)
	SETTING_LIST.each { |setting|
		if url.start_with? setting[0] then
			f = open(src, "r:utf-8")
			buf = f.read
			f.close
			sindex = buf.index setting[1]
			eindex = buf.index setting[2]
			if sindex.nil? or eindex.nil? then
				puts "インデックスが不正です。設定を確認してください。".encode("sjis")
				puts "開始インデックス = ".encode("sjis") + sindex.to_s
				puts "終了インデックス = ".encode("sjis") + eindex.to_s
				exit
			else
				puts "Scraping ok."
				buf2 = buf[sindex..eindex]
				f = open(dst, "wb")
				f.puts buf2
				f.close
				File.delete(src)
			end
		end
	}
end

def normalize(src, dst)
	f = open(src, "r:utf-8")
	buf = f.read
	f.close
	
	buf = buf.gsub(/\n/m, "")
	buf = buf.gsub("\r", "")

	buf = buf.gsub(/<!--((?!-->).)*-->/, "")
	buf = buf.gsub(/<script((?!<\/script>).)*<\/script>/, "")
	buf = buf.gsub(/<noscript((?!<\/noscript>).)*<\/noscript>/, "")

	buf = buf.gsub(/<h2[^>]*>/, "")
	buf = buf.gsub("</h2>", "")

	buf = buf.gsub(/<div[^>]*>/i, "")
	buf = buf.gsub(/<\/div>/i, "")
	buf = buf.gsub(/<span[^>]*>/, "")
	buf = buf.gsub("</span>", "")
	buf = buf.gsub(/<font[^>]*>/, "")
	buf = buf.gsub("</font>", "")
	buf = buf.gsub(/<b[^>r][^>]*>/, "")
	buf = buf.gsub("<b>", "")
	buf = buf.gsub("</b>", "")
	buf = buf.gsub(/<p[^>a][^>]*>/, "")
	buf = buf.gsub("</p>", "")
	buf = buf.gsub(/<u[^>]*>/, "")
	buf = buf.gsub("</u>", "")
#	buf = buf.gsub(/<iframe[^>]*><\/iframe>/, "")
	
	buf = buf.gsub(/<dl[^>]*>/, "")
	buf = buf.gsub(/<dd[^>]*>/, "\r\n")
	buf = buf.gsub("<dt>", "\r\n")
	buf = buf.gsub("</dl>", "")
	buf = buf.gsub("</dd>", "")
	buf = buf.gsub("</dt>", "")

	buf = buf.gsub("<a name=\"more\"></a>","")

	buf = buf.gsub("&lt;","<")
	buf = buf.gsub("&gt;",">")
	buf = buf.gsub("&nbsp;"," ")

	buf = buf.gsub("<br>","\n")
	buf = buf.gsub("<br/>","\n")
	buf = buf.gsub("<br />","\n")

	buf = buf.gsub(/<img [^\/>]*src="?([^ "]+)"?[^\/>]*\/?>/i, '<img src="\1">')
	buf = buf.gsub(/<a [^\/>]*href="?([^ "]+)"?[^\/>]*\/?>/i, '<a href="\1">')
#	buf = buf.gsub(/<a [^\/>]*name="?([^ "]+)"?[^\/>]*\/?>/i, '<a name="\1">')
	buf = buf.gsub(/<a [^>]*(?!href)[^>]*>([^<]+)<\/a>/i, '\1')
	buf = buf.gsub("</A>", "</a>")

	buf = buf.gsub("&#9833;", "♩")
	buf = buf.gsub("&hellip;", "…")

	buf = buf.gsub(/^\t+/,"")

	buf = buf.gsub(/^[ ]+/,"")

	buf = buf.gsub(/\t+\n/,"")

	buf = buf.gsub(/\n{2,}/m, "\r\n\r\n")

	return buf
end

def readOne(url, title, date)
	if not File.exist?("tmp.txt") and not File.exist?("tmp.html") and not File.exist?("result.txt") and not File.exist?("result_n.txt")
		puts "Get html > " + url
		getHtml(url, "tmp.html")
	end
	
	if not File.exist?("tmp.txt") and not File.exist?("result.txt") and not File.exist?("result_n.txt")
		puts "Normalize"
		read("tmp.html", "tmp.txt")
	end
	
	if not File.exist?("result.txt") and not File.exist?("result_n.txt")
		puts "Scraping..."
		scraping("tmp.txt", "result.txt", url)
	end
	
	if not File.exists?("result_n.txt")
		buf = normalize("result.txt", "result_n.txt")

		open("result_n.txt", "wb") { |f|
			f.puts title + "\r\n" * 2
			f.puts "URL：" + url + "\r\n" * 2
			f.puts "公開日：" + date + "\r\n"
			f.puts "取得日：" + Time.now.strftime("%Y-%m-%d") + "\r\n" * 2
			f.puts buf
		}
		File.delete("result.txt")
	end
end

def readText()
	File.open("read.txt", "r:utf-8") do |frp|
		lines = frp.readlines
		lines.each { |line|
			l = line.chomp
			items = l.split(',')
			if items.size() == 2 then
				readOne(items[0], items[1], Time.now.strftime("%Y-%m-%d"))
			elsif items.size() == 3 then
				readOne(items[0], items[1], items[2])
			else
				puts "ファイルが不正です。".encode("sjis")
			end
		}
	end
end

#############################
def wget(src, dst)
	puts "> " + src
	f = open(src)
	w = File.open('img\\' + dst,'wb')
	w.puts f.read
	w.close
	f.close
end

def getImgList()
	f = open("result_n.txt", "r:utf-8")
	buf = f.read
	f.close

	r = []
	list = buf.scan(/<img src="(http[^\"]+(.jpg|.png|.gif))">(?!<\/a>)/)
	list.each { |a|
		r << a[0]
	}
	list = buf.scan(/<a href="(http[^\"]+(.jpg|.png|.gif))"><img/)
	list.each { |a|
		r << a[0]
	}
	return r
end

def imgconv(filename)
	f = open("result_n.txt", "r:utf-8")
	buf = f.read
	f.close()

	regex = /<a [^>]*?href=\"[^>\"]+\/([^\/\"]+(.jpg|.png|.gif))\"[^>]*><img [^>]*?src=\"([^\"]+)\"[^>]*\/?><\/a>/
	if regex =~ buf then
		buf = buf.gsub(regex, '<img src="\1">')
	end

	regex = /<img src=\"[^\"]+\/([^\/\"]+(.jpg|.png|.gif))\"[^>\/]*\/?>/
	if regex =~ buf then
		buf = buf.gsub(regex, '<img src="\1">')
	end

	f = open('img\\' + filename + ".txt", "w")
	f.puts buf
	f.close
end

def download(list)
	list1 = []
	list2 = []
	list3 = []
	counter = 0
	list.each { |url|
		if counter %3 == 0 then
			list1 << url
		elsif counter % 3 == 1 then
			list2 << url
		else
			list3 << url
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
end

def zip(dir, filename)
	fileName = filename + '.zip'
	files = Dir.entries(dir).reject! do |file|
		file == "." or file == ".."
	end
	Zip::ZipFile.open(fileName, Zip::ZipFile::CREATE) do |ar|
		files.each { |file|
			puts dir + '/' + file
			ar.add(file.encode("sjis"), dir.encode + '/' + file)
		}
	end
#	Zip::Archive.open(fileName, Zip::CREATE) do |arc|
#		files.each{|f| arc.add_file(f) }
#	end
end

def img()
#	list = getImgList
	FileUtils.mkdir_p("img") unless FileTest.exist?("img")
#	download(list)
#	imgconv(ary[1])
#	open("result_n.txt", "r:utf-8") { |file|
#		open("img\\筆おろししてもらった女の子に号泣された話をする.txt".encode("sjis"), "wb") { |out|
#			out.puts file.read
#		}
#	}
	zip("img", "2011-12-11 筆おろししてもらった女の子に号泣された話をする")
end
#############################

# main
puts ARGV.size()
if ARGV.size() == 0
  readText()
elsif ARGV.size() == 1
  puts ARGV[0]
  if ARGV[0] == "i"
    img()
  else
    puts "Invalid args."
  end
else
  puts "Invalid args."
end