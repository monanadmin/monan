# Passos de compilação do código-fonte do MPAS

## Documento Técnico - DT - Rev. Beta 0.1

##### Autores: Roberto Pinto Souto, ...

Baixando o código-fonte do repositório Git do MPAS:
```bash
$ wd
$ mkdir -p mpas/github
$ git clone --depth 1 --branch v6.3 https://github.com/MPAS-Dev/MPAS-Model.git MPAS-Model_v6.3_minerva_mlogin
$ cd MPAS-Model_v6.3_minerva_mlogin
$ git switch -c branch_v6.3
```

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

```bash
$ spack load --only dependencies mpas-model
$ spack load --list
==> 19 loaded packages
-- linux-rhel8-zen / gcc@8.4.0 ----------------------------------
hdf5@1.10.7           libevent@2.1.12    libxml2@2.9.12  netcdf-fortran@4.5.3  openssh@8.7p1           parallelio@2_5_4  zlib@1.2.11
hwloc@2.6.0           libiconv@1.16      ncurses@6.2     numactl@2.0.14        openssl@1.1.1l          pkgconf@1.8.0
libedit@3.1-20210216  libpciaccess@0.16  netcdf-c@4.8.1  openmpi@4.1.1         parallel-netcdf@1.12.2  xz@5.2.5
```

```bash
$ spack install curl%gcc@8.4.0
$ spack load curl
```

```bash
$ spack find -p netcdf-c parallel-netcdf parallelio
==> 3 installed packages
-- linux-rhel8-zen / gcc@8.4.0 ----------------------------------
netcdf-c@4.8.1          /work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/netcdf-c-4.8.1-cgxru3taqkwr2eguhpzi6ld5pk3fdhbk
parallel-netcdf@1.12.2  /work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/parallel-netcdf-1.12.2-jnzqzicokmvmogm5zthffgvo27ozoq3c
parallelio@2_5_4        /work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/parallelio-2_5_4-xbzx6sbupydf35wfo2fkfqs5rxrums4y
```

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

export NETCDF=/work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/netcdf-c-4.8.1-cgxru3taqkwr2eguhpzi6ld5pk3fdhbk
export PNETCDF=/work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/parallel-netcdf-1.12.2-jnzqzicokmvmogm5zthffgvo27ozoq3c
export PIO=/work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/parallel-netcdf-1.12.2-jnzqzicokmvmogm5zthffgvo27ozoq3c

make -j 8 gfortran CORE=atmosphere USE_PIO2=true PRECISION=single 2>&1 | tee make.output
#make -j 8 gfortran CORE=atmosphere OPENMP=true USE_PIO2=true PRECISION=single 2>&1 | tee make.output
```

```bash
$ chmod +x ../make_gfortran.sh
$ ../make_gfortran.sh

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
*******************************************************************************
```

```bash
$ mkdir bin_single
$ cp build_tables atmosphere_model make.output bin_single/
```

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

export NETCDF=/work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/netcdf-c-4.8.1-cgxru3taqkwr2eguhpzi6ld5pk3fdhbk
export PNETCDF=/work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/parallel-netcdf-1.12.2-jnzqzicokmvmogm5zthffgvo27ozoq3c
export PIO=/work/rpsouto.incc/spack/v0.17.1_minerva_mlogin/opt/spack/linux-rhel8-zen/gcc-8.4.0/parallel-netcdf-1.12.2-jnzqzicokmvmogm5zthffgvo27ozoq3c

#make -j 8 gfortran CORE=atmosphere USE_PIO2=true PRECISION=single 2>&1 | tee make.output
make -j 8 gfortran CORE=atmosphere OPENMP=true USE_PIO2=true PRECISION=single 2>&1 | tee make.output
```

```bash
$ ../make_gfortran.sh

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

```bash
$ mkdir bin_single_openmp
$ cp build_tables atmosphere_model make.output bin_single_openmp/
```
