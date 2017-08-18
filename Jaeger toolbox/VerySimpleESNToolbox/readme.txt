DISCLAIMER: THIS PACKAGE COMES WITHOUT ANY SUPPORT OR GUARANTEE. 

THE ESN METHOD IS PROTECTED BY INTERNATIONAL PATENTS OWNED 
BY FRAUNHOFER GESELLSCHAFT GERMANY. Use for 
academic research is free. If you want to use it for commercial
purposes, contact h.jaeger@iu-bremen.de.

If you find bugs, I would be pleased to learn about them 
(h.jaeger@jacobs-university.de). However, I will generally not answer 
questions asking for explanations of the code. 

**************************************************************
This is a simplistic toolbox that doesn't deserve this name, 
because it is essentially just one big script for a standard
type of experiment (learnAndTest.m). From a software engineering
view, this thing doesn't meet even the most modest demands. 
All variables are global, for instance... But it is handy 
and leightweight and useful for gathering first experiences with
ESNs. -- If you want a more modular (and much more comprehensive)
toolbox, check out 

http://www.faculty.jacobs-university.de/hjaeger/pubs/ESNtools.zip
*************************************************************

File description (see comments within files for more details):

Helper functions:

f.m, fInverse.m: the sigmoid functions used and their inverse

minusPoint5.m, myeigs.m: helper functions used in network generation

createEmptyFigs.m: should be run once at every session, creates 
empty figs in the left bottom screen corner (where I want to have them). 

The really important functions that do the work:

generateTrainTestData.m: as the name says. This is the file that you 
need to edit to produce (or import) your training and testing data.

generateNet.m: as the name says

learnAndTest.m: the main learning and testing script. It first runs 
a part of the training data through the network for training, then
computes the readout weights, then continues this run with the rest
of the training data and the learnt output weights to check performance
of the trained model on these "test" data (that is, we split the given
sequence into a training and a testing part). 

continueRun.m: when a network has been trained, use this
for testing it on novel data

*************************************************************
Overall hints to using this toolbox

The file headers.m is the "command center" for running experiments. All 
important parameters are set in this file. I suggest that if you 
run experiments, you do it via this file, by calling the appropriate
functions from here through double-click -- right click -- "evaluate
selected". Make sure that you evaluate this file (thus making your 
network design and experiment design parameters known to Matlab) first before
you expect anything to come out of calling the other scripts. 

A peculiarity of this implementation is that some scripts require that 
an initial call to "createEmptyFigs" has been done, which simply creates
some empty figures with name pointers. Today I would do this differently, 
but at that time I used this to arrange these figures as I wanted them
on my screen and then later was sure that the same kind of contents was always
placed in the same figures. 





