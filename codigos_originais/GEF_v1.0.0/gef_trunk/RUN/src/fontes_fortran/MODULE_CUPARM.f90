!--------------------------------------------------------------------------------------------------
!  DOXYGEN
!> @brief SCHEME HAVING THE OPTION OF USING DIFFERENT FAST AND SLOW PROFILES FOR SEA AND FOR 
!! LAND POINTS; AND ALSO THE "SEA" AND THE "LAND" SCHEME EVERYWHERE.  
!! @details AUGUST 91: SCHEME HAVING THE OPTION OF USING DIFFERENT FAST AND SLOW PROFILES FOR SEA 
!!AND FOR 
!! LAND POINTS; AND ALSO THE "SEA" AND THE "LAND" SCHEME EVERYWHERE.
!! OVER LAND PROFILES DEPART FROM THE FAST (DRY) PROFILES ONLY FOR PRECIPITATION/TIME STEP .GT. A 
!! PRESCRIBED VALUE (CURRENTLY, IN THE VERSION #3 DONE WEDNESDAY 18 SEPTEMBER, 1/4 INCH/24 H).
!! USE OF VARIOUS SWITCHES AS FOLLOWS.
!!
!> THE "OLD" ("HARD", = ZAVISA OCT. 1990) LAND SCHEME WITH FIXED LAND PROFILES IS RUN BY:
!>
!> - SETTING OCT90 = .TRUE. IN THE FIRST EXECUTABLE LINE FOLLOWING THESE COMMENTS (THIS REACTIVATES
!>   EFI=1. OVER LAND IF .NOT. UNIS, AND CLDEFI(K) = EFIMN AS THE LEFTOVER CLDEFI VALUE AT SWAP 
!>   POINTS)
!> - DEFINING FAST LAND PROFILES SAME AS FAST SEA PROFILES (OR BY CHOOSING ANOTHER SET OF LAND 
!>   PROFILES ZAVISA USED AT EARLIER TIME)
!> - SETTING FSL = 1.
!> - DEFINING STEFI (STARTING EFI) EQUAL TO AVGEFI. (THE LAST THREE POINTS ARE HANDLED BY SWITCHING
!>   AROUND THE "CFM" COMMENTS AT TWO PLACES)
!>
!> THE "OLD,OLD" (APPR. ORIGINAL BETTS) SCHEME IS RUN BY:
!> - SPECIFYING UNIL=.TRUE.;
!> - SETTING FSL=1.;
!> - SETTING OCT90=.TRUE. (WITH THESE SETTINGS FAST LAND PROFILES ONLY ARE USED).
!>
!> IN THIS VERSION 3.5, OVER LAND AND FOR THE FAST PROFILES, DSPB IS PRESCRIBED TO BE 25 PERCENT 
!> DRIER THAN THE FAST SEA VALUE (IN ROUGH AGREEMENT WITH BINDER, QJ, IN PRESS) WHILE DSP0 AND
!> DSPT ARE EACH 20 PERCENT DRIER THAN THE CORRESPONDING FAST SEA VALUES.
!> WITH FSL = .875 THIS MAKES THE AVERAGE OF THE FAST AND THE SLOW LAND PROFILES SOMEWHAT DRIER THAN
!> THE OCT90 FIXED LAND PROFILES. 
!! @author Lucci 
!! @date 18-03-20 \n
!<
!> @details <b>Use Module:</b>  
!! @arg @c DYNAM 
!! @arg @c F77KINDS 
!! @details <b>Driver:</b> 
!! @arg @c CUCNVC
!! @arg @c INIT
!<
!--------------------------------------------------------------------------------------------------
    MODULE CUPARM
!--------------------------------------------------------------------------------------------------
! MODULE CUPARM
!
! ABSTRACT:
! AUGUST 91: SCHEME HAVING THE OPTION OF USING DIFFERENT FAST AND SLOW PROFILES FOR SEA AND FOR 
! LAND POINTS; AND ALSO THE "SEA" AND THE "LAND" SCHEME EVERYWHERE.
! OVER LAND PROFILES DEPART FROM THE FAST (DRY) PROFILES ONLY FOR PRECIPITATION/TIME STEP .GT. A 
! PRESCRIBED VALUE (CURRENTLY, IN THE VERSION #3 DONE WEDNESDAY 18 SEPTEMBER, 1/4 INCH/24 H).
! USE OF VARIOUS SWITCHES AS FOLLOWS.
!
! THE "OLD" ("HARD", = ZAVISA OCT. 1990) LAND SCHEME WITH FIXED LAND PROFILES IS RUN BY:
!
! - SETTING OCT90 = .TRUE. IN THE FIRST EXECUTABLE LINE FOLLOWING THESE COMMENTS (THIS REACTIVATES
!   EFI=1. OVER LAND IF .NOT. UNIS, AND CLDEFI(K) = EFIMN AS THE LEFTOVER CLDEFI VALUE AT SWAP 
!   POINTS)
! - DEFINING FAST LAND PROFILES SAME AS FAST SEA PROFILES (OR BY CHOOSING ANOTHER SET OF LAND 
!   PROFILES ZAVISA USED AT EARLIER TIME)
! - SETTING FSL = 1.
! - DEFINING STEFI (STARTING EFI) EQUAL TO AVGEFI. (THE LAST THREE POINTS ARE HANDLED BY SWITCHING
!   AROUND THE "CFM" COMMENTS AT TWO PLACES)
!
! THE "OLD,OLD" (APPR. ORIGINAL BETTS) SCHEME IS RUN BY:
! - SPECIFYING UNIL=.TRUE.;
! - SETTING FSL=1.;
! - SETTING OCT90=.TRUE. (WITH THESE SETTINGS FAST LAND PROFILES ONLY ARE USED).
!
! IN THIS VERSION 3.5, OVER LAND AND FOR THE FAST PROFILES, DSPB IS PRESCRIBED TO BE 25 PERCENT 
! DRIER THAN THE FAST SEA VALUE (IN ROUGH AGREEMENT WITH BINDER, QJ, IN PRESS) WHILE DSP0 AND
! DSPT ARE EACH 20 PERCENT DRIER THAN THE CORRESPONDING FAST SEA VALUES.
! WITH FSL = .875 THIS MAKES THE AVERAGE OF THE FAST AND THE SLOW LAND PROFILES SOMEWHAT DRIER THAN
! THE OCT90 FIXED LAND PROFILES.
!
! USE MODULES: DYNAM
!              F77KINDS
!
! DRIVER     : CUCNVC
!              INIT
!--------------------------------------------------------------------------------------------------
    USE DYNAM
    USE F77KINDS
!
    IMPLICIT NONE

    LOGICAL(KIND=L4)                                                                            ::&
    & UNIS = .TRUE.     , UNIL = .FALSE.    , OCT90 = .FALSE.  
!
    REAL   (KIND=R4)    , PARAMETER :: G      =     9.80616
    REAL   (KIND=R4)    , PARAMETER :: CAPA   =     0.28589641
    REAL   (KIND=R4)    , PARAMETER :: ELWV   =     2.50E6
    REAL   (KIND=R4)    , PARAMETER :: ELIVW  =     2.72E6
    REAL   (KIND=R4)    , PARAMETER :: ROW    =     1.E3
    REAL   (KIND=R4)    , PARAMETER :: EPSQ   =     2.E-12
    REAL   (KIND=R4)    , PARAMETER :: A2     =    17.2693882
    REAL   (KIND=R4)    , PARAMETER :: A3     =   273.16
    REAL   (KIND=R4)    , PARAMETER :: A4     =    35.86
    REAL   (KIND=R4)    , PARAMETER :: TFRZ   =   273.15
    REAL   (KIND=R4)    , PARAMETER :: T1     =   274.16
    REAL   (KIND=R4)    , PARAMETER :: PQ0    =   379.90516
    REAL   (KIND=R4)    , PARAMETER :: STRESH =     1.10
    REAL   (KIND=R4)    , PARAMETER :: STABS  =     1.0
    REAL   (KIND=R4)    , PARAMETER :: STABD  =      .90
    REAL   (KIND=R4)    , PARAMETER :: STABFC =     1.00
    REAL   (KIND=R4)    , PARAMETER :: DTTOP  =     0.0 
    REAL   (KIND=R4)    , PARAMETER :: RHF    =     0.10
    REAL   (KIND=R4)    , PARAMETER :: EPSUP  =     1.00
    REAL   (KIND=R4)    , PARAMETER :: EPSDN  =     1.05
    REAL   (KIND=R4)    , PARAMETER :: EPSTH  =     0.0
    REAL   (KIND=R4)    , PARAMETER :: PBM    = 13000.
    REAL   (KIND=R4)    , PARAMETER :: PQM    = 20000.
    REAL   (KIND=R4)    , PARAMETER :: PNO    =  1000.
    REAL   (KIND=R4)    , PARAMETER :: PONE   =  2500.
    REAL   (KIND=R4)    , PARAMETER :: PSH    = 29000.
    REAL   (KIND=R4)    , PARAMETER :: PFRZ   = 15000.
    REAL   (KIND=R4)    , PARAMETER :: PSHU   = 45000.
    REAL   (KIND=R4)    , PARAMETER :: FSS    =      .85
    REAL   (KIND=R4)    , PARAMETER :: EFIMN  =      .20
    REAL   (KIND=R4)    , PARAMETER :: EFMNT  =      .70
    REAL   (KIND=R4)    , PARAMETER :: FCC    =      .50
    REAL   (KIND=R4)    , PARAMETER :: FCB    =  1. - FCC 
    REAL   (KIND=R4)    , PARAMETER :: DSPBFL = -4843.75
    REAL   (KIND=R4)    , PARAMETER :: DSP0FL = -7050.00
    REAL   (KIND=R4)    , PARAMETER :: DSPTFL = -2250.0
    REAL   (KIND=R4)    , PARAMETER :: FSL    =      .850 
    REAL   (KIND=R4)    , PARAMETER :: DSPBFS = -3875.
    REAL   (KIND=R4)    , PARAMETER :: DSP0FS = -5875.
    REAL   (KIND=R4)    , PARAMETER :: DSPTFS = -1875.
    REAL   (KIND=R4)    , PARAMETER :: DSPBSL = DSPBFL * FSL
    REAL   (KIND=R4)    , PARAMETER :: DSP0SL = DSP0FL * FSL
    REAL   (KIND=R4)    , PARAMETER :: DSPTSL = DSPTFL * FSL 
    REAL   (KIND=R4)    , PARAMETER :: DSPBSS = DSPBFS * FSS
    REAL   (KIND=R4)    , PARAMETER :: DSP0SS = DSP0FS * FSS
    REAL   (KIND=R4)    , PARAMETER :: DSPTSS = DSPTFS * FSS  
    REAL   (KIND=R4)    , PARAMETER :: TREL   =  2400.
    REAL   (KIND=R4)    , PARAMETER :: EPSNTP =      .0010
    REAL   (KIND=R4)    , PARAMETER :: EFIFC  =     5.0 
    REAL   (KIND=R4)    , PARAMETER :: AVGEFI = (EFIMN + 1.) * .5
    REAL   (KIND=R4)    , PARAMETER :: DSPC   = -3000.
    REAL   (KIND=R4)    , PARAMETER :: EPSP   =     1.E-7
    REAL   (KIND=R4)    , PARAMETER :: STEFI  =     1.  
    REAL   (KIND=R4)    , PARAMETER :: SLOPBL = (DSPBFL - DSPBSL) / (1. - EFIMN)
    REAL   (KIND=R4)    , PARAMETER :: SLOP0L = (DSP0FL - DSP0SL) / (1. - EFIMN)
    REAL   (KIND=R4)    , PARAMETER :: SLOPTL = (DSPTFL - DSPTSL) / (1. - EFIMN)
    REAL   (KIND=R4)    , PARAMETER :: SLOPBS = (DSPBFS - DSPBSS) / (1. - EFIMN)
    REAL   (KIND=R4)    , PARAMETER :: SLOP0S = (DSP0FS - DSP0SS) / (1. - EFIMN)
    REAL   (KIND=R4)    , PARAMETER :: SLOPTS = (DSPTFS - DSPTSS) / (1. - EFIMN)
    REAL   (KIND=R4)    , PARAMETER :: SLOPE  = (1.     - EFMNT ) / (1. - EFIMN)
    REAL   (KIND=R4)    , PARAMETER :: A23M4L = A2 * (A3 - A4) * ELWV
    REAL   (KIND=R4)    , PARAMETER :: ELOCP  = ELIVW / CP
    REAL   (KIND=R4)    , PARAMETER :: CPRLG  = CP / (ROW * G * ELWV)
    REAL   (KIND=R4)    , PARAMETER :: RCP    = 1. / CP
!
    END MODULE CUPARM

