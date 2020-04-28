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
float Demand [Buses][Years] = ...; //Demand (MW) for each bus
int LineToBus [Buses][Lines]=...; //Define lines by their start and end points
int LineFromBus [Buses][Lines]=...;
int UnitsByBus [Buses][Units]=...; //Number of generating units in each bus

//Transmission Line Physics
float LineReactance[Lines]=...;
float LineCapacity[Lines]=...;

//Generator Parameters
float MaxGen [Units] = ...; //Unit Maximum Generation (MW)
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

float EV_subsidy_cost = ...; //Capital cost to subsidize 20% of EV costs

//Optimization Parameters
float DiscRate = ...; //Discount Rate for NPV calculations
float maxCO2 = ...; //Maximum 2045 CO2 emissions

//Decision Variables
dvar float+ Gen [u in Units, y in Years] in 0..MaxGen [u]; //Generation for each Unit (MW)
dvar float Flow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar boolean on[u in Units, y in Years];
dvar float objective [y in Years]; //objective function set as a decision variable
dvar float NOx_total [y in Years]; //Emissions decision variables (only CO2 is constrained so far)
dvar float SO2_total [y in Years];
dvar float CO2_total [y in Years];
dvar float CH4_total [y in Years];
dvar float N2O_total [y in Years];

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
	{	//Total cost is calculated here
	    objective[y] == (1/((1+DiscRate)^y))*((sum(u in Units) Gen[u][y] * MarginalC[u])
	    	+ (capex_solar * build_solar[y]) + (new_solar_cap[y] * opex_solar)
	    		+ (capex_wind * build_wind[y]) + (new_wind_cap[y] * opex_wind))
	    			+ (EV_subsidy_cost*EV_subsidy_decision);
    }	   
    
    forall(y in Years) //Emissions are summed up for output file
    { 		
		NOx_total[y] == sum(u in Units) Gen[u][y] * NOx[u];
		SO2_total[y] == sum(u in Units) Gen[u][y] * SO2[u];
		CO2_total[y] == sum(u in Units) Gen[u][y] * CO2[u];
		CH4_total[y] == sum(u in Units) Gen[u][y] * CH4[u];
		N2O_total[y] == sum(u in Units) Gen[u][y] * N2O[u];
	}		
  
//Meet demand       
   TotalPowerBalance:
    forall(y in Years) 
    { 
        sum(u in Units) Gen[u][y] == sum(b in Buses) Demand[b][y];
    };		 	  	    
      
   BusPowerBalance:
    forall(y in Years)
    {
    	forall(b in Buses) 
    	{
    	  
    	  sum(l in Lines) LineToBus[b][l]*Flow[l,y] 
      	  - sum(l in Lines) LineFromBus[b][l]*Flow[l,y] 
      	  +sum(u in Units) UnitsByBus[b][u]*Gen[u,y] 
      	  - Demand[b,y] >= 0;
    	};
    };        	
    	
//KVL around the loop
	KVLAroundTheLoop:
	 forall(y in Years)
	 {
		 sum(l in Lines)	LineReactance[l]*Flow[l,y] == 0;
     };		 
            
//Max/Min Unit Constraints   
	forall(y in Years)
	{
    	forall(u in Units)
      	  MaxGeneration:
    	    Gen[u,y] <= MaxGen[u]*on[u,y]; //multiplied by binary variable to ensure it's switched on
    }
    
    forall(y in Years)
    {    
    	forall(u in Units)
      	  MinGeneration:
    	    Gen[u,y] >= MinGen[u]*on[u,y];
    }    	    	

//Transmission Lines
	forall(y in Years)
	{
		forall(l in Lines)
	  	  MaxFlow:
	  		Flow[l,y] <= LineCapacity[l];
    }	 
	  	
	forall(y in Years)
	{  	
		forall(l in Lines)
	  	  MaxCounterFlow:
	  		Flow[l,y] >= -LineCapacity[l];
    }
    
//New Renewables Constraints 
	forall(y in Years)
	{   
    	MaxSolarGen:
    	   //constrains new solar generation to be less than the total installed capacity up to that point
    	  new_solar_cap[y] == sum(z in Years : z<=y) bs_sa[z] * solar_inc;
    	  (build_solar[y] == 1) => (bs_sa[y] == solar_additions[y]);
    	  (build_solar[y] == 0) => (bs_sa[y] == 0);
    	  Gen[41][y] <= new_solar_cap[y] * solar_cap_factor;
    	  solar_additions[y] >= 0;
    	  bs_sa[y] >= 0;
	}
	
	forall(y in Years)
	{
	  	MaxWindGen: //constrains new wind generation to be less than the total installed capacity up to that point
	  	  new_wind_cap[y] == sum(z in Years : z<=y) bw_wa[z] * wind_inc;
    	  (build_wind[y] == 1) => (bw_wa[y] == wind_additions[y]);
    	  (build_wind[y] == 0) => (bw_wa[y] == 0);
    	  Gen[42][y] <= new_wind_cap[y] * wind_cap_factor;
    	  wind_additions[y] >= 0;
    	  bw_wa[y] >= 0;
	}
	
	//sum(y in Years) build_solar[y] <= 5;    
    

//Emissions
	forall(y in Years: y>1)
	{
		CO2_emissions:
	  	  CO2_total[y] <= CO2_total[y-1] * 0.9460576;
	  	  
	  	  //CO2_total[26] == 0; //uncomment for carbon-free electricity
    }	  	 
}  