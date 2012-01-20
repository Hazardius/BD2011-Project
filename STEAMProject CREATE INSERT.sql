--drop DATABASE Steam
--GO

CREATE DATABASE Steam
GO

USE Steam
GO

SET LANGUAGE polski
GO

--------- CREATE (Utworzenie podstawy bazy danych, czyli tabel
--------- i kilku zależności między nimi)

create table SteamWallet
(id int not null primary key,
kwota money default 0);

create table Klienci
(steamid int not null primary key,
nazwa_wyswietlana varchar(40) not null,
haslo varchar(64),
data_urodzenia datetime,
portfel int references SteamWallet(id) unique);

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

create table Produkty
(id int not null primary key,
nazwa varchar(40) not null unique,
cena money,
wielkosc int not null,
opis varchar(400),
check (wielkosc > 0));

create table OST
(id int references Produkty(id) primary key);

create table Utwory
(tytul varchar(40) not null primary key,
autor varchar(40),
dlugosc int,
wielkosc int,
album int references OST(id),
check (wielkosc > 0),
check (dlugosc > 0));

create table Gry
(id int references Produkty(id) primary key,
ost int references OST(id));

create table DLC
(id int references Produkty(id) primary key,
gra int references Gry(id),
ost int references OST(id));

create table SDK
(id int references Produkty(id) primary key,
wersja varchar(10));

create table Osiagniecia
(id int not null primary key,
nazwa varchar(50) not null,
opis varchar(100),
idProd int references Produkty(id) not null);

create table OsiagnieciaOdblokowane
(id int not null primary key,
osiagniecie int references Osiagniecia(id),
kolekcjoner int references Klienci(steamid));

create table Posiadania
(id int not null primary key,
produkt int references Produkty(id),
wlasciciel int references Klienci(steamid));

create table ObiektyNaWishlist
(id int not null primary key,
produkt int references Produkty(id),
autorWishlisty int references Klienci(steamid),
priorytet int not null,
check (priorytet > -1));

create table PozycjeTransakcji
(id int not null primary key,
produkt int references Produkty(id),
transakcja int references Transakcje(id));

GO

---------- TU BĘDĄ FUNKCJE DODAJĄCE I USUWAJĄCE

--nic na razie nie ma :(

---------- INSERT (Dodanie kilku przykładowych wartości na początek)

insert into Produkty
values ('profesor', 3000, 5000);

insert into Pracownicy
values(1, 'Wachowiak', null, 4500, 900, 'profesor', '01-09-1980');

------------ SELECT (Pokazanie zawartości naszej bazy)
------------ Na razie za pomocą selectów. Później wykorzystamy funkcje!

select * from Czlonkostwa
select * from DLC
select * from Grupy
select * from Gry
select * from Klienci
select * from ObiektyNaWishlist
select * from Osiagniecia
select * from OsiagnieciaOdblokowane
select * from OST
select * from Posiadania
select * from PozycjeTransakcji
select * from Produkty
select * from SDK
select * from SteamWallet
select * from Transakcje
select * from Utwory
select * from Znajomosci
