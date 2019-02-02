form cp_makeDico v0.01 Ferragne 2016
comment Choose tier containing vowel labels
integer tier 1
endform
myList$ = chooseReadFile$: "Choose list of wav files"
if myList$ <> ""
	Read Strings from raw text file: myList$
	listName$ = selected$("Strings")
	nbFiles = Get number of strings
	for i to nbFiles
		selectObject: "Strings " + listName$
		currentFile$ = Get string: i
		Read from file: currentFile$ - ".wav" + ".TextGrid"
		Extract one tier: tier
		Down to Table: "no", 1, "no", "no"
		if i <> 1
			plusObject: "Table myDico"
			Append
		endif
		Rename: "myDico"
	endfor
	Remove column: "tmin"
	Remove column: "tmax"
	Collapse rows: "text", "", "", "", "", ""
	nbRows = Get number of rows
	myDicoFile$ = chooseWriteFile$: "Save dictionary file", "myDico.txt"
	if myDicoFile$ <> ""
		for k to nbRows
			currentSymb$ = Get value: k, "text"
			appendFileLine: myDicoFile$, currentSymb$
		endfor		
	endif
endif
			
		
		
		