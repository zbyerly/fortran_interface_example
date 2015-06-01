subroutine print(g, timestep)
  use global_data
  implicit none

  type(global_type), pointer :: g
  integer :: timestep

  integer :: unit_out
  CHARACTER*8 :: outfilename = '0000.dat'

  !loop variables
  integer :: i,j
 
  unit_out = 555 ! set to one unit to write to a single file

  WRITE(outfilename(1:4),'(I4.4)') timestep

  OPEN(unit_out,FILE='./output/'//outfilename)  

  do i=1,g%NP
     if (g%resnode(i)) then
        WRITE(unit_out,*) i,g%x(i),g%y(i),g%NEW_ALIVE(i)
!        WRITE(unit_out,*) i,g%x(i),g%y(i),g%id
     end if
  enddo

end subroutine print
