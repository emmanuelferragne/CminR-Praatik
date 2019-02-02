# CminR-Praatik
I wrote these Praat and R scripts for a doctoral seminar I teach at Université Paris Diderot. My aim was to establish a consistent workflow to manually measure **vowel formants**.
## Getting started
The easiest way to start with the programs is to use the demo files in the folder `formantDemo` :

Make sure [Praat](http://www.fon.hum.uva.nl/praat/) is installed on your computer

Download `cp_formants.praat`and the `formantDemo` folder

Edit `file.txt` and adapt the paths to your own directories

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

`cp_formants.praat` creates a folder called `output` that contains the estimated formant tracks. 

The `R`script, `cp_BuildTable.R` expects a list of the files in the `output` folder. When you run  `cp_BuildTable.R` you'll be prompted to load the list of formant files. Then dialog boxes will ask you to ''Name variables''. 
