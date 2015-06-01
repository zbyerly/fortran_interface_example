subroutine term(g)
  use global_data
  implicit none

  type (global_type), pointer :: g

  deallocate(g)

end subroutine
