---------- NIEKTORE PROCEDURY DODAJ�CE I EDYTUJ�CE

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
       raiserror ('Istnieje ju� produkt o tej nazwie!', 11, 3)
    end
    else
    begin
        insert into Produkty(nazwa, cena, wielkosc, opis)
        values (@nazwa, @cena, @wielkosc, @opis)
        
        declare @idek int
        set @idek = (select id from Produkty where (nazwa = @nazwa AND cena = @cena AND wielkosc = @wielkosc))
        
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
       raiserror ('Istnieje ju� produkt o tej nazwie!', 11, 5)
    end
    if exists (select * from Utwory where (tytul = @tytulPierwszegoUtworu))
    begin
       raiserror ('Istnieje ju� utwor o tej nazwie!', 11, 6)
    end
    else
    begin
        insert into Produkty(nazwa, cena, wielkosc, opis)
        values (@nazwa, @cena, @wielkosc, @opis)
        
        declare @idek int
        set @idek = (select id from Produkty where (nazwa = @nazwa AND cena = @cena AND wielkosc = @wielkosc))
        
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
       raiserror ('Istnieje ju� produkt o tej nazwie!', 11, 3)
    end
    else
    begin
        insert into Produkty(nazwa, cena, wielkosc, opis)
        values (@nazwa, @cena, @wielkosc, @opis)

        declare @idek int
        set @idek = (select id from Produkty where (nazwa = @nazwa AND cena = @cena AND wielkosc = @wielkosc))

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
       raiserror ('Istnieje ju� produkt o tej nazwie!', 11, 4)
    end
    if not exists (select * from Produkty where (id = @gra))
    begin
       raiserror ('Nie istnieje taka gra!', 11, 5)
    end
    else
    begin
        insert into Produkty(nazwa, cena, wielkosc, opis)
        values (@nazwa, @cena, @wielkosc, @opis)

        declare @idek int
        set @idek = (select id from Produkty where (nazwa = @nazwa AND cena = @cena AND wielkosc = @wielkosc))

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
        raiserror ('Nie podano tytu�u pierwszego utworu!', 11, 1)
    if (@autor is null)
        raiserror ('Nie podano autora!', 11, 2)
    if (@wielkoscSciezki is null)
        raiserror ('Nie podano wielkosci pliku!', 11, 3)
    if (@album is null)
        raiserror ('Nie podano albumu!', 11, 4)
    if not exists (select * from OST where (id = @album))
    begin
       raiserror ('Istnieje ju� produkt o tej nazwie!', 11, 5)
    end
    if exists (select * from Utwory where (tytul = @tytulPierwszegoUtworu))
    begin
       raiserror ('Istnieje ju� utwor o tej nazwie!', 11, 6)
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
       raiserror ('Istnieje ju� uzytkownik o tej nazwie!', 11, 5)
    end
    else
    begin
        insert into Klienci(nazwa_wyswietlana,haslo,data_urodzenia)
        values (@nazwa_wyswietlana,@haslo,@data_urodzenia)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_SteamWallet
       @steamid int,
       @kwota int
AS
begin try
    if (@steamid is null)
        raiserror ('Nie podano nazwy uzytkownika!', 11, 1)
    if (@kwota is null)
        set @kwota = 0
    if not exists (select * from Klienci where (@steamid = steamid))
    begin
       raiserror ('Nie istnieje taki uzytkownik!', 11, 2)
    end
    else
    begin
        insert into SteamWallet (wlasciciel, kwota)
        values (@steamid, @kwota)
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
       raiserror ('Istnieje ju� osiagniecie o tej nazwie dla wybranej gry!', 11, 4)
    end
    else
    begin
        insert into Osiagniecia(nazwa, opis, idProd)
        values (@nazwa,@opis,@id_prod)
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
    if exists (select * from Czlonkostwa where (@nazwa = grupa AND @steamid = klient))
    begin
       raiserror ('Klient nalezy juz do tej grupy!', 11, 5)
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
    if not exists (select * from Produkty where (@idProduktu = id))
    begin
       raiserror ('Nie istnieje taki produkt!', 11, 4)
    end
    else
    begin
        declare @kupujacy varchar(40)
        declare @cena_pierwszego int
        declare @data datetime
        set @kupujacy = (select nazwa_wyswietlana from Klienci where (steamid = @steamidKupujacego))
        set @cena_pierwszego = (select cena from Produkty where (id = @idProduktu))
        set @data = CURRENT_TIMESTAMP
        insert into Transakcje(data, kwota_laczna, zleceniodawca)
        values (@data, @cena_pierwszego, @kupujacy)

        declare @idek int
        set @idek = (select id from Transakcje where (kwota_laczna = @cena_pierwszego AND @kupujacy = zleceniodawca AND @data = data))
        
        insert into PozycjeTransakcji(produkt, transakcja)
        values (@idProduktu, @idek)
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure zmien_Transakcje
        @dodanaCena money,
        @idTransakcji int
