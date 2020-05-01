/*********************************************
 * OPL 12.10.0.0 Model
 * Author: jawessel
 * Creation Date: Apr 16, 2020 at 3:57:31 PM
 *********************************************/
/*********************************************
 * OPL 12.10.0.0 Model
 * Author: jawessel
 * Creation Date: Apr 16, 2020 at 3:57:31 PM
 *********************************************/
//Simulate NicISO Power System to calculate LMPs, diagnose system deficiencies, and offer direction for system improvements.

int NumBuses = ...; //Number of buses
int NumLines = ...; //Number of transmission lines
int NumUnits = ...; //Number of generating units
int NumYears = ...; //Number of years in planning horizon

range Buses = 1..NumBuses;
range Lines = 1..NumLines;
range Units = 1..NumUnits;
range Years = 1..NumYears;
range ConvUnits = 1..20;

//Demand (Load)
float WinterPeakDemand [Buses][Years] = ...; //Demand (MW) for each bus
float WinterOffDemand [Buses][Years] = ...;
float SpringPeakDemand [Buses][Years] = ...; //Demand (MW) for each bus
float SpringOffDemand [Buses][Years] = ...;
float SummerPeakDemand [Buses][Years] = ...; //Demand (MW) for each bus
float SummerOffDemand [Buses][Years] = ...;
float FallPeakDemand [Buses][Years] = ...; //Demand (MW) for each bus
float FallOffDemand [Buses][Years] = ...;

float WinterPeakHours = ...;
float WinterOffHours = ...;
float SpringPeakHours = ...;
float SpringOffHours = ...;
float SummerPeakHours = ...;
float SummerOffHours = ...;
float FallPeakHours = ...;
float FallOffHours = ...;

float WinterPPDemand [Buses][Years] = ...;
float SpringPPDemand [Buses][Years] = ...;
float SummerPPDemand [Buses][Years] = ...;
float FallPPDemand [Buses][Years] = ...;

int LineToBus [Buses][Lines]=...; //Define lines by their start and end points
int LineFromBus [Buses][Lines]=...;
int UnitsByBus [Buses][Units]=...; //Number of generating units in each bus

//Transmission Line Physics
float LineReactance[Lines]=...;
float LineCapacity[Lines]=...;

//Generator Parameters
float WinterPeakMaxGen [Units] = ...; //Unit Maximum Generation during peak hours (MW)
float SpringPeakMaxGen [Units] = ...; 
float SummerPeakMaxGen [Units] = ...; 
float FallPeakMaxGen [Units] = ...;
float ConvUnitCap [ConvUnits] = ...; //Nameplate Capacity of existing conventional units 
float OffMaxGen [Units] = ...; //Unit Maximum Generation during off-peak hours (MW)
float MinGen [Units] = ...; //Unit Minimum Generation (MW)
float MarginalC[Units] = ...; //Unit Marginal Cost of Energy ($/MWh)
float opex_existing[Units] = ...; //Unit opex ($/MWh)
float NOx [Units] = ...; //NOx Emissions by generator (lb/MWh)
float SO2 [Units] = ...; //SO2 Emissions by generator (lb/MWh)
float CO2 [Units] = ...; //CO2 Emissions by generator (lb/MWh)
float CH4 [Units] = ...; //CH4 Emissions by generator (lb/MWh)
float N2O [Units] = ...; //N2O Emissions by generator (lb/MWh)

float capex_solar[Years] = ...; //Capital Cost of a solar project ($/MW)
float opex_solar[Years] = ...; //Annual O&M Cost of new solar ($/MW)
float capex_wind[Years] = ...; //Capital Cost of a wind project ($/MW)
float opex_wind[Years] = ...; //Annual O&M Cost of new wind ($/MW)
float solar_inc = ...; //Incremental amount of solar that can be built (MW)
float wind_inc = ...; //Incremental amount of wind that can be built (MW)
float solar_cap_factor = ...; //How much of the installed solar capacity will be generated at this hour in the year
float wind_cap_factor = ...; //How much of the installed wind capacity will be generated at this hour in the year
float capex_storage[Years] = ...; //Capital Cost of a storage project ($/MW)
float opex_storage[Years] = ...; //Annual O&M Cost of new storage ($/MW)
float bat_eff = ...; //battery round-trip efficiency
float RampRate [Units] = ...; //Ramp rate for ramping constraints
int SolarBuildTime = ...;
int WindBuildTime = ...;

int ngccBuildTime = ...;
float capex_ngcc[Years] = ...; //Capital Cost of an NGCC project ($/MW)
float opex_ngcc[Years] = ...; //Annual O&M Cost of new NGCC ($/MW) - may need to treat differently due to fuel costs
float ngcc_inc = ...; //Incremental amount of NGCC that can be built (MW)
float ngcc_cap_factor = ...; //How much of the installed NGCC capacity will be generated at this hour in the year


float WinterSolarFactor = ...; //Amount of solar capacity available during peak hours in the winter
float SpringSolarFactor = ...;
float SummerSolarFactor = ...;
float FallSolarFactor = ...;

