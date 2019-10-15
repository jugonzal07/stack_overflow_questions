# Density of Air
Based on question found here:
[Density of air question on unmet hours](https://unmethours.com/question/40743/energyplus-89-error-psyrhoairfnpbtdbw-rhoair-density-of-air-is-calculated-0/)

Gist of it is that UnitaryMultiSpeed heat pumps are causing issues for the prototype school model in Chicago. The error spit out by E+ shows an error that reads as follow:

`** Severe ** PsyRhoAirFnPbTdbW: RhoAir (Density of Air) is calculated <= 0 [-384.79728]. ** ~~~ ** pb =[98725.00], tdb=[-274.04], w=[0.0000000]. ** ~~~ ** Routine=CalcMultiSpeedDXCoilHeating, Environment=RUN PERIOD 1, at Simulation time=07/01 00:34 - 00:35 ** Fatal ** Program terminates due to preceding condition.`