create table clientgroup(clientgropuid int, clientgroupname varchar(50))
insert into clientgroup values
(111,'clientgroupname1'),
(112,'clientgroupname2')

select * from clientgroup

create table legalentity(cmdid int , clientgroupid int, legalentityname varchar(50))

insert into legalentity values
(1,111,'legalentityname1'),
(2,111,'legalentityname2'),
(3,112,'legalentityname3'),
(4,112,'legalentityname4')

create table tradingentity(wildid int, cmdid int , tradingentityname varchar(50))

insert into tradingentity values
(1,1,'tradingentity1'),
(2,1,'tradingentity2'),
(3,1,'tradingentity3'),
(4,2,'tradingentity4'),
(5,2,'tradingentity5'),
(6,3,'tradingentity6'),
(7,3,'tradingentity7'),
(8,3,'tradingentity8'),
(9,4,'tradingentity9')

delete from tradingentity
