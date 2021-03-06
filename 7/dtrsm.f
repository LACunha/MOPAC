      SUBROUTINE DTRSM ( SIDE, UPLO, TRANSA, DIAG, M, N, ALPHA, A, LDA,
     $                   B, LDB )
*     .. SCALAR ARGUMENTS ..
      CHARACTER*1        SIDE, UPLO, TRANSA, DIAG
      INTEGER            M, N, LDA, LDB
      DOUBLE PRECISION   ALPHA
*     .. ARRAY ARGUMENTS ..
      DOUBLE PRECISION   A( LDA, * ), B( LDB, * )
*     ..
*
*  PURPOSE
*  =======
*
*  DTRSM  SOLVES ONE OF THE MATRIX EQUATIONS
*
*     OP( A )*X = ALPHA*B,   OR   X*OP( A ) = ALPHA*B,
*
*  WHERE ALPHA IS A SCALAR, X AND B ARE M BY N MATRICES, A IS A UNIT, OR
*  NON-UNIT,  UPPER OR LOWER TRIANGULAR MATRIX  AND  OP( A )  IS ONE  OF
*
*     OP( A ) = A   OR   OP( A ) = A'.
*
*  THE MATRIX X IS OVERWRITTEN ON B.
*
*  PARAMETERS
*  ==========
*
*  SIDE   - CHARACTER*1.
*           ON ENTRY, SIDE SPECIFIES WHETHER OP( A ) APPEARS ON THE LEFT
*           OR RIGHT OF X AS FOLLOWS:
*
*              SIDE = 'L' OR 'L'   OP( A )*X = ALPHA*B.
*
*              SIDE = 'R' OR 'R'   X*OP( A ) = ALPHA*B.
*
*           UNCHANGED ON EXIT.
*
*  UPLO   - CHARACTER*1.
*           ON ENTRY, UPLO SPECIFIES WHETHER THE MATRIX A IS AN UPPER OR
*           LOWER TRIANGULAR MATRIX AS FOLLOWS:
*
*              UPLO = 'U' OR 'U'   A IS AN UPPER TRIANGULAR MATRIX.
*
*              UPLO = 'L' OR 'L'   A IS A LOWER TRIANGULAR MATRIX.
*
*           UNCHANGED ON EXIT.
*
*  TRANSA - CHARACTER*1.
*           ON ENTRY, TRANSA SPECIFIES THE FORM OF OP( A ) TO BE USED IN
*           THE MATRIX MULTIPLICATION AS FOLLOWS:
*
*              TRANSA = 'N' OR 'N'   OP( A ) = A.
*
*              TRANSA = 'T' OR 'T'   OP( A ) = A'.
*
*              TRANSA = 'C' OR 'C'   OP( A ) = A'.
*
*           UNCHANGED ON EXIT.
*
*  DIAG   - CHARACTER*1.
*           ON ENTRY, DIAG SPECIFIES WHETHER OR NOT A IS UNIT TRIANGULAR
*           AS FOLLOWS:
*
*              DIAG = 'U' OR 'U'   A IS ASSUMED TO BE UNIT TRIANGULAR.
*
*              DIAG = 'N' OR 'N'   A IS NOT ASSUMED TO BE UNIT
*                                  TRIANGULAR.
*
*           UNCHANGED ON EXIT.
*
*  M      - INTEGER.
*           ON ENTRY, M SPECIFIES THE NUMBER OF ROWS OF B. M MUST BE AT
*           LEAST ZERO.
*           UNCHANGED ON EXIT.
*
*  N      - INTEGER.
*           ON ENTRY, N SPECIFIES THE NUMBER OF COLUMNS OF B.  N MUST BE
*           AT LEAST ZERO.
*           UNCHANGED ON EXIT.
*
*  ALPHA  - DOUBLE PRECISION.
*           ON ENTRY,  ALPHA SPECIFIES THE SCALAR  ALPHA. WHEN  ALPHA IS
*           ZERO THEN  A IS NOT REFERENCED AND  B NEED NOT BE SET BEFORE
*           ENTRY.
*           UNCHANGED ON EXIT.
*
*  A      - DOUBLE PRECISION ARRAY OF DIMENSION ( LDA, K ), WHERE K IS M
*           WHEN  SIDE = 'L' OR 'L'  AND IS  N  WHEN  SIDE = 'R' OR 'R'.
*           BEFORE ENTRY  WITH  UPLO = 'U' OR 'U',  THE  LEADING  K BY K
*           UPPER TRIANGULAR PART OF THE ARRAY  A MUST CONTAIN THE UPPER
*           TRIANGULAR MATRIX  AND THE STRICTLY LOWER TRIANGULAR PART OF
*           A IS NOT REFERENCED.
*           BEFORE ENTRY  WITH  UPLO = 'L' OR 'L',  THE  LEADING  K BY K
*           LOWER TRIANGULAR PART OF THE ARRAY  A MUST CONTAIN THE LOWER
*           TRIANGULAR MATRIX  AND THE STRICTLY UPPER TRIANGULAR PART OF
*           A IS NOT REFERENCED.
*           NOTE THAT WHEN  DIAG = 'U' OR 'U',  THE DIAGONAL ELEMENTS OF
*           A  ARE NOT REFERENCED EITHER,  BUT ARE ASSUMED TO BE  UNITY.
*           UNCHANGED ON EXIT.
*
*  LDA    - INTEGER.
*           ON ENTRY, LDA SPECIFIES THE FIRST DIMENSION OF A AS DECLARED
*           IN THE CALLING (SUB) PROGRAM.  WHEN  SIDE = 'L' OR 'L'  THEN
*           LDA  MUST BE AT LEAST  MAX( 1, M ),  WHEN  SIDE = 'R' OR 'R'
*           THEN LDA MUST BE AT LEAST MAX( 1, N ).
*           UNCHANGED ON EXIT.
*
*  B      - DOUBLE PRECISION ARRAY OF DIMENSION ( LDB, N ).
*           BEFORE ENTRY,  THE LEADING  M BY N PART OF THE ARRAY  B MUST
*           CONTAIN  THE  RIGHT-HAND  SIDE  MATRIX  B,  AND  ON EXIT  IS
*           OVERWRITTEN BY THE SOLUTION MATRIX  X.
*
*  LDB    - INTEGER.
*           ON ENTRY, LDB SPECIFIES THE FIRST DIMENSION OF B AS DECLARED
*           IN  THE  CALLING  (SUB)  PROGRAM.   LDB  MUST  BE  AT  LEAST
*           MAX( 1, M ).
*           UNCHANGED ON EXIT.
*
*
*  LEVEL 3 BLAS ROUTINE.
*
*
*  -- WRITTEN ON 8-FEBRUARY-1989.
*     JACK DONGARRA, ARGONNE NATIONAL LABORATORY.
*     IAIN DUFF, AERE HARWELL.
*     JEREMY DU CROZ, NUMERICAL ALGORITHMS GROUP LTD.
*     SVEN HAMMARLING, NUMERICAL ALGORITHMS GROUP LTD.
*
*
*     .. EXTERNAL FUNCTIONS ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
*     .. EXTERNAL SUBROUTINES ..
      EXTERNAL           XERBLA
