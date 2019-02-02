#Ferragne 2016
beginPause: "cp_makeList"
extension = 1
choice: "Extension", extension
	option: ".txt"
	option: ".wav"
	option: ".TextGrid"
myChoice = endPause: "Continue", 1

myDir$ = chooseDirectory$: "Choose input directory"
myDir$ = replace$(myDir$, "\", "/", 100)
Create Strings as file list: "myList", myDir$ + "/*" + extension$
Replace all: "^.*$", myDir$ + "/" + "&", 0, "regular expressions"
myFile$ = chooseWriteFile$: "Choose output directory", "myList.txt"
Save as raw text file: myFile$


