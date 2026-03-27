###########################
### Open-field analysis ###
### written by Koji     ###
###########################

# Packages
#install.packages("tidyverse") # This should be installed once
#install.packages("gridExtra") # This should be installed once
#install.packages("filesstrings")# This should be installed once
#install.packages("heatmap3")
#install.packages("squash")
#install.packages("ggsci")
library(tidyverse)# "install.packages("gridExtra")" is necessary
library(ggplot2)
library(gridExtra)             # "install.packages("gridExtra")" is necessary
#library(heatmap3)
#library(squash)
#library(ggsci)
#library(ggnewscale)

# Clear all
rm(list=ls())                  # Delete all objects
if (is.null(dev.list()) != 1){ # If you have figure(s)...
  dev.off()                    # Delete all figures
}

# Set working directory
#setwd("/Users/Koji/Downloads/OpenField2")                      # Koji
path <- setwd("D:/R/OpenField")                     # Windows
path <- getwd()                                                 # Both

# Save directory
#saveDirName <- c("/Users/Koji/Downloads/OpenField2/Analyzed/") # Koji
saveDirName <- c("D:/R/OpenField/Analyzed/")     # Windows

# Parameters
totalTime     = 120     # in minutes
fps           = 30     # frame per second
analyzeTime   = 5      # in minutes
min2sec       = 60     # 1 min = 60 sec
totalHalfs    = 3  # analyze data by 1st, 2nd, and last half
heat.block = 2  # define heatmap block, def = 60  (nead not change)

# Utility parameters
totalFrames   = totalTime * fps * min2sec    # Total frames
binFrames     = analyzeTime * fps * min2sec  # Frames per bin
totalBins     = totalTime/analyzeTime        # Total number of bins
halfTime      = totalTime / totalHalfs
halfFrames    = halfTime * fps * min2sec


# Get .csv file name
ofFiles <- list.files(path, pattern = "\\.csv$") # Get .csv file name

