      SUBROUTINE ADDNUC (ENUCLR)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INCLUDE 'SIZES'
      COMMON / SOLV / FEPSI,RDS,DISEX2,NSPA,NPS,NPS2,NDEN,
     1                COSURF(3,LENABC), SRAD(NUMATM),ABCMAT(LENAB2),
     2                TM(3,3,NUMATM),QDEN(MAXDEN),DIRTM(3,NPPA),
     3                BH(LENABC)
     4       /SOLVI/  IATSP(LENABC+1),NAR(LENABC), NN(2,NUMATM)
      COMMON /MOLKST/ NUMAT,NAT(NUMATM),NFIRST(NUMATM),NMIDLE(NUMATM),
     1                NLAST(NUMATM), NORBS, NELECS,NALPHA,NBETA,
     2                NCLOSE,NOPEN,NDUMY,FRACT
      COMMON /CORE  / CORE(107)

      ENCLR=0.D0
      I0=NPS2+NDEN*NPS
      IDEN=0
      DO 20 I=1,NUMAT
         IA=NFIRST(I)
         IDEL=NLAST(I)-IA
         I1=I0+(IDEN*(IDEN+1))/2
         COREI = CORE(NAT(I))
         DO 10 J=1,I-1
            JA=NFIRST(J)
            JDEL=NLAST(J)-JA
            I1=I1+1
            ENCLR = ENCLR + 2 * COREI * ABCMAT(I1) * CORE(NAT(J))
            I1=I1+JDEL**2
   10    CONTINUE
         I1=I1+1
         ENCLR = ENCLR + COREI * ABCMAT(I1) * COREI
         IDEN=IDEN+1+IDEL**2
   20 CONTINUE
      ENUCLR = ENUCLR+ENCLR
      RETURN
      END
