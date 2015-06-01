! %%%%%%%%%%%%%%%%%%% c wrappers %%%%%%%%%%%%%%%%%%%%%%%

subroutine init_fort(id, global_c_ptr)
  use, intrinsic :: iso_c_binding
  use global
  implicit none

  integer :: id
  type (C_PTR), intent(out) :: global_c_ptr
  type (global_type), pointer :: gdata

  call init(id, gdata)

  global_c_ptr = C_LOC(gdata)

end subroutine init_fort

subroutine print_fort(global_c_ptr, timestep)
  use, intrinsic :: iso_c_binding
  use global
  implicit none

  type (C_PTR) :: global_c_ptr
  type (global_type), pointer :: g
  integer :: timestep

  call C_F_POINTER(global_c_ptr,g)

  call print(g, timestep)

end subroutine print_fort

subroutine update_fort(timestep, global_c_ptr)
  use, intrinsic :: iso_c_binding
  use global
  implicit none

  type (C_PTR) :: global_c_ptr
  type (global_type), pointer :: g
  integer :: timestep

  call C_F_POINTER(global_c_ptr,g)

  call update(timestep, g)

  global_c_ptr = C_LOC(g)

end subroutine update_fort

subroutine term_fort(global_c_ptr)
  use, intrinsic :: iso_c_binding
  use global
  implicit none

  type (C_PTR) :: global_c_ptr
  type (global_type), pointer :: gdata

  call C_F_POINTER(global_c_ptr, gdata)
  call term(gdata)

end subroutine term_fort

subroutine get_neighbors_fort(numneighbors, neighbors, global_c_ptr)
  use, intrinsic :: iso_c_binding
  use global
  implicit none

  type (C_PTR) :: global_c_ptr
  type (global_type), pointer :: gdata
  integer :: numneighbors
  integer :: neighbors(MAX_DOMAIN_NEIGHBORS)

  call C_F_POINTER(global_c_ptr, gdata)
  call get_neighbors(numneighbors, neighbors, gdata)

end subroutine get_neighbors_fort

subroutine get_outgoing_nodes_fort(global_c_ptr, neighbor, num_nodes, alives)
  use, intrinsic :: iso_c_binding
  use global
  implicit none

  type (C_PTR) :: global_c_ptr
  type (global_type), pointer :: gdata
  integer :: neighbor
  integer, intent(out) :: num_nodes
  integer :: alives(MAX_BOUNDARY_SIZE)

  call C_F_POINTER(global_c_ptr, gdata)

  call get_outgoing_nodes(gdata, neighbor, num_nodes, alives)

end subroutine get_outgoing_nodes_fort

subroutine put_incoming_nodes_fort(global_c_ptr, neighbor, num_nodes, alives)
  use, intrinsic :: iso_c_binding
  use global
  implicit none

  type (C_PTR) :: global_c_ptr
  type (global_type), pointer :: gdata
  integer :: neighbor
  integer :: num_nodes
  integer :: alives(MAX_BOUNDARY_SIZE)

  call C_F_POINTER(global_c_ptr, gdata)

  call put_incoming_nodes(gdata, neighbor, num_nodes, alives)

end subroutine put_incoming_nodes_fort
