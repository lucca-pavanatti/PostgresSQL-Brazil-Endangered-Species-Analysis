CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE Localizacao (
    id_localizacao UUID PRIMARY KEY,
    estado VARCHAR(30),
    regiao VARCHAR(20),
    bioma VARCHAR(50)
);

CREATE TABLE Especie (
    id_especie UUID PRIMARY KEY,
    nome VARCHAR(100),
    filo VARCHAR(50),
    ordem VARCHAR(50),
    classe VARCHAR(50),
    familia VARCHAR(50),
    genero VARCHAR(50),
    grupo VARCHAR(50),
    endemica_brasil CHAR(3),
    migratoria CHAR(3)
);

CREATE TABLE Plano_de_Acao_Nacional (
    id_pan VARCHAR(20) PRIMARY KEY,
    pan_nome VARCHAR(50),
    pan_nome_completo VARCHAR(500),
    pan_nome_fantasia VARCHAR(50),
    pan_abreviacao_taxonomica VARCHAR(100),
    pan_ciclo VARCHAR(15),
    pan_status VARCHAR(30),
    pan_inicio_data DATE,
    pan_fim_data DATE,
    pan_abrangencia_geografica VARCHAR(100),
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie)
);

CREATE TABLE Especie_PAN (
    id_especie UUID REFERENCES Especie(id_especie),
    id_pan VARCHAR(20) REFERENCES Plano_de_Acao_Nacional(id_pan),
    PRIMARY KEY (id_especie, id_pan)
);

CREATE TABLE Risco (
    id_risco UUID PRIMARY KEY,
    id_especie UUID,
    tendencia_populacional VARCHAR(30),
    ameaca VARCHAR(100),
    categoria VARCHAR(30),
    possivelmente_extinta CHAR(3),
    uso VARCHAR(50),
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie)
);

CREATE TABLE Conservacao (
    id_conservacao UUID PRIMARY KEY,
    nome VARCHAR(500)
);

CREATE TABLE Portaria (
    id_portaria UUID PRIMARY KEY,
    id_pan VARCHAR(20),
    pan_status_legal VARCHAR(200),
    data_da_portaria_vigente_do_PAN DATE,
    FOREIGN KEY (id_pan) REFERENCES Plano_de_Acao_Nacional(id_pan)
);

CREATE TABLE Especie_Conservacao (
    id_especie_id_conservacao UUID PRIMARY KEY,
    id_especie UUID,
    id_conservacao UUID,
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie),
    FOREIGN KEY (id_conservacao) REFERENCES Conservacao(id_conservacao)
);

CREATE TABLE Especie_Localizacao (
    id_especie UUID,
    id_localizacao UUID,
    
    PRIMARY KEY (id_especie, id_localizacao),
    
    FOREIGN KEY (id_especie) REFERENCES Especie(id_especie),
    FOREIGN KEY (id_localizacao) REFERENCES Localizacao(id_localizacao)
);

CREATE TABLE PAN_Localizacao (
    id_pan VARCHAR(20),
    id_localizacao UUID,
    PRIMARY KEY (id_pan, id_localizacao),
    FOREIGN KEY (id_pan) REFERENCES Plano_de_Acao_Nacional(id_pan),
    FOREIGN KEY (id_localizacao) REFERENCES Localizacao(id_localizacao)
);