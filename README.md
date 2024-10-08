# Kymo_Analyser_MultiChannel
The KymoAnalyser_MultiChannel_GUI is designed to quantify the velocity of mobile particles through kymograph analysis. Initially, a kymogram is constructed for each pixel row spanning the cell midline. These kymograms are then aligned in a side-by-side configuration to generate a single two-dimensional image, wherein each column encompasses a kymograph of the successive pixel rows within the cell. 

The current version has been adapted from the '20201127 CB ProCeD/Micalis/INRAE' version with the objective of facilitating a comparison of kymograms generated using two fluorescent markers (in Channels #1 and #2) and quantifying the speeds observed in each kymogram. 

Upon launching the program, a window with three buttons will appear, allowing the user to navigate through the various stages of the analytical process. These include: 
1. identifying the median axes of the cells; 
2. generating kymograpms distributed at regular intervals (~1 pixel) perpendicular to the axis defined during step #1 and quantifying the speed of moving particles (in a kymogram, directionally moving structures appear as a tilted line, velocity is quantified by measuring the slope in kymogram); 
3. compiling the results from different replicates by extracting velocity and saved them in an Excel file
