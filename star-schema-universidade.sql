-- ============================================================
-- Desafio Power BI — Star Schema para Cenários Acadêmicos
-- Banco de dados: universidade_star_schema
-- Projeto educacional — DIO
-- Autor: Marcos Roberto
-- ============================================================

CREATE DATABASE IF NOT EXISTS universidade_star_schema;

USE universidade_star_schema;

-- ============================================================
-- DIMENSÃO PROFESSOR
-- ============================================================

CREATE TABLE dim_professor (
    professor_key INT PRIMARY KEY AUTO_INCREMENT,
    id_professor_origem INT NOT NULL,
    nome_professor VARCHAR(100) NOT NULL,
    titulacao VARCHAR(50)
);

INSERT INTO dim_professor
    (id_professor_origem, nome_professor, titulacao)
VALUES
    (101, 'Ana Souza', 'Doutorado'),
    (102, 'Carlos Mendes', 'Mestrado'),
    (103, 'Juliana Martins', 'Doutorado'),
    (104, 'Ricardo Almeida', 'Mestrado'),
    (105, 'Fernanda Lima', 'Especialização'),
    (106, 'Paulo Oliveira', 'Doutorado');

-- ============================================================
-- DIMENSÃO DEPARTAMENTO
-- ============================================================

CREATE TABLE dim_departamento (
    departamento_key INT PRIMARY KEY AUTO_INCREMENT,
    id_departamento_origem INT NOT NULL,
    nome_departamento VARCHAR(100) NOT NULL,
    campus VARCHAR(100)
);

INSERT INTO dim_departamento
    (id_departamento_origem, nome_departamento, campus)
VALUES
    (10, 'Tecnologia da Informação', 'Campus Centro'),
    (20, 'Administração e Negócios', 'Campus Centro'),
    (30, 'Engenharia', 'Campus Norte'),
    (40, 'Ciências Humanas', 'Campus Sul');

-- ============================================================
-- DIMENSÃO CURSO
-- ============================================================

CREATE TABLE dim_curso (
    curso_key INT PRIMARY KEY AUTO_INCREMENT,
    id_curso_origem INT NOT NULL,
    nome_curso VARCHAR(150) NOT NULL
);

INSERT INTO dim_curso
    (id_curso_origem, nome_curso)
VALUES
    (201, 'Análise e Desenvolvimento de Sistemas'),
    (202, 'Ciência da Computação'),
    (203, 'Administração'),
    (204, 'Engenharia de Produção'),
    (205, 'Engenharia de Computação'),
    (206, 'Gestão de Recursos Humanos');

-- ============================================================
-- DIMENSÃO DISCIPLINA
-- ============================================================

CREATE TABLE dim_disciplina (
    disciplina_key INT PRIMARY KEY AUTO_INCREMENT,
    id_disciplina_origem INT NOT NULL,
    nome_disciplina VARCHAR(150) NOT NULL,
    carga_horaria INT NOT NULL
);

INSERT INTO dim_disciplina
    (id_disciplina_origem, nome_disciplina, carga_horaria)
VALUES
    (301, 'Banco de Dados', 80),
    (302, 'Programação', 80),
    (303, 'Engenharia de Software', 60),
    (304, 'Gestão de Projetos', 60),
    (305, 'Administração Estratégica', 60),
    (306, 'Gestão de Pessoas', 60),
    (307, 'Inteligência Artificial', 80),
    (308, 'Estatística Aplicada', 60);

-- ============================================================
-- DIMENSÃO DATA
-- ============================================================

CREATE TABLE dim_data (
    data_key INT PRIMARY KEY,
    data_completa DATE NOT NULL,
    dia INT NOT NULL,
    mes INT NOT NULL,
    nome_mes VARCHAR(20) NOT NULL,
    trimestre INT NOT NULL,
    ano INT NOT NULL,
    semestre INT NOT NULL
);

INSERT INTO dim_data
    (data_key, data_completa, dia, mes, nome_mes, trimestre, ano, semestre)
VALUES
    (20260101, '2026-01-01', 1, 1, 'Janeiro', 1, 2026, 1),
    (20260201, '2026-02-01', 1, 2, 'Fevereiro', 1, 2026, 1),
    (20260301, '2026-03-01', 1, 3, 'Março', 1, 2026, 1),
    (20260401, '2026-04-01', 1, 4, 'Abril', 2, 2026, 1),
    (20260501, '2026-05-01', 1, 5, 'Maio', 2, 2026, 1),
    (20260601, '2026-06-01', 1, 6, 'Junho', 2, 2026, 1),
    (20260701, '2026-07-01', 1, 7, 'Julho', 3, 2026, 2),
    (20260801, '2026-08-01', 1, 8, 'Agosto', 3, 2026, 2),
    (20260901, '2026-09-01', 1, 9, 'Setembro', 3, 2026, 2),
    (20261001, '2026-10-01', 1, 10, 'Outubro', 4, 2026, 2),
    (20261101, '2026-11-01', 1, 11, 'Novembro', 4, 2026, 2),
    (20261201, '2026-12-01', 1, 12, 'Dezembro', 4, 2026, 2);

-- ============================================================
-- TABELA FATO — DOCÊNCIA
-- ============================================================

CREATE TABLE fato_docencia (
    docencia_key INT PRIMARY KEY AUTO_INCREMENT,
    professor_key INT NOT NULL,
    departamento_key INT NOT NULL,
    curso_key INT NOT NULL,
    disciplina_key INT NOT NULL,
    data_key INT NOT NULL,
    quantidade_turmas INT NOT NULL,
    carga_horaria_ofertada INT NOT NULL,

    CONSTRAINT fk_docencia_professor
        FOREIGN KEY (professor_key)
        REFERENCES dim_professor(professor_key),

    CONSTRAINT fk_docencia_departamento
        FOREIGN KEY (departamento_key)
        REFERENCES dim_departamento(departamento_key),

    CONSTRAINT fk_docencia_curso
        FOREIGN KEY (curso_key)
        REFERENCES dim_curso(curso_key),

    CONSTRAINT fk_docencia_disciplina
        FOREIGN KEY (disciplina_key)
        REFERENCES dim_disciplina(disciplina_key),

    CONSTRAINT fk_docencia_data
        FOREIGN KEY (data_key)
        REFERENCES dim_data(data_key)
);

-- ============================================================
-- CARGA DE DADOS — FATO DOCÊNCIA
-- ============================================================

INSERT INTO fato_docencia
    (professor_key, departamento_key, curso_key, disciplina_key,
     data_key, quantidade_turmas, carga_horaria_ofertada)
VALUES
    (1, 1, 1, 1, 20260101, 2, 160),
    (2, 1, 2, 2, 20260201, 2, 160),
    (3, 2, 3, 5, 20260301, 1, 60),
    (4, 3, 4, 4, 20260401, 2, 120),
    (5, 3, 5, 3, 20260501, 1, 60),
    (6, 4, 6, 6, 20260601, 2, 120),
    (1, 1, 2, 7, 20260701, 2, 160),
    (3, 2, 3, 8, 20260801, 1, 60),
    (2, 1, 1, 1, 20260901, 2, 160),
    (5, 3, 5, 7, 20261001, 1, 80),
    (6, 4, 6, 6, 20261101, 2, 120),
    (4, 3, 4, 3, 20261201, 1, 60);

-- ============================================================
-- VALIDAÇÃO DOS DADOS
-- ============================================================

SELECT
    COUNT(*) AS registros_fato,
    SUM(quantidade_turmas) AS total_turmas,
    SUM(carga_horaria_ofertada) AS carga_horaria_total
FROM fato_docencia;

