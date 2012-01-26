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
kwota_laczna money,
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
(id int IDENTITY(1,1) primary key,
nazwa varchar(50) not null,
opis varchar(100),
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

exec dodaj_Klienta 'Klient_1', '1234567890123456789012345678901234567890123456789012345678901234', '19890223'
exec dodaj_Klienta 'Klient_2', '1234567890123456789012345678901234567890123456789012345678901234', '19700304'
exec dodaj_Klienta 'Klient_3', '1234567890123456789012345678901234567890123456789012345678901234', '19900406'
exec dodaj_Klienta 'Klient_4', '1234567890123456789012345678901234567890123456789012345678901234', '19831212'
exec dodaj_Klienta 'Klient_5', '1234567890123456789012345678901234567890123456789012345678901234', '19500605'

exec dodaj_SteamWallet 1, null
exec dodaj_SteamWallet 2, 2000

exec dodaj_Znajomosc 1, 2
exec dodaj_Znajomosc 3, 4
exec dodaj_Znajomosc 2, 3

exec dodaj_Grupe 3, 'Nie dla ACTA', 'Nie dajmy się zwieść ACTA! ACTA to ZUO! Nie daje nam PACZEĆ!'
exec dodaj_Czlonka_Grupy 5, 'Nie dla ACTA'
exec dodaj_Czlonka_Grupy 1, 'Nie dla ACTA'

exec dodaj_OST 'Diablo II - OST', 0, 716800, 'Wspaniała muzyka ze wspaniałej gry.', 'Wilderness', 'Matt Uelmen', 478, 7170
exec dodaj_OST 'Magica - OST', 500, 358400, 'OST z gry Magica.', 'Vlad is not a Vampire!', 'Vlad', 134, 2010

exec dodaj_Utwor 'Rogue', 'Matt Uelman', 178, 2670, 1
exec dodaj_Utwor 'Sisters', 'Matt Uelman', 105, 1575, 1

exec dodaj_Gre 'Diablo II', 4000, 2621440, 'Klasyk gier komputerowych. Znany powszechnie HacknSlash!', 1
exec dodaj_Gre 'Deus Ex', 2000, 409600, 'Klasyk gier komputerowych. Świetna gra RPG!', null
exec dodaj_Gre 'Magica', 4000, 819200, 'Parodnia gier RPG zapewniająca spore możliwości tworzenia czarów.', 2

exec dodaj_DLC 'Diablo II - Lord Of Destruction', 2000, 768000, 'Dodatek do Diablo II! Dodaje dwie nowe postaci!', 3, 1
exec dodaj_DLC 'Magica - Vietnam', 500, 153600, 'Dodatek do gry Magica. Przenosi naszych magów do.. Wietnamu? O.o', 5 , 2

exec dodaj_SDK 'Source SDK', 0, 2359296, 'SDK pozwalające na tworzenie gier na silniczku Source', '1.0.0.0'

exec dodaj_Transakcje 1, 3
exec dodaj_PozycjeTransakcji 1, 1
exec dodaj_PozycjeTransakcji 6, 1
exec dodaj_Transakcje 4, 4

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
