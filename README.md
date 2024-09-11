# Kymo_Analyser_MultiChannel
Kymo_Analyser_MultiChannel is a simple GUI dedicated to quantify velocities of directionally moving structures in image time series. (Matlab)

Kymo_Analyser_MultiChannel is adapted from 'KymoAnalyser_GUI' version '20201127 CB ProCeD/Micalis/INRAE' (see below) to take into account acquisition with 2 channels.
The goal is to compare kymographs generated using two fluorescent markers (in Channel #1 and #2), quantify speed on each kymographs.

KymoAnalyser_GUI is a simple GUI dedicated to quantify velocities of directionally moving structures in image time series. The analysis workflow is divided into three steps:
1 - It generates kymograms distributed at regular intervals (~1 pixel) perpendicular to a manually defined axis.
2 - The kymograms obtained are aligned side-by-side to generate a single 2D image (the vertical axis corresponds to time and the horizontal axis represents spatial displacement). Since directionally moving structures appear as a tilted line in a kymogram, velocity is quantified by measuring the slope in kymogram.
3 - Extracting velocities are then combined together in an excel file allowing various statistical analysis (not performed here).