AS
begin try
    if (@dodanaCena is null)
        raiserror ('Nie podano dodanej ceny!', 11, 1)
    if (@idTransakcji is null)
        raiserror ('Nie podano id Transakcji!', 11, 2)
    if not exists (select * from Transakcje
        where (@idTransakcji = id))
    begin
       raiserror ('Nie istnieje taka transakcja!', 11, 3)
    end
    else
    begin
        declare @nowaSumaCen money
        set @nowaSumaCen = @dodanaCena + (Select kwota_laczna from Transakcje where @idTransakcji = id)

        update Transakcje
        set kwota_laczna = @nowaSumaCen
        where @idTransakcji = id
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO

create procedure dodaj_PozycjeTransakcji
       @idProduktu int,
       @idTransakcji int
AS
begin try
    if (@idProduktu is null)
        raiserror ('Nie mozna dodac niczego do transakcji!', 11, 1)
    if (@idTransakcji is null)
        raiserror ('Nie podano do jakiej transakcji mamy dodac ten produkt!', 11, 2)
    else
    begin
        insert into PozycjeTransakcji(produkt, transakcja)
        values (@idProduktu, @idTransakcji)
        
        declare @cena money
        set @cena = (select cena from Produkty where id = @idProduktu)
        
        exec zmien_Transakcje @cena, @idTransakcji
    end
end try
begin catch
               SELECT ERROR_NUMBER() AS 'NUMER BLEDU',ERROR_MESSAGE() AS 'KOMUNIKAT'
end catch
GO
-- View i tabela tymczasowa
--- Tabela tymczasowa rzeczyniekupione

create table #rzeczyniekupione
(id int not null primary key,
nazwa varchar(40) not null unique,
cena money not null,
wielkosc int not null,
opis varchar(400),
check (wielkosc > 0));

insert into #rzeczyniekupione
select c.id, c.nazwa, c.cena, c.wielkosc, c.opis
       from Posiadania d join Produkty c
	on d.produkt = c.id
	where wlasciciel is null;
	
---------- view

create view Wishlist_info(id, produkt)
as
select  id, produkt
		from ObiektyNaWishlist
		where autorWishlisty = (select steamid
					from Klienci
					where steamid = ???/**tutaj nr klineta**/)
					
					
select * from Wishlist_info

/**
create function produkt
    	(@nick steamid)
        returns table
as
begin
        return select id , nazwa ,wlasciciel , steamid
		from Posiadania d join Produkty c
		on d.produkt = c.id
		where wlasciciel = (select steamid
					from Klienci
					where steamid = @nick)
end

create function wishlista
		(@nick steamid)
        returns table
as
begin
        return select id , produkt
		from ObiektyNaWishlist
		where autorWishlisty = (select steamid
					from Klienci
					where steamid = @nick)
end


create function achivmon
		(@nick steamid,
		 @nazwagry id )
        returns table
as
begin
return select c.id as id_osiagniecia, c.nazwa as nazwa_osigniecia , c.nazwa2 as nazwa_gry
		from (select a.nazwa, a.id, b.nazwa as nazwa2
		from Osiagniecia a join (select *
				from Posiadania d join Produkty c
				on d.produkt = c.id
				where wlasciciel = (select steamid   /** zamiast tego mozna wywolać procedure od nicku ? **/
					from Klienci
					where steamid = @nick)) b
on a.idProd = b.id ) c
where nazwa2 = @nazwagry 

**/

---- Agregujace

select COUNT(*)
from Klienci

select COUNT(*)
from Grupy

select id, nazwa
from Produkty
where cena = (select MAX(cena)
				from Produkty)
			
select id, nazwa
from Produkty
where cena = (select MIN(cena)
				from Produkty)
				

-- Przyk�ady ich u�ycia
