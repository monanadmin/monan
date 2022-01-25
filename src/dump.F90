module dump
  !# Auxiliary module to dump messages.
  !#
  !# @note
  !# ![](http://brams.cptec.inpe.br/wp-content/uploads/2015/11/logo-brams.navigation.png "")
  !#
  !# **Brief**: The module can print 4 types of messages:
  !# 0) No Error message - just a print,
  !# 1) Notice,
  !# 2) warning or
  !# 3) Fatal.
  !# The interfaces selects the correct function and print the message using
  !# color or no. May be used simple messages only with text, text and
  !# integers, text and real, text and logical or combination of text and arrays
  !# 1D or 2D. The message may be printed inside a file or in ordinary TTY.
  !# See the examples of functions invokes:
  !#
  !# err=dumpMessage(c_tty,c_yes,header,version,c_notice,'Just a notice!')
  !# err=dumpMessage(c_tty,c_yes,header,version,c_warning,'Just a warning!')
  !# err=dumpMessage(c_tty,c_yes,header,version,c_warning,'Warning with an integer:',j,'I2')
  !# err=dumpMessage(c_tty,c_yes,header,version,c_notice,'Notice with a real:',x,'E18.4')
  !# err=dumpMessage(c_tty,c_yes,header,version,c_notice,'Do You love colors?',l1(2))
  !# err=dumpMessage(c_tty,c_yes,header,version,c_warning,'Warning with an array of reals: ',y,'F4.1')
  !# err=dumpMessage(c_tty,c_yes,header,version,c_notice,'Notice of 3 integers a,b,c: ',(/a,b,c/),'I1')
  !# err=dumpMessage(c_tty,c_yes,header,version,c_warning,'Array of Logicals: ',l1)
  !# err=dumpMessage(c_tty,c_yes,header,version,c_notice,'Notice with 2 d array:',a2d,'F3.1')
  !# err=dumpMessage(c_tty,c_no,header,version,c_notice,'Notice with 2 d array:',i2d,'I1')
  !# err=dumpMessage(c_tty,c_yes,header,version,c_warning,'Error in logical array:',l2d)
  !# err=dumpMessage(c_tty,c_yes,header,version,c_fatal,'Fatal - System crash!')
  !# err=dumpMessage(66,c_yes,c_empty,c_empty,c_noError,'Error in logical array:',l2d)
  !#
  !# c_tty, c_yes, c_no, c_notice, c_warning and c_fatal are parameters from contants.f90
  !#
  !# **Documentation**: <http://brams.cptec.inpe.br/documentation/>
  !#
  !# **Author**: Rodrigues, L.F. **&#9993;**<mailto:luiz.rodrigues@inpe.br>
  !#
  !# **Date**: 2015Sep
  !# @endnote
  !#
  !# @changes
  !#
  !# + 20190213 Now using ifdef to color case (-Dcolor)
  !# @endchanges
  !# @bug
  !# No active bugs reported now
  !# @endbug
  !#
  !# @todo
  !#  &#9744; <br/>
  !# @endtodo
  !#
  !# @warning
  !# Now is under CC-GPL License, please see
  !# &copy; <https://creativecommons.org/licenses/GPL/2.0/legalcode.pt>
  !# @endwarning
  !#
  !#--- ----------------------------------------------------------------------------------------

  interface dumpMessage
    module procedure dumpSingle
    module procedure dumpZeroInteger
    module procedure dumpZeroReal
    module procedure dump1DInteger
    module procedure dump1DReal
    module procedure dumpZeroLogical
    module procedure dump1DLogical
    module procedure dump2DReal
    module procedure dump2DInteger
    module procedure dump2DLogical
  end interface

  interface debug 
    module procedure debugText
    module procedure debugChar
    module procedure debugChar1D
    module procedure debugChar2D
    module procedure debugChar3D
    module procedure debugInt
    module procedure debugInt1D
    module procedure debugInt2D
    module procedure debugInt3D
    module procedure debugReal
    module procedure debugReal1D
    module procedure debugReal2D
    module procedure debugReal3D
    !module procedure debuglogical
    module procedure debuglogical1D
    module procedure debuglogical2D
    module procedure debuglogical3D
  end interface

  interface cFormat
    module procedure cFmt1DInteger
    module procedure cFmt2DInteger
    module procedure cFmt3DInteger
    module procedure cFmt1DChar
    module procedure cFmt2DChar
    module procedure cFmt3DChar
    module procedure cFmt1Dreal
    module procedure cFmt2Dreal
    module procedure cFmt3Dreal
    module procedure cFmt1Dlogical
    module procedure cFmt2Dlogical
    module procedure cFmt3Dlogical
  end interface

  character(len=*), parameter :: noticeColor=achar(27)//'[97m'&
                                 //'Notice.! '//achar(27)//'[0m'
  !# Use to put the notice word in bold color
  character(len=*), parameter :: warningColor=achar(27)//'[97m'&
                                // 'Warning! '//achar(27)//'[0m'
  !# Use to put the warning word in bold color
  character(len=*), parameter :: fatalColor=achar(27)//'[97m'&
                                // 'Fatal..! '//achar(27)//'[0m'
  !# Use to put the fatal word in bold color

  private

  public :: dumpMessage, emptyLine, logical2Int,openLogFile, debug,l2int

  logical, parameter :: showInColor=.true.

