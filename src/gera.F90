module modUtils
   !! Modulo com funções específicas
   !!
   !! @note
   !!
   !! **Project**: MONAN
   !! **Author(s)**: Rodrigues, L.F. [LFR]
   !! **e-mail**: <mailto:luiz.rodrigues@inpe.br>
   !! **Date**:  11Novembro2022 13:50
   !!
   !! **Full description**:
   !! Modulo com funções específicas
   !!
   !! @endnote
   !!
   !! @warning
   !!
   !!  [](https://www.gnu.org/graphics/gplv3-127x51.png'')
   !!
   !!     This program is free software: you can redistribute it and/or modify
   !!     it under the terms of the GNU General Public License as published by
   !!     the  Free  Software  Foundation, either version 3 of the License, or
   !!     (at your option) any later version.
   !!
   !!     This program is distributed in the hope that it  will be useful, but
   !!     WITHOUT  ANY  WARRANTY;  without  even  the   implied   warranty  of
   !!     MERCHANTABILITY or FITNESS FOR A  PARTICULAR PURPOSE.  See  the, GNU
   !!     GNU General Public License for more details.
   !!
   !!     You should have received a copy  of the GNU General  Public  License
   !!     along with this program.  If not, see <https://www.gnu.org/licenses/>.
   !!
   !! @endwarning

   use dump
   implicit none
   include 'constants.h'
   character(len=*), parameter :: sourceName = 'gera.F90' ! Nome do arquivo fonte
   character(len=*), parameter :: moduleName = 'modUtils' ! Nome do módulo

   type tm 
      character(len=256) :: fonte
      character(len=64) :: nome
   end type
   type(tm) :: modules(64000)
   integer :: totalModules
   integer :: i

   type(tm) :: uses(128000)
   integer :: totalUses

   type pcd
      character(len=64) :: bloco
      character(len=63) :: procedure
      character(len=256) :: dir 
   end type pcd
   type(pcd) :: pcds(32000)
   integer :: totalPcds

   private
   public :: leFiles, totalModules, totalUses, modules, uses, totalPcds &
           , leFontes, checaStrutura

contains

   subroutine leFiles(fileName)
      !! Lê os arquivos txt com informações do código
      !!
      !! @note
      !!
      !! **Project**: MONAN
      !! **Author(s)**: Rodrigues, L.F. [LFR]
      !! **e-mail**: <mailto:luiz.rodrigues@inpe.br>
      !! **Date**:  11Novembro2022 16:08
      !!
      !! **Full description**:
      !! Lê os arquivos txt com informações do código
      !!
      !! @endnote
      !!
      !! @warning
      !!
      !!  [](https://www.gnu.org/graphics/gplv3-127x51.png'')
      !!
      !!     Under the terms of the GNU General Public version 3
      !!
      !! @endwarning
      use modString, only: parseLine, lower
      implicit none
      !Parameters:
      character(len=*), parameter :: procedureName = 'leFiles' ! Nome da subrotina
   
      !Variables (input, output, inout)
      character(len=*), intent(in) :: fileName
   
      !Local variables:
      character(len=256) :: campo(4),campo3,campo4
      character(len=512) :: linha
      character(len=256) :: modul
   
      !Lê o arquivo que contém a lista de includes 
      open(unit=22,file=fileName//"_include.txt",status='old',action='read')
      do 
         read(unit=22,fmt="(A)",END=100) linha
         !Divide a linha:
         ! A primeira coluna (antes do :) contém o diretório e arquivo fonte
         ! A segunda coluna contém o nome do módulo (ou lixo)
         campo = parseLine(linha,":")
         modul = adjustl(trim(campo(2)))
         !Se a segunda coluna começa com a declaração de módulo pega os dados:
         ! Nome e arquivo fonte. COlocados no tipo na posição totalModules
         if(lower(modul(1:6)) == 'module') then
            !print *,"|"//adjustl(trim(campo(2)))//"|"
            totalModules = totalModules+1
            modules(totalModules)%nome  = trim(adjustl(modul(7:)))
            modules(totalModules)%fonte = trim(adjustl(campo(1)))
         endif 
      end do
   100 close(unit=22)
      !Imprime para checagem
      do i=1,totalModules
         print *,i,trim(modules(i)%nome)," : ",trim(modules(i)%fonte)
      enddo
   
      !Lê o arquivo que contém a lista de uses
      open(unit=22,file=fileName//"_use.txt",status='old',action='read')
      do 
         read(unit=22,fmt="(A)",END=200) linha
         !Divide a linha:
         ! A primeira coluna (antes do :) contém o diretório e arquivo fonte
         ! A segunda coluna contém o nome do módulo que será necessário (ou lixo)
         campo = parseLine(linha,":")
         modul = adjustl(trim(campo(2)))
         !Se a segunda coluna começa com a declaração de use pega os dados:
         ! Nome e arquivo fonte. COlocados no tipo na posição totalUses
         !print *,trim(linha)
         !print *,campo
         !print *,"|"//adjustl(trim(campo(1)))//"|"
         !print *,"|"//modul//"|"
         if(lower(modul(1:4)) == 'use ') then
            !print *,"USE: |"//adjustl(trim(campo(2)))//"|"
            totalUses = totalUses+1
            uses(totalUses)%nome  = trim(adjustl(modul(4:)))
            uses(totalUses)%fonte = trim(adjustl(campo(1)))
         endif
         !print *,'---------'   
      end do
      200 close(unit=22)
      !Retirando apenas o nome, sem as cláusulas only
      do i=1,totalUses
         campo = parseLine(uses(i)%nome,",")
         uses(i)%nome = trim(adjustl(campo(1)))
      enddo
   
      !Imprime para checagem
      do i=1,totalUses
         print *,i,trim(uses(i)%nome)," : ",trim(uses(i)%fonte)
      enddo
   
   end subroutine leFiles

   subroutine leFontes(fileName)
      !! Le os nomes dos fontes .F
      !!
      !! @note
      !!
      !! **Project**: MONAN
      !! **Author(s)**: Rodrigues, L.F. [LFR]
      !! **e-mail**: <mailto:luiz.rodrigues@inpe.br>
      !! **Date**:  14Novembro2022 10:58
      !!
      !! **Full description**:
      !! Le os nomes dos fontes .F
      !!
      !! @endnote
      !!
      !! @warning
      !!
      !!  [](https://www.gnu.org/graphics/gplv3-127x51.png'')
      !!
      !!     Under the terms of the GNU General Public version 3
      !!
      !! @endwarning
      
      use modString, only: parseLine, lower
      implicit none
      !Parameters:
      character(len=*), parameter :: procedureName = 'leFontes' ! Nome da subrotina
   
      !Variables (input, output, inout)
      character(len=*), intent(in) :: fileName
   
      !Local variables:
      character(len=256) :: campo(4),campo3,campo4
      character(len=512) :: linha
      character(len=256) :: modul
      integer :: i

      !Code:
            !Lê o arquivo que contém a lista de procedures
      open(unit=22,file=fileName,status='old',action='read')
      do 
         read(unit=22,fmt="(A)",END=300) linha
         !Divide a linha:
         ! A segunda coluna (após o primeiro /) contém o bloco
         campo = ""
         campo = parseLine(linha,"/")
         modul = adjustl(trim(campo(2)))
         !print *,'Campos: ',trim(campo(1)),"|",trim(campo(2)),"|",trim(campo(3)),"|",trim(campo(4)),"|"
         if(trim(campo(4)) == "") then 
            campo3 = campo(3)
            if(campo3(len(trim(campo3)):len(trim(campo3))) == "F") then
               totalPcds = totalPcds+1
               pcds(totalPcds)%procedure = adjustl(trim(campo(3)))
               pcds(totalPcds)%bloco  = modul
               !print *,"3- Module: |"//trim(modul)//"|",trim(pcds(totalPcds)%procedure)
            endif
         else
            campo4 = campo(4)
            if(campo4(len(trim(campo4)):len(trim(campo4))) == "F") then
               totalPcds = totalPcds+1
               pcds(totalPcds)%procedure = adjustl(trim(campo(4)))
               pcds(totalPcds)%bloco  = modul
               !print *,"4- Module: |"//trim(modul)//"|",trim(pcds(totalPcds)%procedure)
            endif
         endif
         !print *,'---------'   
      end do
300 close(unit=22)
     ! stop 23232

      !Imprime para checagem
      do i=1,totalPcds
         print *,i,trim(pcds(i)%procedure)," : ",trim(pcds(i)%bloco)
      enddo
   
   end subroutine leFontes

   subroutine checaStrutura(bloco)
      !! Faz a árvore da estrutura no bloco pedido
      !!
      !! @note
      !!
      !! **Project**: MONAN
      !! **Author(s)**: Rodrigues, L.F. [LFR]
      !! **e-mail**: <mailto:luiz.rodrigues@inpe.br>
      !! **Date**:  14Novembro2022 11:18
      !!
      !! **Full description**:
      !! Faz a árvore da estrutura no bloco pedido
      !!
      !! @endnote
      !!
      !! @warning
      !!
      !!  [](https://www.gnu.org/graphics/gplv3-127x51.png'')
      !!
      !!     Under the terms of the GNU General Public version 3
      !!
      !! @endwarning
      use modString, only: parseLine, lower   
      implicit none
      !Parameters:
      character(len=*), parameter :: procedureName = 'checaStrutura' ! Nome da subrotina
   
      !Variables (input, output, inout)
      character(len=*), intent(in) :: bloco
   
      !Local variables:
      integer :: i,j,k
      character(len=256) :: procName, procName2
      character(len=256) :: campo(4),auxCampo

   
      !Code:
      !Percorre o laço com as procedures e identifica as que pertencem ao bloco

      !Abre arquivo de saída usando a linguagem dot (Graphviz)
      open(unit=22,file=bloco//".dot", status="replace", action="write")
      write(unit=22,fmt="(A)") 'digraph G  {'
	   write(unit=22,fmt="(A)") '   fontname="Helvetica,Arial,sans-serif"'
	   write(unit=22,fmt="(A)") '   node [fontname="Helvetica,Arial,sans-serif"]'
	   write(unit=22,fmt="(A)") '   edge [fontname="Helvetica,Arial,sans-serif"]'
	   write(unit=22,fmt="(A)") '   layout=neato'
	   write(unit=22,fmt="(A)") '   center=""'
	   write(unit=22,fmt="(A)") '   node[width=.25,height=.375,fontsize=9]'

      !Percorre todos os procedures para achar aqueles que são
      !Pertentes ao bloco passado
      do i=1,totalPcds
         !SE é do bloco 
         if(trim(pcds(i)%bloco) == bloco) then
            procName = trim(pcds(i)%procedure)
            !Verifica quem essa procedure usa
            !percorrendo a lista de uses para cada fonte do bloco
            do j=1,totalUses
               auxCampo = uses(j)%fonte
               campo = parseLine(auxCampo,"/")
               if(trim(campo(3)) == "") then
                  procName2 = adjustl(trim(campo(2)))
               else 
                  procName2 = adjustl(trim(campo(3)))
               endif
               !Se achou o use então escreva a dependência no arquivo de dot
               if(trim(procName2) == trim(procName)) then
                  write(unit=22,fmt="(A,A)") '   "',trim(procName)//'" -> "'//trim(uses(j)%nome)//'" ;'
               endif
            enddo
         endif
      enddo
      write(unit=22,fmt="(A)") '}'
      close(unit=22)
   
   end subroutine checaStrutura

end module modUtils

program teste
   use modUtils

   character(len=*), parameter :: bloco="core_atmosphere"

   totalModules = 0
   totalUses = 0
   totalPcds = 0

   call leFiles("/home/rpsouto/projetos/monan/github/monan/data/core_atmosphere")
   call leFiles("/home/rpsouto/projetos/monan/github/monan/data/framework")
   call leFiles("/home/rpsouto/projetos/monan/github/monan/data/driver")
   call leFiles("/home/rpsouto/projetos/monan/github/monan/data/external")
   call leFiles("/home/rpsouto/projetos/monan/github/monan/data/operators")
   call leFiles("/home/rpsouto/projetos/monan/github/monan/data/tools")
   call leFontes("/home/rpsouto/projetos/monan/github/monan/data/listaProcedures.txt")
   call checaStrutura(bloco)

end program teste
