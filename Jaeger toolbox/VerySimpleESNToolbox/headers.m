% header infos for controller learning

%%%%%%% createEmptyFigs
%%%%%%% generateNetold
netDim = 100; connectivity = 0.1; inputLength = 2; outputLength = 2;
%%%%%%% generateTrainTestData
samplelength = 2000;
%%%%%%% learnAndTest
specRad = 0.8; ofbSC = [1;1]; noiselevel = 0.0000; 
linearOutputUnits = 0; linearNetwork = 0; WienerHopf = 0; 
initialRunlength = 100; sampleRunlength = 1000; freeRunlength = 0; plotRunlength = 100;
inputscaling = [0.1;0.5]; inputshift = [0;1];
teacherscaling = [0.3;0.3]; teachershift = [-.2;-0.2];
