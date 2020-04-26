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

//Decision Variables
dvar float+ Gen [u in Units, y in Years] in 0..MaxGen [u]; //Generation for each Unit (MW)
dvar float Flow[l in Lines, y in Years] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)
dvar boolean on[u in Units, y in Years];
dvar float objective;
dvar float NOx_total;
dvar float SO2_total;
dvar float CO2_total;
dvar float CH4_total;
dvar float N2O_total;

//Objective Function
minimize 
  sum(u in Units) sum(y in Years) Gen[u][y] * MarginalC[u];   //Minimize Energy Costs

//Constraints
subject to {
  
//Assign obj function and emissions values to variables
	Objective:
	objective == sum(u in Units) sum(y in Years) Gen[u][y] * MarginalC[u];
	NOx_total == sum(u in Units) sum(y in Years) Gen[u][y] * NOx[u];
	SO2_total == sum(u in Units) sum(y in Years) Gen[u][y] * SO2[u];
	CO2_total == sum(u in Units) sum(y in Years) Gen[u][y] * CO2[u];
	CH4_total == sum(u in Units) sum(y in Years) Gen[u][y] * CH4[u];
	N2O_total == sum(u in Units) sum(y in Years) Gen[u][y] * N2O[u];
  
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
    	    Gen[u,y] <= MaxGen[u]*on[u,y];
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
    	  			
}  