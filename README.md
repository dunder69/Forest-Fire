# CAS Project 3: Forest-Fire

## Running a single simulation of the forest fire model
To run a single simulation of the forst fire model use the forst fire functions:
* forest_fire.m for one species
* forest_fire2trees.m for 2 species
* firefighters.m for one species with firefighters

These functions output fitness values based on the provided mode.

In each the input parameters are:
* f = chance of lightning
* p = chance of growing tree (p1 and p2 for 2 tree simulation)
* N,M = dimensions of grid
* mode = 1 for biomass fitness function, 2 for longevityfitness function

An example call is: bioFitness = forest_fire(.01,.3,250,250,1);

Each function has the following line uncommented to graphically display the model.

`image(F); pause(.1)`

Comment this line out to suppress visual output and improve runtime (very useful for running the GA). Black represents a barren space. Different shades of green represent different tree species. Orange represents trees on fire. Blue repreents trees that were on on fire, that were extinguished by firefighters.

## Running the Genetic Algorithm
To run the genetic algorithm, use the genetic algorithm functions:
* forestGA for one species
* forestGA2trees for 2 species

These functions output vectors of:
* The population of p values from the final generation
* The max fitness/p value pair per generation
* The average fitness/p value pair per generation
* The min fitness/p value pair per generation

In each the input parameters are:
* population size
* mutation probability - how likely a value will mutate
* mutation range - if a value mutates, how much will it mutate by
* generations
* mode = 1 for biomass fitness function, 2 for longevityfitness function

An example call is: [populationSpecies,maxTree,avgTree,minTree] = forestGA(20,.1,.1,20,1);