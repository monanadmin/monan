# Passos de compilação do código-fonte do MPAS

## Documento Técnico - DT - Rev. Beta 0.1

##### Autores: Roberto Pinto Souto, ...

## Cluster Minerva (Dell)

Baixando o código-fonte do repositório Git do MPAS, utilizando *branch* relativo a versão 6.3 do MPAS:

```bash
$ ssh minerva
$ wd
$ mkdir -p mpas/github
$ cd mpas/github
$ git clone --depth 1 --branch v6.3 https://github.com/MPAS-Dev/MPAS-Model.git MPAS-Model_v6.3_minerva_mlogin
$ cd MPAS-Model_v6.3_minerva_mlogin
$ git switch -c branch_v6.3
```

Mostrando informações do *commit* desta versão:

```bash
$ git log
commit 3a7b219bcc2e8fef61c629bb784e027ccdf693df (grafted, HEAD -> branch_v6.3, tag: v6.3)
Author: Michael Duda <duda@ucar.edu>
Date:   Sat May 11 14:23:21 2019 -0600

    Merge branch 'hotfix-v6.3'

    This merge addresses two minor issues in MPAS-Atmosphere.

    1) The default setting for config_o3climatology was previously 'false',
       which caused the model to use a single seasonal ozone profile everywhere
       in the model domain when the RRTMG radiation schemes was used. The default
       is now 'true', which causes the model to use the same monthly ozone
       climatology for RRTMG as is used by the CAM radiation schemes.

    2) Model simulations using a non-integer timestep would result in 'xtime'
       variables in model output files that were incorrect, which caused problems
       when trying to restart the model at the correct time. The xtime variable
       is now correct when the valid time of output files has no fractional
       seconds.

    * hotfix-v6.3:
      Fix incorrect 'xtime' variable for fractional dt
      In ./src/core_atmosphere/Registry.xml, switch the default value of the logical config_o3climatology from false to true.
      Increment version number to 6.3
```

Carregar no ambiente o gerenciador de pacotes Spack:

```bash
$ source /work/rpsouto.incc/.spack/v0.17.1_minerva/env_gnu.sh
```

Carregar as bibliotecas utilizadas pelo MPAS. Neste exemplo, são carregadas as bibliotecas compiladas pelo Spack para a instalação do pacote `mpas-model`. 

```bash
$ spack load --only dependencies mpas-model%gcc@9.3.0
spack load --list
==> 15 loaded packages
-- linux-rhel8-zen2 / gcc@9.3.0 ---------------------------------
hdf5@1.10.7  libfabric@1.13.2  libpciaccess@0.16  mpich@3.4.2  netcdf-c@4.8.1        parallel-netcdf@1.12.2  pkgconf@1.8.0  zlib@1.2.11
hwloc@2.6.0  libiconv@1.16     libxml2@2.9.12     ncurses@6.2  netcdf-fortran@4.5.3  parallelio@2_5_4        xz@5.2.5
```

Visualiza a relação de dependência entre os pacotes:

```bash
$ spack find -d mpas-model%gcc@9.3.0
==> 1 installed package
-- linux-rhel8-zen2 / gcc@9.3.0 ---------------------------------
mpas-model@7.1
    mpich@3.4.2
        hwloc@2.6.0
            libpciaccess@0.16
            libxml2@2.9.12
                libiconv@1.16
                xz@5.2.5
                zlib@1.2.11
            ncurses@6.2
        libfabric@1.13.2
    parallelio@2_5_4
        netcdf-c@4.8.1
            hdf5@1.10.7
                pkgconf@1.8.0
        netcdf-fortran@4.5.3
        parallel-netcdf@1.12.2
```



Verifica os caminhos das bibliotecas `netcdf-c`, `parallel-netcdf` e `parallelio`, necessárias para a instalação do MPAS.

```bash
$ spack find -p netcdf-c parallel-netcdf parallelio
==> 3 installed packages
-- linux-rhel8-zen2 / gcc@9.3.0 ---------------------------------
netcdf-c@4.8.1          /work/rpsouto.incc/usr/local/spack/github/spack_minerva/opt/spack/linux-rhel8-zen2/gcc-9.3.0/netcdf-c-4.8.1-vun3nal72kttni6g2ypixm5itln255us
parallel-netcdf@1.12.2  /work/rpsouto.incc/usr/local/spack/github/spack_minerva/opt/spack/linux-rhel8-zen2/gcc-9.3.0/parallel-netcdf-1.12.2-fqifcgmlaxjqlaczouf4gtxqwmebj2ab
parallelio@2_5_4        /work/rpsouto.incc/usr/local/spack/github/spack_minerva/opt/spack/linux-rhel8-zen2/gcc-9.3.0/parallelio-2_5_4-2jza7lkcznqqxtgzkymq6c6ow5xi3hqx
```

