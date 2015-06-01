subroutine init(id, g)
  use global_data
  implicit none

  !incoming variable
  integer :: id

  INTEGER, ALLOCATABLE :: NM(:,:)
  type(global_type), pointer :: g
  allocate(g)

  g%id = id
  g%DIRNAME  = 'PE0000'
  WRITE(g%DIRNAME(3:6),'(I4.4)') g%id
  g%unit14 = 200+g%id ! This is experimental! might not be safe
  g%unit18 = 500+g%id ! this will definitely break things 
  ! certain file unit numbers are reserved in FORTRAN

  call read_fort14(g)

  ! build neighbor table
  call NEIGHB(g)

  call msg_table(g)

  ! Seed single node
  if (g%id.eq.0) then
     g%NEW_ALIVE(6) = 1
  end if

end subroutine init
