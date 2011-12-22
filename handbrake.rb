#! ruby -Ks

LIST_FILE = "list.csv"
BAT_FILE = "enc.bat"
OUTPUT_PATH = "C:\\"

class Handbrake
    @@EXE_PATH = "\"C:\Program Files\Handbrake\HandBrakeCLI.exe\""
    @@X264_OPT = "ref=2:bframes=2:subq=6:mixed-refs=0:weightb=0:8x8dct=0:trellis=0 --verbose=1"
    # コンストラクタ
    def initialize(sourcePath, title, chapter, mode, isChapterSplit)
        @sourcePath = sourcePath
        @title = title
        if isChapterSplit == "0"
            @chapter = "1-" + chapter
        else
            @chapterNum = chapter
        end
        if mode == "W"
            @width = 720
            @height = 406
        elsif (mode == "N")
            @width = 640
            @height = 480
        end
        @outputPath = OUTPUT_PATH + File.basename(sourcePath)
        @isChapterSplit = isChapterSplit
    end
    
    def print
        puts "#{@@EXE_PATH} -i \"#{@sourcePath}\" -t #{@title} -c #{@chapter} -o \"#{@outputPath}\" -f mp4 --decomb -w #{@width} -l #{@height} -e x264 -b 2000 -a 1 -E faac -6 dpl2 -R Auto -B 160 -D 0.0 -m -x #{@@X264_OPT}\n"
    end
    
    def appendFile
        fwp = File.open(BAT_FILE, "a+")
        if @isChapterSplit == "0"
            fwp.write("#{@@EXE_PATH} -i \"#{@sourcePath}\" -t #{@title} -c #{@chapter} -o \"#{@outputPath}\" -f mp4 --decomb -w #{@width} -l #{@height} -e x264 -b 2000 -a 1 -E faac -6 dpl2 -R Auto -B 160 -D 0.0 -m -x #{@@X264_OPT}\n")
        else
            for i in 1..@chapterNum.to_i
                @chapter = i.to_s
                fwp.write("#{@@EXE_PATH} -i \"#{@sourcePath}\" -t #{@title} -c #{@chapter} -o \"#{@outputPath}\" -f mp4 --decomb -w #{@width} -l #{@height} -e x264 -b 2000 -a 1 -E faac -6 dpl2 -R Auto -B 160 -D 0.0 -m -x #{@@X264_OPT}\n")
            end
        end
        fwp.close()
    end
end

frp = File.open( LIST_FILE, "r" )
buf = frp.read
frp.close

lines = buf.split(/\n/)
list = []
for line in lines
    puts "[" + line + "]"
    items = line.split(/,/)
    if items.size == 5
        puts "yes"
        h = Handbrake.new(items[0], items[1], items[2], items[3], items[4])
        list.push(h)
    else
        raise "設定に誤りがあります。"
    end
end

for h in list
    h.appendFile
end