Criar script para instalação do MPAS

```bash
$ vi ../make_mpich_minerva.sh
```

Contendo o conteúdo a seguir, definindo as variáveis de ambiente `NETCDF`, `PNETCF` e `PIO`, e executando comando make com alguns parâmetros a serem seguidos na durante a compilação do código-fonte. O cabeçalho do script explica o significado de cada parâmetro. Neste exemplo o MPAS será compilado em precisão simples (single).

```bash
#!/bin/bash

#Usage: make target CORE=[core] [options]

#Example targets:
#    ifort
#    gfortran
#    xlf
#    pgi

#Availabe Cores:
#    atmosphere
#    init_atmosphere
#    landice
#    ocean
#    seaice
#    sw
#    test

#Available Options:
#    DEBUG=true    - builds debug version. Default is optimized version.
#    USE_PAPI=true - builds version using PAPI for timers. Default is off.
#    TAU=true      - builds version using TAU hooks for profiling. Default is off.
#    AUTOCLEAN=true    - forces a clean of infrastructure prior to build new core.
#    GEN_F90=true  - Generates intermediate .f90 files through CPP, and builds with them.
#    TIMER_LIB=opt - Selects the timer library interface to be used for profiling the model. Options are:
#                    TIMER_LIB=native - Uses native built-in timers in MPAS
#                    TIMER_LIB=gptl - Uses gptl for the timer interface instead of the native interface
#                    TIMER_LIB=tau - Uses TAU for the timer interface instead of the native interface
#    OPENMP=true   - builds and links with OpenMP flags. Default is to not use OpenMP.
#    OPENACC=true  - builds and links with OpenACC flags. Default is to not use OpenACC.
#    USE_PIO2=true - links with the PIO 2 library. Default is to use the PIO 1.x library.
#    PRECISION=single - builds with default single-precision real kind. Default is to use double-precision.
#    SHAREDLIB=true - generate position-independent code suitable for use in a shared library. Default is false.

export PIO=/work/rpsouto.incc/usr/local/spack/github/spack_minerva/opt/spack/linux-rhel8-zen2/gcc-9.3.0/parallelio-2_5_4-2jza7lkcznqqxtgzkymq6c6ow5xi3hqx
export NETCDF=/work/rpsouto.incc/usr/local/spack/github/spack_minerva/opt/spack/linux-rhel8-zen2/gcc-9.3.0/netcdf-c-4.8.1-vun3nal72kttni6g2ypixm5itln255us
export PNETCDF=/work/rpsouto.incc/usr/local/spack/github/spack_minerva/opt/spack/linux-rhel8-zen2/gcc-9.3.0/parallel-netcdf-1.12.2-fqifcgmlaxjqlaczouf4gtxqwmebj2ab

make -j 8 gfortran CORE=atmosphere USE_PIO2=true PRECISION=single 2>&1 | tee make.output
#make -j 8 gfortran CORE=atmosphere OPENMP=true USE_PIO2=true PRECISION=single 2>&1 | tee make.output
```

Executa o script

```bash
$ source ../make_gfortran.sh

....

*******************************************************************************
MPAS was built with default single-precision reals.
Debugging is off.
Parallel version is on.
Papi libraries are off.
TAU Hooks are off.
MPAS was built without OpenMP support.
MPAS was built with .F files.
The native timer interface is being used
Using the PIO 2 library.
*******************************************************************************o
```

A mensagem final acima informa que a compilação foi bem-sucedida, além dos parâmetros de instalação empregados. É recomendável copiar os executáveis gerados em um diretório a parte, preferencialmente com nome que remeta a alguma propriedade da compilação efetuada. 

```bash
$ mkdir bin_single
$ cp build_tables atmosphere_model make.output bin_single/
```

Tentar repetir a instalação, mas agora com ativando a opção com OpenMP 
(`OPENMP=true`). Antes, deve-se limpar a instalação atual:

```bash
$ make clean CORE=atmosphere
$ make -j 8 gfortran CORE=atmosphere OPENMP=true USE_PIO2=true PRECISION=single 2>&1 | tee make.output
```

Se tudo correr bem, ao final irá aparecer a mensagem abaixo, semelhante a anteriormente vista

```bash
....

*******************************************************************************
MPAS was built with default single-precision reals.
Debugging is off.
Parallel version is on.
Papi libraries are off.
TAU Hooks are off.
MPAS was built with OpenMP enabled.
MPAS was built with .F files.
The native timer interface is being used
Using the PIO 2 library.
*******************************************************************************
```

Copiar para um novo diretório os executáveis recém criados:

```bash
$ mkdir bin_single_openmp
$ cp build_tables atmosphere_model make.output bin_single_openmp/
```
