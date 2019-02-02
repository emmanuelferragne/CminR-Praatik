form cp_byHandFormants v. 0.02 Ferragne 2016
comment number of points per formant
positive maxPoints 5
comment number of formants (2 to 5)
positive maxForm 4
endform
demoWindowTitle: "cp_byHandFormants v. 0.01 Ferragne 2016"

demo Erase all
demo Colour: "Black"
demo Select inner viewport: 0, 100, 0, 100
demo Axes: 0, 100, 0, 100
demo Font size: 20
demo Paint rectangle: "grey", 25, 75, 50, 70
demo Text: 50, "centre", 60, "half", "Click to load discarded file list"
demoShow()
while demoWaitForInput()
	if demoClickedIn (25, 75, 50, 70)
		goto LOADLIST
	endif
endwhile
label LOADLIST
myFile$ = chooseReadFile$: "Choose list file"
indSlash = rindex(myFile$,"\")
if indSlash = 0
	indSlash = rindex(myFile$,"/")
endif
directoryOut$ = left$(myFile$,indSlash) + "outputManual/"
createDirectory: directoryOut$

if fileReadable(directoryOut$ + "discardedSegments4Good.txt") = 0
	writeFile: directoryOut$ + "discardedSegments4Good.txt"
	writeFileLine: directoryOut$ + "discardedSegments4Good.txt", "file_name", tab$, "tier_number", tab$, "interval_number", tab$, "symbol"
endif

Read Table from tab-separated file: myFile$
Rename: "myList"

nbFiles = Get number of rows

for iFile from 1 to nbFiles
	selectObject: "Table myList"
	fileName$ = Get value: iFile, "file_name"
	tierNumber = Get value: iFile, "tier_number"
	numInter = Get value: iFile, "interval_number"
	phonSymb$ = Get value: iFile, "symbol"
	Read from file: fileName$
	objName$ = selected$("Sound")
	Read from file: fileName$ - "wav" + "TextGrid"
	deb = Get starting point: tierNumber, numInter
	fin = Get end point: tierNumber, numInter
	selectObject: "Sound " + objName$
	Extract part: deb, fin, "rectangular", 1, "yes"

	Rename: "mySound"
	myDuration = Get total duration
	To Spectrogram: 0.005, 5000, 0.002, 10, "Gaussian"
	demo Paint: 0, 0, 0, 0, 100, "no", 50, 6, 0, "no"
	
	label LAPAUSE
	beginPause: "Try manual tracking or discard vowel [ " + phonSymb$ +" ]?   " + string$(iFile) + "/" + string$(nbFiles)
		comment: "Start with " + string$(maxPoints) + " points on F1"
	isTry = endPause: "Try", "Discard", "Play sound", 1
	if isTry = 1

		Create FormantGrid: "myFormants", deb, fin, 5, 500, 500, 10, 10
		for i from 1 to 5
			Remove formant points between: i, deb, fin
		endfor
		isOk = 0
		forNum = 1
		nbPoints = 0
		while isOk = 0
			demoWaitForInput ()
			if demoClicked()
				xCoord = demoX()
				yCoord = demoY()
				demo Paint circle: "red", xCoord, yCoord, 0.002
				selectObject: "FormantGrid myFormants"
				Add formant point: forNum, xCoord, yCoord
				nbPoints = nbPoints + 1
				if nbPoints = maxPoints
					forNum = forNum + 1
					if forNum = maxForm + 1
						isOk = 1
					else
						nbPoints = 0
						pauseScript: "Moving to formant number ", forNum
					endif

				endif	
   			endif
		endwhile
		demo Erase all
		To Formant: 0.005, 0.1
		selectObject: "Spectrogram mySound"
		demo Paint: 0, 0, 0, 0, 100, "no", 50, 6, 0, "no"
		selectObject: "Formant myFormants"
		demo Line width: 2
		demo Colour: "Red"
		demo Draw tracks: 0, 0, 5000, "no"
		beginPause: "Save?"
			comment: "Would you like to save these tracks?"
		choice = endPause: "Save", "Discard", 1
		if choice = 1
			phonSymbInName$ = unicodeToBackslashTrigraphs$(phonSymb$)
			phonSymbInName$ = replace$(phonSymbInName$,"\","-",3)
			phonSymbInName$ = replace$(phonSymbInName$,":","#",3)
			@zeroPadding
			Down to Table: "no", "yes", 6, "yes", 3, "yes", 3, "no"
			Append column: "symbol"
			Set string value: 1, "symbol", phonSymb$
			Save as tab-separated file: directoryOut$ + objName$ + "_" + stringInter$ + "_" + phonSymbInName$ + ".txt"
		else
			@discardProc
		endif
	elsif isTry = 2
		@discardProc
	else
		@playSound
	endif
	demo Erase all
	select all
	minusObject: "Table myList"
	Remove
endfor

Erase all
demo Colour: "Black"
demo Font size: 14
demo Axes: 0, 100, 0, 100
demo Text: 50, "centre", 60, "half", "All the files in the list have been processed"
demoShow()

procedure zeroPadding
	stringInter$ = string$(numInter)
	myLength = length(stringInter$)
	while myLength < 3
		stringInter$ = "0" + stringInter$
		myLength = myLength + 1		
	endwhile
endproc

procedure discardProc
appendFileLine: directoryOut$ + "discardedSegments4Good.txt", fileName$, tab$, tierNumber, tab$, numInter, tab$, phonSymb$
endproc

procedure playSound
selectObject: "Sound mySound"
Play
goto LAPAUSE
endproc