# Analyze the data
for (i in 1:length(ofFiles)) {
  
  # Make file name
  fileName       <- (ofFiles[i])
  print(fileName)
  newFileNamePre <- sub(".csv","",fileName)                     # Delete ".csv" from fileName
  fileNameCSV    <- paste0(saveDirName, newFileNamePre, ".csv") # Make new file name
  fileNamePNG    <- paste0(saveDirName, newFileNamePre, ".png") # Make new file name
  fileNamepdf    <- paste0(saveDirName, newFileNamePre, ".pdf")
  
  # Get .csv data
  data <- read.csv(ofFiles[i])
  print(paste0(i,"/",length(ofFiles)))
  
  # Make data.frame
  X <- data[,1]              # X-coordinate
  Y <- data[,2]              # Y-coordinate
  ofData <- data.frame(X, Y) # data.frame
  ofData <- ofData[1:totalFrames,]
  # Make box frame
  lim_left      <- min(X[1:totalFrames],na.rm = TRUE)     # in pixels
  lim_right     <- max(X[1:totalFrames],na.rm = TRUE)     # in pixels
  lim_bottom    <- min(Y[1:totalFrames],na.rm = TRUE)     # in pixels 
  lim_top       <- max(Y[1:totalFrames],na.rm = TRUE)     # in pixelx
  boxlength_pix = round((lim_top-lim_bottom)/2)+round((lim_right-lim_left)/2)
  boxLength_cm  = 50          # in cm
  pixel2cm      = boxLength_cm/boxlength_pix

  
  # Define center erea
  center_left   = lim_left + (lim_right - lim_left)/4
  center_right  = lim_left + (lim_right - lim_left)*3/4
  center_bottom = lim_bottom + (lim_top - lim_bottom)/4
  center_top    = lim_bottom + (lim_top - lim_bottom)*3/4

  # Calculate activities
  activity        <- sqrt(diff(ofData$X)^2 + diff(ofData$Y)^2) # Calculate activities in each frame

  activityMeanAll <- mean(activity, na.rm = TRUE)              # Mean activity
  
  # Analyze time spent in center
  centerT <- sum((ofData[1:totalFrames, 1] > center_left) * 
                   (ofData[1:totalFrames, 1] < center_right) * 
                   (ofData[1:totalFrames, 2] > center_bottom) * 
                   (ofData[1:totalFrames, 2] < center_top), 
                 na.rm = TRUE)
  
  # Analyze the activities over time
  activityMeanEach   <- numeric() # Initial setting for mean
  activitySemEach    <- numeric() # Initial setting for SEM
  activityCenterEach <- numeric() # Initial setting for time spent in center
  for (binN in 1:totalBins) {
    activityMeanBin    <- mean(activity[(1 + binFrames*(binN - 1)):(binFrames * binN)], na.rm = TRUE)               # Note that the data is total activities NOT mean
    activitySemBin     <- sd(activity[(1 + binFrames*(binN - 1)):(binFrames * binN)], na.rm = TRUE)/sqrt(binFrames) # Data included in each bin
    activityCenterBin  <- sum((ofData[(1 + binFrames*(binN - 1)):(binFrames * binN), 1] > center_left) * 
                                (ofData[(1 + binFrames*(binN - 1)):(binFrames * binN), 1] < center_right) * 
                                (ofData[(1 + binFrames*(binN - 1)):(binFrames * binN), 2] > center_bottom) * 
                                (ofData[(1 + binFrames*(binN - 1)):(binFrames * binN), 2] < center_top), 
                              na.rm = TRUE)
    activityMeanEach   <- append(activityMeanEach, activityMeanBin)     # Combine
    activitySemEach    <- append(activitySemEach, activitySemBin)       # Combine
    activityCenterEach <- append(activityCenterEach, activityCenterBin) # Combine
  }
  
  # Analyze the activity over half
  activityMeanHalfEach   <- numeric() # Initial setting for mean
  activityCenterHalfEach <- numeric() # Initial setting for time spent in center
  
  for (halfN in 1:totalHalfs) {
    activityMeanHalf   <- mean(activity[(1 + halfFrames * (halfN - 1)):(halfFrames * halfN)], na.rm = TRUE)    
    activityCenterHalf <- sum((ofData[(1 + halfFrames*(halfN - 1)):(halfFrames * halfN), 1] > center_left) * 
                                (ofData[(1 + halfFrames*(halfN - 1)):(halfFrames * halfN), 1] < center_right) * 
                                (ofData[(1 + halfFrames*(halfN - 1)):(halfFrames * halfN), 2] > center_bottom) * 
                                (ofData[(1 + halfFrames*(halfN - 1)):(halfFrames * halfN), 2] < center_top), 
                              na.rm = TRUE)
    activityMeanHalfEach   <- append(activityMeanHalfEach, activityMeanHalf)
    activityCenterHalfEach <- append(activityCenterHalfEach, activityCenterHalf)
    
  }
  
  # Transform pixels to cm & Transform frames to seconds
  activityMeanEachcm    = activityMeanEach*pixel2cm*fps 
  activityMeanAllcm     = activityMeanAll*pixel2cm*fps 
  centerTsec　 　　　   = centerT/fps
  activityCenterEachsec = activityCenterEach/fps
  activityMeanHalfEachcm    = activityMeanHalfEach*pixel2cm*fps
  activityCenterHalfEachsec = activityCenterHalfEach/fps
  
  
  # Output the results
  singleData     <- cbind(activityMeanAllcm,centerTsec)
  timecourseData <- data.frame(activityMeanEachcm,activityCenterEachsec)
  HalfData     <- data.frame(activityMeanHalfEachcm,activityCenterHalfEachsec)
  #openFieldData <- cbind( t(activityMeanEachcm), activityMeanAllcm, centerTsec, t(activityCenterEachsec),t(activityMeanHalfEachcm)) # Combine all open-field data
  openFieldData  <- cbind(singleData, timecourseData, HalfData)
  write.csv(openFieldData, fileNameCSV)   
  
  # Figure 1: Plot the spontaneous activities
  figActivity <- data.frame(time = 1:totalBins, Locomotions= activityMeanEachcm)
  errors <- aes(ymax = activityMeanEachcm + activitySemEach, 
                ymin = activityMeanEachcm - activitySemEach)
  fig1 <- ggplot(figActivity, aes(x = time, y = Locomotions)) +
    geom_line(color = "black", size = 1) + theme_classic(12) + 
    geom_errorbar(errors, color = "black", width = 0.5) + 
    geom_point(color = "black", size = 4) +
    theme(axis.text.x = element_text(color = "black"),
          axis.text.y = element_text(color = "black"),
          text = element_text("Arial")) +
    scale_x_continuous(limits = c(0, totalTime/analyzeTime + 1), 
                       breaks = seq(0, totalTime/analyzeTime + 1, by = 1),
                       labels = seq(0, totalTime + analyzeTime, by = analyzeTime)) +
    xlab("Time (min)") + ylab("Locomotions (cm/second)")
  
  # Figure 2: Plot the heatmap-like data
  figOpenField <- data.frame(x = ofData[,1], y = ofData[,2])
  fig2 <- ggplot(figOpenField, aes(x, y)) + 
    theme_classic(12) +
    theme(rect = element_rect(color = "black", fill = "black"),
          plot.background = element_rect(color = "black", fill = "black"),
          panel.background = element_rect(color = "black", fill = "black"),
          panel.border = element_rect(fill = NA, colour = "white", size = 1),
          axis.text.x = element_text(color = "white"),
          axis.text.y = element_text(color = "white"),
          axis.title.x = element_text(color = "white"),
          axis.title.y = element_text(color = "white"),
          text = element_text("Arial")) +
    geom_point(color = "white", size = 1, alpha = .02) +
    geom_vline(xintercept = lim_left, linetype = "dashed", color = "white") +
    geom_vline(xintercept = lim_left + (lim_right - lim_left)/4, linetype = "dashed", color = "white") +
    geom_vline(xintercept = lim_left + (lim_right - lim_left)/2, linetype = "dashed", color = "white") +
    geom_vline(xintercept = lim_left + (lim_right - lim_left)*3/4, linetype = "dashed", color = "white") +
    geom_vline(xintercept = lim_right, linetype = "dashed", color = "white") +
    geom_hline(yintercept = lim_top, linetype = "dashed", color = "white")+
    geom_hline(yintercept = lim_bottom + (lim_top - lim_bottom)/4, linetype = "dashed", color = "white") +
    geom_hline(yintercept = lim_bottom + (lim_top - lim_bottom)/2, linetype = "dashed", color = "white") +
    geom_hline(yintercept = lim_bottom + (lim_top - lim_bottom)*3/4, linetype = "dashed", color = "white") +
    geom_hline(yintercept = lim_bottom, linetype = "dashed", color = "white")+
    xlab("X-axis (pixels)") + ylab("Y-axis (pixels)")
  #pal <- c("gray2", "gray5", "gray10", "gray20", "gray40",
  #"gray60", "gray90", "gray95", "gray98", "white")
  #fig2 + scale_color_gradientn(colors = pal)
  #fig2 <- fig2 + stat_bin2d(bins = 40) +
  #scale_fill_gradient(low = "black", high = "white")
  
  # Figure 3: Plot the figure of time spent in Center
  figCent <- data.frame(time = 1:totalBins, timeCenter = activityCenterEachsec)
  fig3 <- ggplot(figCent, aes(x = time, y = timeCenter)) +
    geom_line(color = "black", size = 1) + theme_classic(12) + 
    geom_point(color = "black", size = 4) +
    theme(axis.text.x = element_text(color = "black"),
          axis.text.y = element_text(color = "black"),
          text = element_text("Arial")) +
    scale_x_continuous(limits = c(0, totalTime/analyzeTime + 1), 
                       breaks = seq(0, totalTime/analyzeTime + 1, by = 1),
                       labels = seq(0, totalTime + analyzeTime, by = analyzeTime)) +
    xlab("Time (min)") + ylab("Time spent in center (second)")
  
  # Figure 4: Plot the summary figure
  
  
 
  #make heatmap data
 
  
  #MapData  <- makecmap(figOpenField[,1],colFn = coolheat)
  #ColorMap <- cmap(figOpenField[,1], map = MapData)

  #fig5 <- ggplot(figOpenField,aes(x = x,y = y))+
   # geom_density_2d_filled(linemitre=1) +
    #theme_classic()+
    #scale_fill_viridis_d(option = 'inferno')+theme(panel.background = element_rect("white"))
  
  
  fig5 <-  ggplot(figOpenField,aes(x = x,y = y))+
    stat_density_2d(geom = "raster",aes(fill = after_stat(ndensity)),contour = FALSE,show.legend = F ) +
    scale_fill_viridis_c(option ="inferno") +
    theme(panel.background = element_rect("white"))+
    theme_classic()
  
  
  #fig6 <- ggplot(figOpenField,aes(x = x,y = y,z = after_stat(density)))+
   # geom_contour_filled() +
    #theme_classic()+
    #scale_fill_viridis_d(option = 'inferno')+theme(legend.position="none")+theme(panel.background = element_rect("white"))

 # fig6 <-ggplot(figOpenField,aes(x = x,y = y))+
  #  geom_density_2d_filled() +
   # stat_density_2d(
    #  geom = "raster",
     # aes(fill = after_stat(density)),
    #  contour = FALSE
    #) 
    
    
    

  fig4 <- gridExtra::grid.arrange(fig1, fig3, fig2, fig5 ,ncol = 2) # Arrange all the figures
  

  # Save the summary figure
  ggsave(fileNamePNG, plot = fig4, dpi = 100, width = 20, height = 20) # Save the figure
  ggsave(fileNamepdf, plot = fig5,dpi = 100, width = 10, height = 10 )
  
}

# Move analyzed row data
 #filesstrings::file.move(files = ofFiles,
  #                      destinations = "C:/R/Dyadic_confirm-pixel/analyzed_rowdata",
   #                     overwrite = TRUE)

# !remove the file to run again!
