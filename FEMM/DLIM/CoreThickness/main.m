%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 460; %Core width in motion direction
THICK_CORE = 50; %Core thickness
LENGTH = 50; %Core length
GAP = 17.5; %Gap between core and xy plane (or 1/2 of air gap)
SLOT_PITCH = 40; %Distance between two slots
SLOTS = 11; %Number of slots
Hs0 = 0; %Slot opening height
Hs01 = 0; %Slot closed bridge height
Hs1 = 0; %Slot wedge height
Hs2 = 20; %Slot body height (Height of teeth gap)
Bs0 = 20; %Slot opening width
Bs1 = 20; %Slot wedge maximum Width
Bs2 = 20; %Slot body bottom width
Rs = 0; %Slot body bottom fillet
Layers = 2; %Number of winding layers
COIL_PITCH = 2; %Coil Pitch measured in slots
END_EXT = 0; %One-sided winding end extended length
SPAN_EXT = 20; %Axial length of winding end span
SEG_ANGLE = 15; %Deviation angle for slot arches

%Define Simulation Default Parameters
inputCurrent = 10;
freq = 60;
coilTurns = 360;
trackThickness = 8;
copperMaterial = '16 AWG';
trackMaterial = 'Aluminum, 6061-T6';
coreMaterial = 'M-19 Steel';
coreMaterialDensity = 7.7;

%Define Simulation Specific Parameters
sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase

%Define simulations bounds
min_depth = 1;
max_depth = 60;
numSims = (max_depth-min_depth);

%Simulation counter/duration Variables
totalTimeElapsed = 0;
singleSimTimeElapsed = 0;
simulationNumber = 1;

for x=min_depth:max_depth
  tic
  THICK_CORE=Bs2+x;
  Volume = 2*(THICK_CORE/10*WIDTH_CORE/10*LENGTH/10-Bs2/10*Hs2/10*LENGTH/10*(SLOTS)); %Volume of DLIM in cm3
  Weight = Volume*coreMaterialDensity; %Weight of DLIM Core in g

  inputCoreThickness(x) = THICK_CORE;
  inputVolume(x)=Volume;
  inputWeight(x)=Weight;

  [losses,totalLosses,lforcex,lforcey,wstforcex,wstforcey,vA,vB,vC,cA,cB,cC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH);
  outputWSTForcex(x)=wstforcex; %Weighted Stress Tensor Force on Track, x direction
  outputWSTForcey(x)=wstforcey; %Weighted Stress Tensor Force on Track, y direction
  outputLForcex(x)=lforcex; %Lorentz Force on Track, x direction
  outputLForcey(x)=lforcey; %Lorentz Force on Track, y direction
  outputHLosses(x)=losses; %Hysteresis Losses
  outputTLosses(x)=totalLosses; %Total Losses
  outputVoltageA(x)=vA; %Voltage of Phase A
  outputVoltageB(x)=vB; %Voltage of Phase B
  outputVoltageC(x)=vC; %Voltage of Phase C
  outputCurrentA(x)=cA; %Current of Phase A
  outputCurrentB(x)=cB; %Current of Phase B
  outputCurrentC(x)=cC; %Current of Phase C
  outputResistanceA(x)=vA/cA; %Resistance of Phase A
  outputResistanceB(x)=vB/cB; %Resistance of Phase B
  outputResistanceC(x)=vC/cC; %Resistance of Phase C
  outputResultX(x)=lforcex/Weight;%Force/Weight Ratio (x-direction)
  outputResultY(x)=lforcey/Weight;%Force/Weight Ratio (y-direction)
  save('thickness_results.mat');

  singleSimTimeElapsed=toc;
  disp(append("Simulation Number ",num2str(simulationNumber)," completed in ",num2str(singleSimTimeElapsed)," seconds with parameters THICK_CORE: ",num2str(THICK_CORE)))
  simulationNumber=simulationNumber+1;
  totalTimeElapsed = totalTimeElapsed+singleSimTimeElapsed;
end
