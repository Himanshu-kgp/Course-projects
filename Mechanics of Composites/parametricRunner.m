clear; clc; close all

Num_files = 1;
for i=1:Num_files
    inputFilename = strcat("./inputFiles/input_", num2str(i), ".txt");
    outputFilename = strcat("./outputFiles/output_", num2str(i), ".mat");
    main(inputFilename, outputFilename);
end