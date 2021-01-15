---------------------------------
-- UNA RIGA PER OGNI CONTRATTO --
---------------------------------

-- JSON RISORSE
SELECT A.JSON
FROM (
    SELECT DISTINCT A.JSON, ORD1, ORD2, ORD3
    FROM (
        SELECT A.ORDINAMENTO AS ORD1, CASE L.TIPO WHEN 0 THEN 'aaaaa' ELSE A.CID || ' ' || REPLACE(A.NOME, '''', '') END AS ORD2, L.ORDINE AS ORD3, L.TIPO,
            '{ id: ''' || CASE L.TIPO WHEN 0 THEN A.CODICE 
                                         WHEN 1 THEN A.CID
                                         ELSE A.CID || '_' || L.CODICE END || ''', '
            || 'name: ''' || CASE L.TIPO WHEN 0 THEN A.CODICE || ' - ' || A.DESCRIZIONE 
                                         WHEN 1 THEN A.CID || ' ' || REPLACE(A.NOME, '''', '')
                                         ELSE L.CODICE || ' - ' || L.DESCRIZIONE END || ''', ' 
            || CASE L.TIPO WHEN 0 THEN 'groupOnly: true, resourceSummary: false, resourceFixed: true, color: ''rgb(50 62 148)''' 
                           WHEN 1 THEN 'groupOnly: true, resourceSummary: false, parentId: ''' || A.CODICE || ''''
                           ELSE 'parentId: ''' || A.CID || '''' 
               END
            || '}, '
            AS JSON
        FROM (
            SELECT *
            FROM (
                SELECT A.COGNOME, A.NOME, G.CODICE, G.DESCRIZIONE, G1.ORDINAMENTO, I.CODICE AS CID
                FROM HRPORTAL.IM_RICHIESTE A, HRPORTAL.A_SOCIETA B, HRPORTAL.A_SOLUTION C, HRPORTAL.A_UFFICI D, HRPORTAL.GRUPPI E, HRPORTAL.QUALIFICHE F, HRPORTAL.SIGLE_QUALIFICHE G, HRPORTAL.LIVELLI_QUALIFICHE G1, HRPORTAL.A_HR_PERSONALE H, HRPORTAL.A_HR_CID I
                WHERE A.STATUS = 'ATT'
                AND A.R_SOCIETA = B.CODICE
                AND A.R_SOLUTION = C.CODICE
                AND A.R_UFFICIO = D.CODICE
                AND A.R_GRUPPO = E.ID
                AND A.R_QUALIFICA = F.ID
                AND F.R_SIGLE_QUALIFICHE = G.ID
                AND F.R_LIVELLI_QUALIFICHE = G1.ID
                AND A.R_PERSONALE_HR = H.ID
                AND H.ID = I.R_PERSONALE
                AND I.FLG_PRINCIPALE = 'S'
                AND H.FLG_ASSUNTO = 'S'
                AND A.R_SOCIETA = 'K003'
                --AND A.R_UFFICIO = 'TO' 
                --AND A.R_SOLUTION IN ('EC', 'EF', 'EP')
                AND A.R_SOLUTION IN ('FM')
                AND G.ORDINAMENTO BETWEEN 260 AND 370
                ORDER BY A.COGNOME, A.NOME
            ) A
            WHERE ROWNUM <= :risorse
        ) A, (
            SELECT 0 AS TIPO, 1 AS ORDINE, NULL AS CODICE, NULL AS DESCRIZIONE, NULL AS CHARGEBLE
            FROM DUAL
            UNION
            SELECT 1 AS TIPO, 1 AS ORDINE, NULL AS CODICE, NULL AS DESCRIZIONE, NULL AS CHARGEBLE
            FROM DUAL
            UNION
            SELECT 2 AS TIPO, 2 AS ORDINE, '1300074697' AS CODICE, 'Dev Contract 1' AS DESCRIZIONE, 'S' AS CHARGEBLE
            FROM DUAL
            UNION
            SELECT 2 AS TIPO, 3 AS ORDINE, '1300074463' AS CODICE, 'Dev Contract 2' AS DESCRIZIONE, 'S' AS CHARGEBLE
            FROM DUAL
            UNION
            SELECT 2 AS TIPO, 4 AS ORDINE, '000099390001' AS CODICE, 'Holiday' AS DESCRIZIONE, 'N' AS CHARGEBLE
            FROM DUAL
            UNION
            SELECT 2 AS TIPO, 5 AS ORDINE, '000099390009' AS CODICE, 'Training' AS DESCRIZIONE, 'N' AS CHARGEBLE
            FROM DUAL
            ORDER BY ORDINE
        ) L
    ) A
    ORDER BY ORD1, ORD2, ORD3
) A
ORDER BY ORD1, ORD2, ORD3;


SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(X.JSON, '##ID1##', ROWNUM+1000), '##ID2##', ROWNUM+2000), '##ID3##', ROWNUM+3000), '##ID4##', ROWNUM+4000), '##ID5##', ROWNUM+5000), '##ID6##', ROWNUM+6000), '##ID7##', ROWNUM+7000), '##ID8##', ROWNUM+8000), '##ID9##', ROWNUM+9000), '##ID10##', ROWNUM+10000), '##ID11##', ROWNUM+11000), '##ID12##', ROWNUM+12000), '##CODICE##', A.CODICE) AS JSON
FROM (
    SELECT *
    FROM (
        SELECT I.CODICE, ROUND(dbms_random.value(1, 3)) AS SET_SCH, G.CODICE AS LIV_QUAL, A.COGNOME || A.NOME AS NOMINATIVO
        FROM HRPORTAL.IM_RICHIESTE A, HRPORTAL.A_SOCIETA B, HRPORTAL.A_SOLUTION C, HRPORTAL.A_UFFICI D, HRPORTAL.GRUPPI E, HRPORTAL.QUALIFICHE F, HRPORTAL.SIGLE_QUALIFICHE G, HRPORTAL.A_HR_PERSONALE H, HRPORTAL.A_HR_CID I
        WHERE A.STATUS = 'ATT'
        AND A.R_SOCIETA = B.CODICE
        AND A.R_SOLUTION = C.CODICE
        AND A.R_UFFICIO = D.CODICE
        AND A.R_GRUPPO = E.ID
        AND A.R_QUALIFICA = F.ID
        AND F.R_SIGLE_QUALIFICHE = G.ID
        AND A.R_PERSONALE_HR = H.ID
        AND H.ID = I.R_PERSONALE
        AND I.FLG_PRINCIPALE = 'S'
        AND H.FLG_ASSUNTO = 'S'
        AND A.R_SOCIETA = 'K003'
        --AND A.R_UFFICIO = 'TO' 
        --AND A.R_SOLUTION IN ('EC', 'EF', 'EP')
        AND A.R_SOLUTION IN ('FM')
        AND G.ORDINAMENTO BETWEEN 260 AND 370
        ORDER BY A.COGNOME, A.NOME
    ) A 
    WHERE ROWNUM <= (:risorse)
) A, (
    -- SET 1: JSON SUMMARY
    SELECT 1 AS SET_SCH, 1 AS ORD,
           '{ id: ##ID1##, start: ''2020-12-01 09:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 100, percentualUnChg: 0 }, '
        || '{ id: ##ID2##, start: ''2020-12-16 09:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 40, percentualUnChg: 60 }, '
        || '{ id: ##ID3##, start: ''2021-01-01 09:30:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 75, percentualUnChg: 45 }, '
        || '{ id: ##ID4##, start: ''2021-01-16 09:30:00'', end: ''2021-01-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 100, percentualUnChg: 0 }, '
        || '{ id: ##ID5##, start: ''2021-02-01 09:30:00'', end: ''2021-02-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 100, percentualUnChg: 0 }, '
        || '{ id: ##ID6##, start: ''2021-02-16 09:30:00'', end: ''2021-02-28 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 70, percentualUnChg: 0 }, '
        || '{ id: ##ID7##, start: ''2021-03-01 09:30:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 70, percentualUnChg: 0 }, '
        || '{ id: ##ID8##, start: ''2021-03-16 09:30:00'', end: ''2021-03-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 50, percentualUnChg: 30 }, '
        || '{ id: ##ID9##, start: ''2021-04-01 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 50, percentualUnChg: 30 }, '
        || '{ id: ##ID10##, start: ''2021-04-16 09:30:00'', end: ''2021-04-30 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        || '{ id: ##ID11##, start: ''2021-05-01 09:30:00'', end: ''2021-05-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        || '{ id: ##ID12##, start: ''2021-05-16 09:30:00'', end: ''2021-05-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        AS JSON
    FROM DUAL
    UNION
    -- SET 1: JSON EVENTS
    SELECT 1 AS SET_SCH, 2 AS ORD,
           '{ id: ##ID1##, start: ''2020-12-01 09:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 50 }, '
        || '{ id: ##ID1##, start: ''2020-12-01 14:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 50 }, '
        || '{ id: ##ID1##, start: ''2020-12-16 12:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 20 }, ' 
        || '{ id: ##ID1##, start: ''2020-12-16 15:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 20 }, '
        || '{ id: ##ID1##, start: ''2020-12-16 16:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_000099390001'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 60 }, '
        || '{ id: ##ID1##, start: ''2021-01-01 15:35:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 75 }, '
        || '{ id: ##ID1##, start: ''2021-01-01 18:30:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##_000099390001'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 45 }, '
        || '{ id: ##ID1##, start: ''2021-01-16 15:40:00'', end: ''2021-02-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 100 }, '
        || '{ id: ##ID1##, start: ''2021-02-16 12:30:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 20 }, ' 
        || '{ id: ##ID1##, start: ''2021-02-16 15:50:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 50 }, '
        || '{ id: ##ID1##, start: ''2021-03-16 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 50 }, '
        || '{ id: ##ID1##, start: ''2021-03-16 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##_000099390009'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 30 }, '
    FROM DUAL
    UNION
    -- SET 2: JSON SUMMARY
    SELECT 2 AS SET_SCH, 1 AS ORD,
           '{ id: ##ID1##, start: ''2020-12-01 09:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 100, percentualUnChg: 0 }, '
        || '{ id: ##ID2##, start: ''2020-12-16 09:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 110, percentualUnChg: 20 }, '
        || '{ id: ##ID3##, start: ''2021-01-01 09:30:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 70, percentualUnChg: 30 }, '
        || '{ id: ##ID4##, start: ''2021-01-16 09:30:00'', end: ''2021-01-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 120, percentualUnChg: 0 }, '
        || '{ id: ##ID5##, start: ''2021-02-01 09:30:00'', end: ''2021-02-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 120, percentualUnChg: 0 }, '
        || '{ id: ##ID6##, start: ''2021-02-16 09:30:00'', end: ''2021-02-28 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 90, percentualUnChg: 0 }, '
        || '{ id: ##ID7##, start: ''2021-03-01 09:30:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 90, percentualUnChg: 0 }, '
        || '{ id: ##ID8##, start: ''2021-03-16 09:30:00'', end: ''2021-03-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 70, percentualUnChg: 10 }, '
        || '{ id: ##ID9##, start: ''2021-04-01 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 70, percentualUnChg: 10 }, '
        || '{ id: ##ID10##, start: ''2021-04-16 09:30:00'', end: ''2021-04-30 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        || '{ id: ##ID11##, start: ''2021-05-01 09:30:00'', end: ''2021-05-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        || '{ id: ##ID12##, start: ''2021-05-16 09:30:00'', end: ''2021-05-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        AS JSON
    FROM DUAL
    UNION
    -- SET 2: JSON EVENTS
    SELECT 2 AS SET_SCH, 2 AS ORD,
           '{ id: ##ID1##, start: ''2020-12-01 09:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 30 }, '
        || '{ id: ##ID1##, start: ''2020-12-01 14:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 70 }, '
        || '{ id: ##ID1##, start: ''2020-12-16 12:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 50 }, ' 
        || '{ id: ##ID1##, start: ''2020-12-16 15:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 60 }, '
        || '{ id: ##ID1##, start: ''2020-12-16 16:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_000099390001'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 20 }, '
        || '{ id: ##ID1##, start: ''2021-01-01 18:30:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##_000099390001'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 30 }, '
        || '{ id: ##ID1##, start: ''2021-01-01 15:35:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 70 }, '
        || '{ id: ##ID1##, start: ''2021-01-16 15:40:00'', end: ''2021-02-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 120 }, '
        || '{ id: ##ID1##, start: ''2021-02-16 15:50:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 60 }, '
        || '{ id: ##ID1##, start: ''2021-02-16 12:30:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 30 }, ' 
        || '{ id: ##ID1##, start: ''2021-03-16 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 70 }, '
        || '{ id: ##ID1##, start: ''2021-03-16 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##_000099390009'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 10 }, '
    FROM DUAL
    UNION
    -- SET 3: JSON SUMMARY
    SELECT 3 AS SET_SCH, 1 AS ORD,
           '{ id: ##ID1##, start: ''2020-12-01 09:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 100, percentualUnChg: 0 }, '
        || '{ id: ##ID2##, start: ''2020-12-16 09:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 80, percentualUnChg: 20 }, '
        || '{ id: ##ID3##, start: ''2021-01-01 09:30:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 70, percentualUnChg: 30 }, '
        || '{ id: ##ID4##, start: ''2021-01-16 09:30:00'', end: ''2021-01-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 100, percentualUnChg: 0 }, '
        || '{ id: ##ID5##, start: ''2021-02-01 09:30:00'', end: ''2021-02-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 100, percentualUnChg: 0 }, '
        || '{ id: ##ID6##, start: ''2021-02-16 09:30:00'', end: ''2021-02-28 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 60, percentualUnChg: 0 }, '
        || '{ id: ##ID7##, start: ''2021-03-01 09:30:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 60, percentualUnChg: 0 }, '
        || '{ id: ##ID8##, start: ''2021-03-16 09:30:00'', end: ''2021-03-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 40, percentualUnChg: 10 }, '
        || '{ id: ##ID9##, start: ''2021-04-01 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 40, percentualUnChg: 10 }, '
        || '{ id: ##ID10##, start: ''2021-04-16 09:30:00'', end: ''2021-04-30 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        || '{ id: ##ID11##, start: ''2021-05-01 09:30:00'', end: ''2021-05-15 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        || '{ id: ##ID12##, start: ''2021-05-16 09:30:00'', end: ''2021-05-31 23:30:00'', resourceId: ''##CODICE##'', title: '''', resizable: false, movable: false, showPopover: false, readOnly: true, summary: true, percentualChg: 0, percentualUnChg: 0 }, '
        AS JSON
    FROM DUAL
    UNION
    -- SET 3: JSON EVENTS
    SELECT 3 AS SET_SCH, 2 AS ORD,
           '{ id: ##ID1##, start: ''2020-12-01 09:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 50 }, '
        || '{ id: ##ID1##, start: ''2020-12-01 14:30:00'', end: ''2020-12-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 50 }, '
        || '{ id: ##ID1##, start: ''2020-12-16 12:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 30 }, ' 
        || '{ id: ##ID1##, start: ''2020-12-16 15:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 50 }, '
        || '{ id: ##ID1##, start: ''2020-12-16 16:30:00'', end: ''2020-12-31 23:30:00'', resourceId: ''##CODICE##_000099390001'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 20 }, '
        || '{ id: ##ID1##, start: ''2021-01-01 18:30:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##_000099390001'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 30 }, '
        || '{ id: ##ID1##, start: ''2021-01-01 15:35:00'', end: ''2021-01-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 70 }, '
        || '{ id: ##ID1##, start: ''2021-01-16 15:40:00'', end: ''2021-02-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 100 }, '
        || '{ id: ##ID1##, start: ''2021-02-16 15:50:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 20 }, '
        || '{ id: ##ID1##, start: ''2021-02-16 12:30:00'', end: ''2021-03-15 23:30:00'', resourceId: ''##CODICE##_1300074697'', title: '''', bgColor: ''#94aff8'',resizable: true, summary: false, percentual: 40 }, ' 
        || '{ id: ##ID1##, start: ''2021-03-16 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##_1300074463'', title: '''', bgColor: ''#94aff8'', resizable: true, summary: false, percentual: 40 }, '
        || '{ id: ##ID1##, start: ''2021-03-16 09:30:00'', end: ''2021-04-15 23:30:00'', resourceId: ''##CODICE##_000099390009'', title: '''', bgColor: ''#b1aaaa'', resizable: true, summary: false, percentual: 10 }, '
    FROM DUAL
) X
WHERE A.SET_SCH = X.SET_SCH
ORDER BY A.CODICE, X.ORD;
