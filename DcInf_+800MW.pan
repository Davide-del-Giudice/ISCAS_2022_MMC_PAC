global gFlt
ground electrical gnd

//-----------------------------------------
// MMC PARAMETERS
//-----------------------------------------

parameters R_ARM=1.31m    L_ARM=29m          \ // MMC ARM RESISTANCE AND INDUCTANCE 
           LEVELS=200   	             \ // NUMBER OF SMs IN EACH MMC ARM
           P_NOM=800M 	                     \ // NOMINAL MMC POWER
           VDC_NOM=400k 	             \ // NOMINAL MMC POLE-TO-POLE VOLTAGE
           VAC_CONV=VDC_NOM/(2*sqrt(2))      \ // NOMINAL MMC AC LINE-TO-LINE VOLTAGE
           I_NOM=P_NOM/(sqrt(3)*VAC_CONV)    \ // NOMINAL MMC AC CURRENT
	   C_SM=10m                            // SM CAPACITANCE

//-----------------------------------------
// MMC CONTROL PARAMETERS (SEE FIGURE 1(c))
//-----------------------------------------

parameters KI_P=33       KP_P=0               \ // INTEGRAL AND PROPORTIONAL GAIN (ACTIVE POWER CONTROL)
	   KI_Q=33       KP_Q=0               \ // INTEGRAL AND PROPORTIONAL GAIN (REACTIVE POWER CONTROL)
	   KI_DC=272     KP_DC=8              \ // INTEGRAL AND PROPORTIONAL GAIN (DC VOLTAGE CONTROL)
           KP_I=0.48     KI_I=149             \ // INTEGRAL AND PROPORTIONAL GAIN (INNER CURRENT CONTROL) 
           KI_CIRC=10k   KP_CIRC=50           \ // INTEGRAL AND PROPORTIONAL GAIN (CIRCULATING CURRENT CONTROL) 
           WN=2*pi*140   XI=0.7               \ // PARAMETERS OF 2ND ORDER FILTER #1 (NOT SHOWN IN THE PAPER)
           WN_1=2*pi*2k  XI_1=0.7               // PARAMETERS OF 2ND ORDER FILTER #2 (NOT SHOWN IN THE PAPER)
                                                // (FOR PLL AND OTHER FILTERS/CONTROLS, SEE "converter.mod" and "auxiliary.mod")

//-----------------------------------------
// SYSTEM PARAMETERS
//-----------------------------------------

parameters VAC_PCC_A1=145k/sqrt(3)           \ // NOMINAL MMC AC LINE-TO-GROUND VOLTAGE AC1 GRID
           VAC_PCC_C1=380k/sqrt(3)           \ // NOMINAL MMC AC LINE-TO-GROUND VOLTAGE AC2 GRID
           RT=0.363/3  LT=35m/3              \ // Yg/D TRANSFORMER RESISTANCE AND INDUCTANCE (D SIDE)
           RON=1.361m   ROFF=1G              \ // ON- AND OFF- RESISTANCE OF BREAKERS 
           F0=50 W_NOM=2*pi*F0               \ // NOMINAL FREQUENCY AND ANGULAR FREQUENCY
           VDIG=1       MAXDCGAIN=1000       \ // AUXILIARY VARIABLES

//-----------------------------------------
// SIMULATION OPTIONS
//-----------------------------------------

parameters TCROSS=10n TSTOP=20
options rawkeep=yes topcheck=2 compile=2 outintnodes=yes
		   
//-----------------------------------------
// SIMULATIONS
//-----------------------------------------

#ifdef ! exist( "Shoot.sh" ) || FORCE
    Dc dc  uic=2 partitioner=0 annotate=3
    Tr_bis tran stop=TSTOP annotate=5 restart=1 uic=2 \
	 devvars=yes cmin=false method=2 maxord=2 \
	 iabstol=10u vreltol=1m ireltol=1m vabstol=1m \
	 sparse=2 chgtol=no supernode=0 saman=0 skip=2 \
	 maxiter=100 tmax=0.1m tmin=1n acntrl=3 
#endif

