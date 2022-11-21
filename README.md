# CminR-Praatik
I wrote these Praat and R scripts for a doctoral seminar I teach at Université Paris Cité. My aim was to establish a consistent workflow to manually measure **vowel formants**.
## Getting started
The easiest way to start with the programs is to use the demo files in the folder `formantDemo` :

Make sure [Praat](http://www.fon.hum.uva.nl/praat/) is installed on your computer

Download `cp_formants.praat`and the `formantDemo` folder

Edit `list.txt` and adapt the paths to your own directories

Run `cp_formants.praat` :
* when prompted to load a file list, choose `file.txt`
* when prompted to load the dictionary file, choose `dico.txt`
* the annotion is on tier number 1 for this example
* you should be able to see a GUI looking like this:

<p align="center">
<img src="https://github.com/emmanuelferragne/CminR-Praatik/blob/master/cpFormants.png" width="400"/>
</p>

If you are a Praat user, the parameters in the GUI are self-explanatory. If the estimated formant tracks in red match the formants on the spectrogram, click Next. Otherwise, you can adjust the estimate by e.g. increasing or decreasing the maximum frequency (you can use the arrow keys on your keyboard to do this). 

## Output and analysis

For better results, your initial sound and TextGrid files should have consistent names with fields separated by underscores as in e.g. `EN_spk01_reading.wav`, `FR_spk01_reading.wav`, etc.

`cp_formants.praat` creates a folder called `output` that contains the estimated formant tracks. 

When you run the `R` script `cp_BuildTable.R` you'll be prompted to load the list of formant files, then it'll split file names according to the underscores and ask you to provide generic names for the fields delimited by underscores. Say yes to the following 2 dialog boxes, and two new variables will be created in your `R` worskpace : `dataList`(a list object) and `phonData`, a dataframe containing formant values taken at temporal midpoint.

In order to make sure that everything went fine, type: `head(phonData)`
and you should see the first lines of your dataframe. The R package [phonR](https://github.com/drammock/phonR) is a good option to analyze this dataframe.

The data in the `dataList` variable can be accessed as follows:

`dataList[[1]]$data$F1Hz`
contains the F1 values for the 1st vowel in the dataset

`dataList[[1]]$metadata$symbolASCII`
contains the symbol of the 1st vowel in the dataset
