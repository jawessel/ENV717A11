/*********************************************
 * OPL 12.10.0.0 Model
 * Author: jawessel
 * Creation Date: Apr 16, 2020 at 3:57:31 PM
 *********************************************/
//Simulate NicISO Power System to calculate LMPs, diagnose system deficiencies, and offer direction for system improvements.

int NumBuses = ...; //Number of buses
int NumLines = ...; //Number of transmission lines
int NumUnits = ...; //Number of generating units

range Buses = 1..NumBuses;
range Lines = 1..NumLines;
range Units = 1..NumUnits;

//Demand (Load)
float Demand [Buses] = ...; //Demand (MW) for each bus
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

//Decision Variables
dvar float+ Gen [u in Units] in 0..MaxGen [u]; //Generation for each Unit (MW)
dvar float Flow[l in Lines] in -LineCapacity[l]..LineCapacity[l]; //Flow on Each Transmission Line (MW)

//Objective Function
minimize 
  sum(u in Units) (Gen[u] * MarginalC[u]);   //Minimize Energy Costs
  

//Constraints
subject to {
//Meet demand       
   TotalPowerBalance: 
    sum(u in Units) Gen[u] == sum(b in Buses) Demand[b];
      
   BusPowerBalance:
    forall(b in Buses) 
    { sum(l in Lines) LineToBus[b][l]*Flow[l] 
      - sum(l in Lines) LineFromBus[b][l]*Flow[l] 
      +sum(u in Units) UnitsByBus[b][u]*Gen[u] 
      -Demand[b] >= 0;
    };    	
    	
//KVL around the loop
	KVLAroundTheLoop:
	sum(l in Lines)	LineReactance[l]*Flow[l] == 0;
            
//Max/Min Unit Constraints           
    forall(u in Units)
      MaxGeneration:
    	    Gen[u] <= MaxGen[u];
        
    forall(u in Units)
      MinGeneration:
    	    Gen[u] >= MinGen[u];

//Transmission Lines
	forall(l in Lines)
	  MaxFlow:
	  	Flow[l] <= LineCapacity[l];
	  	
	forall(l in Lines)
	  MaxCounterFlow:
	  	Flow[l] >= -LineCapacity[l];	
}  