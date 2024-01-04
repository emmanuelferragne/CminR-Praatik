#changes
#v2.0
#added .param files to save formant parameters for reproducibility

demoWindowTitle: "cp_formants v.2.0 Ferragne 2024"
demo Erase all

maxFreq = 5500
nbFormants = 5
preEmph = 50
timeStep = 0.005
#phonTier : le tier dans lequel on cherche les labels
phonTier = 1
winSize = 0.025
#force UTF-8 encoding
Text writing preferences: "UTF-8"

demo Select inner viewport: 0, 100, 0, 100
demo Axes: 0, 100, 0, 100
demo Font size: 20
demo Paint rectangle: "grey", 25, 75, 50, 70
demo Text: 50, "centre", 60, "half", "Click to load file list"
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
directoryOut$ = left$(myFile$,indSlash) + "output/"
createDirectory: directoryOut$
Read Strings from raw text file: myFile$
Rename: "myList"
stringToCheck$ = Get string: 1
if index(stringToCheck$, "intervalNumberLastSession") <> 0
	numInter = number(replace$(stringToCheck$, "intervalNumberLastSession", "", 1))
	Remove string: 1
else
	numInter = 1
endif
interAtSessionStart = numInter - 1
nbFiles = Get number of strings

demo Erase all
demo Paint rectangle: "grey", 25, 75, 50, 70
demo Text: 50, "centre", 60, "half", "Click to load dictionary file"
while demoWaitForInput()
	if demoClickedIn (25, 75, 50, 70)
		goto LOADDICO
	endif
endwhile

label LOADDICO
myDicoFile$ = chooseReadFile$: "Choose dictionary file file"
Read Strings from raw text file: myDicoFile$
Rename: "myDico"
nbVTypes = Get number of strings


if fileReadable(directoryOut$ + "discardedSegments.txt") = 0
	writeFile: directoryOut$ + "discardedSegments.txt"
	writeFileLine: directoryOut$ + "discardedSegments.txt", "file_name", tab$, "tier_number", tab$, "interval_number", tab$, "symbol"
endif


label GLOBALPARAMS
demo Erase all
demo Select inner viewport: 0, 100, 0, 100
demo Axes: 0, 100, 0, 100
demo Font size: 20
demo Text: 30, "centre", 60, "half", "Tier number with vowel symbols"
demo Text: 30, "centre", 50, "half", string$(phonTier)
demo Paint rectangle: "grey", 15, 25, 45, 55
demo Text: 20, "centre", 50, "half", "<"
demo Paint rectangle: "grey", 35, 45, 45, 55
demo Text: 40, "centre", 50, "half", ">"

demo Paint rectangle: "grey", 75, 95, 5, 20
demo Text: 85, "centre", 12.5, "half", "NEXT"


okGlobalParams = 0
while okGlobalParams = 0
demoWaitForInput()
	if demoClickedIn(15, 25, 45, 55)
		phonTier = phonTier - 1
		goto GLOBALPARAMS
	elsif demoClickedIn(35, 45, 45, 55)
		phonTier = phonTier + 1
		goto GLOBALPARAMS
	elsif demoKeyPressed()
		if demoKey$() = "→"
			phonTier = phonTier + 1
		elsif demoKey$() = "←"
			phonTier = phonTier - 1
		endif
		goto GLOBALPARAMS
	elsif demoClickedIn(75, 95, 5, 20)
		okGlobalParams = 1	
	endif
endwhile


