lines = []
errors = []
File.open(ARGV[0], "r").each_line do |line|
	lineParts = line.split(" ")
	if lineParts[0] == "#" && lineParts[1] == "LOG:" && lineParts[2] != "Done"
		lines.push(lineParts)
	elsif lineParts[0] == "#" && lineParts[1] == "ERROR"
		errors.push("Line: " + lines.length.to_s + " " + lines.last.join(" ")) 		
	end
end

addr_file = File.open("test.addr", 'w')
log_file = File.open("test.log", 'w')
error_file = File.open("test.error", 'w')

lines.each do |line|
	write = (line[8] == "Wr") ? 1 : 0
	read = (line[8] == "Rd") ? 1 : 0
	addr = line[10].hex.to_s
	value = line[12].hex.to_s
	addr_file.write(write.to_s + " " + read.to_s + " " + addr + " " + value + "\n")
	log_file.write(line.join(" ") + "\n")
end

error_file.write(errors.join("\n"))
