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
float OffMaxGen [Units] = ...; //Unit Maximum Generation during off-peak hours (MW)
float MinGen [Units] = ...; //Unit Minimum Generation (MW)
float MarginalC[Units] = ...; //Unit Marginal Cost of Energy ($/MWh)
float NOx [Units] = ...; //NOx Emissions by generator (lb/MWh)
float SO2 [Units] = ...; //SO2 Emissions by generator (lb/MWh)
float CO2 [Units] = ...; //CO2 Emissions by generator (lb/MWh)
float CH4 [Units] = ...; //CH4 Emissions by generator (lb/MWh)
float N2O [Units] = ...; //N2O Emissions by generator (lb/MWh)

float capex_solar = ...; //Capital Cost of a solar project ($)
float opex_solar = ...; //Annual O&M Cost of new solar ($/MW)
float capex_wind = ...; //Capital Cost of a wind project ($)
float opex_wind = ...; //Annual O&M Cost of new wind ($/MW)
float solar_inc = ...; //Incremental amount of solar that can be built (MW)
float wind_inc = ...; //Incremental amount of wind that can be built (MW)
float solar_cap_factor = ...; //How much of the installed solar capacity will be generated at this hour in the year
float wind_cap_factor = ...; //How much of the installed wind capacity will be generated at this hour in the year

float WinterSolarFactor = ...; //Amount of solar capacity available during peak hours in the winter
float SpringSolarFactor = ...;
float SummerSolarFactor = ...;
float FallSolarFactor = ...;

float EV_subsidy_cost = ...; //Capital cost to subsidize 20% of EV costs

//Optimization Parameters
float DiscRate = ...; //Discount Rate for NPV calculations
float maxCO2 = ...; //Maximum 2045 CO2 emissions

//Decision Variables
dvar float+ WinterPeakGen [u in Units, y in Years] in 0..WinterPeakMaxGen[u]; //Peak Generation for each Unit (MW)
//Need to change the minimum of PeakGen to allow batteries to charge
dvar float+ WinterOffGen [u in Units, y in Years] in 0..OffMaxGen[u];
dvar float WinterPeakFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar float WinterOffFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)

dvar float+ SpringPeakGen [u in Units, y in Years] in 0..SpringPeakMaxGen[u];
dvar float+ SpringOffGen [u in Units, y in Years] in 0..OffMaxGen[u];
dvar float SpringPeakFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar float SpringOffFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)dvar float+ SummerPeakGen [u in Units, y in Years] in 0..OffMaxGen[u];

dvar float+ SummerPeakGen [u in Units, y in Years] in 0..SummerPeakMaxGen[u];
dvar float+ SummerOffGen [u in Units, y in Years] in 0..OffMaxGen[u];
dvar float SummerPeakFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar float SummerOffFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)

dvar float+ FallPeakGen [u in Units, y in Years] in 0..FallPeakMaxGen[u];
dvar float+ FallOffGen [u in Units, y in Years] in 0..OffMaxGen[u];
dvar float FallPeakFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar float FallOffFlow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)

//The "on" variable may need to be adjusted to mean whether a plant is active for a set of years
dvar boolean on[u in Units, y in Years];

dvar float objective [y in Years]; //objective function set as a decision variable
//dvar float NOx_total [y in Years]; //Emissions decision variables (only CO2 is constrained so far)
//dvar float SO2_total [y in Years];
dvar float CO2_total [y in Years];
//dvar float CH4_total [y in Years];
//dvar float N2O_total [y in Years];

dvar boolean build_solar [y in Years]; //binary decision for whether or not to build solar in a given year
dvar int solar_additions [y in Years] in 0..10000; //number of solar modules that will be built (multiplied by solar_inc to get total capacity)
dvar boolean build_wind [y in Years]; //binary decision for whether or not to build solar in a given year
dvar int wind_additions [y in Years] in 0..10000; //number of wind modules that will be built (multiplied by wind_inc to get total capacity)
dvar float new_solar_cap [y in Years];
dvar float new_wind_cap [y in Years];
dvar int bs_sa [y in Years]; //logical int for linearizing MILP build constraints
dvar int bw_wa [y in Years]; //logical int for linearizing MILP build constraints

