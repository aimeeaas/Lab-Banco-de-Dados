-- CLIENTES
CREATE TABLE cliente (
    id_cliente NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    email VARCHAR2(100)
)
/
-- FUNCIONARIOS
CREATE TABLE funcionario (
    id_funcionario NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    salario NUMBER(10,2),
    cargo VARCHAR2(50)
);

-- PRODUTOS
CREATE TABLE produto (
    id_produto NUMBER PRIMARY KEY,
    nome VARCHAR2(100),
    preco NUMBER(10,2)
)
/
-- PEDIDOS
CREATE TABLE pedido (
    id_pedido NUMBER PRIMARY KEY,
    data DATE,
    id_cliente NUMBER,
    id_funcionario NUMBER,
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
)
/
-- ITENS DO PEDIDO
CREATE TABLE item_pedido (
    id_item NUMBER PRIMARY KEY,
    id_pedido NUMBER,
    id_produto NUMBER,
    quantidade NUMBER,
    CONSTRAINT fk_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
)
/
-- INSERÇÃO DE DADOS
INSERT INTO cliente VALUES (1, 'Ana Silva', 'ana@email.com');
INSERT INTO cliente VALUES (2, 'Carlos Souza', 'carlos@email.com');
INSERT INTO cliente VALUES (3, 'Mariana Lima', 'mariana@email.com');
INSERT INTO cliente VALUES (4, 'Genoveva Flor', 'geflor@gmail.com');
/
/
INSERT INTO funcionario VALUES (1, 'João Pereira', 3500, 'Vendedor');
INSERT INTO funcionario VALUES (2, 'Fernanda Costa', 5000, 'Gerente');

INSERT INTO produto VALUES (1, 'Notebook', 3500);
INSERT INTO produto VALUES (2, 'Smartphone', 2000);
INSERT INTO produto VALUES (3, 'Mouse Gamer', 150);
INSERT INTO produto VALUES (4, 'Teclado Mecânico', 400);

INSERT INTO pedido VALUES (100, TO_DATE('2024-05-10','YYYY-MM-DD'), 1, 1);
INSERT INTO pedido VALUES (101, TO_DATE('2024-06-15','YYYY-MM-DD'), 2, 2);
INSERT INTO pedido VALUES (102, TO_DATE('2024-07-01','YYYY-MM-DD'), 3, 1);

INSERT INTO item_pedido VALUES (1, 100, 1, 1); 
INSERT INTO item_pedido VALUES (2, 100, 3, 2); 
INSERT INTO item_pedido VALUES (3, 101, 2, 1); 
INSERT INTO item_pedido VALUES (4, 102, 4, 1); 
INSERT INTO item_pedido VALUES (5, 102, 2, 1); 


