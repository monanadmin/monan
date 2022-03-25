      PROGRAM CONVERTE_R4_TO_R8
!
      USE ACMCLD
      USE ACMCLH
      USE ACMPRE
      USE ACMRDL
      USE ACMRDS
      USE ACMSFC
      USE CTLBLK
      USE CONTIN
      USE DYNAM
      USE DGNSOUT
      USE HS
      USE LOOPS
      USE MASKS
      USE METRCS
      USE MPPSTAFF
      USE PARMSOIL
      USE PHYS
      USE PVRBLS
      USE SOIL
      USE VRBLS
!      
       IMPLICIT NONE
!
    SAVE
!
!
    CHARACTER(LEN=4)                                                                            ::&
    & C_NHRS
!
    CHARACTER(LEN=80)                                                                           ::&
    & RESTRTFILE2
!
!
   CALL ALLOC
!  
!------
! 
   DO MYPE = 5 , 5
 
!
        WRITE(C_MYPE, 1000) MYPE
 1000    FORMAT(I4.4)
 
!
        WRITE(C_NHRS, 1010) MYPE
 1010    FORMAT(I4.4) 


        print*,C_MYPE

!!!!!!!!!!!!!!!!!!!!!!! READ GEFfcstVEG !!!!!!!!!!!!!!!!!!!!!!!!!!
    RESTRTFILE2 = "GEFfcstVEG_"//C_MYPE//"."//C_NHRS
!
    OPEN (UNIT=LISTOUT, FILE= TRIM(RESTRTFILE2), FORM = 'UNFORMATTED')
!       
    READ(LISTOUT) TSHLTR
    READ(LISTOUT) QSHLTR
    READ(LISTOUT) PLM
    READ(LISTOUT) SFCLHX
    READ(LISTOUT) SFCSHX
    READ(LISTOUT) QWBS
    READ(LISTOUT) TWBS 
    READ(LISTOUT) GRNFLX
    READ(LISTOUT) VEGFRC
    READ(LISTOUT) IVGTYP
    READ(LISTOUT) ISLTYP
    READ(LISTOUT) GLAT
    READ(LISTOUT) GLON
    READ(LISTOUT) SM   
    READ(LISTOUT) HTM 
    READ(LISTOUT) VTM 
    READ(LISTOUT) SICE
    READ(LISTOUT) Z0
    READ(LISTOUT) OMGALF
    READ(LISTOUT) ALBEDO
    READ(LISTOUT) ALBASE
    READ(LISTOUT) MXSNAL
    READ(LISTOUT) CZEN
    READ(LISTOUT) CZMEAN
    READ(LISTOUT) FIS
    READ(LISTOUT) Q10    
    READ(LISTOUT) TH10    
    READ(LISTOUT) QZ0    
    READ(LISTOUT) THZ0   
    READ(LISTOUT) U10
    READ(LISTOUT) V10
    READ(LISTOUT) UZ0
    READ(LISTOUT) VZ0
    READ(LISTOUT) USTAR
    READ(LISTOUT) THS
    READ(LISTOUT) Q2    
    READ(LISTOUT) TCUCN    
    READ(LISTOUT) TRAIN    
    READ(LISTOUT) DIV  
    READ(LISTOUT) RTOP
! 
    CLOSE (LISTOUT)
!

    WRITE(1000,*) TSHLTR
    WRITE(1000,*) QSHLTR
    WRITE(1000,*) PLM
    WRITE(1000,*) SFCLHX
    WRITE(1000,*) SFCSHX
    WRITE(1000,*) QWBS
    WRITE(1000,*) TWBS 
    WRITE(1000,*) GRNFLX
    WRITE(1000,*) VEGFRC
    WRITE(1000,*) IVGTYP
    WRITE(1000,*) ISLTYP
    WRITE(1000,*) GLAT
    WRITE(1000,*) GLON
    WRITE(1000,*) SM   
    WRITE(1000,*) HTM 
    WRITE(1000,*) VTM 
    WRITE(1000,*) SICE
    WRITE(1000,*) Z0
    WRITE(1000,*) OMGALF
    WRITE(1000,*) ALBEDO
    WRITE(1000,*) ALBASE
    WRITE(1000,*) MXSNAL
    WRITE(1000,*) CZEN
    WRITE(1000,*) CZMEAN
    WRITE(1000,*) FIS
    WRITE(1000,*) Q10    
    WRITE(1000,*) TH10    
    WRITE(1000,*) QZ0    
    WRITE(1000,*) THZ0   
    WRITE(1000,*) U10
    WRITE(1000,*) V10
    WRITE(1000,*) UZ0
    WRITE(1000,*) VZ0
    WRITE(1000,*) USTAR
    WRITE(1000,*) THS
    WRITE(1000,*) Q2    
    WRITE(1000,*) TCUCN    
    WRITE(1000,*) TRAIN    
    WRITE(1000,*) DIV  
    WRITE(1000,*) RTOP

!!!!!!!!!!!!!!!!!!!!!!! READ GEFfcstVEG !!!!!!!!!!!!!!!!!!!!!!!!!!





   END DO


END 















     
      
      
      
      
      
      
      
      
   
