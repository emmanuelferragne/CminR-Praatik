demoWindowTitle: "cp_plot2D v0.05 Ferragne 2016"
demo Erase all
demo Select inner viewport: 0, 100, 0, 100
demo Axes: 0, 100, 0, 100
demo Font size: 20
demo Paint rectangle: "grey", 25, 75, 50, 70
demo Text: 50, "centre", 60, "half", "Click to choose directory"
while demoWaitForInput()
	if demoClickedIn (25, 75, 50, 70)
		goto CHOOSEDIR
	endif
endwhile
label CHOOSEDIR
dirName$ = chooseDirectory$: "Choose directory"
#dirName$ = "C:\Users\eferragne\Documents\travailEnCours\scriptFormants\demoFormants\outputAuto"
outDir$ = dirName$ + "/figure"
createDirectory: outDir$

Create Strings as file list: "myList", dirName$ + "/*.txt"

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

xLower = floor(minF2)-30
xUpper = ceiling(maxF2)+30
yLower = floor(minF1)-30
yUpper = ceiling(maxF1)+30

Down to TableOfReal: "Vowel"
To TableOfReal (means by row labels): "no"
Rename: "formantMean"

select all
minusObject: "Table formantTable2D", "TableOfReal formantMean"
Remove

fontSize = 12
drawAll = 2
pictNb = 1
label DASHBOARD

	if drawAll mod 2 = 0
		@drawBasic
	else
		@drawMean
	endif
	demo Select inner viewport: 0, 100, 0, 100

	demo Axes: 0, 100, 0, 100
	demo Font size: 16

	demo Text: 80, "centre", 90, "half", "Font size"
	demo Text: 80, "centre", 85, "half", string$(fontSize)
	demo Paint rectangle: "grey", 72, 77, 82.5, 87.5
	demo Text: 74.5, "centre", 85, "half", "-"
	demo Paint rectangle: "grey", 83, 88, 82.5, 87.5
	demo Text: 85.5, "centre", 85, "half", "+"

	demo Text: 80, "centre", 70, "half", "F2 lower limit"
	demo Text: 80, "centre", 65, "half", string$(xLower)
	demo Paint rectangle: "grey", 72, 77, 62.5, 67.5
	demo Text: 74.5, "centre", 65, "half", "-"
	demo Paint rectangle: "grey", 83, 88, 62.5, 67.5
	demo Text: 85.5, "centre", 65, "half", "+"
	demo Paint rectangle: "grey", 66, 71, 62.5, 67.5
	demo Text: 68.5, "centre", 65, "half", "- -"
	demo Paint rectangle: "grey", 89, 94, 62.5, 67.5
	demo Text: 91.5, "centre", 65, "half", "+ +"
	
	demo Text: 80, "centre", 55, "half", "F2 upper limit"
	demo Text: 80, "centre", 50, "half", string$(xUpper)
	demo Paint rectangle: "grey", 72, 77, 47.5, 52.5
	demo Text: 74.5, "centre", 50, "half", "-"
	demo Paint rectangle: "grey", 83, 88, 47.5, 52.5
	demo Text: 85.5, "centre", 50, "half", "+"
	demo Paint rectangle: "grey", 66, 71, 47.5, 52.5
	demo Text: 68.5, "centre", 50, "half", "- -"
	demo Paint rectangle: "grey", 89, 94, 47.5, 52.5
	demo Text: 91.5, "centre", 50, "half", "+ +"

	demo Text: 80, "centre", 40, "half", "F1 lower limit"
	demo Text: 80, "centre", 35, "half", string$(yLower)
	demo Paint rectangle: "grey", 72, 77, 32.5, 37.5
	demo Text: 74.5, "centre", 35, "half", "-"
	demo Paint rectangle: "grey", 83, 88, 32.5, 37.5
	demo Text: 85.5, "centre", 35, "half", "+"
	demo Paint rectangle: "grey", 66, 71, 32.5, 37.5
	demo Text: 68.5, "centre", 35, "half", "- -"
	demo Paint rectangle: "grey", 89, 94, 32.5, 37.5
	demo Text: 91.5, "centre", 35, "half", "+ +"

	demo Text: 80, "centre", 25, "half", "F1 upper limit"
	demo Text: 80, "centre", 20, "half", string$(yUpper)
	demo Paint rectangle: "grey", 72, 77, 17.5, 22.5
	demo Text: 74.5, "centre", 20, "half", "-"
	demo Paint rectangle: "grey", 83, 88, 17.5, 22.5
	demo Text: 85.5, "centre", 20, "half", "+"
	demo Paint rectangle: "grey", 66, 71, 17.5, 22.5
	demo Text: 68.5, "centre", 20, "half", "- -"
	demo Paint rectangle: "grey", 89, 94, 17.5, 22.5
	demo Text: 91.5, "centre", 20, "half", "+ +"

	demo Paint rectangle: "grey",10, 25, 10, 20
	demo Text: 17.5, "centre", 15, "half", "All/Mean"

	demo Paint rectangle: "grey",35, 50, 10, 20
	demo Text: 42.5, "centre", 15, "half", "Export to PNG"

	demo Paint rectangle: "grey",72.5, 87.5, 0, 10
	demo Text: 80, "centre", 5, "half", "RESET"

	demoWaitForInput()
	if demoClickedIn(35, 50, 10, 20)
		@toPNG
		goto DASHBOARD
	elsif demoClickedIn(10, 25, 10, 20)
		drawAll = drawAll + 1
		goto DASHBOARD
	elsif demoClickedIn(72, 77, 82.5, 87.5)
		fontSize = fontSize - 1
		goto DASHBOARD
	elsif demoClickedIn(83, 88, 82.5, 87.5)
		fontSize = fontSize + 1
		goto DASHBOARD
	elsif demoClickedIn (72, 77, 62.5, 67.5)
		xLower = xLower - 1
		goto DASHBOARD
	elsif demoClickedIn(83, 88, 62.5, 67.5)
		xLower = xLower + 1
		goto DASHBOARD
	elsif demoClickedIn(66, 71, 62.5, 67.5)
		xLower = xLower - 10
		goto DASHBOARD
	elsif demoClickedIn(89, 94, 62.5, 67.5)
		xLower = xLower + 10
		goto DASHBOARD
	elsif demoClickedIn(72, 77, 47.5, 52.5)
		xUpper = xUpper - 1
		goto DASHBOARD
	elsif demoClickedIn(83, 88, 47.5, 52.5)
		xUpper = xUpper + 1
		goto DASHBOARD
	elsif demoClickedIn(66, 71, 47.5, 52.5)
		xUpper = xUpper - 10
		goto DASHBOARD
	elsif demoClickedIn(89, 94, 47.5, 52.5)
		xUpper = xUpper + 10
		goto DASHBOARD
	elsif demoClickedIn(72, 77, 32.5, 37.5)
		yLower = yLower - 1
		goto DASHBOARD
	elsif demoClickedIn(83, 88, 32.5, 37.5)
		yLower = yLower + 1
		goto DASHBOARD
	elsif demoClickedIn(66, 71, 32.5, 37.5)
		yLower = yLower - 10
		goto DASHBOARD
	elsif demoClickedIn(89, 94, 32.5, 37.5)
		yLower = yLower + 10
		goto DASHBOARD
	elsif demoClickedIn(72, 77, 17.5, 22.5)
		yUpper = yUpper - 1
		goto DASHBOARD
	elsif demoClickedIn(83, 88, 17.5, 22.5)
		yUpper = yUpper + 1
		goto DASHBOARD
	elsif demoClickedIn(66, 71, 17.5, 22.5)
		yUpper = yUpper - 10
		goto DASHBOARD
	elsif demoClickedIn(89, 94, 17.5, 22.5)
		yUpper = yUpper + 10
		goto DASHBOARD
	elsif demoClickedIn(72.5, 87.5, 0, 10)
		selectObject: "Table formantTable2D"
		minF1 = Get minimum: "F1"
		maxF1 = Get maximum: "F1"
		minF2 = Get minimum: "F2"
		maxF2 = Get maximum: "F2"

		xLower = floor(minF2)-30
		xUpper = ceiling(maxF2)+30
		yLower = floor(minF1)-30
		yUpper = ceiling(maxF1)+30
		goto DASHBOARD
	elsif demoKeyPressed()
		if demoKey$() = "→"
			xLower = xLower - 10
			goto DASHBOARD
		elsif demoKey$() = "←"
			xUpper = xUpper + 10
			goto DASHBOARD
		elsif demoKey$() = "↑"
			yLower = yLower - 10
			goto DASHBOARD
		elsif demoKey$() = "↓"
			yUpper = yUpper + 10
			goto DASHBOARD
		endif
	else
		demo Erase all
		goto DASHBOARD
	endif



