# Como rodar o benchmark do MPAS

## ## Obtenção do benchmark

O benchmark pode ser obtido a partir deste site da UCAR https://www2.mmm.ucar.edu/projects/mpas/benchmark/

Há dados para as versões v5.2, v6.x e v7.0. Neste documento os exemplos foram preparados para trabalhar com dados da versão v6.x. Baixar os dados com resolução de 15 km.

```bash
$ wget https://www2.mmm.ucar.edu/projects/mpas/benchmark/v6.x/MPAS-A_benchmark_15km_L56.tar.gz
$ tar zxvf MPAS-A_benchmark_15km_L56.tar.gz
$ cd MPAS-A_benchmark_15km_L56
$ ls -A1
GENPARM.TBL
LANDUSE.TBL
OZONE_DAT.TBL
OZONE_LAT.TBL
OZONE_PLEV.TBL
README
RRTMG_LW_DATA
RRTMG_LW_DATA.DBL
RRTMG_SW_DATA
RRTMG_SW_DATA.DBL
SOILPARM.TBL
VEGPARM.TBL
namelist.atmosphere
stream_list.atmosphere.diagnostics
stream_list.atmosphere.output
streams.atmosphere
x1.2621442.graph.info
x1.2621442.graph.info.part.1024
x1.2621442.graph.info.part.1056
x1.2621442.graph.info.part.1152
x1.2621442.graph.info.part.144
x1.2621442.graph.info.part.16384
x1.2621442.graph.info.part.1728
x1.2621442.graph.info.part.1920
x1.2621442.graph.info.part.2048
x1.2621442.graph.info.part.2112
x1.2621442.graph.info.part.2304
x1.2621442.graph.info.part.240
x1.2621442.graph.info.part.256
x1.2621442.graph.info.part.288
x1.2621442.graph.info.part.3456
x1.2621442.graph.info.part.36
x1.2621442.graph.info.part.3840
x1.2621442.graph.info.part.4096
x1.2621442.graph.info.part.4608
x1.2621442.graph.info.part.480
x1.2621442.graph.info.part.512
x1.2621442.graph.info.part.576
x1.2621442.graph.info.part.72
x1.2621442.graph.info.part.8192
x1.2621442.graph.info.part.960
x1.2621442.init.nc
```

## Preparação para rodar o benchmark

Para executar o benchmark em paralelo, deve-se realizar uma preparação prévia. O arquivo `x1.2621442.init.nc` é o arquivo de malha, onde o número 26214422 corresponde ao número de células da malha, relativo a resolução de 15 km.

O arquivo `x1.2621442.graph.info` refere-se ao grafo associado a malha. Neste caso, o grafo possui 327680 vértices e 491520 arestas. Por exemplo, o arquivo `x1.26214422.graph.info.part.144` contém informação do particionamento do grafo, dividido em 144 sub-regiões. Ao ser executado o MPAS em paralelo com "p" processos MPI (mpi ranks), deve existir no mesmo diretório de submissão o arquivo  `x1.2621442.graph.info.part.<p>`. Portanto, o benchmark de 15 km já vem habilitado para ser executado em paralelo com número de mpi ranks entre 36 e 16384 mpi ranks. Para rodar com outro número de processos MPI, pode-se gerar o arquivo particionado com a bliblioteca **Metis**, sobretudo quando não houver o arquivo correspondente ao número de processos MPI que deseja ser utilizado. 

Alguns ambientes computacionais já possuem o pacote/módulo da biblioteca Metis instalados para gerar o arquivo e particionamento em quantas partições forem necessárias. Por exemplo, para criar o arquivo de particionamento para executar o MPAS com 768 processos MPI:

```bash
$ module load metis
$ gpmetis -minconn -contig -niter=200 x1.2621442.graph.info 768  
```

## Execução do benchmark do MPAS

O arquivo `namelist.atmosphere` configura os parâmetros de execução. O parâmetro que define o tempo de integração é dado por `config_run_duration = '3_00:00:00'`, ou seja, 3 dias. 

#### namelist.atmosphere

