/* Liste o nome do cliente, a data do pedido e o nome do produto comprado. CLIENTE <> PEDIDO <> ITEM_PEDIDO <> PRODUTO */
select cli.nome as Nome, ped.data as Data_Pedido, prod.nome as Produto 
    from produto prod
        join item_pedido i
            on prod.id_produto = i.id_produto
        join pedido ped
            on i.id_pedido = ped.id_pedido
        join cliente cli
            on ped.id_cliente = cli.id_cliente

/* A  gerência quer saber quais clientes que ainda não compraram nada. */
select c.nome 
    from cliente c 
        left outer join pedido p 
            on c.id_cliente = p.id_cliente 
    where p.id_pedido is null

/* A  gerência quer saber quais clientes compraram produtos. */
select c.nome
    from cliente c
        join pedido p
            on c.id_cliente = p.id_cliente

/* Exiba o nome dos funcionários que possuem salário acima da média geral. */
select nome 
    from funcionario 
        where salario > (
            select AVG(salario) from funcionario
        )

/* Crie uma sequência SEQ_PEDIDO para gerar automaticamente o código dos pedidos,  que inicie em 1000 com incremento 1 e sem valores na memória cache. */
create sequence seq_pedido start with 1000 increment by 1 nocache

/* Utilizando a sequência SEQ_PEDIDO, cadastrar um pedido para o cliente com id = 1 e com a data atual. */
insert into pedido values(seq_pedido.nextval, sysdate, 1, 1)

/* Alterar a sequência SEQ_PEDIDO para que o incremento passe a ser de 15 em 15 com valor máximo de 3000 */
alter sequence seq_pedido increment by 15 maxvalue 3000

/* Mostre os itens comprados no pedido 100, exibindo produto, quantidade e valor total. */
select prod.nome as Itens, ip.quantidade as Quantidade, ip.quantidade * prod.preco as Valor_Total
    from produto prod
        join item_pedido ip
            on prod.id_produto = ip.id_produto
    where id_pedido = 100

/* Com subconsulta, lista o nome dos clientes que tem pedido emitido */
select nome
from cliente
where id_cliente in (
    select id_cliente
    from pedido
)

/* Com subconsulta, lista o nome dos clientes que não tem pedido emitido */
select nome
from cliente
where id_cliente  not in (
    select id_cliente
    from pedido
)

/* Criar um índice IDX_CLIENTE para a coluna nome_cliente na tabela CLIENTE */
create index idx_cliente on cliente(nome)

/* Criar um sinônimo chamado COLABORADOR para a tabela FUNCIONARIO */
create synonym colaborador for funcionario

/* Consultar todas as sequências criadas no usuário logado. */
select * from user_sequences

/* Consultar todos os sinônimos existentes no banco de dados */
select * from all_synonyms

/* Consultar todos os índices no dicionário de dados */
select * from user_indexes

/* Consultar todas as views existentes no dicionário de dados */
select * from user_views

/* Excluir o índice IDX_CLIENTE */
drop index idx_cliente

/* Excluir a sequência SEQ_PEDIDO */
drop sequence seq_pedido

/* Excluir o sinônimo COLABORADOR */
drop synonym colaborador

/*  | Operador  | Palavra-chave no enunciado       |
    | --------- | -------------------------------- |
    | UNION     | "juntar"                         |
    | UNION ALL | "juntar tudo"                    |
    | INTERSECT | "em comum"                       |
    | MINUS     | "exceto", "menos", "que não têm" |
*/

/* Com operadores de conjunto exibir o nome dos funcionários e o nome dos clientes sem repetição de nomes. */
select nome
    from cliente
union
select nome
    from funcionario

/* Com operadores de conjunto exibir o nome dos funcionários e o nome dos clientes com repetição de nomes. */
select nome
    from cliente
union all
select nome
    from funcionario

/* Com subconsulta, exiba o nome e o preço dos produtos mais caros que a média de preços. */
select nome, preco 
    from produto 
    where preco > (
        select avg(preco)
            from produto
)
order by preco desc

/* Liste o nome dos funcionários e com a função SUM, multiplique o preço pela quantidade. */
select f.nome, sum(preco * quantidade) as Valor_Vendas
    from funcionario f
        join pedido p
            on f.id_funcionario = p.id_funcionario
        join item_pedido ip
            on p.id_pedido = ip.id_pedido
        join produto prod
            on ip.id_produto = prod.id_produto
/* Como estou usando SUM, precisa do group by */
group by f.nome

/*  WHERE → filtra linhas
    HAVING → filtra grupos (com SUM, AVG, etc) */

/* Liste o nome dos funcionários e com a função SUM, multiplique o preço pela quantidade. Somente exibir os que realizaram pedidos acima de R$ 3000 no total. */
select f.nome, sum(preco * quantidade) as Valor_Vendas
    from funcionario f
        join pedido p
            on f.id_funcionario = p.id_funcionario
        join item_pedido ip
            on p.id_pedido = ip.id_pedido
        join produto prod
            on ip.id_produto = prod.id_produto
    having sum(preco * quantidade) > 3000
group by f.nome

/* Crie uma view vw_clientes_compras que mostre cliente, produto e valor total gasto (quantidade * preço). */
create or replace view vw_clientes_compras as 
    select c.nome as Cliente, prod.nome as Produto, (ip.quantidade * prod.preco) as Total_Gasto
        from cliente c 
            join pedido p 
                on c.id_cliente = p.id_cliente
            join item_pedido ip 
                on p.id_pedido = ip.id_pedido
            join produto prod
                on ip.id_produto = prod.id_produto

/* Utilizando a view vw_clientes, exibir o nome e a coluna valor_total gasto, ordenado pelo nome do cliente. */
select Cliente, Total_Gasto
    from vw_clientes_compras
order by Cliente

/* Utilizando a view vw_clientes, exibir o nome e a coluna valor_total gasto somente quando o valor_total for maior ou igual a 2000 */
select Cliente, Total_Gasto 
    from vw_clientes_compras
where Total_Gasto >= 2000