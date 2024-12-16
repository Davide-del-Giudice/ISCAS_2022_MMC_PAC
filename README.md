# MMC-PAC

The folder contains all the simulation files and codes (running on MATLAB) needed to generate every figure of the paper *"Impact of Modular Multilevel Converters Impedances on the AC/DC Power System Stability"*.
For what concerns the main folder, files have the following extensions:
-	**.pan** : they include the simulations to be carried out with PAN simulator. Each .pan file includes a netlist describing most of the simulated system. Some components are included in form of subcircuits: these are described by the **.mod** and **.va** files.
-	**.mod** : they describe at netlist level some power system components and controls common to each **.pan** file.
-	**.va** : they describe some of the MMC controls implemented with the Verilog-A language.

The folder *"Figures"* contains all the Matlab codes and .mat files needed to generate each figure of the paper. The Matlab codes are named after the figures they generate. Each **.mat** file can be generated by simulating a specific **.pan** file (see below). The file **"format_ticks"** allows plotting graphs in a nice manner.
For further information, please refer to the paper (and its references) or contact the Authors.
For what concerns the main folder, files have the following extensions:
- **.pan** : they include the simulations to be carried out with PAN simulator. Each **.pan** file includes a netlist describing most of the simulated system. Some components are included in form of subcircuits: these are described by the **.mod** and **.va** files.
- **.mod** : they describe at netlist level some power system components and controls common to each **.pan** file.
- **.va**  : they describe some of the MMC controls implemented with the Verilog-A language.

For further information, please refer to the paper (and its references) or contact the Authors.

# SIMULATION DESCRIPTION
If run, each **.pan** file generates one or more .mat file, which can be used to generate the figures in the **"Figures"** folder. Each **.pan** file simulates a different version of **Fig.1(a)** of the paper. The following holds:
-	The **"DcInf_+800MW.pan"** file allows obtaining the **.mat** files necessary to plot the black lines in the upper and lower panel of **Fig.2** and **Fig.4**. In this case, power is injected into the DC grid.
-	The **"DcInf_-800MW.pan"** file allows obtaining the **.mat** files necessary to plot the red lines in the upper and lower panel of **Fig.2** and **Fig.4**. In this case, power is injected into the AC grid.
-	The **"dcInstability.pan"** file allows obtaining the **.mat** files necessary to plot **Fig.3**. Compared to **Fig.1(a)**, in this case a time-varying inductor (implemented in **ind.va**) was connected at each pole of MMC1 (i.e., bus Dc1).
-	The **"acInstability.pan"** file allows obtaining the **.mat** files necessary to plot Fig.5. Compared to **Fig.1(a)**, in this case a weak AC grid was added.

The **"distlibs.tar"** folder includes the libraries needed to generate the simulator executable (updated to the latest version of 16/12/2024). Expand the .tar file and issue these two commands:
1) chmod 700 do_link
2) ./do_link

So doing, in the same directory, the PAN executable should be generated. 
