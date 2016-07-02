require 'spreadsheet'
require 'zip'
require 'mail'

def main
  result = ""
  Dir.glob('./sample_data/**/*.xls').each do |xlsfile|
    xls = Spreadsheet.open(xlsfile)
    result << "#{xlsfile}\n"
    xls.worksheets.each do |ws|
      result << "#{ws.name}\n"
      (0..256).each do |x|
        break unless ws[x,0]
        (0..256).each do |y|
          break unless ws[x,y]
          result << "[#{ws[x,y]}] "
        end
        result << "\n"
      end
      result << "----------\n"
    end
  end
  File.open("./result.txt","w"){|io| io.write(result)}

  # zip生成
  zip = Zip::OutputStream.write_buffer(::StringIO.new(''), Zip::TraditionalEncrypter.new('password')) do |buf|
      buf.put_next_entry('book.xls')
      buf.write(open('sample_data/book.xls','rb').read)
      buf.put_next_entry('testcontent.txt')
      buf.write(open('sample_data/testcontent.txt','rb').read)
    end.string
  File.open("result.zip", "wb"){|io| io.write(zip)}

  # emlファイル生成テスト
  body = <<-EOB
    これはテストメール本文です。
    改行や

    空行が
    あっても問題なく出力されるはずです。
  EOB
  mail = Mail.new do |mail|
    mail.charset = 'utf-8'
    from      'from@example.com'
    to        'to@example.com'
    subject   'これはテストメールです'
    body      body
    add_file  filename: '添付ファイル.zip', content: zip
  end
  File.open("result.eml", "wb"){|io| io.write(mail.encoded)}
end

main