dvar boolean EV_subsidy_decision; //binary decision for whether or not to instate 20% EV capital cost subsidy

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
	    objective[y] == (1/((1+DiscRate)^y))*((sum(u in Units) WinterPeakGen[u][y] * MarginalC[u] /* PeakHours*/)
	    	+ (sum(u in Units) WinterOffGen[u][y] * MarginalC[u] /* OffHours*/)
	    	+ (sum(u in Units) SpringPeakGen[u][y] * MarginalC[u])
	    	+ (sum(u in Units) SpringOffGen[u][y] * MarginalC[u])
	    	+ (sum(u in Units) SummerPeakGen[u][y] * MarginalC[u])
	    	+ (sum(u in Units) SummerOffGen[u][y] * MarginalC[u])
	    	+ (sum(u in Units) FallPeakGen[u][y] * MarginalC[u])
	    	+ (sum(u in Units) FallOffGen[u][y] * MarginalC[u])
	    	+ (capex_solar * bs_sa[y]) + (new_solar_cap[y] * opex_solar)
	    		+ (capex_wind * bw_wa[y]) + (new_wind_cap[y] * opex_wind))
	    			+ (EV_subsidy_cost*EV_subsidy_decision);
    }	   
    
    forall(y in Years) //Emissions are summed up for output file
    { 		
		//Need to be revised after seasons are completely added 
		//NOx_total[y] == sum(u in Units) (PeakGen[u][y] * PeakHours /*+ OffGen[u][y] * OffHours*/) * NOx[u];
		//SO2_total[y] == sum(u in Units) (PeakGen[u][y] * PeakHours /*+ OffGen[u][y] * OffHours*/) * SO2[u];
		CO2_total[y] == sum(u in Units) (WinterPeakGen[u][y] * WinterPeakHours + WinterOffGen[u][y] * WinterOffHours
			+ SpringPeakGen[u][y] * SpringPeakHours + SpringOffGen[u][y] * SpringOffHours
			+ SummerPeakGen[u][y] * SummerPeakHours + SummerOffGen[u][y] * SummerOffHours
			+ FallPeakGen[u][y] * FallPeakHours + FallOffGen[u][y] * FallOffHours) * CO2[u];
		//CH4_total[y] == sum(u in Units) (PeakGen[u][y] * PeakHours /*+ OffGen[u][y] * OffHours*/) * CH4[u];
		//N2O_total[y] == sum(u in Units) (PeakGen[u][y] * PeakHours /*+ OffGen[u][y] * OffHours*/) * N2O[u];
	}		
  
