-- Pra quê serve: Essa consulta identifica, por bioma, as espécies endêmicas criticamente ameaçadas que ainda não estão protegidas por um plano nacional de conservação, destacando também biomas sem registros..
SELECT 
    l.bioma,
    COALESCE(COUNT(DISTINCT e.id_especie), 0) AS total_especies,
    COALESCE(STRING_AGG(DISTINCT e.nome, ', ' ORDER BY e.nome), 'Sem registro') AS especies
FROM 
    Localizacao l
LEFT JOIN 
    Especie_Localizacao el ON l.id_localizacao = el.id_localizacao
LEFT JOIN 
    Especie e ON el.id_especie = e.id_especie
LEFT JOIN 
    Risco r ON e.id_especie = r.id_especie
LEFT JOIN 
    Especie_PAN ep ON e.id_especie = ep.id_especie
WHERE 
    (e.endemica_brasil = 'Sim' AND r.categoria = 'Criticamente em Perigo' AND ep.id_especie IS NULL)
    OR e.id_especie IS NULL
GROUP BY 
    l.bioma
ORDER BY 
    total_especies DESC;

--Correlação entre categorias de risco e número de ações de conservação
SELECT r.categoria, COUNT(DISTINCT ec.id_conservacao) AS total_acoes
FROM Risco r
JOIN Especie e ON r.id_especie = e.id_especie
JOIN Especie_Conservacao ec ON e.id_especie = ec.id_especie
GROUP BY r.categoria
ORDER BY total_acoes DESC;

--Detecção de Espécies em Situação Crítica com Lacunas de Proteção e Ação Governamental
WITH especies_criticas AS (
    SELECT e.id_especie, e.nome
    FROM Especie e
    JOIN Risco r ON e.id_especie = r.id_especie
    WHERE r.categoria = 'Criticamente em Perigo'
),
sem_pan_ativo AS (
    SELECT ec.id_especie
    FROM especies_criticas ec
	LEFT JOIN Especie_PAN esp_pan 
        ON ec.id_especie = esp_pan.id_especie
    LEFT JOIN Plano_de_Acao_Nacional pan 
        ON esp_pan.id_pan = pan.id_pan 
       AND CURRENT_DATE BETWEEN pan.pan_inicio_data AND pan.pan_fim_data
    WHERE pan.id_pan IS NULL
),
sem_portaria AS (
    SELECT ec.id_especie
    FROM especies_criticas ec
    LEFT JOIN Especie_PAN esp_pan 
        ON ec.id_especie = esp_pan.id_especie
    LEFT JOIN Plano_de_Acao_Nacional pan 
        ON esp_pan.id_pan = pan.id_pan 
    LEFT JOIN Portaria p ON pan.id_pan = p.id_pan
    WHERE p.id_portaria IS NULL
),
sem_conservacao AS (
    SELECT ec.id_especie
    FROM especies_criticas ec
    LEFT JOIN Especie_Conservacao ecv ON ec.id_especie = ecv.id_especie
    WHERE ecv.id_conservacao IS NULL
)
SELECT 
    e.nome AS especie,
    'Criticamente em Perigo' AS categoria,
    CASE WHEN sp.id_especie IS NOT NULL THEN 'Sem plano de ação ativo' ELSE NULL END AS problema_pan,
    CASE WHEN pr.id_especie IS NOT NULL THEN 'Sem portaria vigente' ELSE NULL END AS problema_portaria,
    CASE WHEN scv.id_especie IS NOT NULL THEN 'Sem área de conservação' ELSE NULL END AS problema_conservacao
FROM especies_criticas e
LEFT JOIN sem_pan_ativo sp ON e.id_especie = sp.id_especie
LEFT JOIN sem_portaria pr ON e.id_especie = pr.id_especie
LEFT JOIN sem_conservacao scv ON e.id_especie = scv.id_especie
WHERE sp.id_especie IS NOT NULL 
   OR pr.id_especie IS NOT NULL 
   OR scv.id_especie IS NOT NULL
ORDER BY e.nome;

-- Planos de Ação Nacional em execução com número de espécies atendidas e estados abrangidos
SELECT 
    p.pan_nome AS plano_acao,
    p.pan_abrangencia_geografica,
    COUNT(DISTINCT ep.id_especie) AS especies_atendidas,
    COUNT(DISTINCT pl.id_localizacao) AS estados_abrangidos,
	STRING_AGG(DISTINCT l.estado, ', ' ORDER BY l.estado) AS estados
FROM 
    Plano_de_Acao_Nacional p
LEFT JOIN 
    Especie_PAN ep ON p.id_pan = ep.id_pan
LEFT JOIN 
    PAN_Localizacao pl ON p.id_pan = pl.id_pan
LEFT JOIN 
    Localizacao l ON pl.id_localizacao = l.id_localizacao
WHERE p.pan_status = 'Em execução'
GROUP BY 
    p.id_pan
ORDER BY 
    especies_atendidas DESC;
	
----Essa nova consulta lista as espécies em declínio populacional, cujos planos de ação nacional (PANs) já expiraram ou estão vencidos.
WITH especies_pan_expirado AS (
    SELECT 
        e.id_especie,
        e.nome AS nome_especie,
        pan.pan_nome AS nome_pan_expirado
    FROM 
        Especie e
    JOIN 
        Especie_PAN ep ON e.id_especie = ep.id_especie
    JOIN 
        Plano_de_Acao_Nacional pan ON ep.id_pan = pan.id_pan
    WHERE 
        (pan.pan_status = 'Finalizado')
),
especies_pan_vigente AS (
    SELECT 
        DISTINCT e.id_especie
    FROM 
        Especie e
    JOIN 
        Especie_PAN ep ON e.id_especie = ep.id_especie
    JOIN 
        Plano_de_Acao_Nacional pan ON ep.id_pan = pan.id_pan
    WHERE 
        (pan.pan_status = 'Em execução')
)

SELECT 
    epe.nome_especie,
    epe.nome_pan_expirado,
    r.tendencia_populacional
FROM 
    especies_pan_expirado epe
JOIN 
    Risco r ON epe.id_especie = r.id_especie
WHERE 
    r.tendencia_populacional = 'Declinando'
    AND epe.id_especie NOT IN (SELECT id_especie FROM especies_pan_vigente)
ORDER BY 
    epe.nome_especie;