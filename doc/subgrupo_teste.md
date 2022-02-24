# Atribuição e atividades do subgrupo de Testes

## 1. Atribuição

O Subgrupo de Testes tem a atribuição de testar todos os códigos que são levados ao controle de versão (via push) após os mesmos serem aceitos pelo Subgrupo de Revisão. Os testes devem ser completos garantindo que o modelo compila adequadamente com os compiladores disponíveis, roda nas filas e máquinas disponíveis para teste com os diversos executáveis gerados e passa pelos testes funcionais para cada conjunto de teste elaborado.

## 2. Atividades

São atividades necessárias do grupo:

**2.1 Testar o modelo na compilação:** O modelo deve ser capaz de ser compilado nos diversos compiladores disponíveis (Intel, NVIDIA, GNU) utilizando seus respectivos Makefiles e gerar os executáveis esperados.

**2.2 Rodar o modelo para cada pacote de teste** criado e para cada compilador e garantir que o modelo está estável até o fim da rodada produzindo os resultados. 

**2.3 Analisar os resultados produzidos** pelas rodadas garantindo que as mesmas estejam dentro de limites aceitáveis conforme o documento de aceitação dos resultados de rodadas.

**2.4 Criar pacotes de teste** de validação de modelos contendo alguns experimentos padrão. Esses pacotes devem conter experimentos significativos de reconhecida importância passada (furacões, chuvas intensas, etc) e ficarem disponíveis em áreas acessíveis bem como ter dados de comparação (PCDs, satélites, etc) prontos para a validação.

**2.5 Desenvolver uma regra de aceitação** dos resultados conforme limites mínimos e máximos aceitáveis de cada variável nas comparações com dados observados ou medidas de referência bem como na comparação com resultados obtidos anteriormente com versões anteriores do código.  

**2.6 Registrar todo os experimentos e seus resultados** em área organizada e com referência conhecida para efeito de consulta e comparações futuras

**2.7 Buscar ferramentas de testes,** automáticos opensource disponíveis para uso e, sempre que possível, fazer uso das mesmas para automatizar as tarefas.

**2.8 Usar ferramentas de comparação,** já desenvolvidas (ScamTec, Intercomparação de Modelos/IAG-USP, etc) e disponíveis, instalá-las e automatizá-las para análise dos resultados de comparação obtidos.

**2.9 Criar os documentos de aceitação ou rejeição dos testes,** conforme as regras de aceitação determinadas e apresentá-los ao grupo de PAD para testes de performance ou para os desenvolvedores para retrabalho. Os documentos devem ser eletrônicos.



## 3. Estrutura de Pessoal

O subgrupo de Teste será composto por um gerente e 2 analistas. Todos os membros, incluindo o gerente, podem atuar em todas as atividades necessárias e atribuídas ao subgrupo. Ao gerente cabe ainda distribuir e acompanhar as atividades, registrar o andamento no Kanban do projeto, fazer os relatórios e preencher documentos quando solicitado, preencher o documento de resultados de teste e manter a equipe comprometida com as atividades e ações necessárias para os fins do subgrupo, agendar reuniões regulares, se necessário, para melhor gerenciamento das atividades.  