contains

  integer function openLogFile()
    !#Function to open a log file
    !#
    !# @note
    !# ![](http://brams.cptec.inpe.br/wp-content/uploads/2015/11/logo-brams.navigation.png "")
    !#
    !# **Brief**: Open a log file to print log information
    !# The unit is suplied by logUnit that is set in constants.h
    !#
    !# **Documentation**: <http://brams.cptec.inpe.br/documentation/>
    !#
    !# **Author**: Rodrigues, L.F. **&#9993;**<mailto:luiz.rodrigues@inpe.br>
    !#
    !# **Date**: 2019Feb
    !# @endnote
    !#
    !# @changes
    !#
    !# @endchanges
    !# @bug
    !# No active bugs reported now
    !# @endbug
    !#
    !# @todo
    !#  &#9744; <br/>
    !# @endtodo
    !#
    !# @warning
    !# Now is under CC-GPL License, please see
    !# &copy; <https://creativecommons.org/licenses/GPL/2.0/legalcode.pt>
    !# @endwarning
    !#
    !#--- ----------------------------------------------------------------------------------------
    include "constants.h"

    openLogFile=0
    if(logUnit/=6) open(unit=logUnit,file='bramsLog.out',ERR=100)
    return

100 openLogFile=-1

  end function openLogFile

  integer function logical2Int(logicalValue)
    !#Convert a logical value to integer
    !#
    !# @note
    !# ![](http://brams.cptec.inpe.br/wp-content/uploads/2015/11/logo-brams.navigation.png "")
    !#
    !# **Brief**: return a integer value 1 if logicalValue=.true. (zero if not)
    !#
    !# **Documentation**: <http://brams.cptec.inpe.br/documentation/>
    !#
    !# **Author**: Rodrigues, L.F. **&#9993;**<mailto:luiz.rodrigues@inpe.br>
    !#
    !# **Date**: 2019Feb
    !# @endnote
    !#
    !# @changes
    !#
    !# @endchanges
    !# @bug
    !# No active bugs reported now
    !# @endbug
    !#
    !# @todo
    !#  &#9744; <br/>
    !# @endtodo
    !#
    !# @warning
    !# Now is under CC-GPL License, please see
    !# &copy; <https://creativecommons.org/licenses/GPL/2.0/legalcode.pt>
    !# @endwarning
    !#
    !#--- ----------------------------------------------------------------------------------------
    implicit none

    logical,intent(in) :: logicalValue
    !# .true. or .false.
    logical2Int=0
    if(logicalValue) logical2Int=1

  end function logical2Int

  integer function emptyLine(tty)
    !#Write an empty line in tty
    !#
    !# @note
    !# ![](http://brams.cptec.inpe.br/wp-content/uploads/2015/11/logo-brams.navigation.png "")
    !#
    !# **Brief**: write an empty line in tty (tty is the file to be write)
    !#
    !# **Documentation**: <http://brams.cptec.inpe.br/documentation/>
    !#
    !# **Author**: Rodrigues, L.F. **&#9993;**<mailto:luiz.rodrigues@inpe.br>
    !#
    !# **Date**: 2019Feb
    !# @endnote
    !#
    !# @changes
    !#
    !# @endchanges
    !# @bug
    !# No active bugs reported now
    !# @endbug
    !#
    !# @todo
    !#  &#9744; <br/>
    !# @endtodo
    !#
    !# @warning
    !# Now is under CC-GPL License, please see
    !# &copy; <https://creativecommons.org/licenses/GPL/2.0/legalcode.pt>
    !# @endwarning
    !#
    !#--- ----------------------------------------------------------------------------------------
    implicit none

    include "constants.h"
    integer, intent(in) :: tty
    !# terminal/file to print

    write(tty,fmt='(A)') c_empty

    emptyLine=0

  end function emptyLine

  integer function dumpSingle(tty,color,header,version,dumpType,message)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print


    select case(dumpType)
    case(c_noError)
      write(tty,fmt='(A)') header//' '//version//' '//message
      dumpSingle=0
    case(c_notice)
if (showInColor) then
        write(tty,fmt='(A)') noticeColor//header//' ' //version//' '//achar(27)&
        //'[32m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Notice! '//header//' '//version//' '//message
endif
      dumpSingle=1
    case(c_warning)
