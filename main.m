%Define LIM Parameters (Parallel to ANSYS rmXprt LinearMCore definition)
WIDTH_CORE = 460;
THICK_CORE = 50;
LENGTH = 50;
GAP = 10;
SLOT_PITCH = 40;
SLOTS = 11;
Hs0 = 0;
Hs01 = 0;
Hs1 = 0;
Hs2 = 20;
Bs0 = 20;
Bs1 = 20;
Bs2 = 20;
Rs = 0;
Layers = 2;
COIL_PITCH = 2;

%Define Simulation Default Parameters
inputCurrent = 200;
freq = 60;
coilTurns = 30;
trackThickness = 8;
copperMaterial = '10 AWG';
coreMaterial = 'M-19 Steel';%'1010 Steel';
trackMaterial = 'Aluminum, 6061-T6';

%Define Simulation Specific Parameters

sumSlotTeeth = SLOTS*2+1; %Number of Teeth + Slots
slotGap = SLOT_PITCH-Bs1; %Width of an Individual Slot
slotTeethWidth = (SLOTS-1)*SLOT_PITCH+slotGap;
coilArea = slotGap*Hs2/2; %Area of coil for a single phase
PF = 0.9; %Planar Packing Factor

[Gauge,Diameter,opk,Ampacity,FtpLb,Area,Volt]=readvars('InputData/copperCoilData');

outputParams = zeros(2,34);
outputVoltage = zeros(3,34);
outputCurrent = zeros(3,34);

for i=5:16
  awg = i*2;
  ind = find(Gauge==awg);
  copperMaterial = join([int2str(Gauge(ind)),' AWG'])
  coilTurns = floor(coilArea/Area(ind)*0.9)
  outputParams(1,i)=coilTurns;
  [force,vA,vB,vC,cA,cB,cC] = DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
  outputParams(2,i)=force;
  outputVoltage(1,i)=resA;
  outputVoltage(2,i)=resA;
  outputVoltage(3,i)=resA;

end



%DLIMSimulations(inputCurrent,freq,coilTurns,trackThickness,copperMaterial,coreMaterial,trackMaterial,WIDTH_CORE,THICK_CORE,LENGTH,GAP,SLOT_PITCH,SLOTS,Hs0,Hs01,Hs1,Hs2,Bs0,Bs1,Bs2,Rs,Layers,COIL_PITCH)
