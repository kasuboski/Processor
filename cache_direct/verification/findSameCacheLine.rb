lines = []
addrToFind = ARGV[1].hex & "0000011111111000".to_i(2)

File.open(ARGV[0], "r").each_line do |line|
	lineParts = line.split(" ")
	if lineParts[0] == "#" && lineParts[1] == "LOG:" && lineParts[2] != "Done"
		addr = lineParts[10].hex & "0000011111111000".to_i(2)
		if addrToFind == addr
			lines.push(lineParts)
		end
	end
end

log_file = File.open("sameCacheLines.log", 'w')

lines.each do |line|
	write = (line[8] == "Wr") ? 1 : 0
	read = (line[8] == "Rd") ? 1 : 0
	addr = line[10].hex.to_s
	value = line[12].hex.to_s
	log_file.write(line.join(" ") + "\n")
end

