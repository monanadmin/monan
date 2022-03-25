# Atribuição e atividades do subgrupo de PAD

## 1. Atribuição

O Subgrupo de Processamento de Alto Desempenho é dividido em duas áreas, a área de testes e a área de otimização. A área de testes tem a atribuição de testar todos os códigos que são levados ao controle de versão (via push) após os mesmos serem aprovados pelo Subgrupo de Testes determinando sua performance em termos de dias de previsão por dia de computação (**DP/DC**). A área de testes deve gerar um relatório contendo uma análise do teste e apontando quais os códigos e/ou setores do código apresentam gargalos e todos os tempos medidos. A área de Otimização deve  trabalhar para buscar alternativas para otimizar dos códigos. 

## 2. Atividades

São atividades necessárias do grupo:

**2.1 Testar a performance do modelo nos diversos compiladores:** O teste deve gerar fundamentalmente um grupo de informações. O básico é para a dada configuração operacional do modelo (definida pela DIPTC) qual a capacidade do modelo em termos de DP/DC. Outra parte da informação é um profile do modelo contendo dados que apontem quais as rotinas/setores do código estão sendo gargalos na computação. Se o modelo roda dentro de um limite mínimo de dias previsão/dias de computação ele é considerado aceito e pode seguir para se fazer um merge com o trunk do modelo. Caso contrário ele é levado para análise da área de otimização.

**2.2 Buscar otimização contínua dos códigos** A área de otimização deve buscar continuamente  a otimização de qualquer código candidato ao trunk do GIT, mesmo aqueles que tenham o requisito de DP/DC aceitos.  O grupo deve trabalhar para identificar as causas de baixa performance e tratá-las quando há recursos diversos para isso. Em caso de falha grave da arquitetura do código que impeça a otimização deve-se avisar ao desenvolvedor. 

**2.3 Analisar os resultados produzidos** pelas rodadas de testes e manter um contato direto com os desenvolvedores informando do andamento dos testes e das otimizações. Quando um ciclo de teste de performance/otimização é concluído o código deve ser entregue novamente ao desenvolvedor para nova análise e encaminhamento para validação em todas as etapas. Se a otimização não for requerida, isto é, o código estar de acordo com o esperado, o mesmo deve seguir para o grupo de versionamento.

**2.4 Usar pacotes de testes** Os testes de performance devem ser realizados em cima de alguns pacotes de teste padrão, desenvolvidos pelo subgrupo de Testes e disponíveis para uso em área comum.

**2.5 Criar uma regra de aceitação** Discutir continuamente com o grupo de desenvolvedores e da DPITC para determinar qual o limite de aceitação dos testes (DP/DC) e outros fatores que possam a vir fazer parte da aceitação de performance.  

**2.6 Registrar todo os experimentos e seus resultados** em área organizada e com referência conhecida para efeito de consulta e comparações futuras.

**2.7 Buscar ferramentas de testes,** automáticos opensource disponíveis para uso e, sempre que possível, fazer uso das mesmas para automatizar as tarefas.

**2.9 Criar os documentos de aceitação ou rejeição dos testes de performance,** conforme as regras de aceitação determinadas.

## 3. Estrutura de Pessoal

O subgrupo de PAD será composto de duas áreas. Uma área de testes e outra área de otimização. A área de testes é composta por apenas um analista que será responsável por disparar, acompanhar e gerar o relatório dos testes. A área de otimização é composta de 3 membros que efetuarão trabalhos de análise, programação, modificação, reprojeto e outras envolvendo o código.  Todos os membros, incluindo o gerente, podem atuar em todas as atividades necessárias e atribuidas ao subgrupo. Ao gerente cabe ainda distribuir e acompanhar as atividades, registrar o andamento no Kanban do projeto, fazer os relatórios e preencher documentos quando solicitado, preencher o documento de resultados de teste e cobrar da equipe as atividades e ações necessárias para os fins do subgrupo. Além dos 4 membros do subgrupo o mesmo ainda tem um gerente que atua nas duas áreas distribuindo e acompanhando as atividades, registrando o andamento no Kanban do projeto, fazendo os relatórios e preenchendo documentos quando solicitado, preenchendo o documento de resultados de teste/otimização, mantendo a equipe comprometida com as atividades e ações necessárias para os fins do subgrupo agendando reuniões regulares para melhor cumprimento das atividades. 
