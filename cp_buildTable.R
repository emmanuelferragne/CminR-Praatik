require(tcltk2)
myFile = choose.files(caption = "choose list of formant files")
myList = read.table(myFile,header=F,comment.char = "")
fileName = basename(as.character(myList[1,]))
fileNameNoExt = strsplit(fileName,".", fixed = T)[[1]][1]


splitChar = "_"
allFields = strsplit(fileNameNoExt, splitChar)
nbFields = length(allFields[[1]])

myTable = character(length=nbFields+1)
for (i in 1:(nbFields-1)){
win1  <- tktoplevel()
tktitle(win1) = "Name variables"

myLabel = tclVar("")
win1$env$entName <-tk2entry(win1, width = "50", textvariable = myLabel)
tkgrid(tk2label(win1, text = allFields[[1]][i], justify = "center"),
       padx = 10, pady = c(15, 5), sticky = "w")
tkgrid(win1$env$entName, padx = 10, pady = c(0, 15))
butOK <- tkbutton(win1, text = "OK", command = function() tkdestroy(win1))
tkgrid(butOK)
tkwait.window(win1)

myTable[i] = tclvalue(myLabel)
}
myTable[i+1] = "symbolASCII"
myTable[i+2] = "symbolUTF8"

dataList = vector("list", dim(myList)[1])
for (iFile in 1:dim(myList)[1]){
  fileName = basename(as.character(myList[iFile,]))
  fileNameNoExt = strsplit(fileName,".", fixed = T)[[1]][1]
  allFields = strsplit(fileNameNoExt, splitChar)
  currentData = read.table(as.character(myList[iFile,]),header = T, encoding = "UTF-8")
  vowelIPA = as.character(currentData[1,dim(currentData)[2]])
  currentMeta = as.data.frame(cbind(t(unlist(allFields)),vowelIPA))
  colnames(currentMeta) = c(myTable)
  currentData = subset(currentData, select = -symbol)
  names(currentData) = gsub("\\.", "", names(currentData))
  dataList[[iFile]]$data = currentData
  dataList[[iFile]]$metadata = currentMeta
  
}
win1 = tktoplevel()
tktitle(win1) = "Files processed"
win1$env$butOK <- tk2button(win1, text = "OK", width = -6,command = function() tkdestroy(win1))
tkgrid(tk2label(win1, text = "All files have been processed. Proceed to PhonR dataframe ?", justify = "center"))
tkgrid(win1$env$butOK, padx = 20, pady = 15)
tkwait.window(win1)

win1 = tktoplevel()
win1$env$rb1 = tk2radiobutton(win1)
win1$env$rb2 = tk2radiobutton(win1)
rbValue = tclVar("Yes")
tkconfigure(win1$env$rb1, variable = rbValue, value = "Yes")
tkconfigure(win1$env$rb2, variable = rbValue, value = "No")
tkgrid(tk2label(win1, text = "Would you like to smooth formant tracks first?"),
       columnspan = 2, padx = 10, pady = c(15, 5))
tkgrid(tk2label(win1, text = "Yes"), win1$env$rb1,
       padx = 10, pady = c(0, 5))
tkgrid(tk2label(win1, text = "No"), win1$env$rb2,
       padx = 10, pady = c(0, 15))
win1$env$butOK = tk2button(win1, text = "OK", width = -6,command = function() tkdestroy(win1))
tkgrid(win1$env$butOK, padx = 20, pady = 15)
tkwait.window(win1)
myCheck = tclvalue(rbValue)

phonData = data.frame(matrix(nrow = dim(myList)[1], ncol = 3 + length(myTable)))
colnames(phonData) = c(myTable, "F1", "F2", "F3")

if (myCheck == "No"){

  for (iList in 1:dim(myList)[1]){
    indCenter = round(length(dataList[[iList]]$data$times)/2)
    phonData[iList,dim(phonData)[2]-2] = dataList[[iList]]$data$F1Hz[indCenter]
    phonData[iList,dim(phonData)[2]-1] = dataList[[iList]]$data$F2Hz[indCenter]
    phonData[iList,dim(phonData)[2]] = dataList[[iList]]$data$F3Hz[indCenter]
    phonData[iList,1:(dim(phonData)[2]-3)] = as.character(unlist(dataList[[iList]]$metadata))
  }

}else{
  for (iList in 1:dim(myList)[1]){
    indCenter = round(length(dataList[[iList]]$data$times)/2)
    smoothF1 = runmed(dataList[[iList]]$data$F1Hz,3)
    phonData[iList,dim(phonData)[2]-2] = smoothF1[indCenter]
    smoothF2 = runmed(dataList[[iList]]$data$F2Hz,3)
    phonData[iList,dim(phonData)[2]-1] = smoothF2[indCenter]
    smoothF3 = runmed(dataList[[iList]]$data$F3Hz,3)
    phonData[iList,dim(phonData)[2]] = smoothF3[indCenter]
    phonData[iList,1:(dim(phonData)[2]-3)] = as.character(unlist(dataList[[iList]]$metadata))
  }
}


