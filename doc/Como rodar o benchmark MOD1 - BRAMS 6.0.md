# Como rodar o benchmark MOD1 - BRAMS 6.0



O MOD1 é o modelo BRAMS 6.0. Ele representa o legado de modelos do INPE e deverá ser usado para avaliar a capacidade do sistema de supercomputação ofertado pela empresa/vendedor em resposta da RFI. Ele roda o modelo operacional do CPTEC, com 8km de resolução horizontal, para toda a América do Sul e parte do Caribe.



## Baixando os dados



Para efeito de fazer os testes de benchmark exigidos você deve baixar os seguintes arquivos:

| Arquivo               | Link | Descrição                                                                | Tamanho |
| --------------------- | ---- | ------------------------------------------------------------------------ |:-------:|
| bm-brams-basic.xz     |      | Contém os namelists (RAMSIN), tabelas, arquivos de configuração          | 370MB   |
| bm-brams-data.xz      |      | Contém os dados para uma rodada do dia 15/Maio/2022                      | 34GB    |
| bm-brams-datafix.xz   |      | Contém dados fixos (topografia, vegetação, NDVI, etc)                    | 7GB     |
| bm-brams-reference.xz |      | Contém as saídas de referência para a rodada do dia em formato GRADS/CTL | 132GB   |

Descompate cada arquivo. Será criado uma pasta chamada **bm** contendo os dados necessários para a rodada.



## Rodando o modelo



O modelo BRAMS é executado em 3 fases: MAKESFC, MAKEVFILE e INITIAL. Para efeito do teste de benchmark **só será necessário rodar e computar o tempo da última fase, a INITIAL.** Essa fase lê os arquivos gerados nas fases anteriores (surface e vfile) e executa a integração no tempo. Esses arquivos já estão disponíveis no pacote (bm-brams-data.xz) baixado permitindo que se rode apenas a fase INITIAL.

Deve-se atentar ao fato que os arquivos gerados na fase anterior estão em formato nativo do BRAMS, chamado '**vformat**' (vfm) e tem em sua base caracteres de texto (ASCII). Portanto não são incompatíveis para máquinas big-endian ou little-endian. 

Já os arquivos produzidos pelo modelo são escritos em formato binário e usam o GRADS cujo formato é descrito em [GrADS Gridded Data](http://cola.gmu.edu/grads/gadoc/aboutgriddeddata.html#formats)

Deve-se estar atento a esse fato nas comparações entre os dados produzidos na rodada e os dados de referência baixados (bm-brams-reference.xz) pois, dependendo da máquina, os dados podem estar em formatos distintos.

Dentro do diretório criado, pasta bm, encontram-se alguns arquivos importantes e exemplos de scripts de submissão do modelo.

| Arquivo/diretório                  | Informação                                                                                                                                              |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| tables                             | Contém as tabelas e arquivos extras lidos pelo modelo                                                                                                   |
| variables.csv                      | Contém a lista de variáveis disponíveis para essa versão do modelo                                                                                      |
| RAMSIN_BASIC_SFC_2022051500        | Namelist necessário para a rodada da fase MAKESFC (desnecessária em caso de rodar apenas INITIAL)                                                       |
| RAMSIN_BASIC_VFL_2022051500        | Namelist necessário para a rodada da fase MAKEVFILE (desnecessária em caso de rodar apenas INITIAL)                                                     |
| **RAMSIN_BASIC_INI_2022051500**    | **Namelist necessário para a rodada da fase INITIAL (será usado sempre)**                                                                               |
| RAMSIN_ADVANCED_2022021400         | Namelist extra usado para todos os casos e contém informações importantes para os parâmetros avançados de rodada                                        |
| brams60-oper_2022051500_sfc.sbatch | Script de submissão exemplo da fase MAKESFC usando SLURM e usado para testar a configuração do modelo (desnecessária em caso de rodar apenas INITIAL)   |
| brams60-oper_2022051500_vfl.sbatch | Script de submissão exemplo da fase MAKEVFILE usando SLURM e usado para testar a configuração do modelo (desnecessária em caso de rodar apenas INITIAL) |
| **BRAMS.INI.2022051500.sbatch**    | **Script de submissão exemplo da fase INITIAL usando SLURM e usado para testar a configuração do modelo. Esse deve ser usado sempre.**                  |

 Devem ser disparados simultâneamente 20 (vinte) instâncias do modelo BRAMS para efeito de avaliação do benchmark e 4 (quatro) instâncias do modelo MPAS. Para o MPAS o procedimento de rodada está descrito em outro documento. Eles devem rodar em uma janela máxíma de 2 (duas) horas. Para isso é necessário ajustar o diretório onde os dados de cada rodada devem ser escritos para que não haja sobreposição de dados. Antes de mais nada faça 20 scripts de submissão distintos e 20 namelists diferente baseados no usado para a fase INITIAL. Para o ajuste dos diretórios é necessário editar o namelist RAMSIN_BASIC_INI_2022051500, na seção POST, e alterar a linha:



```bash
GPREFIX = './2022051500/dataout/POST/brams-ams8km',
```



Aponte a saída em cada Namelist para um diretório distinto ou para um prefixo diferente evitando assim a sobreposição.

Depois de ajustados basta submeter as 20 (vinte) instâncias do modelo (e também as 4 do MPAS) escolhendo a quantidade de núcleos (cores) adequado para uma janela de 2 horas. 

Ao final da rodada, cada instância vai produzir uma informação no final do log produzido. O log é a saida do modelo que pode ser em tela ou em arquivo dependendo da forma de submissão. A mensagem tem o seguinte formato:



```bash
Notice.!    === Time integration ends; Total run time = 6440.2 [s]
```

No caso exemplo acima o modelo fez toda a integração em um tempo de 6440seg ou 1h47min20seg o que demonstra que coube em uma janela de 2 horas.



## Observando as saídas e fazendo a comparação



Os dados de saída, em formato GRADS, são escritos no diretório/arquivos apontados em GPREFIX.

 A área da previsão para a rodada do modelo é mostrada na figura:

![](https://i.ibb.co/BPwC5Nh/sa.png)

Para efeito de comparação use os dados de referência disponíveis no arquivo  bm-brams-reference.xz para uma mesma data e horário. O GRADS permite que sejam carregadas mais de um dado binário e permite comparações entre eles. As comparações podem ser feitas por erro absoluto ou plotando-se uma figura como a de cima (shaded) e com a outra usando isolinhas (contour) por cima. Assim é possível observar os deslocamentos espaciais dos resultados.

Abaixo um exemplo onde mostra-se um arquivo de referência (shaded) e sobre ele um arquivo de comparação (contour). Observe que nesse caso exemplo os modelos estão coerentes nos resultados.

![](https://i.ibb.co/yy7Lq3g/clab-default.png)

Diferenças pequenas causadas por otimizações, epsilon de máquina diferentes e outras são admissíveis desde que não prejudiquem substancialmente os resultados.
