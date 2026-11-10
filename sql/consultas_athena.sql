-- Consultas executadas no Amazon Athena
-- Banco: "sdl-demo-data" | Tabela: "raw" (catalogada pelo AWS Glue Crawler)
-- Colunas: cust_id, rating, date, movie_id, title, year

-- 1.1 Quantos filmes existem no dataset?
SELECT COUNT(DISTINCT movie_id) AS total_filmes
FROM "sdl-demo-data"."raw";

-- 1.2 Os 5 filmes com melhor média de avaliação
SELECT title AS filme,
       ROUND(AVG(rating), 4) AS media_avaliacao
FROM "sdl-demo-data"."raw"
GROUP BY movie_id, title
ORDER BY media_avaliacao DESC, filme
LIMIT 5;

-- 1.3 Os 9 anos com menos lançamentos
SELECT year AS ano,
       COUNT(DISTINCT movie_id) AS qtd_filmes
FROM "sdl-demo-data"."raw"
WHERE year IS NOT NULL
GROUP BY year
ORDER BY qtd_filmes ASC, ano
LIMIT 9;

-- 1.4 Filmes com média >= 4,7 na última data de avaliação do dataset
SELECT COUNT(*) AS qtd_filmes
FROM (
    SELECT movie_id, AVG(rating) AS media
    FROM "sdl-demo-data"."raw"
    WHERE "date" = (SELECT MAX("date") FROM "sdl-demo-data"."raw")
    GROUP BY movie_id
    HAVING AVG(rating) >= 4.7
);

-- 1.5 Os 5 usuários que mais avaliaram filmes
SELECT cust_id AS id_usuario,
       COUNT(*) AS qtd_avaliacoes
FROM "sdl-demo-data"."raw"
GROUP BY cust_id
ORDER BY qtd_avaliacoes DESC, id_usuario
LIMIT 5;
