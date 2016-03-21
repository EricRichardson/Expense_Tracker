def get_file
  File.open("entries.txt", 'a+')
end

def get_item
  item = ' '
  while (item =~ /\s+/ or item.empty?) do
    puts "What did you buy?"
    item = gets.chomp.capitalize
  end
  if item.length >= 16
    number_of_lines = item.length / 14
    line_place = 1
    number_of_lines.times do
      item.insert( line_place * 14, "-\n")
      line_place += 1
    end
    item = item.split("\n")
    item[-1] = item[-1] + space(item.last)
    return item.join("\n")
  end
  item + space(item)
end

def get_price
  price = 0
  until (price =~ /\d+\.\d\d/) do
    puts "How much did it cost? Format: 100.00 required"
    price = gets.chomp
  end
  price
end

def write_to_file (file, item, price)
 file << "#{item}"
 file << "$#{price}"
 file << "\n"
end

def space(item)
  space = 20 - item.length
  ' ' * space
end

def add_sum
  sum = 0
  File.open("entries.txt", 'r+') do |f|
  f.each_line do |line|
    value = line.scan(/\d+/).join.to_i
    sum += value
  end
  f << "#{'_'*30}\n"
  sum = sum.to_s.insert(-3, '.')
  f << "Total: #{space('Total: ')}$#{sum}\n"
  end
end

def remove_sum
  require 'fileutils'
  open('entries.txt', 'r') do |f|
  open('file.txt.tmp', 'w') do |f2|
    f.each_line do |line|
       f2.write(line) unless line.start_with? "Total:" or line.start_with? "____"
    end
  end
end
FileUtils.mv 'file.txt.tmp', 'entries.txt'
end

if File.exist?('entries.txt')
  remove_sum
else
  file = File.new('entries.txt', 'w')
  file << "Item #{space('Item ')}Price \n"
  file << "#{'-'*30}\n"
  file.close
end

file = get_file
continue = String.new
until (continue == 'n') do
  continue = String.new
  write_to_file(file, get_item, get_price)
  until (continue == 'y' or continue == 'n')
    puts "More items? (y/n)"
    continue = gets.chomp.downcase
  end
end
file.close
add_sum