Sh1 shooting fund=F0 restart=no floquet=yes tmin=1n method=2 maxord=2 \
	       iabstol=10u sparse=1 solver=1 acntrl=3 ereltol=1m eabstol=10u \
	       tmax=0.001m save="NewShoot.sh" load="Shoot.sh"

AlAcB alter instance=B0C1.Eg1 param="pacmag" value=1 
PAc   pac start=100m stop=10*F0 dec=200 parsolver=1
AlAcA alter instance=B0C1.Eg1 param="pacmag" value=0 

AlDcB alter instance=CfC1 param="pacmag" value=1 
PDc   pac start=100m stop=7*F0 dec=100 parsolver=1
AlDcA alter instance=CfC1 param="pacmag" value=0 

Save control begin 

    Fr  = get("PAc@0.freq");
    Ig1 = get("PAc@0.B0C1.Eg1:i");
    Ig2 = get("PAc@0.B0C1.Eg2:i");
    Ig3 = get("PAc@0.B0C1.Eg3:i");

    save("mat5", "PAc0@+800MW.mat", "Fr", Fr, "Ig1", -Ig1, "Ig2", -Ig2, "Ig3", -Ig3 );

    Fr  = get("PDc@0.freq");
    Idc = get("PDc@0.CfC1:i");

    save("mat5", "PDc0@+800MW.mat", "Fr", Fr, "Idc", -Idc );

endcontrol

//---------------------------------------------
//  THE SIMULATED CIRCUIT
//---------------------------------------------

Eflt  gFlt    gnd    vsource vdc=0
Von on gnd  vsource v1=0 v2=VDIG td=(5*0+3)/F0 tr=1u width=TSTOP+1 period=TSTOP+2

//-------------------
//  AC GRID (AC1) -- MMC-PQ SIDE
//-------------------
B0C1 B0C1_a B0C1_b B0C1_c AC_GRID VG=VAC_PCC_A1 FG=F0 SCC=30G RATIO=0.1 PHASE=90

Brk_pq_a B0C1_a CmC1_a pq_acon  gnd  AC_SW  RON=1m ROFF=ROFF
Brk_pq_b B0C1_b CmC1_b pq_acon  gnd  AC_SW  RON=1m ROFF=ROFF
Brk_pq_c B0C1_c CmC1_c pq_acon  gnd  AC_SW  RON=1m ROFF=ROFF

Rxa   B0C1_a       xa1   resistor  r=1000
Cxa      xa1    CmC1_a   capacitor c=100n
Rxb   B0C1_b       xb1   resistor  r=1000
Cxb      xb1    CmC1_b   capacitor c=100n
Rxc   B0C1_c       xc1   resistor  r=1000
Cxc      xc1    CmC1_c   capacitor c=100n

CONV_PCC_PQ CmC1_a CmC1_b CmC1_c pq_a pq_b pq_c pq_va pq_vb pq_vc pq_ia pq_ib pq_ic on \
		CONV_PCC V1=VAC_PCC_A1 V2=VAC_CONV/sqrt(3) L=LT


// ------------
// MMC1 (PQ)
// ------------
CmC1 pq_a pq_b pq_c BmC1_pos BmC1_neg pq_va pq_vb pq_vc pq_ia pq_ib pq_ic \
                 pq_omega pq_acon on pq_blocked MMC_PQ

// ------------
//  DC SYSTEM
// ------------

CfC1   BmC1_pos   BmC1_neg  vsource dc=VDC_NOM pacmag=0 ; vsin=0.01*VDC_NOM freq=10

// -------------------------------------------
//               MMC SUBCIRCUITS 
// -------------------------------------------

// --------------
// MMC P/Q
// --------------
subckt MMC_PQ a1 b1 c1 dc_pos dc_neg a3 b3 c3 za zb zc omega acon on blocked

AVG_CAP_MODEL a1 b1 c1 dc_pos dc_neg a3 b3 c3 za zb zc \
	vdp vqp vdn vqn idp iqp idn iqn \
	idp_ref iqp_ref idn_ref iqn_ref \
	vdc_mea idc_pos idc_neg omega blocked acon \
	AVG_CAP_MODEL  L=L_ARM C=C_SM*LEVELS R=R_ARM R_GND=1M VDIG=VDIG LEVELS=LEVELS VDC_NOM=VDC_NOM TCROSS=TCROSS CNTR_L=LT+L_ARM/2 W_NOM=W_NOM

