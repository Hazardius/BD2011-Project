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

create table Klienci
(steamid int IDENTITY(1,1) primary key,
nazwa_wyswietlana varchar(40) not null,
haslo varchar(64) not null check (Len(haslo) = 64),
data_urodzenia date);

create table SteamWallet
(wlasciciel int references Klienci(steamid) primary key,
kwota money default 0);

create table Znajomosci
(znajomy1 int references Klienci(steamid) not null,
znajomy2 int references Klienci(steamid) not null,
check (znajomy1 != znajomy2));

create table Transakcje
(id int IDENTITY(1,1) primary key,
data datetime,
kwota_laczna money default 0,
zleceniodawca varchar(40));

create table Grupy
(nazwa varchar(50) not null primary key,
opis varchar(400));

create table Czlonkostwa
(klient int references Klienci(steamid),
grupa varchar(50) references Grupy(nazwa));

create table Produkty
(id int IDENTITY(1,1) primary key,
nazwa varchar(40) not null unique,
cena money not null,
wielkosc int not null check (wielkosc > 0),
opis varchar(400));

create table OST
(id int references Produkty(id) primary key);

create table Utwory
(tytul varchar(40) not null primary key,
autor varchar(40),
dlugosc int,
wielkosc int not null,
album int references OST(id) not null,
check (wielkosc > 0),
check (dlugosc > 0));

create table Gry
(id int references Produkty(id) primary key,
ost int references OST(id));

create table DLC
(id int references Produkty(id) primary key,
gra int references Gry(id) not null,
ost int references OST(id));

create table SDK
(id int references Produkty(id) primary key,
wersja varchar(10));

create table Osiagniecia
(nazwa varchar(100) not null primary key,
opis varchar(400),
idProd int references Produkty(id) not null);

create table OsiagnieciaOdblokowane
(osiagniecie int references Osiagniecia(id) not null,
kolekcjoner int references Klienci(steamid) not null);

create table Posiadania
(produkt int references Produkty(id) not null,
wlasciciel int references Klienci(steamid) not null);

create table ObiektyNaWishlist
(id int IDENTITY(1,1) primary key,
produkt int references Produkty(id),
autorWishlisty int references Klienci(steamid),
priorytet int not null,
check (priorytet > -1));

create table PozycjeTransakcji
(id int IDENTITY(1,1) primary key,
produkt int references Produkty(id),
transakcja int references Transakcje(id));

GO

---------- INSERT (Dodanie kilku przykładowych wartości na początek)

insert into Klienci (nazwa_wyswietlana, haslo, haslo)
values ('Klient_1', '1234567890123456789012345678901234567890123456789012345678901234', '19890223'),
('Klient_2', '1234567890123456789012345678901234567890123456789012345678901234', '19700304'),
('Klient_3', '1234567890123456789012345678901234567890123456789012345678901234', '19900406'),
('Klient_4', '1234567890123456789012345678901234567890123456789012345678901234', '19831212'),
('Klient_5', '1234567890123456789012345678901234567890123456789012345678901234', '19500605')

insert into SteamWallet (wlasciciel)
values (1)

insert into SteamWallet (wlasciciel, kwota)
values (2, 2000),
(3, 5000)

insert into Znajomosci (znajomy1, znajomy2)
values (1,2), (3,4), (2,3), (1,5)

insert into Grupy (nazwa, opis)
values ('Nie dla ACTA', 'Nie dajmy się zwieść ACTA! ACTA to ZUO! Nie daje nam PACZEĆ!')

insert into Czlonkostwa (klient, grupa)
values (3, 'Nie dla ACTA'), (5, 'Nie dla ACTA'), (1, 'Nie dla ACTA')

insert into Produkty (nazwa, cena, wielkosc, opis)
values
('Diablo II - OST', 0, 716800, 'Wspaniała muzyka ze wspaniałej gry.'),
('Magica - OST', 500, 358400, 'OST z gry Magica.'),
('Diablo II', 4000, 2621440, 'Klasyk gier komputerowych. Znany powszechnie HacknSlash!'),
('Deus Ex', 2000, 409600, 'Klasyk gier komputerowych. Świetna gra RPG!'),
('Magica', 4000, 819200, 'Parodnia gier RPG zapewniająca spore możliwości tworzenia czarów.'),
('Diablo II - Lord Of Destruction', 2000, 768000, 'Dodatek do Diablo II! Dodaje dwie nowe postaci!'),
('Magica - Vietnam', 500, 153600, 'Dodatek do gry Magica. Przenosi naszych magów do.. Wietnamu? O.o'),
('Source SDK', 0, 2359296, 'SDK pozwalające na tworzenie gier na silniczku Source')

insert into OST (id)
values (1), (2)

insert into Utwory (tytul, autor, dlugosc, wielkosc, album)
values
('Wilderness', 'Matt Uelmen', 478, 7170, 1),
('Vlad is not a Vampire!', 'Vlad', 134, 2010, 2),
('Rogue', 'Matt Uelman', 178, 2670, 1),
('Sisters', 'Matt Uelman', 105, 1575, 1)

insert into Gry (id, ost)
values (3, 1), (5, 2)

insert into DLC (id, gra, ost)
values (6, 3, 1), (7, 5, 2)

insert into SDK (id, wersja)
values (8, '1.0.0.0')

insert into Transakcje (data, kwota_laczna, zleceniodawca)
values ('20120120', 6000, 1), ('20101220', 2000, 4)

insert into PozycjeTransakcji (produkt, transakcja)
values (1,1), (3,1), (6,1), (4,2)

insert into Posiadania (produkt, wlasciciel)
values (1,1), (3,1), (6,1), (4,4)

insert into ObiektyNaWishlist (autorWishlisty, priorytet, produkt)
values (1, 0, 4), (2, 0, 5), (2, 1, 7), (2, 2, 2)

insert into Osiagniecia (idProd, nazwa, opis)
values
(3, 'Wyjscie spod kiecki mamusi', 'Wyjdz z obozowiska lotrzyc'),
(3, 'Stay a while and listen!', 'Uratuj pewnego starca'),
(3, 'You did it again!', 'Zabij Diablo'),
(5, 'You bastards! You killed Yellow!', 'Grajac w zoltych szatach zgin z reki ktoregos z wspolgraczy'),
(5, 'Yellow! No! Maybe green...', 'Wybieraj kolor swojej szaty przez dluzszy czas'),
(4, 'Jestes zlym czlowiekiem JC!', 'Traf do tajnego wiezienia')

insert into OsiagnieciaOdblokowane (kolekcjoner, osiagniecie)
values
(1, 'Wyjscie spod kiecki mamusi'),
(1, 'Stay a while and listen!'),
(4, 'Jestes zlym czlowiekiem JC!')
GO
------------ SELECT (Pokazanie zawartości naszej bazy)
------------ Na razie za pomocą selectów. Później wykorzystamy funkcje!

select * from Produkty
select * from SDK
select * from Gry
select * from DLC
select * from OST
select * from Utwory

select * from Klienci
select * from SteamWallet
select * from Znajomosci
select * from Grupy
select * from Czlonkostwa

select * from Transakcje
select * from PozycjeTransakcji

select * from Posiadania
select * from ObiektyNaWishlist

select * from Osiagniecia
select * from OsiagnieciaOdblokowane
