SUBROUTINE NEIGHB(g)  
     USE global_data
     implicit none

     !incoming data
     type (global_type) :: g
     
     !internal variables
     INTEGER :: N,NN,EN1,EN2,EN3,I,J

     DO N=1,g%NP
        g%NNEIGH(N) = 0
        DO NN=1,MAX_NEIGHBORS
           g%NEIGH(N,NN) = 0
        ENDDO
     ENDDO

     DO 10 N=1,g%NE
        EN1 = g%NM(N,1)
        EN2 = g%NM(N,2)
        EN3 = g%NM(N,3)
        DO 20 J=1,g%NNEIGH(EN1)
20         IF(EN2.EQ.g%NEIGH(EN1,J)) GOTO 25
           g%NNEIGH(EN1)=g%NNEIGH(EN1)+1
           g%NNEIGH(EN2)=g%NNEIGH(EN2)+1
           g%NEIGH(EN1,g%NNEIGH(EN1))=EN2
           g%NEIGH(EN2,g%NNEIGH(EN2))=EN1
25         DO 30 J=1,g%NNEIGH(EN1)
30            IF(EN3.EQ.g%NEIGH(EN1,J)) GOTO 35
              g%NNEIGH(EN1)=g%NNEIGH(EN1)+1
              g%NNEIGH(EN3)=g%NNEIGH(EN3)+1
              g%NEIGH(EN1,g%NNEIGH(EN1))=EN3
              g%NEIGH(EN3,g%NNEIGH(EN3))=EN1
35            DO 50 J=1,g%NNEIGH(EN2)
50               IF(EN3.EQ.g%NEIGH(EN2,J)) GOTO 10
                 g%NNEIGH(EN2)=g%NNEIGH(EN2)+1
                 g%NNEIGH(EN3)=g%NNEIGH(EN3)+1
                 g%NEIGH(EN2,g%NNEIGH(EN2))=EN3
                 g%NEIGH(EN3,g%NNEIGH(EN3))=EN2
10               CONTINUE

END SUBROUTINE NEIGHB