//float EV_subsidy_cost = ...; //Capital cost to subsidize 20% of EV costs
int EV_subsidy_decision = ...; //binary decision for whether or not to instate 20% EV capital cost subsidy (predetermined)
float vehicle_CO2_no_subsidy = ...; //Annual CO2 emissions (in lbs.) from transportation sector, without implementing EV subsidy
float vehicle_CO2_subsidy = ...; //Annual CO2 emissions (in lbs.) from transportation sector with EV subsidy
float fridge_eff_cost = ...; //non-discounted annual cost of refrigerator energy efficiency (program is either implemented for every year or not at all)
float fridge_eff_benefit [Buses][Years] = ...; //annual demand reduction resulting from investment in refrigerator energy efficiency program (MW/year)
float led_eff_cost = ...; //non-discounted annual cost of LED energy efficiency (program is either implemented for every year or not at all)
float led_eff_benefit [Buses][Years] = ...; //annual demand reduction resulting from investment in LED energy efficiency program (MW/year)

float retrofit_cap_cost = ...; //capital cost (LCOE) of retrofitting an existing coal or natural gas plant to reduce emissions
float retrofit_opex_cost = ...; //operational costs of retrofitting
float retrofit_NOx_removal = ...; //proportion of NOx emissions that will be eliminated as a result of a retrofit
float retrofit_SO2_removal = ...; //proportion of SO2 emissions that will be eliminated as a result of a retrofit
float retrofit_CO2_removal = ...; //proportion of CO2 emissions that will be eliminated as a result of a retrofit

//Optimization Parameters
float DiscRate = ...; //Discount Rate for NPV calculations
float maxCO2 = ...; //Maximum 2045 CO2 emissions

//Decision Variables
dvar float+ WinterPeakGen [u in Units, y in Years] in -10000..WinterPeakMaxGen[u]; //Peak Generation for each Unit (MW)
//Need to change the minimum of PeakGen to allow batteries to charge
dvar float+ WinterOffGen [u in Units, y in Years] in -10000..OffMaxGen[u];
dvar float WinterPeakFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar float WinterOffFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)

dvar float+ SpringPeakGen [u in Units, y in Years] in -10000..SpringPeakMaxGen[u];
dvar float+ SpringOffGen [u in Units, y in Years] in -10000..OffMaxGen[u];
dvar float SpringPeakFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar float SpringOffFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)dvar float+ SummerPeakGen [u in Units, y in Years] in 0..OffMaxGen[u];

dvar float+ SummerPeakGen [u in Units, y in Years] in -10000..SummerPeakMaxGen[u];
dvar float+ SummerOffGen [u in Units, y in Years] in -10000..OffMaxGen[u];
dvar float SummerPeakFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar float SummerOffFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)

dvar float+ FallPeakGen [u in Units, y in Years] in -10000..FallPeakMaxGen[u];
dvar float+ FallOffGen [u in Units, y in Years] in -10000..OffMaxGen[u];
dvar float FallPeakFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar float FallOffFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)

//binary decision variables determining whether a plant is online during a certain year for a certain demand level
dvar boolean onWinPk[u in Units, y in Years];
dvar boolean onWinOffPk[u in Units, y in Years];
dvar boolean onSprPk[u in Units, y in Years];
dvar boolean onSprOffPk[u in Units, y in Years];
dvar boolean onSumPk[u in Units, y in Years];
dvar boolean onSumOffPk[u in Units, y in Years];
dvar boolean onFallPk[u in Units, y in Years];
dvar boolean onFallOffPk[u in Units, y in Years];

dvar float objective [y in Years]; //objective function set as a decision variable
dvar float NOx_total [y in Years]; //Emissions decision variables (only CO2 is constrained so far)
dvar float SO2_total [y in Years];
dvar float CO2_total [y in Years];
dvar float CH4_total [y in Years];
dvar float N2O_total [y in Years];

dvar boolean build_solar [y in Years]; //binary decision for whether or not to build solar in a given year
dvar int solar_additions [y in Years] in 0..100; //number of solar modules that will be built (multiplied by solar_inc to get total capacity)
dvar boolean build_wind [y in Years]; //binary decision for whether or not to build solar in a given year
dvar int wind_additions [y in Years] in 0..10000; //number of wind modules that will be built (multiplied by wind_inc to get total capacity)
dvar boolean build_ngcc [y in Years]; //binary decision for whether or not to build NGCC generation in a given year
dvar int ngcc_additions [y in Years] in 0..10000; //number of NGCC modules that will be built (multiplied by solar_inc to get total capacity)
dvar float new_solar_cap [y in Years];
dvar float new_wind_cap [y in Years];
dvar float new_ngcc_cap [y in Years];
dvar boolean build_storage [y in Years];
dvar int storage_additions [y in Years] in 0..10000;
dvar float new_storage_cap [y in Years];
dvar int bs_sa [y in Years]; //logical int for linearizing MILP build constraints (solar)
dvar int bw_wa [y in Years]; //logical int for linearizing MILP build constraints (wind)
dvar int bb_ba [y in Years]; // ^ (battery)
dvar int bn_na [y in Years]; // ^ (natural gas)

dvar boolean fridge_eff_decision; //binary decision for whether or not to invest in refrigerator energy efficiency
dvar boolean led_eff_decision; //binary decision for whether or not to invest in LED energy efficiency
dvar boolean retrofit_decision [ConvUnits]; //binary decision for retrofitting existing coal and natural gas plants