procedure drawBasic
demo Erase all
demo Colour: 0
demo Font size: fontSize
demo Select inner viewport: 10, 50, 50, 90
selectObject: "Table formantTable2D"
demo Scatter plot: "F2", xUpper, xLower, "F1", yUpper, yLower, "Vowel", fontSize, "no"
demo Draw inner box
demo Text left: "yes", "F1 (Hz)"
demo Text bottom: "yes", "F2 (Hz)"
demo One mark bottom: xUpper, "yes", "yes", "no", string$(xUpper)
demo One mark bottom: xLower, "yes", "yes", "no", string$(xLower)
demo One mark left: yUpper, "yes", "yes", "no", string$(yUpper)
demo One mark left: yLower, "yes", "yes", "no", string$(yLower)
endproc

procedure drawMean
demo Erase all
demo Colour: 0
demo Font size: fontSize
demo Select inner viewport: 10, 50, 50, 90
selectObject: "TableOfReal formantMean"
demo Draw scatter plot: 3, 2, 0, 0, xUpper, xLower, yUpper, yLower, fontSize, "yes", "", "no"
demo Draw inner box
demo Text left: "yes", "F1 (Hz)"
demo Text bottom: "yes", "F2 (Hz)"
demo One mark bottom: xUpper, "yes", "yes", "no", string$(xUpper)
demo One mark bottom: xLower, "yes", "yes", "no", string$(xLower)
demo One mark left: yUpper, "yes", "yes", "no", string$(yUpper)
demo One mark left: yLower, "yes", "yes", "no", string$(yLower)
endproc

