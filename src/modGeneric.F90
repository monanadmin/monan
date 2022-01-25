!=============================================================================================
module modGeneric
   !# This module contains generic subroutines and functions of MONAN
   !#
   !# @note
   !#
   !# **Project**  : MONAN
   !# **Author(s)**: Luiz Flávio Rodrigues [lufla]
   !# **e-mail**   : <luiz.rodrigues@inpe.br>
   !# **Date**: 24 January 2022 (Monday)
   !#
   !# **Full Description**: 
   !# A lot of generic functions and subroutines of MONAN
   !#
   !# @endnote
   !#
   !# @warning
   !#  [](https://www.gnu.org/graphics/gplv3-127x51.png"")
   !#
   !#     This program is free software: you can redistribute it and/or modify
   !#     it under the terms of the GNU General Public License as published by
   !#     the Free Software Foundation, either version 3 of the License, or
   !#     (at your option) any later version.
   !#
   !#     This program is distributed in the hope that it will be useful,
   !#     but WITHOUT ANY WARRANTY; without even the implied warranty of
   !#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   !#     GNU General Public License for more details.
   !#
   !#     You should have received a copy of the GNU General Public License
   !#     along with this program.  If not, see <https://www.gnu.org/licenses/>.
   !#
   !# @endwarning
       
      use dump !Dump contains a lot of functions for debugs and formated printouts
      implicit none
      include "constants.h"
      character(len = *),parameter :: sourceName = '' !Name of this source code
      character(len = *),parameter :: moduleName = '**modGeneric**' !Name of this procedure
      
      private
      public :: mainHeader

   contains
      
      !=============================================================================================
      integer function mainHeader(outTermIn)
        !# write a header in output
        !#
        !# @note
        !#
        !# **Project**  : MONAN
        !# **Author(s)**: Luiz Flávio Rodrigues [lufla]
        !# **e-mail**   : <luiz.rodrigues@inpe.br>
        !# **Date**: 24 January 2022 (Monday)
        !#
        !# **Full Description**: 
        !# Only write a header and licence warning
        !#
        !# @endnote
    
        implicit none
        
        !Parameters
        character(len=*),parameter :: procedureName = '**mainHeader**' !Name of this procedure
        integer, parameter :: defaultTerm = 6
    
        !Variables intent(in/out)
        integer, intent(in), optional :: outTermIn
        !# Number of tty output or file number
    
        !Local Variables
        integer :: outTerm
    
        !Code area
        if(present(outTermIn)) then
          outTerm = outTermIn
        else
          outTerm = defaultTerm
        endif

        write (outTerm,fmt = '(A)') achar(27)//'[34m'
        write (outTerm,fmt = '(A)') '                               ... .                       ... .'
        write (outTerm,fmt = '(A)') '                               .... ...                  . .... .'
        write (outTerm,fmt = '(A)') '                                 .. ... ..             ... ....'
        write (outTerm,fmt = '(A)') '                          .       . ... ...          . ... ...       ..'
        write (outTerm,fmt = '(A)') '                       .. ...        .. .... .     ... ...        .. ... .'
        write (outTerm,fmt = '(A)') '                       .. ....        . .... ..   .... ...       ... ... .'
        write (outTerm,fmt = '(A)') '                          .... ..        ... .... ....        . .... ..'
        write (outTerm,fmt = '(A)') '               . ....       .. ....        . .... ...       ... ....      ... ..'
        write (outTerm,fmt = '(A)') '               . .... .      . .... .        .... .        .... ...      .... ...'
        write (outTerm,fmt = '(A)') '                 .... ...       ... ...        ..       .. .... .     .. .... .'
        write (outTerm,fmt = '(A)') '          .       ... ... .      .. ... .              ... ....      ... ....       .'
        write (outTerm,fmt = '(A)') '        ... ..      . ... ...       ... ...         .. ... ..     .. ... ..      . ... .'
        write (outTerm,fmt = '(A)') '        ... ....       .. .... .      . .... .    .... ...      .... ...       ... ...'
        write (outTerm,fmt = '(A)') '         .. .... .      . .... ..     . .... .. . .... ..     . .... ..       .... ..'
        write (outTerm,fmt = '(A)') ' . ..       .... ...       ... ....       .. .... ....      ... .... .     .. ....        . ..'
        write (outTerm,fmt = '(A)') '.. ...       ... ....       .. .... .     .. .... ...      .... ...       ... ...        .. ..'
        write (outTerm,fmt = '(A)') '.. .... .      . .... ..       .... ...      .... .     .. .... ..     . .... ..        ... ..'
        write (outTerm,fmt = '(A)') '    ... ...       ... ... .      .. ... ..           . ... ....      ... ....       .. .... .'
        write (outTerm,fmt = '(A)') '    ... ... .      .. ... ..      . ... ...         .. ... ..      . ... ...       ... ....'
        write (outTerm,fmt = '(A)') '      . ... ...       ... ....       .. ....      .... ... .     ... ... .       . ... ..'
        write (outTerm,fmt = '(A)') '        ... ....       .. .... .      . .... .. . .... ..       .... ...       ... ... .'
        write (outTerm,fmt = '(A)') '          . .... ..       .... ...       ... .... .... .     .. .... .        .... ..'
        write (outTerm,fmt = '(A)') '             ... ....       .. .... .      . .... ...      .... ...        .. ....'
        write (outTerm,fmt = '(A)') '             ... ....       .. .... .      . .... ...      .... ...       ... ....'
        write (outTerm,fmt = '(A)') '          . .... ..       .... ...       ... .... ....       .. .... .      . .... ..'
        write (outTerm,fmt = '(A)') '        ... ....       .. .... .      . .... ..   .... ..       .... ...       ... ... .'
        write (outTerm,fmt = '(A)') '      . ... ...       ... ....       .. .... .     ... ...       ... ... .      .. ... ..'
        write (outTerm,fmt = '(A)') '    ... ... .       . ... ..      . ... ...          . ... ..      . ... ...       ... ....'
        write (outTerm,fmt = '(A)') '   .... ...       ... ... .      .. ... ..    ...      ... ...       ... ....       .. .... .'
        write (outTerm,fmt = '(A)') '.. .... .      . .... ..       .... ...      .... ..     . .... .      . .... ..       .... ..'
        write (outTerm,fmt = '(A)') ' . ...        .. ....       .. .... .     .. .... ....      ... ...       ... ....       .. ..'
        write (outTerm,fmt = '(A)') '   ..       .... ...       ... ....      ... .... .... .     .. ....       .. .... .      . ..'
        write (outTerm,fmt = '(A)') '          . .... .      . .... ..     . .... ..   .... ...      .... ..       .... ...'
        write (outTerm,fmt = '(A)') '        ... ....       .. .... .     .. .... .     ... ... .     ... ...       ... ... .'
        write (outTerm,fmt = '(A)') '         .. ..      . ... ...     . ... ...          . ... ...     . ... ..      . ... .'
        write (outTerm,fmt = '(A)') '                  ... ... .     ... ... .      .        .. .... .     .. ....'
        write (outTerm,fmt = '(A)') '                 .... ...      .... ...       ...        . .... ..     . .... .'
        write (outTerm,fmt = '(A)') '               . .... .     .. .... .      . .... ..        ... ...       ... ...'
        write (outTerm,fmt = '(A)') '                 ....      ... ....       .. .... ...        .. .... .     .. ..'
        write (outTerm,fmt = '(A)') '                        . .... ..       .... .... .... .        .... ...'
        write (outTerm,fmt = '(A)') '                      ... ....       .. .... .     ... ...        .. ... .'
        write (outTerm,fmt = '(A)') '                       .. ...       ... ....        .. ... .       . ...'
        write (outTerm,fmt = '(A)') '                                 .. ... ..             ... ...'
        write (outTerm,fmt = '(A)') '                                ... ... .               .. ....'
        write (outTerm,fmt = '(A)') '                               .... ..                     .... ..'
        write (outTerm,fmt = '(A)') '                                ...                          ..'
        write (outTerm,fmt = '(A)') '                                ...                          ..'
        write (outTerm,fmt = '(A)') achar(27)//'[0m'
        write (outTerm,fmt = '(A)') '                                __  __  ___  _   _    _    _   _'
        write (outTerm,fmt = '(A)') '                               |  \/  |/ _ \| \ | |  / \  | \ | |'
        write (outTerm,fmt = '(A)') '                               | |\/| | | | |  \| | / _ \ |  \| |'
        write (outTerm,fmt = '(A)') '                               | |  | | |_| | |\  |/ ___ \| |\  |'
        write (outTerm,fmt = '(A)') '                               |_|  |_|\___/|_| \_/_/   \_\_| \_|'
        write (outTerm,fmt = '(A)') ''
        write (outTerm,fmt = '(A)') ''
        write (outTerm,fmt = '(A)') '                               Copyright (C) 2022 MONAN Community'
        write (outTerm,fmt = '(A)') ''
        write (outTerm,fmt = '(A)') '               This program is free software: you can redistribute it and/or modify'
        write (outTerm,fmt = '(A)') '               it under the terms of the GNU General Public License as published by'
        write (outTerm,fmt = '(A)') '               the Free Software Foundation, either version  3 of  the  License, or'
        write (outTerm,fmt = '(A)') '               (at your option) any later version.'
        write (outTerm,fmt = '(A)') '               '
        write (outTerm,fmt = '(A)') '               This program is distributed in the hope that it will be  useful, but' 
        write (outTerm,fmt = '(A)') '               WITHOUT  ANY  WARRANTY;  without  even   the   implied  warranty  of'
        write (outTerm,fmt = '(A)') '               MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.   See the'
        write (outTerm,fmt = '(A)') '               GNU General Public License for more details.'
        write (outTerm,fmt = '(A)') '               '
        write (outTerm,fmt = '(A)') '               You should have received a copy of the GNU  General  Public  License'
        write (outTerm,fmt = '(A)') '               along with this program. If not, see <https://www.gnu.org/licenses/>'
        write (outTerm,fmt = '(A)') ''     
        write (outTerm,fmt = '(A)') ''

        mainHeader = 0

      end function mainHeader 

end module modGeneric 