```bash
&nhyd_model
    config_time_integration_order = 2
    config_dt = 360.0
    config_start_time = '2010-10-23_00:00:00'
    config_run_duration = '3_00:00:00'
    config_split_dynamics_transport = true
    config_number_of_sub_steps = 2
    config_dynamics_split_steps = 3
    config_h_mom_eddy_visc2 = 0.0
    config_h_mom_eddy_visc4 = 0.0
    config_v_mom_eddy_visc2 = 0.0
    config_h_theta_eddy_visc2 = 0.0
    config_h_theta_eddy_visc4 = 0.0
    config_v_theta_eddy_visc2 = 0.0
    config_horiz_mixing = '2d_smagorinsky'
    config_len_disp = 60000.0
    config_visc4_2dsmag = 0.05
    config_w_adv_order = 3
    config_theta_adv_order = 3
    config_scalar_adv_order = 3
    config_u_vadv_order = 3
    config_w_vadv_order = 3
    config_theta_vadv_order = 3
    config_scalar_vadv_order = 3
    config_scalar_advection = true
    config_positive_definite = false
    config_monotonic = true
    config_coef_3rd_order = 0.25
    config_epssm = 0.1
    config_smdiv = 0.1
/
&damping
    config_zd = 22000.0
    config_xnutr = 0.2
/
&io
    config_pio_num_iotasks = 0
    config_pio_stride = 1
/
&decomposition
    config_block_decomp_file_prefix = 'x1.2621442.graph.info.part.'
/
&restart
    config_do_restart = false
/
&printout
    config_print_global_minmax_vel = true
    config_print_detailed_minmax_vel = false
/
&IAU
    config_IAU_option = 'off'
    config_IAU_window_length_s = 21600.
/
&physics
    config_sst_update = false
    config_sstdiurn_update = false
    config_deepsoiltemp_update = false
    config_radtlw_interval = '00:30:00'
    config_radtsw_interval = '00:30:00'
    config_bucket_update = 'none'
    config_physics_suite = 'mesoscale_reference'
/
&soundings
    config_sounding_interval = 'none'
/
```

O arquivo `streams.atmosphere` configura quais campos (variáveis) serão gravadas em disco durante a execução do modelo. Por exemplo, exemplo abaixo, somente as variáveis diagnósticas serão gravadas `<stream name="diagnostics"`, e em um intervalo 3 horas entre as saídas `output_interval="03:00:00"`.

#### streams.atmosphere

```bash
<streams>
<immutable_stream name="input"
                  type="input"
                  io_type="pnetcdf,cdf5"
                  precision="single"
                  filename_template="x1.2621442.init.nc"
                  input_interval="initial_only" />

<immutable_stream name="restart"
                  type="input;output"
                  filename_template="restart.$Y-$M-$D_$h.$m.$s.nc"
                  input_interval="initial_only"
                  output_interval="none" />

<stream name="output"
        type="output"
        filename_template="history.$Y-$M-$D_$h.$m.$s.nc"
        output_interval="none" >

        <file name="stream_list.atmosphere.output"/>
</stream>

<stream name="diagnostics"
        type="output"
        filename_template="diag.$Y-$M-$D_$h.$m.$s.nc"
        output_interval="03:00:00" >

        <file name="stream_list.atmosphere.diagnostics"/>
</stream>

<stream name="surface"
        type="input"
        filename_template="x1.2621442.sfc_update.nc"
        filename_interval="none"
        input_interval="none" >

        <var name="sst" />
        <var name="xice" />
</stream>

<immutable_stream name="iau"
                  type="input"
                  filename_template="x1.2621442.AmB.$Y-$M-$D_$h.$m.$s.nc"
                  filename_interval="none"
                  packages="iau"
                  input_interval="initial_only" />

</streams>
```

Para fazer uma execução do benchmark do MPAS, por exemplo, com 768 processos MPI:

```bash
mpirun -np 768 ./atmosphere_model 
```

Se a execução tiver sido bem-sucedida, no final haverá o arquivo `log.atmosphere.0000.out` mais os arquivos de saída `diag.$Y-$M-$D_$h.$m.$s.nc`:

```bash
$ ls -A1 diag.2010-10-2*
diag.2010-10-23_00.00.00.nc
diag.2010-10-23_03.00.00.nc
diag.2010-10-23_06.00.00.nc
diag.2010-10-23_09.00.00.nc
diag.2010-10-23_12.00.00.nc
diag.2010-10-23_15.00.00.nc
diag.2010-10-23_18.00.00.nc
diag.2010-10-23_21.00.00.nc
diag.2010-10-24_00.00.00.nc
```

