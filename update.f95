subroutine update(timestep, g)
  use global_data
  implicit none

  type(global_type), pointer :: g
  integer :: timestep

  ! loop variables 
  integer :: i,j

  ! local variables
  integer :: sum, n1, n2, n3

  print*, "timestep:",timestep," domain id:",g%id

  ! do this at the beginning and the end because boundary value exchange occured
  do i=1,g%np
     g%alive(i) = g%new_alive(i)
  end do

  !loop over nodes
  
  do i=1,g%np
     g%new_alive(i) = 0
     if (g%alive(i).eq.1) then
        g%new_alive(i)=0
     else
        sum=0
        do j=1,g%nneigh(i)
           sum=sum+g%alive(g%neigh(i,j))
        end do
        if (sum.gt.0) then
           g%new_alive(i)=1
        end if
     end if
  end do

  do i=1,g%np
     g%alive(i) = g%new_alive(i)
  end do

end subroutine update
