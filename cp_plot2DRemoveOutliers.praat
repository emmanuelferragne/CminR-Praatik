#plots vowels in F1/F2; lets you remove outliers
#click on a vowel in the vowel space: Praat plays back the relevant sound file
#then windows pops up: asking if you want to remove said vowel
#removed vowels are in file "removeOutliers + current date"
#if reset is pressed or Praat is closed, the process starts again from scratch
#currently plays back whole sound file (so original sound files should be short)
#assumes formant files were obtained with cp_formants

demoWindowTitle: "cp_plot2DRemoveOutliers v0.01 Ferragne 2024"
theDate$ = date$()
theDate$ = replace$(theDate$,":","-",2)
theDate$ = replace$(theDate$," ","-",5)
outputFileName$ = "removeOutliers-" + theDate$ + ".txt"

fontSize = 10

demo Erase all
demo Select inner viewport: 0, 100, 0, 100
demo Axes: 0, 100, 0, 100
demo Font size: 20
demo Paint rectangle: "grey", 25, 75, 50, 70
demo Text: 50, "centre", 60, "half", "Choose directory of formant files after cp\_ formants"
while demoWaitForInput()
	if demoClickedIn (25, 75, 50, 70)
		goto CHOOSEDIR
	endif
endwhile
label CHOOSEDIR
dirName$ = chooseDirectory$: "Choose directory of formant files after cp_formants"
#dirName$ = "formantOutput"

demo Erase all
demo Select inner viewport: 0, 100, 0, 100
demo Axes: 0, 100, 0, 100
demo Font size: 20
demo Paint rectangle: "grey", 25, 75, 50, 70
demo Text: 50, "centre", 60, "half", "Choose directory where sound files are"
while demoWaitForInput()
	if demoClickedIn (25, 75, 50, 70)
		goto CHOOSEDIR2
	endif
endwhile
label CHOOSEDIR2
dirNameSounds$ = chooseDirectory$: "Choose directory where sound files are"
#dirNameSound$ = "soundFiles"

Create Strings as file list: "myList", dirName$ + "/*.txt"
Create Strings as file list: "tempList", dirNameSound$ + "/*wav"
testString$ = Get string: 1
soundLength = length(testString$) - 4
removeObject: "Strings tempList"
selectObject: "Strings myList"

#check if "discardedSegments.txt" is in list
nbStrings = Get number of strings
iCheck = 1
while iCheck <= nbStrings
	if Strings_myList$[iCheck] = "discardedSegments.txt" or index(Strings_myList$[iCheck], "upDatedFileList") <> 0
		Remove string: iCheck
		nbStrings = nbStrings - 1
		iCheck = iCheck - 1
	endif
	iCheck = iCheck + 1
endwhile

nbFiles = Get number of strings
Create Table with column names: "formantTable2D", nbFiles, "File Vowel F1 F2"
for fileID to nbFiles
	currentFile$ = Strings_myList$[fileID]
	Read Table from tab-separated file: dirName$ + "/" + currentFile$
	indLastUS = rindex(currentFile$, "_")
	indDotText = rindex(currentFile$,".txt")
	rawVowel$ = mid$(currentFile$, indLastUS+1, indDotText - indLastUS - 1)
	vowelTrigraph$ =  replace$(rawVowel$,"-","\",0)
	vowelTrigraph$ =  replace$(vowelTrigraph$,"#",":",0)
	formLength = Get number of rows
	whichRow = round(formLength/2)
	myF1 = Get value: whichRow, "F1(Hz)"
	myF2 = Get value: whichRow, "F2(Hz)"
	selectObject: "Table formantTable2D"
	Set string value: fileID, "File", currentFile$
	Set string value: fileID, "Vowel", vowelTrigraph$
	Set numeric value: fileID, "F1", myF1
	Set numeric value: fileID, "F2", myF2
endfor

minF1 = Get minimum: "F1"
maxF1 = Get maximum: "F1"
minF2 = Get minimum: "F2"
maxF2 = Get maximum: "F2"

Copy: "formantTemporary"

xLower = floor(minF2)-30
xUpper = ceiling(maxF2)+30
yLower = floor(minF1)-30
yUpper = ceiling(maxF1)+30

select all
minusObject: "Table formantTable2D", "Table formantTemporary"
Remove

@drawPlot: "Table formantTemporary"

while demoWaitForInput()
	oldMinDist = 10000
	if demoClicked()
		if demoX()< xLower and demoY()< yLower
			@reset
		else
		selectObject: "Table formantTemporary"
		nbRows = Get number of rows
		for idx from 1 to nbRows
			#recall that f1 (first column) is y
			currentX = Get value: idx, "F2"
			currentY = Get value: idx, "F1"
			currentDist = sqrt((currentX - demoX())^2 + (currentY - demoY())^2)
			if currentDist < oldMinDist
				oldMinDist = currentDist
				theInd = idx
			endif
		endfor
		fileName$ = Get value: theInd, "File"
		Read from file: dirNameSound$ + "/" + left$(fileName$, soundLength) + ".wav"
		Scale peak: 0.99
		Play
		Remove
		beginPause: "cp_Plot2DRemoveOutliers"
		comment: "Remove current value?"
		clicked = endPause: "Yes", "Cancel", 2, 2
		if clicked = 1
			selectObject:"Table formantTemporary"
			removedFile$ = Get value: theInd, "File"
			Remove row: theInd
			@drawPlot: "Table formantTemporary"
			appendFileLine: outputFileName$, removedFile$ 
		endif
	endif
endwhile

procedure drawPlot: whichTable$
	demo Erase all
	demo Colour: 0
	demo Font size: 16
	demo Axes: 0, 100, 0, 100
	demo Select inner viewport: 0,100,0,100
	demo Paint rectangle: "grey",90, 100, 90, 100
	demo Text: 95, "centre", 95, "half", "RESET"
	selectObject: whichTable$
	demo Font size: fontSize
	demo Select inner viewport: 10,90,10,90
	demo Scatter plot: "F2", xUpper, xLower, "F1", yUpper, yLower, "Vowel", fontSize, "no"
	demo Draw inner box
	demo Text left: "yes", "F1 (Hz)"
	demo Text bottom: "yes", "F2 (Hz)"
	demo One mark bottom: xUpper, "yes", "yes", "no", string$(xUpper)
	demo One mark bottom: xLower, "yes", "yes", "no", string$(xLower)
	demo One mark left: yUpper, "yes", "yes", "no", string$(yUpper)
	demo One mark left: yLower, "yes", "yes", "no", string$(yLower)
endproc

procedure reset
	selectObject: "Table formantTemporary"
	Remove
	selectObject: "Table formantTable2D"
	Copy: "formantTemporary"
	@drawPlot: "Table formantTemporary"
	writeFile: outputFileName$
endproc