//Meet demand       
   TotalPowerBalance:
    forall(y in Years) 
    { 
        sum(u in Units) WinterPeakGen[u][y] == sum(b in Buses) WinterPeakDemand[b][y];
        sum(u in Units) WinterOffGen[u][y] == sum(b in Buses) WinterOffDemand[b][y];
        sum(u in Units) SpringPeakGen[u][y] == sum(b in Buses) SpringPeakDemand[b][y];
        sum(u in Units) SpringOffGen[u][y] == sum(b in Buses) SpringOffDemand[b][y];
        sum(u in Units) SummerPeakGen[u][y] == sum(b in Buses) SummerPeakDemand[b][y];
        sum(u in Units) SummerOffGen[u][y] == sum(b in Buses) SummerOffDemand[b][y];
        sum(u in Units) FallPeakGen[u][y] == sum(b in Buses) FallPeakDemand[b][y];
        sum(u in Units) FallOffGen[u][y] == sum(b in Buses) FallOffDemand[b][y];
        
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
      	  - WinterPeakDemand[b,y] >= 0;
      	  
      	  //Off Peak
      	  sum(l in Lines) LineToBus[b][l]*WinterOffFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*WinterOffFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*WinterOffGen[u,y] 
      	  - WinterOffDemand[b,y] >= 0;
      	  
      	  //Peak 
    	  sum(l in Lines) LineToBus[b][l]*SpringPeakFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*SpringPeakFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*SpringPeakGen[u,y] 
      	  - SpringPeakDemand[b,y] >= 0;
      	  
      	  //Off Peak
      	  sum(l in Lines) LineToBus[b][l]*SpringOffFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*SpringOffFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*SpringOffGen[u,y] 
      	  - SpringOffDemand[b,y] >= 0;
      	  
      	  //Peak 
    	  sum(l in Lines) LineToBus[b][l]*SummerPeakFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*SummerPeakFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*SummerPeakGen[u,y] 
      	  - SummerPeakDemand[b,y] >= 0;
      	  
      	  //Off Peak
      	  sum(l in Lines) LineToBus[b][l]*SummerOffFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*SummerOffFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*SummerOffGen[u,y] 
      	  - SummerOffDemand[b,y] >= 0;
      	  
      	  //Peak 
    	  sum(l in Lines) LineToBus[b][l]*FallPeakFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*FallPeakFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*FallPeakGen[u,y] 
      	  - FallPeakDemand[b,y] >= 0;
      	  
      	  //Off Peak
      	  sum(l in Lines) LineToBus[b][l]*FallOffFlow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*FallOffFlow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*FallOffGen[u,y] 
      	  - FallOffDemand[b,y] >= 0;
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
    	    WinterPeakGen[u,y] <= WinterPeakMaxGen[u]*on[u,y]; //multiplied by binary variable to ensure it's switched on
    	    WinterOffGen[u,y] <= OffMaxGen[u] *on[u,y];
    	    SpringPeakGen[u,y] <= SpringPeakMaxGen[u] *on[u,y];
    	    SpringOffGen[u,y] <= OffMaxGen[u] *on[u,y];
    	    SummerPeakGen[u,y] <= SummerPeakMaxGen[u] *on[u,y];
    	    SummerOffGen[u,y] <= OffMaxGen[u] *on[u,y];
    	    FallPeakGen[u,y] <= FallPeakMaxGen[u] *on[u,y];
    	    FallOffGen[u,y] <= OffMaxGen[u] *on[u,y];
       }    	    
    }
    
    
    /* Currently ignores minimum generation constraints to avoid issues with unnecseeary dispatch in seasons with lower loads
    forall(y in Years)
    {    
    	forall(u in Units)
      	  PeakMinGeneration:
    	    PeakGen[u,y] >= MinGen[u]*on[u,y];
    	    
    	//forall(u in Units)
      	//  OffMinGeneration:
    	//    OffGen[u,y] >= MinGen[u]* on[u,y];
    } */   	    	
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
    
//New Renewables Constraints 
	forall(y in Years)
	{   
    	MaxSolarGen:
    	   //constrains new solar generation to be less than the total installed capacity up to that point
    	   //solar only needs to consider PeakGen, all OffMaxGen set to 0
    	  new_solar_cap[y] == sum(z in Years : z<=y) bs_sa[z] * solar_inc;
    	  (build_solar[y] == 1) => (bs_sa[y] == solar_additions[y]);
    	  (build_solar[y] == 0) == (bs_sa[y] == 0);
    	  
    	  //Need to rework capacity factor for VERs
    	  WinterPeakGen[41][y] <= new_solar_cap[y] * solar_cap_factor * WinterSolarFactor;
    	  SpringPeakGen[41][y] <= new_solar_cap[y] * solar_cap_factor * SpringSolarFactor;
    	  SummerPeakGen[41][y] <= new_solar_cap[y] * solar_cap_factor * SummerSolarFactor;
    	  FallPeakGen[41][y] <= new_solar_cap[y] * solar_cap_factor * FallSolarFactor;
    	  
    	  solar_additions[y] >= 0;
    	  bs_sa[y] >= 0;
	}
	
	forall(y in Years)
	{
	  	MaxWindGen: //constrains new wind generation to be less than the total installed capacity up to that point
	  	  new_wind_cap[y] == sum(z in Years : z<=y) bw_wa[z] * wind_inc;
    	  (build_wind[y] == 1) => (bw_wa[y] == wind_additions[y]);
    	  (build_wind[y] == 0) == (bw_wa[y] == 0);
    	  
    	  WinterPeakGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  SpringPeakGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  SummerPeakGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  FallPeakGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  
    	  WinterOffGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  SpringOffGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  SummerOffGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  FallOffGen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  
    	  wind_additions[y] >= 0;
    	  bw_wa[y] >= 0;
	}
	
	//sum(y in Years) build_solar[y] <= 5;    
    
