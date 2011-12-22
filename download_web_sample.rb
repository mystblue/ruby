require "thread"
require "uri"
require "net/http"

#並列数（スレッド数）
poolSize = 5

dir = ARGV[0]

q = Queue.new
#キューに URL を設定
$stdin.readlines.each {|l| q.push(l.chomp)}

threads = []
poolSize.times do
    threads << Thread.start(q) do |tq|
        #キューが空になるまでループ
        while not q.empty?
            #キューから URL 取り出し
            u = q.pop(true)

            begin
                url = URI.parse(u)
                filePath = File.join(dir, File.basename(url.path))

                res = Net::HTTP.get_response(url)
                open(filePath, 'wb') {|f| f.puts res.body}

                puts "downloaded: #{url} => #{filePath}"
            rescue => e
                puts "failed: #{url}, #{e}"
            end
        end
    end
end

#ダウンロード終了まで待機
threads.each {|t| t.join}