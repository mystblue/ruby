# -*- coding: utf-8 -*-

# SOAP クライアントのサンプル

require "base64"
require "net/http"
require "uri"

credentials = "admin:password"
base64Encoded = Base64.encode64(credentials)

uri = URI.parse("http://localhost/evportal/test.asmx")
Net::HTTP.start(uri.host, uri.port){|http|
  #ヘッダー部
  header = {
    "SOAPAction" => "\"http://kk-osk.co.jp/easyportal/ad/1.0/BoardList\"",
    "Content-Type" => "text/xml; charset=utf-8",
    "Authorization" => "Basic " + base64Encoded
  }
  #ボディ部
  body = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><BoardList xmlns="http://kk-osk.co.jp/easyportal/ad/1.0/"><requestXml>string</requestXml></BoardList></soap:Body></soap:Envelope>'
  #送信
  response = http.post(uri.path, body, header)
  puts response.body
}
