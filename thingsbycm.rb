# thingsbycm by danrfq

require "open-uri"
require "nokogiri"

puts "Welcome to thingsbycm!"
puts "How many centimeters that you want to measure the things of?"
centimeters = gets.chomp

# Handle first if the input is not a valid number or the number is less than or equal to zero.

if !(centimeters.to_i.to_s == centimeters)
    puts "Input should only be a number!"
    return
elsif centimeters.to_i <= 0
    puts "Number must not be less than or equal to zero!"
    return
end

# Main program

result = URI.open("https://www.themeasureofthings.com/results.php?comp=height&unit=cm&amt=#{centimeters}&sort=pr&p=1")
data = Nokogiri::HTML(result)

formatted_cm = centimeters.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
numcheck = centimeters.to_i > 1 ? "s" : ""
index = 1

puts
puts "Results for things around #{formatted_cm} centimeter#{numcheck} are..."
puts

results = data.css("div.result")[0..4].each do |result|
    datas = result.css("div")

    title = datas.first.content.gsub("  ", " ") + "."
    info = result.css("div.numbers").first.content.gsub("  ", " ")

    location = datas[1].css("div")[2]
    location = location ? location.content.chomp.gsub("  ", " ") : "Not in data"
    location = location.scan("(").length == 1 && location.scan(")").length == 1 ? location[1..-2] : location

    detail = result.css("div.detail").first.content.gsub("  ", " ")
    source = result.css("a")[-1].attributes["href"].value

    puts "#{index}. #{title}"
    puts
    puts info
    puts "Location: #{location}"
    puts
    puts detail
    puts
    puts "For more information: #{source}"
    
    index += 1
    puts if index != 6
end