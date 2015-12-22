#characterization parser
require 'benchmark'

folder = ARGV[0]
puts "Examining folder #{folder}"

pass = 0
total = 0
serialNumber = "undefined"
dataSet = Hash.new
record = Array.new
leakageRecord = Array.new
leakageRecords = Array.new
puts Benchmark.measure {
File.open(folder+".csv","w") do |csv|
Dir.glob(folder +"/*.*") do |file|
  puts "File: #{file}"  
  #File.open("output.csv","w") do |csv|
  File.open(file) do |log_file|
    log_file.each_line do|data|
      if data.start_with?(" My SN:")
        record = data.split(":")
        serialNumber = record[1].rstrip
        puts "Serial Number: #{serialNumber}"
      end
      if data.start_with?("TB:")
        #special case for pin leakage
        record = data.split
        if record[1].match(/tb_input_leakage_low/)
          leakageRecord = record
          #puts record
          #puts "----> #{file}, #{serialNumber}, #{leakageRecord[2]}, #{leakageRecord[1]}, #{leakageRecord[6]}, #{leakageRecord[7]}"
          #place leakageRecord into leakageRecords[DUT position]
          if leakageRecord[2].match(/IDSN1:/)
            leakageRecords[1] = leakageRecord
            #puts leakageRecords[1]
          end
          if leakageRecord[2].match(/IDSN2:/)
            leakageRecords[2] = leakageRecord
            #puts leakageRecords[2]
          end
          if leakageRecord[2].match(/IDSN3:/)
            leakageRecords[3] = leakageRecord
            #puts leakageRecords[3]
          end
          if leakageRecord[2].match(/IDSN4:/)
            leakageRecords[4] = leakageRecord
            #puts leakageRecords[4]
          end
          if leakageRecord[2].match(/IDSN5:/)
            leakageRecords[5] = leakageRecord
            #puts leakageRecords[5]
          end
          if leakageRecord[2].match(/IDSN6:/)
            leakageRecords[6] = leakageRecord
            #puts leakageRecords[6]
          end
          if leakageRecord[2].match(/IDSN7:/)
            leakageRecords[7] = leakageRecord
            #puts leakageRecords[7]
          end
          if leakageRecord[2].match(/IDSN8:/)
            leakageRecords[8] = leakageRecord
            #puts leakageRecords[8]
          end
          
        end
        unless (record[1].match(/tb_I/)|| data.match(/bin number|TN:|tb_input_leakage_low|tb_opens|tb_shorts/))
         #puts "----> #{file}, #{serialNumber}, #{record[2].sub(/IDSN\d:/,'IDSN1:')}, #{record[1]}, #{record[3]}, #{record[4]}"
         csv.print "#{file}, #{serialNumber}, #{record[2].sub(/IDSN\d:/,'IDSN1:')}, #{record[1]}, #{record[3]}, #{record[4]}\n"
        end
        if record[1].match(/tb_I/)
          #jh puts "----> #{file}, #{serialNumber}, #{record[2]}, #{record[1]}, #{record[6]}, #{record[7]}"
          csv.print "#{file}, #{serialNumber}, #{record[2].sub(/IDSN\d:/,'IDSN1:')}, #{record[1]}, #{record[6]}, #{record[7]}\n"
        end
        
      
        if data.match(/bin number =   1/)
          if data.match(/IDSN1:/)
            leakageRecord = leakageRecords[1]
          end
          if data.match(/IDSN2:/)
            leakageRecord = leakageRecords[2]
          end
          if data.match(/IDSN3:/)
            leakageRecord = leakageRecords[3]
          end
          if data.match(/IDSN4:/)
            leakageRecord = leakageRecords[4]
          end
          if data.match(/IDSN5:/)
            leakageRecord = leakageRecords[5]
          end
          if data.match(/IDSN6:/)
            leakageRecord = leakageRecords[6]
          end
          if data.match(/IDSN7:/)
            leakageRecord = leakageRecords[7]
          end
          if data.match(/IDSN8:/)
            leakageRecord = leakageRecords[8]
          end
          leakageRecord[2] = record[1]
          #puts "----> #{file}, #{serialNumber}, #{leakageRecord[2]}, #{leakageRecord[1]}, #{leakageRecord[6]}, #{leakageRecord[7]}"
          csv.print "#{file}, #{serialNumber}, #{leakageRecord[2].sub(/IDSN\d:/,'IDSN1:')}, #{leakageRecord[1]}, #{leakageRecord[6]}, #{leakageRecord[7]}\n"
          
          puts data
          pass += 1
          record = data.split(/:| |=/)
          #puts record
          csv.print "#{file}, #{serialNumber}, IDSN1:#{record[3]}, bin, #{record[18]}\n"
        elsif data.match(/bin number/)
          puts data
          total += 1
          record = data.split(/:| |=/)
          #puts record
          csv.print "#{file}, #{serialNumber}, IDSN1:#{record[3]}, bin, #{record[16]}\n"
        end
      end
    end #line
  end #file
end
end #directory
}
puts "Passing DUTS #{pass}"
puts "Failing DUTS #{total}"