for stringID from 1 to nbFiles
	selectObject: "Strings myList"
	currentString$ = Get string: stringID
	stringForDiscard$ = replace$(currentString$, "\", "/", 50)
	Read from file: currentString$
	Read from file: currentString$ - ".wav" + ".TextGrid"
	objName$ = selected$("TextGrid")
	
	nbInter = Get number of intervals: phonTier
	while numInter <= nbInter
		selectObject: "TextGrid " + objName$
		label$ = Get label of interval: phonTier, numInter
		for typeID from 1 to nbVTypes
			if label$ = Strings_myDico$[typeID]
				oldInter = numInter
				myStart = Get starting point: phonTier, numInter
				myEnd = Get end point: phonTier, numInter
				phonSymb$ = Get label of interval: phonTier, numInter
				phonSymbInName$ = replace$(phonSymb$,"\","-",3)
				phonSymbInName$ = replace$(phonSymbInName$,":","#",3)
				phonSymbInName$ = replace$(phonSymbInName$,"/","-",3)
				phonSymb$ = backslashTrigraphsToUnicode$(phonSymb$)
				selectObject: "Sound " + objName$
				Extract part: myStart - winSize, myEnd + winSize, "rectangular", 1, "yes"
				Rename: "mySelection"
				noprogress To Spectrogram: 0.005, 5000, 0.002, 20, "Gaussian"

				label FORMANTSCREEN
				demo Erase all
				demo Font size: 12
				selectObject: "Spectrogram mySelection"
				demo Select inner viewport: 15, 60 , 25, 70
				demo Paint: 0, 0, 0, 0, 100, "yes", 50, 6, 0, "yes"
				demo Marks left every: 1, 500, "yes", "yes", "no"
				selectObject: "Sound mySelection"
				noprogress To Formant (burg): 0.005, nbFormants, maxFreq,winSize, 50
				demo Colour: "Red"
				demo Line width: 2
				demo Draw tracks: 0, 0, 5000, "no"
				demo Line width: 1
				demo Colour: "Black"

				nombreForm = Get number of formants: 1
				tFr1 = Get time from frame number: 1
				for iFNum to nombreForm
					currentFVal = Get value at time: iFNum, tFr1, "Hertz", "Linear"
					if currentFVal < 5000
						demo Text: tFr1, "Centre", currentFVal, "Half", "F"+string$(iFNum)
					endif
				endfor
				demo Select inner viewport: 0, 100, 0, 100

				demo Axes: 0, 100, 0, 100
				demo Font size: 24
				demo Text: 35, "centre", 80, "half", "[ " + phonSymb$ + " ]"
				demo Font size: 12
				demo Text: 80, "centre", 95, "half", "File " + string$(stringID) + " of " + string$(nbFiles)
				demo Text: 80, "centre", 92, "half", "Interval " + string$(numInter) + " of " + string$(nbInter)
			
				demo Font size: 16
				demo Text: 80, "centre", 85, "half", "number of expected formants"
				demo Text: 80, "centre", 80, "half", string$(nbFormants)
				demo Paint rectangle: "grey", 70, 75, 78.5, 82.5
				demo Text: 72.5, "centre", 80, "half", "<"
				demo Paint rectangle: "grey", 85, 90, 78.5, 82.5
				demo Text: 87.5, "centre", 80, "half", ">"

				demo Text: 80, "centre", 70, "half", "maximum frequency (Hz)"
				demo Text: 80, "centre", 65, "half", string$(maxFreq)
				demo Paint rectangle: "grey", 70, 75, 62.5, 67.5
				demo Text: 72.5, "centre", 65, "half", "<"
				demo Paint rectangle: "grey", 85, 90, 62.5, 67.5
				demo Text: 87.5, "centre", 65, "half", ">"

				demo Paint rectangle: "grey", 75, 85, 45, 55
				demo Text: 80, "centre", 50, "half", "PLAY"

				demo Paint rectangle: "grey", 75, 85, 30, 40
				demo Text: 80, "centre", 35, "half", "SAVE"

				demo Paint rectangle: "grey", 75, 85, 15, 25
				demo Text: 80, "centre", 20, "half", "DISCARD"

				demo Paint rectangle: "grey", 75, 85, 0, 10
				demo Text: 80, "centre", 5, "half", "STOP"

				myChoice = 0
				while myChoice = 0
					demoWaitForInput()
					if demoClickedIn(70, 75, 78.5, 82.5)
						nbFormants = nbFormants - 0.5
						goto FORMANTSCREEN
					elsif demoClickedIn(85, 90, 78.5, 82.5)
						nbFormants = nbFormants + 0.5
						goto FORMANTSCREEN
					elsif demoClickedIn(70, 75, 62.5, 67.5)
						maxFreq = maxFreq - 100
						goto FORMANTSCREEN
					elsif demoClickedIn(85, 90, 62.5, 67.5)
						maxFreq = maxFreq + 100
						goto FORMANTSCREEN
						#voici comment interagir avec les touches du clavier
					elsif demoKeyPressed()
						if demoKey$() = "→"
							maxFreq = maxFreq + 100
						elsif demoKey$() = "←"
							maxFreq = maxFreq - 100
						endif
							goto FORMANTSCREEN
					elsif demoClickedIn(75, 85, 45, 55)
						selectObject: "Sound mySelection"
						Play
					elsif demoClickedIn(75, 85, 30, 40)
						@zeroPadding
						selectObject: "Formant mySelection"
						Down to Table: "no", "yes", 6, "yes", 3, "yes", 3, "no"
						Append column: "symbol"
						Set string value: 1, "symbol", phonSymb$
						Save as tab-separated file: directoryOut$ + objName$ + "_" + stringInter$ + "_" + phonSymbInName$ + ".txt"
						writeFile: directoryOut$ + objName$ + "_" + stringInter$ + "_" + phonSymbInName$ + ".param", 
						... "Time step (s): ", timeStep, newline$,
						... "Max. number of formants: ", nbFormants, newline$,
						... "Formant ceiling (Hz): ", maxFreq, newline$,
						... "Window length (s): ",winSize, newline$,
						... "Pre-emphasis from (Hz): ", preEmph 
						myChoice = 1
						@saveNewList
					elsif demoClickedIn(75, 85, 15, 25)
						@zeroPadding
						appendFileLine: directoryOut$ + "discardedSegments.txt", stringForDiscard$, tab$, phonTier, tab$, numInter, tab$, phonSymb$
						myChoice = 1
						@saveNewList
					elsif demoClickedIn(75, 85, 0, 10)
						@saveNewList
						@interruptScreen
					endif
				endwhile
			endif
		endfor
		numInter = numInter + 1
	endwhile
	select all
	minusObject: "Strings myList", "Strings myDico"
	Remove
	numInter = 1
endfor


demo Erase all
demo Text: 50, "centre", 60, "half", "All the files in the list have been processed"
select all
Remove

#cette procédure ajoute des zéros pour le numéro
#d'intervalle qui sera dans le fichier
#ici, le numéro d'intervalle peut aller jusqu'à 999
#si vous avez plus de 999 intervalles à analyser dans un seul
#fichier, il faut : while myLength < 4
procedure zeroPadding
	stringInter$ = string$(numInter)
	myLength = length(stringInter$)
	while myLength < 3
		stringInter$ = "0" + stringInter$
		myLength = myLength + 1		
	endwhile
endproc

procedure saveNewList
	Create Strings as file list: "listOfLists", directoryOut$ - "output/" + "upDatedFileList*"
	nbLists = Get number of strings
	if nbLists > 0
		for iNumList to nbLists
			currentListName$ = Get string: iNumList
			deleteFile: directoryOut$ - "output/" + currentListName$
		endfor
	endif
	removeObject: "Strings listOfLists"
	theDate$ = date$()
	theDate$ = replace$(theDate$,":","-",2)
	theDate$ = replace$(theDate$," ","-",5)
	selectObject: "Strings myList"
	Extract part: stringID, nbFiles
	Insert string: 1, "intervalNumberLastSession" + string$(oldInter)
	Save as raw text file: directoryOut$ - "output/" + "upDatedFileList-" + theDate$ + ".txt"
endproc

procedure interruptScreen
	demo Erase all
	demo Text: 50, "centre", 70, "half", "A new file list called " + "upDatedFileList-" + theDate$ + ".txt" + " has been saved"
	demo Text: 50, "centre", 60, "half", "Next time, load this list if you want to start where you stopped"
	select all
	Remove
endproc