if (showInColor) then
        write(tty,fmt='(A)') warningColor//header//' '//version//' ' &
        //achar(27)//'[93m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Warning!! '//header//' '//version//' '//message
endif
      dumpSingle=2
    case(c_fatal)
if (showInColor) then
        write(tty,fmt='(A)') fatalColor//header//' '//version//' '&
        //achar(27)//'[31m'//message//achar(27)//'[0m'
        write(tty,fmt='(A)') c_blink//'Fatal Error! See the message above!' &
                           //c_noColor
else
        write(tty,fmt='(A)') 'Fatal!!! from '//header//' '//version//' '&
        //message
        write(tty,fmt='(A)') '!!!!!!! Fatal Error! See the message above !!!!!!!!'
endif

      print *,c_empty
      stop
    end select

  end function dumpSingle

  integer function dumpZeroInteger(tty,color,header,version,dumpType,message &
                   ,value,cFormat)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    integer,intent(in) :: value
    !# Integer value to print
    character(len=*), intent(in) :: cFormat
    !# Format of number output

    select case(dumpType)
    case(c_noError)
      write(tty,fmt='(A,'//cFormat//')') header//' '//version&
              //' '//message//' ',value
      dumpZeroInteger=0
    case(c_notice)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') noticeColor//header//' '//version &
             //' '//achar(27)//'[32m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[95m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Notice! '//header//' '//version&
              //' '//message//' ',value
endif
      dumpZeroInteger=1
    case(c_warning)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') warningColor//header//' '//version&
             //' '//achar(27)//'[93m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[95m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Notice! '//header//' '//version&
              //' '//message//' ',value
endif
      dumpZeroInteger=2
    case(c_fatal)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') fatalColor//header//' '//version &
             //' '//achar(27)//'[31m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[95m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Fatal!!! from '//header//'|' &
             //version//' '//message//' ',value
endif
      write(tty,fmt='(A)') c_blink//'Fatal Error! See the message above!'&
                         //c_noColor
      print *,c_empty
      stop
    end select

  end function dumpZeroInteger

  integer function dumpZeroReal(tty,color,header,version,dumpType,message &
                   ,value,cFormat)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    real,intent(in) :: value
    !# real value to print
    character(len=*), intent(in) :: cFormat
    !# Format of number output

    select case(dumpType)
    case(c_noError)
      write(tty,fmt='(A,'//cFormat//')') header//' '//version&
              //' '//message//' ',value
      dumpZeroReal=0
    case(c_notice)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') noticeColor//header//' '//version &
             //' '//achar(27)//'[32m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[35m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Notice! '//header//' '//version&
              //' '//message//' ',value
endif
      dumpZeroReal=1
    case(c_warning)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') warningColor//header//' '//version&
             //' '//achar(27)//'[93m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[35m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Notice! '//header//' '//version&
              //' '//message//' ',value
endif
      dumpZeroReal=2
    case(c_fatal)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') fatalColor//header//' '//version &
             //' '//achar(27)//'[31m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[35m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Fatal!!! from '//header//'|' &
             //version//' '//message//' ',value
endif
      write(tty,fmt='(A)') c_blink//'Fatal Error! See the message above!'&
                         //c_noColor
      print *,c_empty
      stop
    end select

  end function dumpZeroReal

  integer function dump1DInteger(tty,color,header,version,dumpType,message &
                   ,value,cFormat)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    integer,intent(in) :: value(:)
    !# Integer value to print
    character(len=*), intent(in) :: cFormat
    !# Format of number output

    integer,allocatable :: value2d(:,:)
    allocate(value2d(size(value,1),1))

    value2d(:,1)=value(:)

    dump1DInteger=dump2dInteger(tty,color,header,version,dumpType,message &
                  ,value2d,cFormat)

  end function dump1DInteger

  integer function dump1DReal(tty,color,header,version,dumpType,message,value &
                   ,cFormat)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    real,intent(in) :: value(:)
    !# Integer value to print
    character(len=*), intent(in) :: cFormat
    !# Format of number output

    real,allocatable :: value2d(:,:)
    allocate(value2d(size(value,1),1))

    value2d(:,1)=value(:)

    dump1DReal=dump2dReal(tty,color,header,version,dumpType,message,value2d &
              ,cFormat)

  end function dump1DReal

  integer function dump1DLogical(tty,color,header,version,dumpType,message &
                   ,value)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    logical,intent(in) :: value(:)
    !# Integer value to print

    character(len=*), parameter :: cFormat='L1'
    !# Format of number output
    logical,allocatable :: value2d(:,:)
    !# var with one more dimension
    integer :: err

    allocate(value2d(size(value,1),1))

    value2d(:,1)=value(:)

    dump1DLogical=dump2DLogical(tty,color,header,version,dumpType,message &
                  ,value2d)

  end function dump1DLogical

  integer function dumpZeroLogical(tty,color,header,version,dumpType,message &
                   ,value)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    logical,intent(in) :: value
    !# real value to print

    character(len=*), parameter :: cFormat='L1'
    !# Format of number output

    select case(dumpType)
    case(c_noError)
      write(tty,fmt='(A,'//cFormat//')') header//' '//version&
              //' '//message//' ',value
      dumpZeroLogical=0
    case(c_notice)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') noticeColor//header//' '//version &
             //' '//achar(27)//'[32m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[34m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Notice! '//header//' '//version&
              //' '//message//' ',value
endif
      dumpZeroLogical=1
    case(c_warning)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') warningColor//header//' '//version&
             //' '//achar(27)//'[93m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[34m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Warning! '//header//' '//version&
              //' '//message//' ',value
endif
      dumpZeroLogical=2
    case(c_fatal)
if (showInColor) then
        write(tty,fmt='(A,'//cFormat//',A)') fatalColor//header//' '//version &
             //' '//achar(27)//'[31m'//message//achar(27)//'[0m'//' ' &
             //achar(27)//'[34m',value,achar(27)//'[0m'
else
        write(tty,fmt='(A,'//cFormat//')') 'Fatal!!! from '//header//'|' &
             //version//' '//message//' ',value
endif
      write(tty,fmt='(A)') c_blink//'Fatal Error! See the message above!'&
                         //c_noColor
      print *,c_empty
      stop
    end select

  end function dumpZeroLogical

  integer function dump2DReal(tty,color,header,version,dumpType,message,value &
                   ,cFormat)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    real,intent(in) :: value(:,:)
    !# real value to print
    character(len=*), intent(in) :: cFormat
    !# Format of number output


    character(len=4) :: c_sizeArray
    integer :: iCount

    write(c_sizeArray,fmt='(I4.4)') size(value,1)

    select case(dumpType)
    case(c_noError)
      write(tty,fmt='(A)') header//' '//version//' '//message
      dump2DReal=0
    case(c_notice)
if (showInColor) then
        write(tty,fmt='(A)') noticeColor//header//' ' //version//' '//achar(27)&
        //'[32m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Notice! '//header//' '//version//' '//message
endif

      dump2DReal=1
    case(c_warning)
if (showInColor) then
        write(tty,fmt='(A)') warningColor//header//' '//version//' ' &
             //achar(27)//'[93m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Warning! '//header//' '//version//' '//message
endif

      dump2DReal=2
    case(c_fatal)
if (showInColor) then
        write(tty,fmt='(A)') fatalColor//header//' ' //version//' '//achar(27) &
             //'[31m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Fatal!!! '//header//' '//version//' '//message
endif

    end select
    !
if (showInColor) then
    do iCount=1,size(value,2)
      write(tty,fmt='(A,'//c_sizeArray//'('//cFormat//',1X),A)') achar(27) &
           //'[35m',value(:,iCount),achar(27)//'[0m'
    enddo
else
    do iCount=1,size(value,2)
      write(tty,fmt='('//c_sizeArray//'('//cFormat//',1X))') value(:,iCount)
    enddo
endif

    !
    if(dumpType==c_fatal) then
if (showInColor) then
      write(tty,fmt='(A)') c_blink//'Fatal Error! See the message above!' &
                         //c_noColor
else
      write(tty,fmt='(A)') 'Fatal Error! See the message above!'
endif
      print *,c_empty
      stop
    endif

  end function dump2DReal

  integer function dump2DInteger(tty,color,header,version,dumpType,message&
                   ,value,cFormat)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    integer,intent(in) :: value(:,:)
    !# real value to print
    character(len=*), intent(in) :: cFormat
    !# Format of number output


    character(len=4) :: c_sizeArray
    integer :: iCount

    write(c_sizeArray,fmt='(I4.4)') size(value,1)

    select case(dumpType)
    case(c_noError)
      write(tty,fmt='(A)') header//' '//version//' '//message
      dump2DInteger=0
    case(c_notice)
if (showInColor) then
        write(tty,fmt='(A)') noticeColor//header//' ' //version//' '//achar(27)&
        //'[32m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Notice! '//header//' '//version//' '//message
endif

      dump2DInteger=1
    case(c_warning)
if (showInColor) then
        write(tty,fmt='(A)') warningColor//header//' '//version//' ' &
             //achar(27)//'[93m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Warning! '//header//' '//version//' '//message
endif

      dump2DInteger=2
    case(c_fatal)
if (showInColor) then
        write(tty,fmt='(A)') fatalColor//header//' ' //version//' '//achar(27) &
             //'[31m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Fatal!!! '//header//' '//version//' '//message
endif

    end select
    !
if (showInColor) then
    do iCount=1,size(value,2)
      write(tty,fmt='(A,'//c_sizeArray//'('//cFormat//',1X),A)') achar(27) &
           //'[95m',value(:,iCount),achar(27)//'[0m'
    enddo
else
  do iCount=1,size(value,2)
    write(tty,fmt='('//c_sizeArray//'('//cFormat//',1X),A)') value(:,iCount)
  enddo
endif
    !
    if(dumpType==c_fatal) then
if (showInColor) then
      write(tty,fmt='(A)') c_blink//'Fatal Error! See the message above!' &
                         //c_noColor
else
      write(tty,fmt='(A)') 'Fatal Error! See the message above!'
endif
      print *,c_empty
      stop
    endif


  end function dump2DInteger


  integer function dump2DLogical(tty,color,header,version,dumpType,message &
                  ,value)
    implicit none

    include "constants.h"

    integer, intent(in) :: tty
    !# terminal/file to print
    logical, intent(in) :: color
    !# if is to color message
    character(len=*), intent(in) :: header
    !# Name of procedure that invokes
    character(len=*), intent(in) :: version
    !# version of the procedure
    integer, intent(in) :: dumpType
    !# Type of dump message: notice, warning or fatal
    character(len=*), intent(in) :: message
    !# message text to print
    logical,intent(in) :: value(:,:)
    !# real value to print

    character(len=*), parameter :: cFormat='L1'
    !# Format of number output


    character(len=4) :: c_sizeArray
    integer :: iCount

    write(c_sizeArray,fmt='(I4.4)') size(value,1)

    select case(dumpType)
    case(c_noError)
      write(tty,fmt='(A)') header//' '//version//' '//message
      dump2DLogical=0
    case(c_notice)
if (showInColor) then
        write(tty,fmt='(A)') noticeColor//header//' ' //version//' '//achar(27)&
        //'[32m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Notice! '//header//' '//version//' '//message
endif

      dump2DLogical=1
    case(c_warning)
if (showInColor) then
        write(tty,fmt='(A)') warningColor//header//' '//version//' ' &
             //achar(27)//'[93m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Warning! '//header//' '//version//' '//message
endif

      dump2DLogical=2
    case(c_fatal)
if (showInColor) then
        write(tty,fmt='(A)') fatalColor//header//' ' //version//' '//achar(27) &
             //'[31m'//message//achar(27)//'[0m'
else
        write(tty,fmt='(A)') 'Fatal!!! '//header//' '//version//' '//message
endif

    end select
    !
    do iCount=1,size(value,2)
      write(tty,fmt='(A,'//c_sizeArray//'('//cFormat//',1X),A)') achar(27) &
           //'[34m',value(:,iCount),achar(27)//'[0m'
    enddo

    !
    if(dumpType==c_fatal) then
      write(tty,fmt='(A)') c_blink//'Fatal Error! See the message above!' &
                         //c_noColor
      print *,c_empty
      stop
    endif

  end function dump2DLogical


  integer function debugText(message,author,sourceName,procedureName,action,myProc,wProc)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc
    write(*,*) c_IYellow

    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugText=0

    

  end function debugText

  integer function debugChar(message,author,sourceName,procedureName,action,myProc,wProc,CharValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    character(len=*), intent(in) :: CharValue
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc
    
    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    write(*,*) '{DBG: } '//CharValue
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugChar=0
    write(*,*) c_noColor
  end function debugChar

  integer function debugChar1D(message,author,sourceName,procedureName,action,myProc,wProc,CharValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    character(len=*), intent(in) :: CharValue(:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(charValue)
      write(*,fmt=cFormat(charValue)) i,CharValue(i)
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugChar1D=0
    write(*,*) c_noColor
    
  end function debugChar1D

    integer function debugChar2D(message,author,sourceName,procedureName,action,myProc,wProc,CharValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    character(len=*), intent(in) :: CharValue(:,:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i,j

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(charValue,1)
      do j=1,size(CharValue,2)
         write(*,fmt=cFormat(charValue)) i,j,CharValue(i,j)
      enddo
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugChar2D=0
    write(*,*) c_noColor
    
  end function debugChar2D

  integer function debugChar3D(message,author,sourceName,procedureName,action,myProc,wProc,CharValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    character(len=*), intent(in) :: CharValue(:,:,:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i,j,k

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(charValue,1)
      do j=1,size(CharValue,2)
        do k=1,size(CharValue,3)
           write(*,fmt=cFormat(charValue)) i,j,k,CharValue(i,j,k)
        enddo
      enddo
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugChar3D=0
    write(*,*) c_noColor
    
  end function debugChar3D



  integer function debugInt(message,author,sourceName,procedureName,action,myProc,wProc,intValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    integer, intent(in) :: intValue
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc
    
    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    write(*,*) '{DBG: } ',intValue
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugInt=0
    write(*,*) c_noColor
  end function debugInt

  integer function debugInt1D(message,author,sourceName,procedureName,action,myProc,wProc,intValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    integer, intent(in) :: intValue(:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i

    write(*,*) c_IYellow

    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(intValue)
      write(*,fmt=cFormat(intValue)) i,intValue(i)
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugInt1D=0
    write(*,*) c_noColor
    
  end function debugInt1D

  integer function debugInt2D(message,author,sourceName,procedureName,action,myProc,wProc,intValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    integer, intent(in) :: intValue(:,:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i,j

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(intValue,1)
      do j=1,size(intValue,2)
        write(*,fmt=cFormat(intValue)) i,j,intValue(i,j)
      enddo
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugInt2D=0
    write(*,*) c_noColor
    
  end function debugInt2D

  integer function debugInt3D(message,author,sourceName,procedureName,action,myProc,wProc,intValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    integer, intent(in) :: intValue(:,:,:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i,j,k

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(intValue,1)
      do j=1,size(intValue,2)
        do k=1,size(intValue,3)
          write(*,fmt=cFormat(intValue)) i,j,k,intValue(i,j,k)
        enddo
      enddo
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugInt3D=0
    write(*,*) c_noColor
    
  end function debugInt3D

  integer function writeSimpleMessage(message,author,sourceName,procedureName)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 

    write(*,*) '{DBG:'//author//':'//sourceName//':'//procedureName//'} '//message

    writeSimpleMessage=1

  end function writeSimpleMessage

  character(len=256) function cFmt1DInteger(intValue)
    integer, intent(in) :: intValue(:)
    character(len=32) :: sonc

    write(sonc,fmt='(I32)') int(log10(real(maxval(intValue)))+1)
    cFmt1DInteger='("{DBG: i V} ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc))//')'

  end function cFmt1DInteger

  character(len=256) function cFmt2DInteger(intValue)
    integer, intent(in) :: intValue(:,:)
    character(len=32) :: sonc

    write(sonc,fmt='(I32)') int(log10(real(maxval(intValue)))+1)
    cFmt2DInteger='("{DBG: i j V } ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc)) &
                                    //',1X,I'//trim(StripSpaces(sonc))//')'

  end function cFmt2DInteger

  character(len=256) function cFmt3DInteger(intValue)
    integer, intent(in) :: intValue(:,:,:)
    character(len=32) :: sonc

    write(sonc,fmt='(I32)') int(log10(real(maxval(intValue)))+1)
    cFmt3DInteger='("{DBG: i j k V } ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc)) &
                              //',1X,I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc))//')'

  end function cFmt3DInteger

  character(len=256) function cFmt1DChar(charValue)
    character(len=*), intent(in) :: charValue(:)
    character(len=32) :: sonc

    write(sonc,fmt='(I32)') int(log10(real(size(charValue)))+1)
    cFmt1DChar='("{DBG: i V} ",I'//trim(StripSpaces(sonc))//',1X,A)'

  end function cFmt1DChar

  character(len=256) function cFmt2DChar(charValue)
    character(len=*), intent(in) :: charValue(:,:)
    character(len=32) :: sonc

    integer :: max

    if(size(charValue,1)>size(charValue,2)) then 
      max=size(charValue,1)
    else 
      max=size(charValue,2)
    endif
    
    write(sonc,fmt='(I32)') int(log10(real(max))+1)
    cFmt2DChar='("{DBG: i j V } ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc)) &
                                    //',1X,A)'

  end function cFmt2DChar

  character(len=256) function cFmt3DChar(charValue)
    character(len=*), intent(in) :: charValue(:,:,:)
    character(len=32) :: sonc

    integer :: max(3),i

    do i=1,3
      max(i)=size(charValue,i)
    enddo

    write(sonc,fmt='(I32)') int(log10(real(maxval(max)))+1)
    cFmt3DChar='("{DBG: i j k V } ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc)) &
                              //',1X,I'//trim(StripSpaces(sonc))//',1X,A)'

  end function cFmt3DChar

  character(len=256) function cFmt1Dreal(realValue)
    real, intent(in) :: realValue(:)
    character(len=32) :: sonc

    write(sonc,fmt='(I32)') int(log10(real(size(realValue)))+1)
    cFmt1Dreal='("{DBG: i V} ",I'//trim(StripSpaces(sonc))//',1X,E18.6)'

  end function cFmt1Dreal

  character(len=256) function cFmt2Dreal(realValue)
    real, intent(in) :: realValue(:,:)
    character(len=32) :: sonc

    integer :: max

    if(size(realValue,1)>size(realValue,2)) then 
      max=size(realValue,1)
    else 
      max=size(realValue,2)
    endif
    write(sonc,fmt='(I32)') int(log10(real(max)))+1
    cFmt2Dreal='("{DBG: i j V } ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc)) &
                                    //',1X,E18.6)'

  end function cFmt2Dreal

  character(len=256) function cFmt3Dreal(realValue)
    real, intent(in) :: realValue(:,:,:)
    character(len=32) :: sonc

    integer :: max(3),i

    do i=1,3
      max(i)=size(realValue,i)
    enddo

    write(sonc,fmt='(I32)') int(log10(real(maxval(max)))+1)
    cFmt3Dreal='("{DBG: i j k V } ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc)) &
                              //',1X,I'//trim(StripSpaces(sonc))//',1X,E18.6)'

  end function cFmt3Dreal


  character(len=32) function StripSpaces(string)
    character(len=*) :: string
    integer :: stringLen 
    integer :: last, actual

    stringLen = len (string)
    last = 1
    actual = 1

    do while (actual < stringLen)
        if (string(last:last) == ' ') then
            actual = actual + 1
            string(last:last) = string(actual:actual)
            string(actual:actual) = ' '
        else
            last = last + 1
            if (actual < last) &
                actual = last
        endif
    end do
    StripSpaces=trim(string)

  end function StripSpaces


  integer function debugReal(message,author,sourceName,procedureName,action,myProc,wProc,realValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    real, intent(in) :: realValue
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc
    
    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    write(*,*) '{DBG: } ',realValue
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugReal=0
    write(*,*) c_noColor
  end function debugReal

  integer function debugReal1D(message,author,sourceName,procedureName,action,myProc,wProc,realValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    real, intent(in) :: realValue(:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i

    write(*,*) c_IYellow

    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(realValue)
      write(*,fmt=cFormat(realValue)) i,realValue(i)
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugReal1D=0
    write(*,*) c_noColor
    
  end function debugReal1D

  integer function debugReal2D(message,author,sourceName,procedureName,action,myProc,wProc,realValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    real, intent(in) :: realValue(:,:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i,j

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(realValue,1)
      do j=1,size(realValue,2)
        write(*,fmt=cFormat(realValue)) i,j,realValue(i,j)
      enddo
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugReal2D=0
    write(*,*) c_noColor
    
  end function debugReal2D

  integer function debugReal3D(message,author,sourceName,procedureName,action,myProc,wProc,realValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    real, intent(in) :: realValue(:,:,:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i,j,k

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(realValue,1)
      do j=1,size(realValue,2)
        do k=1,size(realValue,3)
          write(*,fmt=cFormat(realValue)) i,j,k,realValue(i,j,k)
        enddo
      enddo
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugReal3D=0
    write(*,*) c_noColor
    
  end function debugReal3D

  integer function debugLogical(message,author,sourceName,procedureName,action,myProc,wProc,logicalValue)
	!# print a color debug with a logical value_ 
	!#
	!# @note
	!# ![](http://brams.cptec.inpe.br/wp-content/uploads/2015/11/logo-brams.navigation.png "")
	!#
	!# **Brief**: print a color debug with a logical value_ _ 
	!#
	!# **Documentation**: <http://twixar.me/kW2T>
	!#
	!# **Author**: Luiz Flavio Rodrigues **&#9993;**<mailto:luiz.rodrigues@inpe.br>
	!#
	!# **Date**: 2020-04-16
	!# @endnote
	!#
	!# @changes
	!#**Changelogs:**
	!# +
	!# @endchanges
	!# @bug
	!# **Open Bugs:**
	!#
	!# @endbug
	!#
	!# @todo
	!# **Todo list:**
	!#
	!# @endtodo
	!#
	!# @warning
	!# Now is under CC-GPL License, please see
	!# &copy; <https://creativecommons.org/licenses/GPL/2.0/legalcode.pt>
	!# @endwarning
	!#
	!#--- ----------------------------------------------------------------------------------------
	
	!implicit none

	!character(len=*),parameter :: procedureName="debugLogical"
	character(len=*),parameter :: srcName="dump.F90"
	include "constants.h"

	character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    logical, intent(in) :: logicalValue
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc
    
    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    write(*,*) '{DBG: } ',logicalValue
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debugLogical=0
    write(*,*) c_noColor
	
end function debugLogical

	integer function debugLogical1D(message,author,sourceName,procedureName,action,myProc,wProc,logicalValue)
		!# print a color debug with a array 1D of logical values
		!#
		!# @note
		!# ![](http://brams.cptec.inpe.br/wp-content/uploads/2015/11/logo-brams.navigation.png "")
		!#
		!# **Brief**: print a color debug with a array 1D of logical values 
		!#
		!# **Documentation**: <http://twixar.me/kW2T>
		!#
		!# **Author**: Luiz Flavio Rodrigues **&#9993;**<mailto:luiz.rodrigues@inpe.br>
		!#
		!# **Date**: 2020-04-16
		!# @endnote
		!#
		!# @changes
		!#**Changelogs:**
		!# +
		!# @endchanges
		!# @bug
		!# **Open Bugs:**
		!#
		!# @endbug
		!#
		!# @todo
		!# **Todo list:**
		!#
		!# @endtodo
		!#
		!# @warning
		!# Now is under CC-GPL License, please see
		!# &copy; <https://creativecommons.org/licenses/GPL/2.0/legalcode.pt>
		!# @endwarning
		!#
		!#--- ----------------------------------------------------------------------------------------		
		!implicit none
	
		!character(len=*),parameter :: procedureName="debugLogical1D"
		character(len=*),parameter :: srcName="dump.F90"
		include "constants.h"
	
		character(len=*), intent(in) :: message
		character(len=*), intent(in) :: author
		character(len=*), intent(in) :: sourceName
		character(len=*), intent(in) :: procedureName 
		logical, intent(in) :: logicalValue(:)
		integer, intent(in) :: action
		integer, intent(in) :: myProc
		integer, intent(in) :: wProc
	
		integer :: i
	
		write(*,*) c_IYellow
	
		if(myProc==wProc .or. wProc==0) &
			iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
		do i=1,size(logicalValue)
		write(*,fmt=cFormat(logicalValue)) i,logicalValue(i)
		enddo
		write(*,*) c_noColor
		if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
			"{DBG: } Debug kill. See the message above!!!")
	
		debugLogical1D=0

	end function debugLogical1D

  character(len=256) function cFmt1Dlogical(logicalValue)
    logical, intent(in) :: logicalValue(:)
    character(len=32) :: sonc

    write(sonc,fmt='(I32)') int(log10(real(size(logicalValue)))+1)
    cFmt1Dlogical='("{DBG: i V} ",I'//trim(StripSpaces(sonc))//',1X,L1)'

  end function cFmt1Dlogical
  
  character(len=256) function cFmt2Dlogical(logicalValue)
    logical, intent(in) :: logicalValue(:,:)
    character(len=32) :: sonc

    integer :: max

    if(size(logicalValue,1)>size(logicalValue,2)) then 
      max=size(logicalValue,1)
    else 
      max=size(logicalValue,2)
    endif
    write(sonc,fmt='(I32)') int(log10(real(max)))+1
    cFmt2Dlogical='("{DBG: i j V } ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc)) &
                                    //',1X,L1)'

  end function cFmt2Dlogical

  character(len=256) function cFmt3Dlogical(logicalValue)
    logical, intent(in) :: logicalValue(:,:,:)
    character(len=32) :: sonc

    integer :: max(3),i

    do i=1,3
      max(i)=size(logicalValue,i)
    enddo

    write(sonc,fmt='(I32)') int(log10(real(maxval(max)))+1)
    cFmt3Dlogical='("{DBG: i j k V } ",I'//trim(StripSpaces(sonc))//',1X,I'//trim(StripSpaces(sonc)) &
                              //',1X,I'//trim(StripSpaces(sonc))//',1X,L1)'

  end function cFmt3Dlogical

  integer function debuglogical2D(message,author,sourceName,procedureName,action,myProc,wProc,logicalValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    logical, intent(in) :: logicalValue(:,:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i,j

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(logicalValue,1)
      do j=1,size(logicalValue,2)
        write(*,fmt=cFormat(logicalValue)) i,j,logicalValue(i,j)
      enddo
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debuglogical2D=0
    write(*,*) c_noColor
    
  end function debuglogical2D

  integer function debuglogical3D(message,author,sourceName,procedureName,action,myProc,wProc,logicalValue)
    include "constants.h"
    character(len=*), intent(in) :: message
    character(len=*), intent(in) :: author
    character(len=*), intent(in) :: sourceName
    character(len=*), intent(in) :: procedureName 
    logical, intent(in) :: logicalValue(:,:,:)
    integer, intent(in) :: action
    integer, intent(in) :: myProc
    integer, intent(in) :: wProc

    integer :: i,j,k

    write(*,*) c_IYellow
    if(myProc==wProc .or. wProc==0) &
        iErrNumber=writeSimpleMessage(message,author,sourceName,procedureName)
    do i=1,size(logicalValue,1)
      do j=1,size(logicalValue,2)
        do k=1,size(logicalValue,3)
          write(*,fmt=cFormat(logicalValue)) i,j,k,logicalValue(i,j,k)
        enddo
      enddo
    enddo
    write(*,*) c_noColor
    if(action==c_kill) iErrNumber=dumpMessage(c_tty,c_yes,sourceName,procedureName,c_fatal, &
           "{DBG: } Debug kill. See the message above!!!")

    debuglogical3D=0
    write(*,*) c_noColor
    
  end function debuglogical3D

  integer function l2int(lval)
	logical,intent(in) :: lval
	
	l2int=0
	if(lval) l2int=1

  end function l2int

end module dump
