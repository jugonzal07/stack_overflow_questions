# AirTerminal:SingleDuct:SeriesPIU:Reheat not being assigned a secondary air inlet node
Based on question found here:
[AirTerminal:SingleDuct:SeriesPIU:Reheat not being assigned a secondary air inlet node ](https://unmethours.com/question/44163/airterminalsingleductseriespiureheat-not-being-assigned-a-secondary-air-inlet-node/)

I'm working to add AirTerminal:SingleDuct:SeriesPIU:Reheat to our workflow and am running into an issue where the "Secondary Air Inlet Node" parameter remaining blank even when adding a zone to its respective demand side branch when using the OpenStudio SDK (2.9.1). When adding a second terminal, however, the "Secondary Air Inlet Node" is set correctly as the zone's return air node.