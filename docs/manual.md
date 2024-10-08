# Manual for Kymo_Analyser_MultiChannel 

To use KymoAnalyser_MultiChannel_GUI with its graphical user interface, it is simply necessary to run the following command in Matlab's command window: 
> KymoAnalyser_MultiChannel_GUI

The application opens a simple dialog box with three buttons, allowing the user to process the successive steps of the analysis.
![image](https://github.com/user-attachments/assets/108da975-1d85-42f4-bc96-afdd7d599a12)

# Step #1: draw medial axis of cells
The first step of the analysis is initiated by clicking the top button, labelled '1-Draw line for kymo'. This action opens a dialog box, through which the analysis parameters can be defined:

![image](https://github.com/user-attachments/assets/bfbbe9ae-0c2b-4511-ac63-19327c6a09d9)

Those parameters are used to define:
* The width of the kymogram
* The frame interval in the time-lapse movie
* The projection mode of the time-lapse movie to draw the medial axis (1: max projection; 2: sum projection; 3: average projection)
* Enable (1) or disable (0) the pause before drawing the line to set the zoom on the image
* Enable (1) or disable (0) the display of the time-lapse sequence (only for multi-channel acquisition)

A dialog box enables the user to select the time-lapse movies for analysis:
![image](https://github.com/user-attachments/assets/365533a5-9760-4839-abe4-8e071d243afc)

The time-lapse movie is imported and the projected image is then displayed, 
![image](https://github.com/user-attachments/assets/24bb50b4-5666-48a2-a79b-0ba78185c447)
enabling the user to draw the medial axis on each cell (To begin creating a line, simply click the left mouse button. To complete the line, click the right mouse button.):
![image](https://github.com/user-attachments/assets/d994b357-5fe3-4efb-9d12-50ea7303d099)
(the medial axis are plotted in black, and the red lines correspond to perpendical line to get intensity profile that will be used to generate kymograms). To halt the drawing process, simply right-click with your mouse.
All results will be automatically saved in a newly created folder named '_results_Kymo', including a subfolder with the same name as the time-lapse movie filename.


# Step #2: generate kymograms and quantify velocity

To begin the second phase of the process, click the button at the middle labelled '2-Analyze kymo'. This will prompt the opening of a file selection window, through which you can choose the original time-lapse movie to analyse:
![image](https://github.com/user-attachments/assets/8680818a-a7af-492c-a2cc-2c7a8022c575)

Then, simply draw a line on the tilted lines that appear on the images displaying the adjacent kymogramms side-by-side. Use the left and right mouse buttons to initiate and end the line, respectively. To move to the next cell, simply right-click with your mouse. Note that no additional lines should be drawn on the adjacent tilted lines, as they correspond to the same particle. 
![image](https://github.com/user-attachments/assets/13136e96-7b26-4af1-864a-3d0a49300f8b)
![image](https://github.com/user-attachments/assets/4ef7de79-a8cd-40b3-9c02-83b12d8cc39d)

# Step #3: compiling the results 

To conclude the analysis and compile the results from the various replicates, click the '3-Data compilation' button located at the bottom. This will prompt the opening of a specific dialogue box, which will allow multiple folders to be selected. The resulting data will then be extracted and saved in an Excel file.
![image](https://github.com/user-attachments/assets/c4f33f9e-9642-4587-a544-f231ce619510)