No final do arquivo `log.atmosphere.0000.out`, com conteúdo similar abaixo, onde constam diversas informações sobre o tempo de execução do modelo. Eestes tempos mostrados abaixo **<u>NÃO SÃO</u>** referência para este *benchmark*. Servem unicamente para ilustrar como os tempos devem aparecer no arquivo.

```textile
 ********************************************************
    Finished running the atmosphere core
 ********************************************************


  Timer information:
     Globals are computed across all threads and processors

  Columns:
     total time: Global max of accumulated time spent in timer
     calls: Total number of times this timer was started / stopped.
     min: Global min of time spent in a single start / stop
     max: Global max of time spent in a single start / stop
     avg: Global max of average time spent in a single start / stop
     pct_tot: Percent of the timer at level 1
     pct_par: Percent of the parent timer (one level up)
     par_eff: Parallel efficiency, global average total time / global max total time


    timer_name                                            total       calls        min            max            avg      pct_tot   pct_par     par_eff
  1 total time                                         108.55933         1      108.55360      108.55933      108.55551   100.00       0.00       1.00
  2  initialize                                          2.90879         1        2.90325        2.90879        2.90518     2.68       2.68       1.00
  2  time integration                                  105.41750        60        1.11709        4.34186        1.75687    97.11      97.11       1.00
  3   physics driver                                    42.72809        60        0.08508        3.31167        0.48076    39.36      40.53       0.68
  4    calc_cldfraction                                  0.03789        12        0.00021        0.00353        0.00146     0.03       0.09       0.46
  4    RRTMG_sw                                         24.54703        12        0.00007        2.22271        0.98503    22.61      57.45       0.48
  4    RRTMG_lw                                         11.38007        12        0.74350        1.26351        0.85621    10.48      26.63       0.90
  4    Monin-Obukhov                                     0.05037        60        0.00066        0.00188        0.00079     0.05       0.12       0.94
  4    Noah                                              0.26593        60        0.00013        0.00460        0.00124     0.24       0.62       0.28
  4    YSU                                               1.71016        60        0.00822        0.03682        0.02081     1.58       4.00       0.73
  4    GWDO_YSU                                          0.30659        60        0.00156        0.01002        0.00367     0.28       0.72       0.72
  4    New_Tiedtke                                       3.77802        60        0.02750        0.07613        0.05256     3.48       8.84       0.83
  3   atm_rk_integration_setup                           0.62398        60        0.00285        0.06384        0.00859     0.57       0.59       0.83
  3   atm_compute_moist_coefficients                     0.23719        60        0.00285        0.01316        0.00353     0.22       0.23       0.89
  3   physics_get_tend                                   2.60354        60        0.00888        0.32133        0.02628     2.40       2.47       0.61
  3   atm_compute_vert_imp_coefs                         0.47648       180        0.00135        0.02344        0.00240     0.44       0.45       0.91
  3   atm_compute_dyn_tend                              13.14626       540        0.01580        0.07746        0.02280    12.11      12.47       0.94
  3   small_step_prep                                    1.84552       540        0.00108        0.01482        0.00264     1.70       1.75       0.77
  3   atm_advance_acoustic_step                          3.70781       720        0.00245        0.02133        0.00446     3.42       3.52       0.87
  3   atm_divergence_damping_3d                          0.62150       720        0.00074        0.00345        0.00082     0.57       0.59       0.95
  3   atm_recover_large_step_variables                   6.43380       540        0.00174        0.02330        0.01033     5.93       6.10       0.87
  3   atm_compute_solve_diagnostics                      5.30881       540        0.00288        0.02008        0.00805     4.89       5.04       0.82
  3   atm_rk_dynamics_substep_finish                     1.33117       180        0.00146        0.01797        0.00616     1.23       1.26       0.83
  3   atm_advance_scalars                                2.88886       120        0.01736        0.03217        0.02137     2.66       2.74       0.89
  3   atm_advance_scalars_mono                           5.01095        60        0.06320        0.11229        0.08087     4.62       4.75       0.97
  3   microphysics                                      13.37864        60        0.12644        0.22768        0.18437    12.32      12.69       0.83
  4    WSM6                                             12.64158        60        0.11653        0.21592        0.17171    11.64      94.49       0.81

 -----------------------------------------
 Total log messages printed:
    Output messages =                 1037
    Warning messages =                   3
    Error messages =                     0
    Critical error messages =            0
 -----------------------------------------
 Logging complete.  Closing file at 2022/06/02 12:01:06
```
