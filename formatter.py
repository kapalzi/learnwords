from string import digits

with open("polishgermantop1000.txt") as f:
    content = f.readlines()

thefile = open('test.txt', 'w')

#for line in content:
#    noDigits = str.maketrans('','',digits)
#    line = line.translate(noDigits)
#    line = line.split()
#    strLine = str(line)
#    strLine = strLine.replace('[','')
#    strLine = strLine.replace(',','')
#    strLine = strLine.replace(']','\n')
#    strLine = strLine.replace('\'','')
#    print(strLine)
#    thefile.write(str(strLine))


#x = 0
#for line in content:
#    x=x+1
#    if x%2 == 0:
#        continue
#    noDigits = str.maketrans('','',digits)
#    line = line.translate(noDigits)
#
#    nextLine = content[content.index(line)+1]
#    line = line + ' ' + nextLine
#
#    line = line.split()
#    strLine = str(line)
#    strLine = strLine.replace('[','')
#    strLine = strLine.replace(',','')
#    strLine = strLine.replace(']','\n')
#    strLine = strLine.replace('\'','')
#    print(strLine)
#    thefile.write(str(strLine))


x = 0
for line in content:
    x=x+1
    if x%2 != 0:
        continue
    noDigits = str.maketrans('','',digits)
    line = line.translate(noDigits)

    nextLine = content[content.index(line)-1]
    line = line + ' ' + nextLine

    line = line.split()
    strLine = str(line)
    strLine = strLine.replace('[','')
    strLine = strLine.replace(',','')
    strLine = strLine.replace(']','\n')
    strLine = strLine.replace('\'','')
    print(strLine)
    thefile.write(str(strLine))
