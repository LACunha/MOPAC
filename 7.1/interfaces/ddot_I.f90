      MODULE ddot_I   
      INTERFACE
!...Generated by Pacific-Sierra Research 77to90  4.4G  22:48:56  03/08/06  
      REAL(KIND(0.0D0)) FUNCTION ddot (N, DX, INCX, DY, INCY) 
      USE vast_kind_param,ONLY: DOUBLE 
      integer, INTENT(IN) :: N 
      real(DOUBLE), DIMENSION(*), INTENT(IN) :: DX 
      integer, INTENT(IN) :: INCX 
      real(DOUBLE), DIMENSION(*), INTENT(IN) :: DY 
      integer, INTENT(IN) :: INCY 
      END FUNCTION  
      END INTERFACE 
      END MODULE 