procedure toPNG
Select inner viewport: 0, 6, 0, 4
if drawAll mod 2 = 0
	Scatter plot: "F2", xUpper, xLower, "F1", yUpper, yLower, "Vowel", fontSize, "no"
	Draw inner box
	Text left: "yes", "F1 (Hz)"
	Text bottom: "yes", "F2 (Hz)"
	One mark bottom: xUpper, "yes", "yes", "no", string$(xUpper)
	One mark bottom: xLower, "yes", "yes", "no", string$(xLower)
	One mark left: yUpper, "yes", "yes", "no", string$(yUpper)
	One mark left: yLower, "yes", "yes", "no", string$(yLower)
	Save as 600-dpi PNG file: outDir$ + "/myVowelPlot" + string$(pictNb) + ".png"
else
	Draw scatter plot: 3, 2, 0, 0, xUpper, xLower, yUpper, yLower, fontSize, "yes", "", "no"
	Draw inner box
	Text left: "yes", "F1 (Hz)"
	Text bottom: "yes", "F2 (Hz)"
	One mark bottom: xUpper, "yes", "yes", "no", string$(xUpper)
	One mark bottom: xLower, "yes", "yes", "no", string$(xLower)
	One mark left: yUpper, "yes", "yes", "no", string$(yUpper)
	One mark left: yLower, "yes", "yes", "no", string$(yLower)
	Save as 600-dpi PNG file: outDir$ + "/myVowelPlot" + string$(pictNb) + ".png"
endif
pictNb = pictNb + 1
Erase all
demoShow()
selectObject: "Table formantTable2D"
Formula: "Vowel", "backslashTrigraphsToUnicode$(self$)"
Save as tab-separated file: outDir$ + "/myTable.txt"
demo Erase all
endproc		