##########################
start of file


Folder 'assg2' contains all data set provided by assignment.

Folder 'GCMex' contains the graphcuts matlab wrapper tool.

Matlab codes for each part are located in their respective sub-folders.


For Part 1 to Part 3, enter the corresponding sub-folder and run the .m file named by the part number. (e.g. for Part 1, run Part_1.m).


For Part 4, enter Part 4 sub-folder:

- run Part_4_initialzation.m first to generate the initialization depth maps and the Dinit.mat that contains the initialization depth maps data. This script will automatically save Dinit.mat under Part 4 sub folder, or overwrite the existing one if there is any.

- next, run Part_4_bundle_optimization.m to generate the bundle optimization result. This script will load the Dinit.mat saved in previous step.

- if you want to change to parameters, make sure the "frame_num" and "start_frame" parameters in both above scripts are consistent.


end of file
###########################