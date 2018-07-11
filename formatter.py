from string import digits

with open("german.txt") as f:
    content = f.readlines()

thefile = open('test.txt', 'w')

for line in content:
	noDigits = str.maketrans('','',digits)
	line = line.translate(noDigits)
	line = line.split()
	strLine = str(line)
	strLine = strLine.replace('[','')
	strLine = strLine.replace(',','')
	strLine = strLine.replace(']','\n')
	strLine = strLine.replace('\'','')
	print(strLine)
	thefile.write(str(strLine))