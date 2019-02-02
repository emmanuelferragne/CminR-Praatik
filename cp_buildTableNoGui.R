myList = read.table('C:/Users/eferragne/Documents/travailEnCours/scriptFormants/demoFormants/formantList.txt',header=F,comment.char = "")
fileName = basename(as.character(myList[1,]))
fileNameNoExt = strsplit(fileName,".", fixed = T)[[1]][1]

splitChar = "_"
allFields = strsplit(fileNameNoExt, splitChar)
nbFields = length(allFields[[1]])

myTable = character(length=nbFields+1)
for (i in 1:(nbFields-1)){
  myTable[i] = paste('var', as.character(i), sep = "")
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

#myCheck = "No" #dans ce cas, pas de lissage
myCheck = "Yes" #lissage

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