//Emissions
	//Simplified emissions constraiton - more efficient in solving than the 600lb average
	forall(y in Years: y>1)
	{
		CO2_emissions:
	  	  CO2_total[y] <= CO2_total[y-1] * 0.9460576;
	  	  
    }	  
    
    
    //EmissionsGoals:
    	//CO2_total[26] == 0; //uncomment for carbon-free electricity
    	
    	//A10 prompt includes condition that GHG emissions from electricity not average above 600lbs/MWh over next 25 yrs
    	//600 >= sum(y in Years) sum(b in Buses) CO2_total[y] / (PeakDemand[b][y] * PeakHours + OffDemand[b][y] * OffHours);
    	 
  
//Reserves 
//Need to have 15% more generation capacity available than the peak peak demand 
	forall(y in Years)
	{
 			sum(u in Units) WinterPeakMaxGen[u]*on[u,y] >= sum(b in Buses) WinterPPDemand[b][y]*1.15;
 			
 			sum(u in Units) SpringPeakMaxGen[u]*on[u,y] >= sum(b in Buses) SpringPPDemand[b][y]*1.15;
 			
 			sum(u in Units) SummerPeakMaxGen[u]*on[u,y] >= sum(b in Buses) SummerPPDemand[b][y]*1.15;
 			
 			sum(u in Units) FallPeakMaxGen[u]*on[u,y] >= sum(b in Buses) FallPPDemand[b][y]*1.15;
			
       }    	    
    
/*
//Spinning Reserves 
//Need to have 5% of PV/wind production in spinning reserves 
//If no PV production, only 3% in spinning reserves  
    forall(y in Years)
	{
   	  	  //(var==1) => (Constraint)
  		(on[43,y] == 0)  =>
  		(
  		sum(u in Units) (WinterPeakMaxGen[u]*on[u,y]-WinterPeakGen[u][y]*on[u,y]) >= sum(b in Buses) WinterPPDemand[b][y]*1.05 && //if we have solar generation capacity in a given year
  		sum(u in Units) (SpringPeakMaxGen[u]*on[u,y]-SpringPeakGen[u][y]*on[u,y]) >= sum(b in Buses) SpringPPDemand[b][y]*1.05 &&
  		sum(u in Units) (SummerPeakMaxGen[u]*on[u,y]-SummerPeakGen[u][y]*on[u,y]) >= sum(b in Buses) SummerPPDemand[b][y]*1.05 &&			
  		sum(u in Units) (FallPeakMaxGen[u]*on[u,y]-FallPeakGen[u][y]*on[u,y]) >= sum(b in Buses) FallPPDemand[b][y]*1.05
		)
	};

    forall(y in Years)
	{
   	  	  //(var==1) => (Constraint)
  		(on[43,y] == 0)  =>
  		(
  		sum(u in Units) WinterPeakMaxGen[u]*on[u,y]-WinterPeakGen[u][y]*on[u,y] >= sum(b in Buses) WinterPPDemand[b][y]*1.03 && //if we have solar generation capacity in a given year
  		sum(u in Units) SpringPeakMaxGen[u]*on[u,y]-SpringPeakGen[u][y]*on[u,y] >= sum(b in Buses) SpringPPDemand[b][y]*1.03 &&
  		sum(u in Units) SummerPeakMaxGen[u]*on[u,y]-SummerPeakGen[u][y]*on[u,y] >= sum(b in Buses) SummerPPDemand[b][y]*1.03 &&  			
  		sum(u in Units) FallPeakMaxGen[u]*on[u,y]-FallPeakGen[u][y]*on[u,y] >= sum(b in Buses) FallPPDemand[b][y]*1.03   			   
		)
	};

*/		
}
