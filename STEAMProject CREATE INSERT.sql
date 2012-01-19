--drop DATABASE Steam
--GO

CREATE DATABASE Steam
GO

USE Steam
GO

SET LANGUAGE polski
GO

--------- CREATE

create table SteamWallet
(id int not null primary key,
kwota money default 0);

create table Klienci
(steamid int not null primary key,
nazwa_wyswietlana varchar(40) not null,
haslo varchar(40),
data_urodzenia datetime,
portfel int references SteamWallet(id) unique,
check (haslo>8));

create table Znajomosci
(znajomy1 int references Klienci(steamid),
znajomy2 int references Klienci(steamid));

create table Transakcje
(id int not null primary key,
data datetime,
kwota_laczna money,
zleceniodawca int references Klienci(steamid) not null);

create table Grupy
(nazwa varchar(50) not null primary key,
opis varchar(400));

create table Czlonkostwa
(klient int references Klienci(steamid),
grupa varchar(50) references Grupy(nazwa));

create table Osiagniecia
(id int not null primary key,
nazwa varchar(50) not null,
opis varchar(100),
idProd int);

(nazwisko varchar(20) not null,
szef int references Pracownicy(id),
placa money,
dod_funkc money,
stanowisko varchar(10) references Stanowiska(nazwa),
zatrudniony datetime);

create table Projekty
(id int identity(10,10) not null primary key,
nazwa varchar(20) not null unique,
dataRozp datetime not null,
dataZakonczPlan datetime not null,
dataZakonczFakt datetime null,
kierownik int references Pracownicy(id),
stawka money);

create table Realizacje
(idProj int references Projekty(id),
idPrac int references Pracownicy(id),
godzin real default 8);

GO

---------- INSERT


insert into Stanowiska
values ('profesor', 3000, 5000);
insert into Stanowiska
values ('adiunkt', 2000, 3000);
insert into Stanowiska
values ('doktorant', 900, 1300);
insert into Stanowiska
values ('sekretarka', 1500, 2500);
insert into Stanowiska
values ('techniczny', 1500, 2500);
insert into Stanowiska
values ('dziekan', 2700, 4800);


insert into Pracownicy
values(1, 'Wachowiak', null, 4500, 900, 'profesor', '01-09-1980');
insert into Pracownicy
values(2, 'Jankowski', 1, 2500, null, 'adiunkt', '01-09-1990');
insert into Pracownicy
values(3, 'Fio³kowska', 1, 2550, null, 'adiunkt', '01-01-1985');
insert into Pracownicy
values(4, 'Mielcarz', 1, 4000, 400, 'profesor', '01-12-1980');
insert into Pracownicy
values(5, 'Ró¿ycka', 4, 2800, 200, 'profesor', '01-09-2001');
insert into Pracownicy
values(6, 'Miko³ajski', 4, 1000, null, 'doktorant', '01-10-2002');
insert into Pracownicy
values(7, 'Wójcicki', 5, 1350, null, 'doktorant', '01-10-2003');
insert into Pracownicy
values(8, 'Listkiewicz', 1, 2200, null, 'sekretarka', '01-09-1980');
insert into Pracownicy
values(9, 'Wróbel', 1, 1900, 300, 'techniczny', '01-01-1999');
insert into Pracownicy
values(10, 'Andrzejewicz', 5, 2900, null, 'adiunkt', '01-01-2002');


insert into Projekty
values('e-learning','01-01-2009', '31-05-2010', null, 5, 100);
insert into Projekty
values('web service', '10-11-1999', '31-12-2000', '20-04-2001', 4, 90)
insert into Projekty
values('semantic web', '01-10-2007', '01-09-2009', null, 4, 85)
insert into Projekty
values('neural network', '01-01-1998', '30-06-2000', '30-06-2000', 1, 120)


insert into Realizacje
values(10, 5, 8)
insert into Realizacje
values(10, 10, 6)
insert into Realizacje
values(10, 9, 2)

insert into Realizacje
values(20, 4, 8)
insert into Realizacje
values(20, 6, 8)
insert into Realizacje
values(20, 9, 2)

insert into Realizacje
values(30, 4, 8)
insert into Realizacje
values(30, 6, 6)
insert into Realizacje
values(30, 10, 6)
insert into Realizacje
values(30, 9, 2)

insert into Realizacje
values(40, 1, 8)
insert into Realizacje
values(40, 2, 4)
insert into Realizacje
values(40, 3, 4)
insert into Realizacje
values(40, 9, 2)



------------ SELECT

select * from Stanowiska
select * from Pracownicy
select * from Projekty
select * from Realizacje


