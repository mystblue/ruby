# -*- coding:utf-8 -*-

# ソートする

# 二つの文字列の重複した先頭部分を除去する
def remove_redundant(str1, str2)
    str1c = str1
    str2c = str2
    counter = 0
    min_length = str1.length > str2.length ? str2.length : str1.length
    if min_length == 0
        return ['', '']
    end
    while (true)
        if counter >= min_length:
            break
        end
        if str1c[counter, 1] == str2c[counter, 1] and str1c[counter, 1].to_i == 0
            counter = counter + 1
        else
            break
        end
    end
    # 違う箇所が数字であれば、数字に変換する
    nstr1 = str1[counter, str1.length - counter]
    nstr2 = str2[counter, str2.length - counter]
    return [nstr1, nstr2]
end

# 先頭の数字を数値に変換して返す
def get_number(str1)
  if str1.length == 0
    return -1
  end
  counter = 0
  while(true)
    counter += 1
    if counter > str1.length
      break
    end
    begin
      Integer(str1[0, counter])
    rescue
      counter -= 1
      break
    end
  end
  if counter == 0
    return -1
  else
    return str1[0, counter].to_i
  end
end


# 比較関数
def compare(str1, str2)
  strt = remove_redundant(str1, str2)
  # 違う箇所が数字であれば、数字に変換する
  num1 = get_number(strt[0])
  num2 = get_number(strt[1])
  if num1 == -1 or num2 == -1
    if strt[0] == strt[1]
      return 0
    end
    if strt[1] > strt[0]
      return -1
    else
      return 1
    end
  else
    diff = num2 - num1
    if diff > 0
      return -1
    else
      return 1
    end
  end
end


# リストの値をソートする
def sort(array)
    newArray = array.sort() { |x, y| compare(x, y)}
    return newArray
end