// POWER MEASUREMENT
Pwr pow gnd za zb zc a1 b1 c1 vcvs func=v(za)*v(a1)+v(zb)*v(b1)+v(zc)*v(c1)

// AC-Q REFERENCE AND REGULATION
Qref qref  gnd   vsource vdc=0
Qreg iqp_ref vdp vqp vdn vqn idp iqp idn iqn qref blocked Q_REG MAX=1.2 MIN=-1.2 KP=0 KI=KI_Q CF=1M

// AC-P REFERENCE AND REGULATION (WITH DC-V DEAD-BAND)
Pref pref  gnd   vsource vdc=0 v1=0 v2=0.8 td=150m tr=1u \
                         width=TSTOP+1 period=TSTOP+2
			 
Preg idp_mod vdp vqp vdn vqn idp iqp idn iqn pref blocked P_REG MAX=1.2 MIN=-1.2 KP=KP_P KI=KI_P CF=1M
Vdcdb vdc_mea delta_idp deadband_on DEADBAND
Idref idp_ref gnd idp_mod delta_idp vcvs func= limit(v(idp_mod) - v(delta_idp),-1.2,1.2)

// D-Q CURRENT REFERENCES (NEGATIVE SEQUENCE)
// KEEP AC CURRENTS BALANCED 
Idn_ref idn_ref gnd vsource vdc=0
Iqn_ref iqn_ref gnd vsource vdc=0

// MMC PROTECTION (MUST BE MODIFIED)
Blk acon on blocked vdp vqp idc_pos idc_neg BLK_CTRL 

ends

// -----------------------------
//  AC_GRID
// ----------------------------

subckt AC_GRID a b c 
parameters VG=1 FG=1 SCC=1 RATIO=1 PHASE=0 ZG=VG^2/SCC \
	   ARG=atan(1/RATIO) RG=ZG*cos(ARG) LG=ZG*sin(ARG)/(2*pi*FG)

Rg1 a  a1 resistor r=RG
Rg2 b  b1 resistor r=RG
Rg3 c  c1 resistor r=RG

Lg1 a1 a2 inductor l=LG ic=0
Lg2 b1 b2 inductor l=LG ic=0
Lg3 c1 c2 inductor l=LG ic=0

Eg1  a2  ys vsource vsin=VG*sqrt(2)     freq=FG vphase=   0+PHASE pacmag=1
Eg2  b2  ys vsource vsin=VG*sqrt(2)     freq=FG vphase=-120+PHASE
Eg3  c2  ys vsource vsin=VG*sqrt(2)     freq=FG vphase= 120+PHASE

Rys ys gnd resistor r=10k

ends


//-----------------------------------------
//  MODELS 
//-----------------------------------------

model      ABCDQ0 nport veriloga="abcdq0.va"   verilogaprotected=yes
model      DQ0ABC nport veriloga="dq0abc.va"   verilogaprotected=yes
model       UVBLK nport veriloga="uvblk.va"    verilogaprotected=yes 
model       OCBLK nport veriloga="ocblk.va"    verilogaprotected=yes
model      BLKTOT nport veriloga="blktot.va"   verilogaprotected=yes
model    DEADBAND nport veriloga="deadband.va" verilogaprotected=yes 
model       AC_SW nport veriloga="acsw.va" verilogatrace=["Status","Current"]
model        ONSW vswitch ron=RT   roff=10k  voff=0.4*VDIG von=0.6*VDIG
model          SW vswitch ron=1m   roff=ROFF voff=0.4*VDIG von=0.6*VDIG
model         DIO diode imax=10k rs=RON        is=1n compact=1
model     DIO_BLK diode imax=30k rs=RON*LEVELS n=1*LEVELS is=1n compact=1

// ------------------------------------------------
//  OTHER FILES WHERE SOME SUBCIRCUITS ARE DEFINED
// ------------------------------------------------

include auxiliary.mod
include converter.mod
