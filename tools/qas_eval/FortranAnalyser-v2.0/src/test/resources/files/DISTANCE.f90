FUNCTION DISTANCE(X,Y,Z,R)
IMPLICIT NONE
REAL(KIND=8),DIMENSION(4),INTENT(IN)::X
REAL(KIND=8),DIMENSION(4),INTENT(IN)::Y
REAL(KIND=8),DIMENSION(4),INTENT(IN)::Z
REAL(KIND=8),DIMENSION(4),INTENT(IN)::R
REAL(KIND=8)::DISTANCE2
REAL(KIND=8)::DISTANCE1
REAL(KIND=8)::DISTANCE0
REAL(KIND=8)::DISTANCE
REAL(KIND=8)::DD
REAL(KIND=8),DIMENSION(3)::P
REAL(KIND=8),DIMENSION(3)::W
INTEGER::I

DD=DISTANCE2(X,Y,Z,R,W)
!WRITE(6,*) "DISTANCE2=",DD
IF (DD<0.0) THEN
	P=-1.0
	IF (w(3)<0.0) P(1)=DISTANCE1(X,Y,R)
	IF (w(2)<0.0) P(2)=DISTANCE1(X,Z,R)
	IF (w(1)<0.0) P(3)=DISTANCE1(Y,Z,R)

	IF (P(1)<0.0.AND.P(2)<0.0.AND.P(3)<0.0) THEN
		DD=MIN(DISTANCE0(X,R),DISTANCE0(Y,R),DISTANCE0(Z,R))
		!WRITE(6,*) "DISTANCE0=",DD
	ELSE
		DO I=1,3
			IF (P(I)<0.0) P(I)=200000.0
		END DO
		DD=MIN(P(1),P(2),p(3))
		!write(6,*) "DISTANCE1=",DD
			
	END IF
END IF
	DISTANCE=DD
RETURN
END