*     .. INTRINSIC FUNCTIONS ..
      INTRINSIC          MAX
*     .. LOCAL SCALARS ..
      LOGICAL            LSIDE, NOUNIT, UPPER
      INTEGER            I, INFO, J, K, NROWA
      DOUBLE PRECISION   TEMP
*     .. PARAMETERS ..
      DOUBLE PRECISION   ONE         , ZERO
      PARAMETER        ( ONE = 1.0D+0, ZERO = 0.0D+0 )
*     ..
*     .. EXECUTABLE STATEMENTS ..
*
*     TEST THE INPUT PARAMETERS.
*
      LSIDE  = LSAME( SIDE  , 'L' )
      IF( LSIDE )THEN
         NROWA = M
      ELSE
         NROWA = N
      END IF
      NOUNIT = LSAME( DIAG  , 'N' )
      UPPER  = LSAME( UPLO  , 'U' )
*
      INFO   = 0
      IF(      ( .NOT.LSIDE                ).AND.
     $         ( .NOT.LSAME( SIDE  , 'R' ) )      )THEN
         INFO = 1
      ELSE IF( ( .NOT.UPPER                ).AND.
     $         ( .NOT.LSAME( UPLO  , 'L' ) )      )THEN
         INFO = 2
      ELSE IF( ( .NOT.LSAME( TRANSA, 'N' ) ).AND.
     $         ( .NOT.LSAME( TRANSA, 'T' ) ).AND.
     $         ( .NOT.LSAME( TRANSA, 'C' ) )      )THEN
         INFO = 3
      ELSE IF( ( .NOT.LSAME( DIAG  , 'U' ) ).AND.
     $         ( .NOT.LSAME( DIAG  , 'N' ) )      )THEN
         INFO = 4
      ELSE IF( M  .LT.0               )THEN
         INFO = 5
      ELSE IF( N  .LT.0               )THEN
         INFO = 6
      ELSE IF( LDA.LT.MAX( 1, NROWA ) )THEN
         INFO = 9
      ELSE IF( LDB.LT.MAX( 1, M     ) )THEN
         INFO = 11
      END IF
      IF( INFO.NE.0 )THEN
         CALL XERBLA( 'DTRSM ', INFO )
         RETURN
      END IF
