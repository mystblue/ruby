# -*- coding: utf-8 -*-

require 'rubygems'
require 'zip/zipfilesystem'

def compare(str1, str2)
  # 最小の長さを取得
  l1 = str1.size
  l2 = str2.size
  min = l1 > l2 ? l1 : l2
  
  is_symbol = lambda {|s| s =~ /\.|\?|-|_|\[|\]|\(|\)|\+|\*|\/|<|>|\!|\"|#|\$|%|\&|'|=|~|\^|@|\{|\}|:|;/ ? true : false}
  
  large = lambda {|s1, s2| s1 > s2 ? 1 : -1}
  compare = lambda {|s1, s2| s1 == s2 ? 0 : large.call(s1, s2)}
  # その長さだけループする
  min.times { |i|
    s1 = str1[i]
    s2 = str2[i]
    # どちらも同じなら続ける
    if s1 == s2
      next
    end
    # 両方共数値なら、数値を取り出す
    regex = /^[0-9]$/
    if s1 =~ regex and s2 =~ regex
      i1 = i + 1
      while i1 < l1
        if str1[i1] =~ regex
          s1 = s1 + str1[i1]
        else
          break
        end
        i1 = i1 + 1
      end
      i2 = i + 1
      while i2 < l2
        if str2[i2] =~ regex
          s2 = s2 + str2[i2]
        else
          break
        end
        i2 = i2 + 1
      end
      if s1.to_i == s2.to_i
        return compare.call(str1, str2)
      else
        return s1.to_i > s2.to_i ? 1 : -1
      end
    end
    # 記号は数値よりも小さい
    if is_symbol.call(s1) and not is_symbol.call(s2)
      return -1
    elsif not is_symbol.call(s1) and is_symbol.call(s2)
      return 1
    end
  }
  return compare.call(str1, str2)
end

def sort(ary)
  return ary.sort { |s1, s2| compare(s1, s2)}
end

def zip(dir)
  fileName = dir + '.zip'
  files = Dir.entries(dir).reject! do |file|
    file == "." or file == ".."
  end
  
  if File.exist? fileName
    File.delete fileName
  end
  files = sort(files)
  i = 1
  Zip::ZipFile.open(fileName, Zip::ZipFile::CREATE) do |ar|
    files.each { |file|
      puts dir + '/' + file
      idx = file.rindex "."
      ext = file[idx..file.size]
      ar.add("%04d" % i + ext, dir.encode + '/' + file)
      i = i + 1
    }
  end
end

def main()
  files = Dir.entries(".").reject! { |f|
    f == "." or f == ".."
  }
  files.each { |d|
    if File::ftype(d) == "directory"
      puts d
      zip(d)
    end
  }
end

main()