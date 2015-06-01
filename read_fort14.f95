subroutine read_fort14(g)
use global_data
implicit none

type (global_type) :: g

!loop variables
integer :: i,j,JKI

!local variables
CHARACTER*24 AGRID
INTEGER :: NHY
INTEGER :: NEIGH_HERE, n1, n2, n3

OPEN(g%unit14,FILE='./shin32/'//g%DIRNAME//'/'//'fort.14')

READ(g%unit14,'(A24)') AGRID
READ(g%unit14,*) g%NE,g%NP

ALLOCATE ( g%X(g%NP),g%Y(g%NP),g%DP(g%NP) )
ALLOCATE ( g%NNEIGH(g%NP) )
ALLOCATE ( g%ALIVE(g%NP) )
allocate ( g%new_alive(g%np) )
ALLOCATE ( g%NEIGH(g%NP,MAX_NEIGHBORS) )
ALLOCATE ( g%NM(g%NE,3) )

DO i = 1,g%NP
   READ(g%unit14,*) JKI,g%X(JKI),g%Y(JKI),g%DP(JKI)
END DO

DO I = 1, g%NP
   g%NNEIGH(I) = 0
   g%ALIVE(I) = 0
   g%NEW_ALIVE(I) = 0
ENDDO

DO I = 1,g%NE
   READ(g%unit14,*) JKI,NHY,g%NM(JKI,1),g%NM(JKI,2),g%NM(JKI,3)
   g%NNEIGH(g%NM(JKI,1)) = g%NNEIGH(g%NM(JKI,1)) + 1     
   g%NNEIGH(g%NM(JKI,2)) = g%NNEIGH(g%NM(JKI,2)) + 1
   g%NNEIGH(g%NM(JKI,3)) = g%NNEIGH(g%NM(JKI,3)) + 1
   
END DO

close(g%unit14)

!make sure NNEIGH for all nodes is less than MAX_NEIGHBORS
do i=1,g%np
   if (g%NNEIGH(i).gt.MAX_NEIGHBORS) then
      print*, "ERROR: NNEIGH is greater than MAX_NEIGHBORS"
      stop
   end if
end do

END subroutine read_fort14
