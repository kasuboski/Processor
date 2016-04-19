lines = []
File.open(ARGV[0], "r").each_line do |line|
	if(lineParts[0] == "#" && lineParts[1] == "LOG:" && lineParts[2] != "Done")
		puts line
		lines.push(lineParts)	
	end
end

file = File.open("test.addr", 'w')

lines.each do |line|
	write = (line[8] == "Wr") ? 1 : 0
	read = (line[8] == "Rd") ? 1 : 0
	addr = line[10].hex.to_s
	value = line[12].hex.to_s
	file.write(write.to_s + " " + read.to_s + " " + addr + " " + value + "\n")
end
