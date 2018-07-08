# Description
This repository contains the code used for the analysis in Lee, Jonathan and Callaway, Duncan. "The cost of reliability in decentralized solar systems in sub-Saharan Africa." Under Review. 2018.

The code is made available under the MIT license. We request that any analysis using this code cites Lee, Jonathan and Callaway, Duncan. "The cost of reliability in decentralized solar systems in sub-Saharan Africa." Under Review. 2018.

Please see the paper above for a description of the analysis conducted, in particular the Methods section. The abstract is included here:

*While there is consensus that both grid extensions and decentralized projects are necessary to approach universal electricity access, existing electrification planning models that assess the costs of decentralized solar energy systems do not include metrics of reliability or quantify the impact of reliability on costs. We focus on stand-alone, household solar systems with battery storage in sub-Saharan Africa (SSA) using the fraction of demand served (FDS) to measure reliability, and develop a multi-step optimization to efficiently compute the least-cost system with FDS as a design constraint, taking into account daily variation in solar resources and costs of solar and storage. We show that the cost of energy is minimized at approximately 90% FDS, that costs increase on average USD 0.11/kWh for each additional “9” of reliability, and that this reliability premium could be as low as USD 0.03/kWh in a plausible future price scenario. We compute the cost of decentralized systems that provide FDS equal to national measures of grid reliability, and compare this to national residential grid tariffs. We find that almost no regions are yet at grid parity, but that a cost reduction scenario supported by the literature would lead to decentralized systems being cheaper than the grid – at current reliability levels – in 28% of the area of SSA.  These results and the forthcoming software tool identify promising locations for decentralized solar systems and can be incorporated into multi-objective electricity planning models.*

The core of the module computes "reliability frontiers," which are a set of solar array capacity and battery storage capacity pairs that ensure that an off-grid solar plus battery system will achieve a given reliability.

# Instructions
The central function in `core` is `generateAndSaveHourReliabilityFrontier.m`, which computes a reliability frontier for a given location and target reliability between 0 and 1.

There are many scripts in the `analysis` folder. Please see the file `makeArticlePlots.m` for the code that generates the figures displayed in the paper. The file `calcAllReliabilitiesConstantLoad.m` will generate reliability frontiers for all locations at 1 degree lat/lon resolution in sub-Saharan Africa.
