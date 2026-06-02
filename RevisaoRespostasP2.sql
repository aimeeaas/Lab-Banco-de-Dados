/* REVISÃO P2 */

-- BLOCO ANÔNIMO

-- Criar um bloco anônimo que cadastre um novo cliente.
DECLARE
    v_id cliente.cdcliente%TYPE := :id;
    v_nome cliente.nmcliente%TYPE := :nome;
    v_tel cliente.cdtelefone%TYPE := :tel;
    v_tipo cliente.ic_tipo_juridico%TYPE := :tipo;
BEGIN
    INSERT INTO cliente(cdcliente, nmcliente, cdtelefone, ic_tipo_juridico) VALUES (v_id, v_nome, v_tel, v_tipo);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cadastrado com sucesso!');
END;

/* Criar um bloco anônimo que entre com o código do serviço e exiba o nome do serviço, a somatória, a média, a quantidade, o maior e o menor valor total 
 de serviços existentes no histórico. */
DECLARE
    v_id servico.cdservico%TYPE := :id;
    v_nome servico.nmservico%TYPE;
    v_soma number(10,2);
    v_media number(10,2);
    v_qtd number;
    v_maior_total number(10,2);
    v_menor_total number(10,2);
BEGIN
    SELECT nmservico, SUM(vlservico), AVG(vlservico), COUNT(cdservico), MAX(vlservico), MIN(vlservico)
    INTO v_nome, v_soma, v_media, v_qtd, v_maior_total, v_menor_total
    FROM servico
    WHERE cdservico = v_id
    GROUP BY nmservico;

    DBMS_OUTPUT.PUT_LINE('O serviço '||v_nome||' tem soma de '||v_soma||', média de '||v_media||', 
    a quantidade '||v_qtd||', o maior valor '||v_maior_total||' e o menor '||v_menor_total);
END;


-- PROCEDURE

/* Criar uma procedure chamada PRC_HISTORICO que informe uma data e exiba o nome dos clientes, a placa do veículo e o valor total e 
a média aritmética dos serviços solicitados nesta data informada. */
CREATE OR REPLACE PROCEDURE prc_historico (p_data IN historico.dtsolicitacao%TYPE) IS
    v_nome cliente.nomecliente%TYPE;
    v_placa veiculo.cdplacaveiculo%TYPE;
    v_valor_total NUMBER(10,2);
    v_media_servicos NUMBER(10,2);
    CURSOR c_historico IS -- consulta que será percorrida linha a linha
        SELECT c.nomecliente, v.cdplacaveiculo, SUM(h.vltotalservico), AVG(h.vltotalservico)
        FROM cliente c JOIN veiculo v ON c.cdcliente = v.cdcliente
        JOIN historico h ON v.cdplacaveiculo = h.cdplacaveiculo

        WHERE h.dtsolicitacao = p_data
        GROUP BY c.nomecliente, v.cdplacaveiculo;
BEGIN
    OPEN c_historico; -- abre o cursor (executa a consulta)
    LOOP
        FETCH c_historico INTO v_nome, v_placa, v_valor_total, v_media_servicos; -- pega UMA linha do resultado e joga nas variáveis
        EXIT WHEN c_historico%NOTFOUND; --  sai do loop quando não houver mais linhas
        DBMS_OUTPUT.PUT_LINE('Nome '||v_nome||' Placa '||v_placa||' Valor Total '||v_valor_total||' Media '||v_media_servicos);
    END LOOP;
    CLOSE c_historico; -- fecha o cursor (libera memória)
END;

/* Criar uma procedure chamada PRC_OFICINA que de acordo com o código do cliente informado exiba quantidade de veículos e a quantidade de serviços efetuados 
por este cliente. */
CREATE OR REPLACE PROCEDURE prc_oficina (p_id IN cliente.cdcliente%TYPE) IS
        v_qtd_veiculos NUMBER;
        v_qtd_servicos NUMBER;
BEGIN
    SELECT COUNT(DISTINCT v.cdplacaveiculo), COUNT(h.cdservico)
    INTO v_qtd_veiculos, v_qtd_servicos
    FROM veiculo v JOIN historico h ON v.cdplacaveiculo = h.cdplacaveiculo
    WHERE v.cdcliente = p_id;
    DBMS_OUTPUT.PUT_LINE('Qtd Veiculos '||v_qtd_veiculos||' Qtd Serviços '||v_qtd_servicos);
END;

-- Exibir o código da procedure PRC_HISTORICO.
SELECT TEXT FROM USER_SOURCE WHERE NAME = 'prc_historico';

-- Exibir o nome das procedures existentes neste usuário.
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = 'PROCEDURE';

-- Executar a procedure PRC_HISTORICO, passando como parâmetro a data de hoje.
EXECUTE prc_historico(SYSDATE);

-- Excluir a procedure PRC_HISTORICO.
DROP PROCEDURE prc_historico;


-- FUNCTION

-- Criar uma function chamada FNC_CALCULA_AUMENTO que de acordo com o código de serviço informado atualizar 15% de aumento sobre o valor do serviço.
CREATE OR REPLACE FUNCTION FNC_CALCULA_AUMENTO (p_id IN servico.cdservico%TYPE)
RETURN NUMBER
IS v_aumento NUMBER(10,2);
BEGIN
    SELECT v_aumento := vlservico*1.15
    INTO v_aumento
    FROM servico
    WHERE cdservico = p_id;

    UPDATE servico
    SET vlservico = v_aumento
    WHERE cdservico = p_id;

    RETURN(v_aumento);
END;

-- Exibir o código da função acima.
SELECT TEXT FROM USER_SOURCE WHERE NAME='FNC_CALCULA_AUMENTO';

-- Consultas as functions criadas no usuario
SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = 'FUNCTION';

-- Executar a function para o servico com codigo 101.
SELECT FNC_CALCULA_AUMENTO(101) FROM DUAL;

-- Excluir a função FNC_CALCULA_AUMENTO
DROP FUNCTION FNC_CALCULA_AUMENTO;

-- PACKAGE

-- Criar uma especificação da package chamada PKG_OFICINA que contenha as FUNCTIONS e PROCEDURES acima.
CREATE OR REPLACE PACKAGE PKG_OFICINA IS
    PROCEDURE prc_oficina (p_id IN cliente.cdcliente%TYPE);
END;