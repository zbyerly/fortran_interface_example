#include <iostream>
#include "fname.h"
#include <vector>

#define MAX_DOMAIN_NEIGHBORS 10
#define MAX_BOUNDARY_SIZE 20


// Forward declarations of FORTRAN subroutines
extern"C" {
  void FNAME(init_fort)(int *n, void** global);
  void FNAME(print_fort)(void** global, int* timestep);
  void FNAME(update_fort)(int *n, void** global);
  void FNAME(term_fort)(void** global);
  void FNAME(get_neighbors_fort)(int *numneighbors,
				 int neighbors[MAX_DOMAIN_NEIGHBORS],
				 void** global 		      	
				 );
  void FNAME(get_outgoing_nodes_fort)(
				      void** global,
				      int* neighbor,
				      int* num_nodes,
				      int alive[MAX_DOMAIN_NEIGHBORS]
				 );
  void FNAME(put_incoming_nodes_fort)(
				      void** global,
				      int* neighbor,
				      int* num_nodes,
				      int alive[MAX_DOMAIN_NEIGHBORS]
				 );
}

int main(
	 int argc
	 , char* argv[]
	 )
{

  std::vector<void *> domains;
  std::vector<int> ids;

  std::vector<int> numneighbors;
  std::vector<std::vector<int> > neighbors;

  int n_domains = 32;
  int n_timesteps = 100;

  // Create vectors of domain pointers and ids
  for(int i=0; i<n_domains; i++){
    void *domain = NULL;
    ids.push_back(i);
    domains.push_back(domain);
  }

  // Initialize all domains
  for(int i=0; i<domains.size(); i++) {
    FNAME(init_fort)(&ids[i],&domains[i]);
  }

  // Get list of neighbors from FORTRAN side of each domain
  for(int i=0; i<domains.size(); i++) {    
    int numneighbors_fort;
    int neighbors_fort[MAX_DOMAIN_NEIGHBORS];
    std::vector<int> neighbors_here;

    FNAME(get_neighbors_fort)(&numneighbors_fort,neighbors_fort,&domains[i]);
    numneighbors.push_back(numneighbors_fort);

    for (int j=0; j<numneighbors_fort; j++) {
      std::cout << neighbors_fort[j] << " ";
      neighbors_here.push_back(neighbors_fort[j]);
    }
    std::cout << std::endl;

    neighbors.push_back(neighbors_here);    
    
  }
  
  // Print out some information about the domains and their neighbors
  std::cout << "*** Grid Information ***" << std::endl;
  std::cout << "domains.size() = " << domains.size() << std::endl;
  std::cout << "numneighbors.size() = " << numneighbors.size() << std::endl;
  for (int domain=0; domain<numneighbors.size(); domain++) {
    std::cout << "numneighbors[" << domain << "] = " << numneighbors[domain] << std::endl;
    std::cout << "neighbors: ";
    std::vector<int> neighbors_here = neighbors[domain];
    for (int neighbor=0; neighbor<numneighbors[domain]; neighbor++) {      
      std::cout << neighbors_here[neighbor] << " ";
    }
    std::cout << std::endl;
  }

  std::cout << "*** End Grid Information ***" << std::endl;

  // Print initial state as timestep 0
  int zero = 0;
  for(int i=0; i<domains.size(); i++) {
    FNAME(print_fort)(&domains[i], &zero);    
  }


  // Start timestepping loop
  for(int timestep=1; timestep<=n_timesteps; timestep++) {
    
    // Update values using Game of Life rules
    // Loop over all domains 
    for (int j=0; j<domains.size(); j++) {      
      FNAME(update_fort)(&timestep,&domains[j]);
    } // End loop over domains
    
    // Boundary exchange
    // Loop over domains   
    for (int domain=0; domain<domains.size(); domain++) {
      std::vector<int> neighbors_here = neighbors[domain];

      //Loop over neighbors
      for (int neighbor=0; neighbor<numneighbors[domain]; neighbor++) {	
	int neighbor_here = neighbors_here[neighbor];
	int num_nodes;
	int alive[MAX_BOUNDARY_SIZE];

	// Get outgoing boundarys from the neighbors
	FNAME(get_outgoing_nodes_fort)(&domains[neighbor_here],&domain,&num_nodes,alive);

	// Put those arrays inside current domain
	FNAME(put_incoming_nodes_fort)(&domains[domain],&neighbor_here,&num_nodes,alive);	

      }// end loop over neighbors
      
    }// end loop over domains

    // Print domains
    for(int i=0; i<domains.size(); i++) {
      FNAME(print_fort)(&domains[i], &timestep);    
    }
    
  } // end timestep loop

  // Deallocate domains
  for(int i=0; i<domains.size(); i++) {
    FNAME(term_fort)(&domains[i]);
  }
  
  return 0;
}

