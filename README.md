# Kymo_Analyser_MultiChannel
The KymoAnalyser_MultiChannel_GUI is designed to quantify the velocity of mobile particles through kymograph analysis. Initially, a kymogram is constructed for each pixel row spanning the cell midline. These kymograms are then aligned in a side-by-side configuration to generate a single two-dimensional image, wherein each column encompasses a kymograph of the successive pixel rows within the cell. 

The current version has been adapted from the '20201127 CB ProCeD/Micalis/INRAE' version with the objective of facilitating a comparison of kymograms generated using two fluorescent markers (in Channels #1 and #2) and quantifying the speeds observed in each kymogram. 

Upon launching the program, a window with three buttons will appear, allowing the user to navigate through the various stages of the analytical process. These include: 
1. identifying the median axes of the cells; 
2. generating kymograpms distributed at regular intervals (~1 pixel) perpendicular to the axis defined during step #1 and quantifying the speed of moving particles (in a kymogram, directionally moving structures appear as a tilted line, velocity is quantified by measuring the slope in kymogram); 
3. compiling the results from different replicates by extracting velocity and saved them in an Excel file
![image](https://github.com/user-attachments/assets/d1af75a0-1b6d-4e2a-bcfd-e6714f685744)

# Installation

Kymo_Analyser_MultiChannel was most recently tested on Matlab R2023b, although it is anticipated to function effectively with a multitude of other Matlab versions. To utilise the Kymo_Analyser_MultiChannel, it is necessary to add it to the MATLAB path. This may be done by entering the command:

> addpath(genpath('path_to_Kymo_Analyser_MultiChannel'));

where path_to_Kymo_Analyser_MultiChannel is the path to the folder containing all the relevant scripts.

# Usage

To use KymoAnalyser_MultiChannel_GUI with its graphical user interface, it is simply necessary to run the following command in Matlab's command window:
> KymoAnalyser_MultiChannel_GUI

A user manual can be found in [docs/manual.md](docs/manual.md)        
