# Como Compilar o Modelo BRAMS

O modelo BRAMS, na revisão 6.0 tem relativa portabilidade e já foi executado em sistemas diversos. Também já foi compilado utilizando-se diversos compiladores tais como GNU, INTEL, NVIDIA (Portland), NEC e XL.  O modelo não foi portado para ser utilizado em máquinas com GPU. O mesmo se aplica aos demais modelos em uso no INPE. Entretanto compila e roda nos mais diversos tipos de máquina variando a eficiência dependendo de diversas características.

## Como baixar o  modelo BRAMS

O modelo BRAMS pode ser obtido diretamente da página do BRAMS no GITHUB. Basta buscá-lo em [GitHub - luflarois/brams: The New Brazilian developments on the Regional Atmospheric Modeling System](https://github.com/luflarois/brams) e fazer o download.

## Pré requisitos

O modelo BRAMS faz uso de diversas bibliotecas para seu correto funcionamento. Todas elas são gratuítas e podem ser obtidas diretamente pela internet. As bibliotecas necessárias **e suas dependências**  são:

- NetCDF-C

- NetCDF-Fortran

- HDF5

- WGRIB2*

> \* A biblioteca WGRIB2 está disponível no seguinte site: [Climate Prediction Center - wgrib2: grib2 utility](https://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/). **Importante**: Essa biblioteca **pode ser dispensada** para a maioria dos casos e é usada especialmente para o pré-processamento do modelo. O Benchmark não necessita dessa biblioteca pois as condições iniciais do teste estão fornecidas no pacote.

A maioria dos sitemas de computação possuem a opção de se carregar as bibliotecas via o comando `module load`

O BRAMS só é executado com comandos de MPI. Logo o sistema necessita estar preparado para isso e preferencialmente a contrução das bibliotecas deve usar o proprio MPI que preferencialmente deve estar compilado com o mesmo compilador. O modelo já foi testado com MPI da INTEL, MPICH, OpenMPI e outros.

## Compilando o modelo BRAMS

O modelo BRAMS possui um configure que é usado para apontar corretamente quais os compiladores C e Fortran serão usados e quais bibliotecas estarão ligadas com seus respectivos caminhos. **É fundamental que os compiladores e bibliotecas sejam compatíveis, preferencialmente compilados com o mesmo compilador** para que não haja erros na montagem do modelo. 

Para fazer o configure e compilar o modelo vá até o sub-diretório build na árvore do modelo.

Estando no subdiretório build execute o configure. O exemplo abaixo (para um fictício usuário oscar) mostra um comando de configuração onde todos os compiladores e bibliotecas necessárias estão em` /opt/gnu8` (lib, include e bin) e informa que o executável será colocado na pasta `/home/oscar`

```bash
./configure --program-prefix=BRAMS_6.0 --prefix=/home/oscar \
 --enable-jules \
 --with-chem=RELACS_TUV --with-aer=SIMPLE \
 --with-fpcomp=/opt/gnu8/bin/mpif90 \
 --with-cpcomp=/opt/gnu8/bin/mpicc \
 --with-fcomp=gfortran --with-ccomp=gcc \
 --with-netcdff=/opt/gnu8 --with-netcdfc=/opt/gnu8 \
 --with-wgrib2=/opt/gnu8
```

Em, alguns sistemas é necessário fazer alterações nos arquivos  Makefile e Make_utils que são produzidos após o configure. Em geral pode-se acrescentar diretivas de otimização específicas ou alterações exigidas pelos compiladores, loader, etc. Proceda adequadamente para cada caso. Podem haver problemas para uma ou outra versão do compilador. Mas são poucos os casos onde a versão mais recente apresenta falhas na compilação e/ou execução.

Após a configuração adequada proceda com os comandos de contrução do executável:

```bash
make
make install
```

O executável será produzido e com o `make install` ele será levado para um diretório apontado por --prefix. Juntamente com ele alguns outros arquivos importantes são movidos. 

> Nota: Para o benchmark **não há a necessidade de fazer o install** visto que o pacote de teste já contém os arquivos necessários. No script de submissão basta apontar o diretório onde se encontra o executável.

Caso seu sistema esteja sem as bibliotecas adequadas, no próprio diretório do modelo há documentos que auxiliam a instalação.  Não há garantia que o passo-a-passo vá funcionar em seu sistema. Contudo serve de auxílio na instalação.  
