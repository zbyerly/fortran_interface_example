module global_data
  integer, parameter :: MAX_NEIGHBORS = 10
  integer, parameter :: MAX_DOMAIN_NEIGHBORS = 10
  integer, parameter :: MAX_BOUNDARY_SIZE = 20
  type global_type
     integer :: id
     integer :: NE, NP
     real(8), allocatable, dimension(:) :: X
     real(8), allocatable, dimension(:) :: Y
     real(8), allocatable, dimension(:) :: DP
     integer, allocatable, dimension(:) :: NNEIGH
     integer, allocatable, dimension(:,:) :: NEIGH
     INTEGER, allocatable, dimension(:,:) :: NM

     integer, allocatable, dimension(:) :: ALIVE
     integer, allocatable, dimension(:) :: NEW_ALIVE

     ! IO stuff
     CHARACTER*6 :: DIRNAME
     INTEGER :: unit18
     INTEGER :: unit14

     ! message passing stuff
     INTEGER :: NEIGHPROC
     logical, allocatable :: resnode(:)
     INTEGER, ALLOCATABLE :: NNODRECV(:),IRECVLOC(:,:)
     INTEGER, ALLOCATABLE :: IPROC(:), NNODELOC(:)
     INTEGER, ALLOCATABLE :: NNODSEND(:), IBELONGTO(:),ISENDLOC(:,:)
     INTEGER, ALLOCATABLE :: ISENDBUF(:,:), IRECVBUF(:,:)
     INTEGER, ALLOCATABLE :: INDX(:)


  end type global_type
end module global_data


module global
  use global_data

  interface
    subroutine init(id, g)
      use global_data
      integer :: id
      type(global_type), pointer :: g
    end subroutine
  end interface

  interface
    subroutine print(g, timestep)
      use global_data
      type(global_type), pointer :: g
      integer :: timestep
    end subroutine
  end interface
 
  interface
    subroutine update(timestep, g)
      use global_data
      type(global_type), pointer :: g
      integer :: timestep
    end subroutine
  end interface

  interface
    subroutine term(g)
      use global_data
      type(global_type), pointer :: g
    end subroutine
  end interface

  interface
     subroutine get_neighbors(numneighbors,neighbors,g)
       use global_data
       type(global_type), pointer :: g
       integer :: numneighbors
       integer :: neighbors(MAX_DOMAIN_NEIGHBORS)
     end subroutine
  end interface

  interface
     subroutine get_outgoing_nodes(g,neighbor,num_nodes,alives)
       use global_data
       type(global_type), pointer :: g
       integer :: neighbor
       integer, intent(out) :: num_nodes
       integer :: alives(MAX_BOUNDARY_SIZE)
     end subroutine
  end interface

  interface
     subroutine put_incoming_nodes(g,neighbor,num_nodes,alives)
       use global_data
       type(global_type), pointer :: g
       integer :: neighbor
       integer :: num_nodes
       integer :: alives(MAX_BOUNDARY_SIZE)
     end subroutine
  end interface

end module global


