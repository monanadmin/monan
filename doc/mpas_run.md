# Passos para execução do benchmark do MPAS

## Documento Técnico - DT - Rev. Beta 0.1

##### Autores: Roberto Pinto Souto, ...

## Obtenção do benchmark

O benchmark pode ser obtido a partir deste site da UCAR https://www2.mmm.ucar.edu/projects/mpas/benchmark/

Há dados para as versões v5.2, v6.x e v7.0. Neste documento os exemplos foram preparados para trabalhar com dados da versão v6.x. Inicialmente com os dados com resolução de 60 km.

```bash
$ ssh minerva
$ wd
$ mkdir -p mpas/benchmark/v6.x
$ cd mpas/benchmark/v6.x
$ wget https://www2.mmm.ucar.edu/projects/mpas/benchmark/v6.x/MPAS-A_benchmark_60km_L56.tar.gz
$ tar zxvf MPAS-A_benchmark_60km_L56.tar.gz
$ cd MPAS-A_benchmark_60km_L56
$ ls -A1
GENPARM.TBL
LANDUSE.TBL
namelist.atmosphere
OZONE_DAT.TBL
OZONE_LAT.TBL
OZONE_PLEV.TBL
README
RRTMG_LW_DATA
RRTMG_LW_DATA.DBL
RRTMG_SW_DATA
RRTMG_SW_DATA.DBL
SOILPARM.TBL
stream_list.atmosphere.diagnostics
stream_list.atmosphere.output
streams.atmosphere
VEGPARM.TBL
x1.163842.graph.info
x1.163842.graph.info.part.144
x1.163842.init.nc
```

## Preparação para rodar o benchmark

Para executar o benchmark em paralelo, deve-se realizar uma preparação prévia. O arquivo `x1.163842.init.nc` é o arquivo de malha, onde o número 163942 corresponde ao número de células da malha, relativo a resolução de 60 km.

O arquivo `x1.163842.graph.info` refere-se ao grafo associado a malha. Neste caso, o grafo possui 327680 vértices e 491520 arestas. E o arquivo `x1.163842.graph.info.part.144` contém informação do particionamento do grafo, dividido em 144 sub-regiões. Ao ser executado o MPAS em paralelo com "p" processos MPI (mpi ranks), deve existir no mesmo diretório de submissão o arquivo  `x1.163842.graph.info.part.<p>`. Portanto, o benchmark de 60 km já vem habilitado para ser executado em paralelo com exatamente  144 ranks. Para rodar com outro número de processos MPI, há duas alternativas:

- Baixar os arquivos particionados a partir do endereço 
  https://mpas-dev.github.io/atmosphere/atmosphere_meshes.html

- Gerar o arquivo particionado com a bliblioteca Metis, sobretudo quando não houver o arquivo correspondente ao número de processos MPI que deseja ser utilizado: 
  `gpmetis -minconn -contig -niter=200 x1.163842.graph.info <p>`



Na primeira alternativa, para 60 km de resolução, pode ser feito o dowload do respectivo arquivo:

```bash
$ wget http://www2.mmm.ucar.edu/projects/mpas/atmosphere_meshes/x1.163842.tar.gz
$ $ tar zxvf x1.163842.tar.gz 
x1.163842.graph.info
x1.163842.graph.info.part.1024
x1.163842.graph.info.part.12
x1.163842.graph.info.part.128
x1.163842.graph.info.part.16
x1.163842.graph.info.part.192
x1.163842.graph.info.part.24
x1.163842.graph.info.part.256
x1.163842.graph.info.part.32
x1.163842.graph.info.part.384
x1.163842.graph.info.part.48
x1.163842.graph.info.part.512
x1.163842.graph.info.part.64
x1.163842.graph.info.part.768
x1.163842.graph.info.part.96
x1.163842.grid.nc


```



Além dos arquivos de malha e do grafo, há 14 aquivos de particionamento, desde `p=12` até `p=1024`. Mas não há, por exemplo, para `p=20`, e logicamente não há também para `p<12` e` p>1024`. Para estes casos, os arquivos podem ser gerados utilizando a biblioteca metis

Alguns ambientes computacionais já possuem o pacote/módulo da biblioteca Metis instalados. Caso não se tenha disponível esta biblioteca no ambiente computacional, o usuário pode instalar em sua conta usando o Spack, para gerar o arquivo e particionamento em quantas partições forem necessárias.

```bash
$ spack install metis
==> Installing metis-5.1.0-7elj2bi46vwmxp6f3bduypj3rzienuiz
$ spack load metis
$ gpmetis -minconn -contig -niter=200 x1.163842.graph.info 20  
```
