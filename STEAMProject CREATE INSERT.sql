drop DATABASE Steam
GO

CREATE DATABASE Steam
GO

USE Steam
GO

SET LANGUAGE polski
GO

--------- CREATE (Utworzenie podstawy bazy danych, czyli tabel
--------- i kilku zależności między nimi)

create table Klienci
(steamid int not null primary key,
nazwa_wyswietlana varchar(40) not null,
haslo varchar(64) not null,
data_urodzenia date,
check (Len(haslo) = 64));

create table SteamWallet
(id int not null primary key,
wlasciciel int references Klienci(steamid) unique not null,
kwota money default 0);

create table Znajomosci
(znajomy1 int references Klienci(steamid) not null,
znajomy2 int references Klienci(steamid) not null,
check (znajomy1 != znajomy2));

create table Transakcje
(id int not null primary key,
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
(id int not null primary key,
nazwa varchar(40) not null unique,
cena money not null,
wielkosc int not null,
opis varchar(400),
check (wielkosc > 0));

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
(id int not null primary key,
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

create procedure dodaj_SDK
       @nazwa varchar(40),
       @cena money,
       @wielkosc int,
       @opis varchar(400),
       @wersja varchar(10)
AS
begin try
    if (@nazwa is null)
        raiserror ('Nie podano nazwy!', 11, 1)
    if (@cena is null)
        set @cena = 0
    if (@wielkosc is null)
        raiserror ('Nie podano wielkosci pliku!', 11, 2)
    if exists (select * from Produkty where (nazwa = @nazwa))
    begin
       raiserror ('Istnieje już produkt o tej nazwie!', 11, 3)
    end
    else
    begin
        declare @idek int
        set @idek = 1000000 * RAND(@wielkosc)
        while exists (select * from Produkty where (id = @idek))
        begin
            set @idek = 1000000 * RAND(@wielkosc)
        end
        insert into Produkty(id, nazwa, cena, wielkosc, opis)
        values (@idek, @nazwa, @cena, @wielkosc, @opis)
        insert into SDK(id, wersja)
        values (@idek, @wersja)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_OST
       @nazwa varchar(40),
       @cena money,
       @wielkosc int,
       @opis varchar(400),
       @tytulPierwszegoUtworu varchar(40),
       @autor varchar(40),
       @dlugosc int,
       @wielkoscSciezki int
AS
begin try
    if (@nazwa is null)
        raiserror ('Nie podano nazwy!', 11, 1)
    if (@cena is null)
        set @cena = 0
    if (@wielkosc is null)
        raiserror ('Nie podano wielkosci pliku!', 11, 2)
    if (@tytulPierwszegoUtworu is null)
        raiserror ('Nie podano nazwy pierwszego utworu!', 11, 3)
    if (@wielkoscSciezki is null)
        raiserror ('Nie podano wielkosci utworu!', 11, 4)
    if exists (select * from Produkty where (nazwa = @nazwa))
    begin
       raiserror ('Istnieje już produkt o tej nazwie!', 11, 5)
    end
    if exists (select * from Utwory where (tytul = @tytulPierwszegoUtworu))
    begin
       raiserror ('Istnieje już utwor o tej nazwie!', 11, 6)
    end
    else
    begin
        declare @idek int
        set @idek = 1000000 * RAND(@wielkosc)
        while exists (select * from Produkty where (id = @idek))
        begin
            set @idek = 1000000 * RAND(@wielkosc)
        end
        insert into Produkty(id, nazwa, cena, wielkosc, opis)
        values (@idek, @nazwa, @cena, @wielkosc, @opis)
        insert into OST(id)
        values (@idek)
        insert into Utwory(tytul, autor, dlugosc, wielkosc, album)
        values (@tytulPierwszegoUtworu, @autor, @dlugosc, @wielkoscSciezki, @idek)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_Gre
       @nazwa varchar(40),
       @cena money,
       @wielkosc int,
       @opis varchar(400),
       @ost int
AS
begin try
    if (@nazwa is null)
        raiserror ('Nie podano nazwy!', 11, 1)
    if (@cena is null)
        set @cena = 0
    if (@wielkosc is null)
        raiserror ('Nie podano wielkosci pliku!', 11, 2)
    if exists (select * from Produkty where (nazwa = @nazwa))
    begin
       raiserror ('Istnieje już produkt o tej nazwie!', 11, 3)
    end
    else
    begin
        declare @idek int
        set @idek = 1000000 * RAND(@wielkosc)
        while exists (select * from Produkty where (id = @idek))
        begin
            set @idek = 1000000 * RAND(@wielkosc)
        end
        insert into Produkty(id, nazwa, cena, wielkosc, opis)
        values (@idek, @nazwa, @cena, @wielkosc, @opis)
        
        if (@ost is not null)
        begin
            insert into Gry(id, ost)
            values (@idek, @ost)
        end
        else
        begin
            insert into Gry(id)
            values (@idek)
        end
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_DLC
       @nazwa varchar(40),
       @cena money,
       @wielkosc int,
       @opis varchar(400),
       @gra int,
       @ost int
AS
begin try
    if (@nazwa is null)
        raiserror ('Nie podano nazwy!', 11, 1)
    if (@cena is null)
        set @cena = 0
    if (@wielkosc is null)
        raiserror ('Nie podano wielkosci pliku!', 11, 2)
    if (@gra is null)
        raiserror ('Nie podano gry!', 11, 3)
    if exists (select * from Produkty where (nazwa = @nazwa))
    begin
       raiserror ('Istnieje już produkt o tej nazwie!', 11, 4)
    end
    if not exists (select * from Produkty where (id = @gra))
    begin
       raiserror ('Nie istnieje taka gra!', 11, 5)
    end
    else
    begin
        declare @idek int
        set @idek = 1000000 * RAND(@wielkosc)
        while exists (select * from Produkty where (id = @idek))
        begin
            set @idek = 1000000 * RAND(@wielkosc)
        end
        insert into Produkty(id, nazwa, cena, wielkosc, opis)
        values (@idek, @nazwa, @cena, @wielkosc, @opis)
        insert into DLC(id, gra, ost)
        values (@idek, @gra, @ost)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_Utwor
       @tytulPierwszegoUtworu varchar(40),
       @autor varchar(40),
       @dlugosc int,
       @wielkoscSciezki int,
       @album int
AS
begin try
    if (@tytulPierwszegoUtworu is null)
        raiserror ('Nie podano tytułu pierwszego utworu!', 11, 1)
    if (@autor is null)
        raiserror ('Nie podano autora!', 11, 2)
    if (@wielkoscSciezki is null)
        raiserror ('Nie podano wielkosci pliku!', 11, 3)
    if (@album is null)
        raiserror ('Nie podano albumu!', 11, 4)
    if not exists (select * from OST where (id = @album))
    begin
       raiserror ('Istnieje już produkt o tej nazwie!', 11, 5)
    end
    if exists (select * from Utwory where (tytul = @tytulPierwszegoUtworu))
    begin
       raiserror ('Istnieje już utwor o tej nazwie!', 11, 6)
    end
    else
    begin
        insert into Utwory(tytul, autor, dlugosc, wielkosc, album)
        values (@tytulPierwszegoUtworu, @autor, @dlugosc, @wielkoscSciezki, @album)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_Klienta
       @nazwa_wyswietlana varchar(40),
       @haslo varchar(64),
       @data_urodzenia date
AS
begin try
    if (@nazwa_wyswietlana is null)
        raiserror ('Nie podano nazwy uzytkownika!', 11, 1)
    if (@haslo is null)
        raiserror ('Nie podano hasla!', 15, 2)
    if (LEN(@nazwa_wyswietlana) < 8)
        raiserror ('Podana nazwa jest za krotka!', 11, 3)
    if (18 > DATEDIFF(yyyy,@data_urodzenia,CURRENT_TIMESTAMP))
        raiserror ('Uzytkownik ma ponizej 18 lat!', 11, 4)
    if exists (select * from Klienci where (nazwa_wyswietlana = @nazwa_wyswietlana))
    begin
       raiserror ('Istnieje już uzytkownik o tej nazwie!', 11, 5)
    end
    else
    begin
        declare @idek int
        set @idek = 1000000 *
            RAND(YEAR(@data_urodzenia)+MONTH(@data_urodzenia)+DAY(@data_urodzenia))
        while exists (select * from Klienci where (steamid = @idek))
        begin
            set @idek = 1000000 *
                RAND(YEAR(@data_urodzenia)+MONTH(@data_urodzenia)+DAY(@data_urodzenia))
        end
        insert into Klienci(steamid,nazwa_wyswietlana,haslo,data_urodzenia)
        values (@idek,@nazwa_wyswietlana,@haslo,@data_urodzenia)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_Osiagniecie
       @nazwa varchar(50),
       @opis varchar(100),
       @id_prod int
AS
begin try
    if (@nazwa is null)
        raiserror ('Nie podano nazwy osiagniecia!', 11, 1)
    if (@id_prod is null)
        raiserror ('Nie podano produktu docelowego!', 11, 2)
    if not exists (select * from Produkty where (@id_prod = id))
    begin
       raiserror ('Nie istnieje wybrany produkt!', 11, 3)
    end
    if exists (select * from Osiagniecia where (nazwa = @nazwa AND @id_prod = idProd))
    begin
       raiserror ('Istnieje już osiagniecie o tej nazwie dla wybranej gry!', 11, 4)
    end
    else
    begin
        declare @idek int
        set @idek = 1000000 * RAND(@id_prod)
        while exists (select * from Osiagniecia where (id = @idek))
        begin
            set @idek = 1000000 * RAND(@id_prod)
        end
        insert into Osiagniecia(id, nazwa, opis, idProd)
        values (@idek,@nazwa,@opis,@id_prod)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_Grupe
       @zalozyciel int,
       @nazwa varchar(50),
       @opis varchar(400)
AS
begin try
    if (@nazwa is null)
        raiserror ('Nie podano nazwy grupy!', 11, 1)
    if not exists (select * from Klienci where (@zalozyciel = steamid))
    begin
       raiserror ('Nie istnieje zalozyciel tej grupy! Niepoprawne steamid!', 11, 2)
    end
    else
    begin
        insert into Grupy(nazwa,opis)
        values (@nazwa,@opis)
        insert into Czlonkostwa(klient, grupa)
        values (@zalozyciel,@nazwa)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_Czlonka_Grupy
       @steamid int,
       @nazwa varchar(50)
AS
begin try
    if (@nazwa is null)
        raiserror ('Nie podano nazwy grupy!', 11, 1)
    if (@steamid is null)
        raiserror ('Nie podano steamid uzytkownika!', 11, 2)
    if not exists (select * from Klienci where (@steamid = steamid))
    begin
       raiserror ('Nie istnieje taki klient! Niepoprawne steamid!', 11, 3)
    end
    if not exists (select * from Grupy where (@nazwa = nazwa))
    begin
       raiserror ('Nie istnieje taka grupa!', 11, 4)
    end
    else
    begin
        insert into Czlonkostwa(klient, grupa)
        values (@steamid,@nazwa)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_Znajomosc
       @steamidProszacego int,
       @steamidPrzyjmujacego int
AS
begin try
    if (@steamidProszacego = @steamidPrzyjmujacego)
        raiserror ('Forever Alone! Nie mozna dodac do znajomych samego siebie', 11, 1)
    if (@steamidProszacego is null)
        raiserror ('Nie podano uzytkownika proszacego o znajomosc!', 11, 2)
    if (@steamidPrzyjmujacego is null)
        raiserror ('Nie podano uzytkownika przyjmujacego do znajomych!', 11, 3)
    if not exists (select * from Klienci
        where (@steamidProszacego = steamid OR @steamidPrzyjmujacego = steamid))
    begin
       raiserror ('Nie istnieje taki klient! Niepoprawne steamid!', 11, 4)
    end
    if exists (select * from Znajomosci
        where ((@steamidProszacego = znajomy1 AND @steamidPrzyjmujacego = znajomy2)
        OR (@steamidProszacego = znajomy2 AND @steamidPrzyjmujacego = znajomy1)))
    begin
       raiserror ('Jestescie juz znajomymi!', 11, 5)
    end
    else
    begin
        insert into Znajomosci(znajomy1, znajomy2)
        values (@steamidProszacego, @steamidPrzyjmujacego)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_Transakcje
       @steamidKupujacego int,
       @idProduktu int
AS
begin try
    if (@steamidKupujacego is null)
        raiserror ('Nie podano wlasciciela koszyka!', 11, 1)
    if (@idProduktu is null)
        raiserror ('Nie podano pierwszego produktu z koszyka!', 11, 2)
    if not exists (select * from Klienci
        where (@steamidKupujacego = steamid))
    begin
       raiserror ('Nie istnieje taki klient! Niepoprawne steamid!', 11, 3)
    end
    if exists (select * from Produkty where (@idProduktu = id))
    begin
       raiserror ('Nie istnieje taki produkt!', 11, 4)
    end
    else
    begin
        declare @idek int
        set @idek = 1000000 * RAND(@steamidKupujacego + @idProduktu)
        while exists (select * from Transakcje where (id = @idek))
        begin
            set @idek = 1000000 * RAND(@steamidKupujacego + @idProduktu)
        end
        declare @kupujacy varchar(40)
        declare @cena_pierwszego int
        set @kupujacy = (select nazwa_wyswietlana from Klienci where (steamid = @steamidKupujacego))
        set @cena_pierwszego = (select cena from Produkty where (id = @idProduktu))
        insert into Transakcje(id, data, kwota_laczna, zleceniodawca)
        values (@idek, CURRENT_TIMESTAMP, @cena_pierwszego, @kupujacy)
        
        declare @idek1 int
        set @idek1 = 10000000 * RAND(@steamidKupujacego + @idProduktu)
        while exists (select * from PozycjeTransakcji where (id = @idek))
        begin
            set @idek1 = 10000000 * RAND(@steamidKupujacego + @idProduktu)
        end
        insert into PozycjeTransakcji(id, produkt, transakcja)
        values (@idek1, @idProduktu, @idek)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

---------- INSERT (Dodanie kilku przykładowych wartości na początek)

exec dodaj_Klienta 'Klient_1', '1234567890123456789012345678901234567890123456789012345678901234', '19890223'
exec dodaj_Klienta 'Klient_2', '1234567890123456789012345678901234567890123456789012345678901234', '19700304'
exec dodaj_Klienta 'Klient_3', '1234567890123456789012345678901234567890123456789012345678901234', '19900406'
exec dodaj_Klienta 'Klient_4', '1234567890123456789012345678901234567890123456789012345678901234', '19831212'
exec dodaj_Klienta 'Klient_5', '1234567890123456789012345678901234567890123456789012345678901234', '19500605'

exec dodaj_OST 'Diablo II - OST', 0, 716800, 'Wspaniała muzyka ze wspaniałej gry.', 'Wilderness', 'Matt Uelmen', 478, 7170

exec dodaj_Gre 'Diablo II', 60, 2621440, 'Klasyk gier komputerowych. Znany powszechnie HacknSlash!', FIRST(select id from Produkty where (nazwa = 'Diablo II - OST'))
exec dodaj_Gre 'Deus Ex', 20, 409600, 'Klasyk gier komputerowych. Świetna gra RPG!', null
exec dodaj_Gre 'Magica', 40, 819200, 'Parodnia gier RPG zapewniająca spore możliwości tworzenia czarów.', null


------------ SELECT (Pokazanie zawartości naszej bazy)
------------ Na razie za pomocą selectów. Później wykorzystamy funkcje!

select * from Czlonkostwa
select * from DLC
select * from Grupy
select * from Gry
select * from Produkty
select * from Klienci
select * from ObiektyNaWishlist
select * from Osiagniecia
select * from OsiagnieciaOdblokowane
select * from OST
select * from Posiadania
select * from PozycjeTransakcji
select * from SDK
select * from SteamWallet
select * from Transakcje
select * from Utwory
select * from Znajomosci