//Objective Function
minimize 
  sum(y in Years) objective[y];   //Minimize Energy Costs

//Constraints
subject to {
  
//Assign obj function and emissions values to variables
	Objective:
	forall(y in Years)
	{	//Total cost is calculated here - commented out peak hour production for model efficiency
	//May want to combine into 1 sum of u in units
	    objective[y] == (1/((1+DiscRate)^y))*((sum(u in Units) WinterPeakGen[u][y] * (MarginalC[u] + opex_existing[u]) * WinterPeakHours)
	    	+ (sum(u in Units) WinterOffGen[u][y] * (MarginalC[u] + opex_existing[u]) * WinterOffHours)
	    	+ (sum(u in Units) SpringPeakGen[u][y] * (MarginalC[u] + opex_existing[u]) * SpringPeakHours)
	    	+ (sum(u in Units) SpringOffGen[u][y] * (MarginalC[u] + opex_existing[u]) * SpringOffHours)
	    	+ (sum(u in Units) SummerPeakGen[u][y] * (MarginalC[u] + opex_existing[u]) * SummerPeakHours)
	    	+ (sum(u in Units) SummerOffGen[u][y] * (MarginalC[u] + opex_existing[u]) * SummerOffHours)
	    	+ (sum(u in Units) FallPeakGen[u][y] * (MarginalC[u] + opex_existing[u]) * FallPeakHours)
	    	+ (sum(u in Units) FallOffGen[u][y] * (MarginalC[u] + opex_existing[u]) * FallOffHours)
	    	+ (capex_solar[y] * bs_sa[y] * solar_inc) + (new_solar_cap[y] * opex_solar[y])
	    		+ (capex_ngcc[y] * bn_na[y]) + (new_ngcc_cap[y] * opex_ngcc[y]) //may be able to nix opex and use MarginalC
	    			+ (capex_wind[y] * bw_wa[y] * wind_inc) + (new_wind_cap[y] * opex_wind[y])
	    				+ (capex_storage[y] * bb_ba[y]) + (new_storage_cap[y] * opex_storage[y])
							+ (fridge_eff_cost * fridge_eff_decision)
	    						+ (led_eff_cost * led_eff_decision))
	    							+ (sum(c in ConvUnits) WinterOffGen[c][y] * retrofit_opex_cost * retrofit_decision[c] * WinterOffHours)
							    	+ (sum(c in ConvUnits) SpringPeakGen[c][y] * retrofit_opex_cost * retrofit_decision[c] * SpringPeakHours)
							    	+ (sum(c in ConvUnits) SpringOffGen[c][y] * retrofit_opex_cost * retrofit_decision[c] * SpringOffHours)
							    	+ (sum(c in ConvUnits) SummerPeakGen[c][y] * retrofit_opex_cost * retrofit_decision[c] * SummerPeakHours)
							    	+ (sum(c in ConvUnits) SummerOffGen[c][y] * retrofit_opex_cost * retrofit_decision[c] * SummerOffHours)
							    	+ (sum(c in ConvUnits) FallPeakGen[c][y] * retrofit_opex_cost * retrofit_decision[c] * FallPeakHours)
							    	+ (sum(c in ConvUnits) FallOffGen[c][y] * retrofit_opex_cost * retrofit_decision[c] * FallOffHours)
							    	+ (sum(c in ConvUnits) ConvUnitCap[c] * retrofit_cap_cost);
    }	   
    
    forall(y in Years) //Emissions are summed up for output file
    { 		
		//Need to be revised after seasons are completely added 
		NOx_total[y] == (sum(u in ConvUnits) (WinterPeakGen[u][y] * WinterPeakHours + WinterOffGen[u][y] * WinterOffHours
			+ SpringPeakGen[u][y] * SpringPeakHours + SpringOffGen[u][y] * SpringOffHours
			+ SummerPeakGen[u][y] * SummerPeakHours + SummerOffGen[u][y] * SummerOffHours
			+ FallPeakGen[u][y] * FallPeakHours + FallOffGen[u][y] * FallOffHours) * NOx[u])
			+ ((WinterPeakGen[44][y] * WinterPeakHours + WinterOffGen[44][y] * WinterOffHours
			+ SpringPeakGen[44][y] * SpringPeakHours + SpringOffGen[44][y] * SpringOffHours
			+ SummerPeakGen[44][y] * SummerPeakHours + SummerOffGen[44][y] * SummerOffHours
			+ FallPeakGen[44][y] * FallPeakHours + FallOffGen[44][y] * FallOffHours) * NOx[44]);
		SO2_total[y] == (sum(u in ConvUnits) (WinterPeakGen[u][y] * WinterPeakHours + WinterOffGen[u][y] * WinterOffHours
			+ SpringPeakGen[u][y] * SpringPeakHours + SpringOffGen[u][y] * SpringOffHours
			+ SummerPeakGen[u][y] * SummerPeakHours + SummerOffGen[u][y] * SummerOffHours
			+ FallPeakGen[u][y] * FallPeakHours + FallOffGen[u][y] * FallOffHours) * SO2[u])
			+ ((WinterPeakGen[44][y] * WinterPeakHours + WinterOffGen[44][y] * WinterOffHours
			+ SpringPeakGen[44][y] * SpringPeakHours + SpringOffGen[44][y] * SpringOffHours
			+ SummerPeakGen[44][y] * SummerPeakHours + SummerOffGen[44][y] * SummerOffHours
			+ FallPeakGen[44][y] * FallPeakHours + FallOffGen[44][y] * FallOffHours) * SO2[44]);
		CO2_total[y] == (sum(u in ConvUnits) (WinterPeakGen[u][y] * WinterPeakHours + WinterOffGen[u][y] * WinterOffHours
			+ SpringPeakGen[u][y] * SpringPeakHours + SpringOffGen[u][y] * SpringOffHours
			+ SummerPeakGen[u][y] * SummerPeakHours + SummerOffGen[u][y] * SummerOffHours
			+ FallPeakGen[u][y] * FallPeakHours + FallOffGen[u][y] * FallOffHours) * CO2[u])
			+ ((WinterPeakGen[44][y] * WinterPeakHours + WinterOffGen[44][y] * WinterOffHours
			+ SpringPeakGen[44][y] * SpringPeakHours + SpringOffGen[44][y] * SpringOffHours
			+ SummerPeakGen[44][y] * SummerPeakHours + SummerOffGen[44][y] * SummerOffHours
			+ FallPeakGen[44][y] * FallPeakHours + FallOffGen[44][y] * FallOffHours) * CO2[44]) + (vehicle_CO2_no_subsidy*(1-EV_subsidy_decision)) + (vehicle_CO2_subsidy*EV_subsidy_decision);
		CH4_total[y] == (sum(u in ConvUnits) (WinterPeakGen[u][y] * WinterPeakHours + WinterOffGen[u][y] * WinterOffHours
			+ SpringPeakGen[u][y] * SpringPeakHours + SpringOffGen[u][y] * SpringOffHours
			+ SummerPeakGen[u][y] * SummerPeakHours + SummerOffGen[u][y] * SummerOffHours
			+ FallPeakGen[u][y] * FallPeakHours + FallOffGen[u][y] * FallOffHours) * CH4[u])
			+ ((WinterPeakGen[44][y] * WinterPeakHours + WinterOffGen[44][y] * WinterOffHours
			+ SpringPeakGen[44][y] * SpringPeakHours + SpringOffGen[44][y] * SpringOffHours
			+ SummerPeakGen[44][y] * SummerPeakHours + SummerOffGen[44][y] * SummerOffHours
			+ FallPeakGen[44][y] * FallPeakHours + FallOffGen[44][y] * FallOffHours) * CH4[44]);
		N2O_total[y] == (sum(u in ConvUnits) (WinterPeakGen[u][y] * WinterPeakHours + WinterOffGen[u][y] * WinterOffHours
			+ SpringPeakGen[u][y] * SpringPeakHours + SpringOffGen[u][y] * SpringOffHours
			+ SummerPeakGen[u][y] * SummerPeakHours + SummerOffGen[u][y] * SummerOffHours
			+ FallPeakGen[u][y] * FallPeakHours + FallOffGen[u][y] * FallOffHours) * N2O[u])
			+ ((WinterPeakGen[44][y] * WinterPeakHours + WinterOffGen[44][y] * WinterOffHours
			+ SpringPeakGen[44][y] * SpringPeakHours + SpringOffGen[44][y] * SpringOffHours
			+ SummerPeakGen[44][y] * SummerPeakHours + SummerOffGen[44][y] * SummerOffHours
			+ FallPeakGen[44][y] * FallPeakHours + FallOffGen[44][y] * FallOffHours) * N2O[44]);
	}		
  
  
		forall(u in ConvUnits)
		  {
		    (retrofit_decision[u] == 1) => (NOx[u] == NOx[u]*(1-retrofit_NOx_removal));
		    (retrofit_decision[u] == 1) => (SO2[u] == SO2[u]*(1-retrofit_SO2_removal));
		    (retrofit_decision[u] == 1) => (CO2[u] == CO2[u]*(1-retrofit_CO2_removal));
		  }
		  
//Meet demand       
   TotalPowerBalance:
    forall(y in Years) 
    { 
        sum(u in Units) WinterPeakGen[u][y] == sum(b in Buses) (WinterPeakDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision);
        sum(u in Units) WinterOffGen[u][y] == sum(b in Buses) (WinterOffDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision);
        sum(u in Units) SpringPeakGen[u][y] == sum(b in Buses) (SpringPeakDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision);
        sum(u in Units) SpringOffGen[u][y] == sum(b in Buses) (SpringOffDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision);
        sum(u in Units) SummerPeakGen[u][y] == sum(b in Buses) (SummerPeakDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision);
        sum(u in Units) SummerOffGen[u][y] == sum(b in Buses) (SummerOffDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision);
        sum(u in Units) FallPeakGen[u][y] == sum(b in Buses) (FallPeakDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision);
        sum(u in Units) FallOffGen[u][y] == sum(b in Buses) (FallOffDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision);
        
        //New Off-Peak balance that only looks at the possibility of generating
        //sum(u in Units) OffMaxGen[u] * on[u, y] >= sum(b in Buses) OffDemand[b][y];
    };		 	  	    
      
   BusPowerBalance:
    forall(y in Years)
    {
    	forall(b in Buses) 
    	{
    	  
    	  //Peak 
    	  sum(l in Lines) LineToBus[b][l]*WinterPeakFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*WinterPeakFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*WinterPeakGen[u,y] 
      	  - WinterPeakDemand[b,y]
      	  + fridge_eff_benefit[b][y] * fridge_eff_decision + led_eff_benefit[b][y] * led_eff_decision >= 0;
      	  
      	  //Off Peak
      	  sum(l in Lines) LineToBus[b][l]*WinterOffFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*WinterOffFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*WinterOffGen[u,y] 
      	  - WinterOffDemand[b,y]
      	  + fridge_eff_benefit[b][y] * fridge_eff_decision + led_eff_benefit[b][y] * led_eff_decision >= 0;
      	  
      	  //Peak 
    	  sum(l in Lines) LineToBus[b][l]*SpringPeakFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*SpringPeakFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*SpringPeakGen[u,y] 
      	  - SpringPeakDemand[b,y]
      	  + fridge_eff_benefit[b][y] * fridge_eff_decision + led_eff_benefit[b][y] * led_eff_decision >= 0;
      	  
      	  //Off Peak
      	  sum(l in Lines) LineToBus[b][l]*SpringOffFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*SpringOffFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*SpringOffGen[u,y] 
      	  - SpringOffDemand[b,y]
      	  + fridge_eff_benefit[b][y] * fridge_eff_decision + led_eff_benefit[b][y] * led_eff_decision >= 0;
      	  
      	  //Peak 
    	  sum(l in Lines) LineToBus[b][l]*SummerPeakFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*SummerPeakFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*SummerPeakGen[u,y] 
      	  - SummerPeakDemand[b,y]
      	  + fridge_eff_benefit[b][y] * fridge_eff_decision + led_eff_benefit[b][y] * led_eff_decision >= 0;
      	  
      	  //Off Peak
      	  sum(l in Lines) LineToBus[b][l]*SummerOffFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*SummerOffFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*SummerOffGen[u,y] 
      	  - SummerOffDemand[b,y]
      	  + fridge_eff_benefit[b][y] * fridge_eff_decision + led_eff_benefit[b][y] * led_eff_decision >= 0;
      	  
      	  //Peak 
    	  sum(l in Lines) LineToBus[b][l]*FallPeakFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*FallPeakFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*FallPeakGen[u,y] 
      	  - FallPeakDemand[b,y]
      	  + fridge_eff_benefit[b][y] * fridge_eff_decision + led_eff_benefit[b][y] * led_eff_decision >= 0;
      	  
      	  //Off Peak
      	  sum(l in Lines) LineToBus[b][l]*FallOffFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*FallOffFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*FallOffGen[u,y] 
      	  - FallOffDemand[b,y]
      	  + fridge_eff_benefit[b][y] * fridge_eff_decision + led_eff_benefit[b][y] * led_eff_decision >= 0;
    	};
    };        	
    	
//KVL around the loop
	KVLAroundTheLoop:
	 forall(y in Years)
	 {
		 sum(l in Lines)	LineReactance[l]*WinterPeakFlow[l,y] == 0;
		 sum(l in Lines)	LineReactance[l]*WinterOffFlow[l,y] == 0;
		 sum(l in Lines)	LineReactance[l]*SpringPeakFlow[l,y] == 0;
		 sum(l in Lines)	LineReactance[l]*SpringOffFlow[l,y] == 0;
		 sum(l in Lines)	LineReactance[l]*SummerPeakFlow[l,y] == 0;
		 sum(l in Lines)	LineReactance[l]*SummerOffFlow[l,y] == 0;
		 sum(l in Lines)	LineReactance[l]*FallPeakFlow[l,y] == 0;
		 sum(l in Lines)	LineReactance[l]*FallOffFlow[l,y] == 0;
     };		 
            
//Max/Min Unit Constraints   
	MaxGeneration:
	forall(y in Years)
	{
    	forall(u in Units){
    	    WinterPeakGen[u,y] <= WinterPeakMaxGen[u]*onWinPk[u,y]; //multiplied by binary variable to ensure it's switched on
    	    WinterOffGen[u,y] <= OffMaxGen[u] *onWinOffPk[u,y];
    	    SpringPeakGen[u,y] <= SpringPeakMaxGen[u] *onSprPk[u,y];
    	    SpringOffGen[u,y] <= OffMaxGen[u] *onSprOffPk[u,y];
    	    SummerPeakGen[u,y] <= SummerPeakMaxGen[u] *onSumPk[u,y];
    	    SummerOffGen[u,y] <= OffMaxGen[u] *onSumOffPk[u,y];
    	    FallPeakGen[u,y] <= FallPeakMaxGen[u] *onFallPk[u,y];
    	    FallOffGen[u,y] <= OffMaxGen[u] *onFallOffPk[u,y];
    	    
    	    //Logical constraints ensuring generators are switched off if they are not needed to generate power
    	    (WinterPeakGen[u,y] == 0) => (onWinPk[u,y] == 0);
    	    (WinterOffGen[u,y] == 0) => (onWinOffPk[u,y] == 0);
    	    (SpringPeakGen[u,y] == 0) => (onSprPk[u,y] == 0);
    	    (SpringOffGen[u,y] == 0) => (onSprOffPk[u,y] == 0);
    	    (SummerPeakGen[u,y] == 0) => (onSumPk[u,y] == 0);
    	    (SummerOffGen[u,y] == 0) => (onSumOffPk[u,y] == 0);
    	    (FallPeakGen[u,y] == 0) => (onFallPk[u,y] == 0);
    	    (FallOffGen[u,y] == 0) => (onFallOffPk[u,y] == 0);
       }    	    
    }
    
    
    //Currently ignores minimum generation constraints to avoid issues with unnecessary dispatch in seasons with lower loads
//    forall(y in Years)
//    {    
//    	forall(u in Units)
//    	  {
//      	    PeakMinGeneration:
//    	      WinterPeakGen[u,y] >= MinGen[u]*on[u,y];
//    	      WinterOffGen[u,y] >= MinGen[u]*on[u,y];
//    	      SpringPeakGen[u,y] >= MinGen[u]*on[u,y];
//    	      SpringOffGen[u,y] >= MinGen[u]*on[u,y];
//    	      SummerPeakGen[u,y] >= MinGen[u]*on[u,y];
//    	      SummerOffGen[u,y] >= MinGen[u]*on[u,y];
//    	      FallPeakGen[u,y] >= MinGen[u]*on[u,y];
//    	      FallOffGen[u,y] >= MinGen[u]*on[u,y];
//          }    	      
//    }   	    	

//Transmission Lines
	MaxFlow:
	forall(y in Years)
	{
		forall(l in Lines){
	  		WinterPeakFlow[l,y] <= LineCapacity[l];
	  		WinterOffFlow[l,y] <= LineCapacity[l];
	  		SpringPeakFlow[l,y] <= LineCapacity[l];
	  		SpringOffFlow[l,y] <= LineCapacity[l];
	  		SummerPeakFlow[l,y] <= LineCapacity[l];
	  		SummerOffFlow[l,y] <= LineCapacity[l];
	  		FallPeakFlow[l,y] <= LineCapacity[l];
	  		FallOffFlow[l,y] <= LineCapacity[l];
  		}	  	
    }	 
	  	
	MaxCounterFlow:
	forall(y in Years)
	{  	
		forall(l in Lines){
	  	  	WinterPeakFlow[l,y] >= -LineCapacity[l];
	  		WinterOffFlow[l,y] >= -LineCapacity[l];
	  		SpringPeakFlow[l,y] >= -LineCapacity[l];
	  		SpringOffFlow[l,y] >= -LineCapacity[l];
	  		SummerPeakFlow[l,y] >= -LineCapacity[l];
	  		SummerOffFlow[l,y] >= -LineCapacity[l];
	  		FallPeakFlow[l,y] >= -LineCapacity[l];
	  		FallOffFlow[l,y] >= -LineCapacity[l];
   		}    	
    }
    
    //New Conventional Generation
    forall(y in Years)
	  {   
    	MaxNGCCGen:
    	//not currently choosing to build NGCC - likely need to add emissions and ramping ability
    	  new_ngcc_cap[y] == sum(z in Years : z<=y - ngccBuildTime) bn_na[z] * ngcc_inc;
    	  (build_ngcc[y] == 1) => (bn_na[y] == ngcc_additions[y]);
    	  (build_ngcc[y] == 0) == (bn_na[y] == 0);
    	  
    	  WinterPeakGen[44][y] <= new_ngcc_cap[y] * ngcc_cap_factor;
    	  SpringPeakGen[44][y] <= new_ngcc_cap[y] * ngcc_cap_factor;
    	  SummerPeakGen[44][y] <= new_ngcc_cap[y] * ngcc_cap_factor;
    	  FallPeakGen[44][y] <= new_ngcc_cap[y] * ngcc_cap_factor;
    	  
    	  WinterOffGen[44][y] <= new_ngcc_cap[y] * ngcc_cap_factor;
    	  SpringOffGen[44][y] <= new_ngcc_cap[y] * ngcc_cap_factor;
    	  SummerOffGen[44][y] <= new_ngcc_cap[y] * ngcc_cap_factor;
    	  FallOffGen[44][y] <= new_ngcc_cap[y] * ngcc_cap_factor;
    	  
    	  ngcc_additions[y] >= 0;
    	  bn_na[y] >= 0;
	  }
    
//New Renewables Constraints 
	forall(y in Years)
	  {   
    	MaxSolarGen:
    	   //constrains new solar generation to be less than the total installed capacity up to that point
    	  new_solar_cap[y] == sum(z in Years : z<=y - SolarBuildTime) bs_sa[z] * solar_inc;
    	  (build_solar[y] == 1) => (bs_sa[y] == solar_additions[y]);
    	  (build_solar[y] == 0) => (bs_sa[y] == 0);
    	  (build_solar[y] == 0) => (solar_additions[y] == 0);
    	  (build_solar[y] == 1) => (solar_additions[y] >= 1);
    	  
    	  //Need to rework capacity factor for VERs
    	  WinterPeakGen[41][y] == new_solar_cap[y] * WinterSolarFactor;
    	  SpringPeakGen[41][y] == new_solar_cap[y] * SpringSolarFactor;
    	  SummerPeakGen[41][y] == new_solar_cap[y] * SummerSolarFactor;
    	  FallPeakGen[41][y] == new_solar_cap[y] * FallSolarFactor;
    	  
    	  //solar only needs to consider PeakGen, all OffMaxGen set to 0
    	  //WinterOffGen[41][y] == new_solar_cap[y] * WinterSolarFactor * solar_cap_factor;
    	  //SpringOffGen[41][y] == new_solar_cap[y] * SpringSolarFactor * solar_cap_factor;
    	  //SummerOffGen[41][y] == new_solar_cap[y] * SummerSolarFactor * solar_cap_factor;
    	  //FallOffGen[41][y] == new_solar_cap[y] * FallSolarFactor * solar_cap_factor;
    	  
    	  solar_additions[y] >= 0;
    	  bs_sa[y] >= 0;
	  }
	
	forall(y in Years)
	  {
	  	MaxWindGen: //constrains new wind generation to be less than the total installed capacity up to that point
	  	  new_wind_cap[y] == sum(z in Years : z<= y - WindBuildTime) bw_wa[z] * wind_inc;
    	  (build_wind[y] == 1) => (bw_wa[y] == wind_additions[y]);
    	  (build_wind[y] == 0) => (bw_wa[y] == 0);
    	  (build_wind[y] == 0) => (wind_additions[y] == 0);
    	  (build_wind[y] == 1) => (wind_additions[y] >= 1);
    	  
    	  WinterPeakGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  SpringPeakGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  SummerPeakGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  FallPeakGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  
    	  WinterOffGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  SpringOffGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  SummerOffGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  FallOffGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  
    	  new_wind_cap[y] <= 3000;
    	  wind_additions[y] >= 0;
    	  bw_wa[y] >= 0;
	  }

//Storage Constraints
	
	forall(y in Years)
	  {	  	
	  	MaxStorageGen:
		  new_storage_cap[y] == sum(z in Years : z<=y) bb_ba[z];
    	  (build_storage[y] == 1) => (bb_ba[y] == storage_additions[y]);
    	  (build_storage[y] == 0) => (bb_ba[y] == 0);
    	  (build_storage[y] == 0) => (storage_additions[y] == 0);
    	  (build_storage[y] == 1) => (storage_additions[y] >= 1);
    	  
//    	  WinterPeakGen[43][y] >= - new_storage_cap[y];
//    	  SpringPeakGen[43][y] >= - new_storage_cap[y];
//    	  SummerPeakGen[43][y] >= - new_storage_cap[y];
//    	  FallPeakGen[43][y] >= - new_storage_cap[y];
    	  
    	  WinterOffGen[43][y] <= new_storage_cap[y] * bat_eff;
    	  SpringOffGen[43][y] <= new_storage_cap[y] * bat_eff;
    	  SummerOffGen[43][y] <= new_storage_cap[y] * bat_eff;
    	  FallOffGen[43][y] <= new_storage_cap[y] * bat_eff;
    	  
    	  //constraint may need to be adjusted differently for seasonality
    	  //This constraint may be in conflict with efficiency-related losses -LFI
//    	  sum(y in Years) WinterPeakGen[43][y] * bat_eff + WinterOffGen[43][y] <= 0; //no free energy from discharging an empty battery
//    	  sum(y in Years) SpringPeakGen[43][y] * bat_eff + SpringOffGen[43][y] <= 0;
//    	  sum(y in Years) SummerPeakGen[43][y] * bat_eff + SummerOffGen[43][y] <= 0;
//    	  sum(y in Years) FallPeakGen[43][y] * bat_eff + FallOffGen[43][y] <= 0;
    	 
    	  storage_additions[y] >= 0;
    	  bb_ba[y] >= 0;
    	  new_storage_cap[y] <= 0.2 * new_solar_cap[y]; //storage capacity maxes out at 20% of new solar capacity
	  }
	  

//Ramping Constraint (only upheld for the peak and off-peak demand hours for each season)
	forall(y in Years)
	  {
		forall(u in Units)
	    {
	      WinterPeakGen[u,y] - WinterOffGen[u,y] <= RampRate[u] * onWinPk[u,y];
	      SpringPeakGen[u,y] - SpringOffGen[u,y] <= RampRate[u] * onSprPk[u,y];
	      SummerPeakGen[u,y] - SummerOffGen[u,y] <= RampRate[u] * onSumPk[u,y];
	      FallPeakGen[u,y] - FallOffGen[u,y] <= RampRate[u] * onFallPk[u,y];
	    };
	  }
    
//Emissions
	//Simplified emissions constraint - more efficient in solving than the 600lb average
	forall(y in Years: y>1)
	  {
		CO2_emissions:
	  	  CO2_total[y] <= CO2_total[y-1] * 0.9460576; //ends in the final year as 25% of the original amount (75% decrease)
	  	  
	  	  
	  	  //Carbon-free constraint, must run both of the next two lines
	  	  //((CO2_total[y] - (vehicle_CO2_no_subsidy*(1-EV_subsidy_decision)) - (vehicle_CO2_subsidy*EV_subsidy_decision)) * 0.2727) + (CH4_total[y] * 0.74868) <= (((CO2_total[y-1] - (vehicle_CO2_no_subsidy*(1-EV_subsidy_decision)) - (vehicle_CO2_subsidy*EV_subsidy_decision)) * 0.2727 * 0.9) + (CH4_total[y-1] * 0.74868 * 0.9)); //reduce carbon emissions annually to get to zero by 2045
	  	  
      }
      CarbonFree:
      	CO2_total[26] - (vehicle_CO2_no_subsidy*(1-EV_subsidy_decision)) - (vehicle_CO2_subsidy*EV_subsidy_decision) <= 0; //carbon-free goal (excluding transportation) 
    
    //EmissionsGoals:
    	//CO2_total[26] <= 0; //uncomment for carbon-free electricity
    	
    	//A10 prompt includes condition that GHG emissions from electricity not average above 600lbs/MWh over next 25 yrs
    	//600 >= sum(y in Years) sum(b in Buses) CO2_total[y] / (PeakDemand[b][y] * PeakHours + OffDemand[b][y] * OffHours);

//GHG Emissions Constraint    	 
	forall(y in Years: y>1)
	  {
		GHG_emissions:
	  	  (CO2_total[y]+CH4_total[y]*25+N2O_total[y]*298) <= (CO2_total[y-1]+CH4_total[y-1]*25+N2O_total[y-1]*298) * 0.9460576; //ends in the final year as 25% of the original amount (75% decrease)  	  
      }	
  
//Reserves 
//Need to have 15% more generation capacity available than the peak peak demand 
	forall(y in Years)
	{
 			sum(u in Units: u <= 40) WinterPeakMaxGen[u] + new_solar_cap[y] * WinterSolarFactor + new_wind_cap[y] * wind_cap_factor + new_storage_cap[y] + new_ngcc_cap[y] >= (sum(b in Buses) (WinterPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*1.15);
 			
 			sum(u in Units: u <= 40) SpringPeakMaxGen[u] + new_solar_cap[y] * SpringSolarFactor + new_wind_cap[y] * wind_cap_factor + new_storage_cap[y] + new_ngcc_cap[y] >= (sum(b in Buses) (SpringPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*1.15);
 			
 			sum(u in Units: u <= 40) SummerPeakMaxGen[u] + new_solar_cap[y] * SummerSolarFactor + new_wind_cap[y] * wind_cap_factor + new_storage_cap[y] + new_ngcc_cap[y] >= (sum(b in Buses) (SummerPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*1.15);
 			
 			sum(u in Units: u <= 40) FallPeakMaxGen[u] + new_solar_cap[y]  * FallSolarFactor + new_wind_cap[y] * wind_cap_factor + new_storage_cap[y] + new_ngcc_cap[y] >= (sum(b in Buses) (FallPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*1.15);
			
    }    	    
    

//Spinning Reserves 
//Need to have 5% of PV/wind production in spinning reserves 
//If no PV production, only 3% in spinning reserves  
    forall(y in Years)
	{
   	  	  //(var==1) => (Constraint)
  		(onWinPk[43,y] == 1)  => (sum(u in Units) (WinterPeakMaxGen[u]*onWinPk[u,y]-WinterPeakGen[u][y]) >= sum(b in Buses) (WinterPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*0.05);
  		(onSprPk[43,y] == 1)  => (sum(u in Units) (SpringPeakMaxGen[u]*onSprPk[u,y]-SpringPeakGen[u][y]) >= sum(b in Buses) (SpringPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*0.05);
  		(onSumPk[43,y] == 1)  => (sum(u in Units) (SummerPeakMaxGen[u]*onSumPk[u,y]-SummerPeakGen[u][y]) >= sum(b in Buses) (SummerPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*0.05);
  		(onFallPk[43,y] == 1)  => (sum(u in Units) (FallPeakMaxGen[u]*onFallPk[u,y]-FallPeakGen[u][y]) >= sum(b in Buses) (FallPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*0.05);
  		
  		(onWinPk[43,y] == 0)  => (sum(u in Units) (WinterPeakMaxGen[u]*onWinPk[u,y]-WinterPeakGen[u][y]) >= sum(b in Buses) (WinterPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*0.03);
  		(onSprPk[43,y] == 0)  => (sum(u in Units) (SpringPeakMaxGen[u]*onSprPk[u,y]-SpringPeakGen[u][y]) >= sum(b in Buses) (SpringPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*0.03);
  		(onSumPk[43,y] == 0)  => (sum(u in Units) (SummerPeakMaxGen[u]*onSumPk[u,y]-SummerPeakGen[u][y]) >= sum(b in Buses) (SummerPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*0.03);
  		(onFallPk[43,y] == 0)  => (sum(u in Units) (FallPeakMaxGen[u]*onFallPk[u,y]-FallPeakGen[u][y]) >= sum(b in Buses) (FallPPDemand[b][y] - fridge_eff_benefit[b][y] * fridge_eff_decision - led_eff_benefit[b][y] * led_eff_decision)*0.03);
//if we have solar generation capacity in a given year		
	}
		
}
