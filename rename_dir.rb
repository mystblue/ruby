# -*- coding: Windows-31J -*-

dirs = Dir::entries(".").reject! { |file|
  File::ftype(file) != "directory" or file == "." or file == ".."
}
for dir in dirs
  if dir =~ /\(一般[^\)]+\) \[([^\]]+)\] (.+) 第([0-9]+)巻/
    p "match"
    newname = $1 + " - " + $2 + " "+ $3
    File::rename(dir, newname)
  end
end
