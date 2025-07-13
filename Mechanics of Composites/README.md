### Function to run all the input files

```
ParametricRunner.m
```

### Function that is called for running an individual input file

```
main.m
```

## Structure of the "main" file

- ``` readInputFile.m``` : reads an input flie
- ```FE.m```: MATLAB script for the FEA model created in COMSOL to calculate the stiffness matrix
- ```rom.m```: ROM formulae to calculate the stiffness matrix
- ```homo.m```: homogenization formulae to calculate the stiffness matrix
- ```calculateLaminateStiffness.m```: calculate the effective laminate stiffness for a given layup sequence -- this is called three times
- ```calculateStrains.m```: calculates strains in the laminate for a given loading -- this is also called three times
- ```calculateStressAllLayers.m```: calculates stresses in the individual layers -- this is also called three times
- ```calculateStressResultants.m```: calculates the stress resultants from the stress to perform a sanity check and see if the stress resultants match with the given input loading - this is also called three times
- ```calculateAverageStressAllLayers.m```: calculates average stresses in a layer -- this is also called three times
- ```calculateRAllLayers.m```: calculates the margin of safety for all the layers using the Tsai-Wu failure criteria -- this is also called three times

## Other functions
- ```transformQ.m```: transforms stiffnes matrix, ```[Q]```, to any given angle
- ```postProcessor.m```: reads all the output files and makes plots from the output data.
- ```FEPlots.m```: makes some FEA specific plots


