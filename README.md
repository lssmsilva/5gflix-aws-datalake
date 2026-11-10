# 5GFlix: análise de filmes da Netflix com Amazon S3, AWS Glue e Amazon Athena

Projeto final da disciplina **Computação em Nuvem (AWS)** da pós em Big Data / Engenharia e Análise de Dados, **CESAR School**. Trabalho em grupo.

Construção de um **data lake serverless** na AWS: um dataset de ~24 milhões de avaliações de filmes é tratado em Python, armazenado no S3, catalogado pelo Glue e consultado com SQL no Athena.

## Arquitetura

```
movies.csv + customers_rating.csv
        │  (Python / pandas, Google Colab)
        ▼
netflix_dataset.csv  (24.053.764 linhas, ~1,2 GB)
        │
        ▼
Amazon S3  ──►  AWS Glue Crawler  ──►  Glue Data Catalog  ──►  Amazon Athena
(raw/)          (sdl-demo-crawler)     (sdl-demo-data.raw)       (consultas SQL)
```

A infraestrutura (bucket S3 com criptografia e log de acesso, funções IAM com privilégio mínimo para o Glue) é criada com **AWS CloudFormation**.

## Estrutura do repositório

| Caminho | Conteúdo |
|---|---|
| `notebooks/preprocessamento_5gflix.ipynb` | Tratamento do `movies.csv` e junção com as avaliações (em *chunks* de 2 milhões de linhas) |
| `infra/template-lab2.json` | Template CloudFormation (S3, políticas e funções IAM do Glue) |
| `sql/consultas_athena.sql` | As 5 consultas de análise executadas no Athena |

## Como reproduzir

1. **Pré-processamento:** coloque `movies.csv` e `customers_rating.csv` no Google Drive e rode o notebook no Colab. Ele gera o `netflix_dataset.csv`.
2. **Infraestrutura:** em `us-east-1`, crie uma pilha no CloudFormation com `infra/template-lab2.json` (marque a permissão `CAPABILITY_NAMED_IAM`).
3. **S3:** envie o `netflix_dataset.csv` para a pasta `raw/` do bucket criado.
4. **Glue:** crie um crawler apontando para `s3://<bucket>/raw/`, com a função `SDL-GlueRole` e o banco `sdl-demo-data`. Ao rodar, ele cria a tabela `raw`.
5. **Athena:** defina o local de resultados (`athena-results/` no mesmo bucket) e execute `sql/consultas_athena.sql`.
6. **Limpeza:** apague crawler, tabela e banco do Glue, os buckets, a pilha do CloudFormation e os log groups do CloudWatch para não gerar custo.

## Resultados

| Pergunta | Resposta |
|---|---|
| Quantos filmes no dataset? | 4.499 |
| 5 filmes com melhor média | Lost: Season 1 (4,671); Ghost in the Shell: S.A.C. 2nd Gig (4,5864); The Simpsons: Season 6 (4,5813); Inu-Yasha (4,5544); LOTR: Return of the King, Extended Edition: Bonus Material (4,552) |
| 9 anos com menos lançamentos | 1915, 1917, 1922, 1926 (1 filme cada); 1916, 1918, 1924, 1929, 1931 (2 filmes cada) |
| Filmes com média ≥ 4,7 na última data | 195 |
| 5 usuários que mais avaliaram | 305344 (4.467), 387418 (4.422), 2439493 (4.195), 1664010 (4.019), 2118461 (3.769) |

## Tecnologias

Python (pandas) · Google Colab · AWS CloudFormation · Amazon S3 · AWS IAM · AWS Glue · Amazon Athena

## Dados

Os arquivos de dados **não** estão no repositório (tamanho e origem de terceiros). O dataset é derivado do conjunto público de avaliações do Netflix Prize.