*
*     QUICK RETURN IF POSSIBLE.
*
      IF( N.EQ.0 )
     $   RETURN
*
*     AND WHEN  ALPHA.EQ.ZERO.
*
      IF( ALPHA.EQ.ZERO )THEN
         DO 20, J = 1, N
            DO 10, I = 1, M
               B( I, J ) = ZERO
   10       CONTINUE
   20    CONTINUE
         RETURN
      END IF
*
*     START THE OPERATIONS.
*
      IF( LSIDE )THEN
         IF( LSAME( TRANSA, 'N' ) )THEN
*
*           FORM  B := ALPHA*INV( A )*B.
*
            IF( UPPER )THEN
               DO 60, J = 1, N
                  IF( ALPHA.NE.ONE )THEN
                     DO 30, I = 1, M
                        B( I, J ) = ALPHA*B( I, J )
   30                CONTINUE
                  END IF
                  DO 50, K = M, 1, -1
                     IF( B( K, J ).NE.ZERO )THEN
                        IF( NOUNIT )
     $                     B( K, J ) = B( K, J )/A( K, K )
                        DO 40, I = 1, K - 1
                           B( I, J ) = B( I, J ) - B( K, J )*A( I, K )
   40                   CONTINUE
                     END IF
   50             CONTINUE
   60          CONTINUE
            ELSE
               DO 100, J = 1, N
                  IF( ALPHA.NE.ONE )THEN
                     DO 70, I = 1, M
                        B( I, J ) = ALPHA*B( I, J )
   70                CONTINUE
                  END IF
                  DO 90 K = 1, M
                     IF( B( K, J ).NE.ZERO )THEN
                        IF( NOUNIT )
     $                     B( K, J ) = B( K, J )/A( K, K )
                        DO 80, I = K + 1, M
                           B( I, J ) = B( I, J ) - B( K, J )*A( I, K )
   80                   CONTINUE
                     END IF
   90             CONTINUE
  100          CONTINUE
            END IF
         ELSE
