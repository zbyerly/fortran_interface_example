subroutine get_neighbors(numneighbors,neighbors,g)
use global_data
implicit none

type (global_type), pointer :: g

integer :: numneighbors
integer :: neighbors(MAX_DOMAIN_NEIGHBORS)

integer :: i

numneighbors = g%NEIGHPROC

do i=1,numneighbors
   neighbors(i) = g%IPROC(i)
end do

end subroutine get_neighbors

subroutine get_outgoing_nodes(g, neighbor, num_nodes, alives)
use global_data
implicit none
type (global_type), pointer :: g
integer :: neighbor
integer,intent(out) :: num_nodes
integer :: alives(MAX_BOUNDARY_SIZE)

integer :: i,j,index
logical :: neighbor_found

neighbor_found = .false.
do I=1,g%NEIGHPROC   

   if (g%IPROC(I).eq.neighbor) then
      index = i
      neighbor_found = .true.
      exit
   end if   

end do

if (neighbor_found) then
   num_nodes = g%NNODSEND(INDEX)
   do J=1,g%NNODSEND(INDEX)
      alives(J)=g%ALIVE(g%ISENDLOC(J,INDEX))
   end do
else
   print*, "FORTRAN ERROR: neighbor not found"
   stop
end if

end subroutine get_outgoing_nodes

subroutine put_incoming_nodes(g, neighbor, num_nodes, alives)
use global_data
implicit none

type (global_type), pointer :: g
integer :: neighbor
integer :: num_nodes
integer :: alives(MAX_BOUNDARY_SIZE)

integer :: i,j,index
logical :: neighbor_found

neighbor_found = .false.
do I=1,g%NEIGHPROC

   if (g%IPROC(i).eq.neighbor) then
      index = i
      neighbor_found = .true.
      exit
   end if
      
end do


if (neighbor_found) then

   if (num_nodes.ne.g%NNODRECV(index)) then
      print*, "Error, numn_nodes .ne. g%NNODRECV(index)"
      print*, "num_nodes = ", num_nodes
      print*, "g%NNODRECV(index) = ", g%NNODRECV(index)
      stop
   end if
   
   do J=1,g%NNODRECV(index)
      g%new_alive(g%IRECVLOC(J,I))=alives(J)
   end do
   
else
   print*, "FORTRAN ERROR: neighbor not found"
   stop
end if

end subroutine put_incoming_nodes