*
*           FORM  B := ALPHA*INV( A' )*B.
*
            IF( UPPER )THEN
               DO 130, J = 1, N
                  DO 120, I = 1, M
                     TEMP = ALPHA*B( I, J )
                     DO 110, K = 1, I - 1
                        TEMP = TEMP - A( K, I )*B( K, J )
  110                CONTINUE
                     IF( NOUNIT )
     $                  TEMP = TEMP/A( I, I )
                     B( I, J ) = TEMP
  120             CONTINUE
  130          CONTINUE
            ELSE
               DO 160, J = 1, N
                  DO 150, I = M, 1, -1
                     TEMP = ALPHA*B( I, J )
                     DO 140, K = I + 1, M
                        TEMP = TEMP - A( K, I )*B( K, J )
  140                CONTINUE
                     IF( NOUNIT )
     $                  TEMP = TEMP/A( I, I )
                     B( I, J ) = TEMP
  150             CONTINUE
  160          CONTINUE
            END IF
         END IF
      ELSE
         IF( LSAME( TRANSA, 'N' ) )THEN
*
*           FORM  B := ALPHA*B*INV( A ).
*
            IF( UPPER )THEN
               DO 210, J = 1, N
                  IF( ALPHA.NE.ONE )THEN
                     DO 170, I = 1, M
                        B( I, J ) = ALPHA*B( I, J )
  170                CONTINUE
                  END IF
                  DO 190, K = 1, J - 1
                     IF( A( K, J ).NE.ZERO )THEN
                        DO 180, I = 1, M
                           B( I, J ) = B( I, J ) - A( K, J )*B( I, K )
  180                   CONTINUE
                     END IF
  190             CONTINUE
                  IF( NOUNIT )THEN
                     TEMP = ONE/A( J, J )
                     DO 200, I = 1, M
                        B( I, J ) = TEMP*B( I, J )
  200                CONTINUE
                  END IF
  210          CONTINUE
            ELSE
               DO 260, J = N, 1, -1
                  IF( ALPHA.NE.ONE )THEN
                     DO 220, I = 1, M
                        B( I, J ) = ALPHA*B( I, J )
  220                CONTINUE
                  END IF
                  DO 240, K = J + 1, N
                     IF( A( K, J ).NE.ZERO )THEN
                        DO 230, I = 1, M
                           B( I, J ) = B( I, J ) - A( K, J )*B( I, K )
  230                   CONTINUE
                     END IF
  240             CONTINUE
                  IF( NOUNIT )THEN
                     TEMP = ONE/A( J, J )
                     DO 250, I = 1, M
                       B( I, J ) = TEMP*B( I, J )
  250                CONTINUE
                  END IF
  260          CONTINUE
            END IF
         ELSE
*
*           FORM  B := ALPHA*B*INV( A' ).
*
            IF( UPPER )THEN
               DO 310, K = N, 1, -1
                  IF( NOUNIT )THEN
                     TEMP = ONE/A( K, K )
                     DO 270, I = 1, M
                        B( I, K ) = TEMP*B( I, K )
  270                CONTINUE
                  END IF
                  DO 290, J = 1, K - 1
                     IF( A( J, K ).NE.ZERO )THEN
                        TEMP = A( J, K )
                        DO 280, I = 1, M
                           B( I, J ) = B( I, J ) - TEMP*B( I, K )
  280                   CONTINUE
                     END IF
  290             CONTINUE
                  IF( ALPHA.NE.ONE )THEN
                     DO 300, I = 1, M
                        B( I, K ) = ALPHA*B( I, K )
  300                CONTINUE
                  END IF
  310          CONTINUE
            ELSE
               DO 360, K = 1, N
                  IF( NOUNIT )THEN
                     TEMP = ONE/A( K, K )
                     DO 320, I = 1, M
                        B( I, K ) = TEMP*B( I, K )
  320                CONTINUE
                  END IF
                  DO 340, J = K + 1, N
                     IF( A( J, K ).NE.ZERO )THEN
                        TEMP = A( J, K )
                        DO 330, I = 1, M
                           B( I, J ) = B( I, J ) - TEMP*B( I, K )
  330                   CONTINUE
                     END IF
  340             CONTINUE
                  IF( ALPHA.NE.ONE )THEN
                     DO 350, I = 1, M
                        B( I, K ) = ALPHA*B( I, K )
  350                CONTINUE
                  END IF
  360          CONTINUE
            END IF
         END IF
      END IF
*
      RETURN
*
*     END OF DTRSM .
*
      END
