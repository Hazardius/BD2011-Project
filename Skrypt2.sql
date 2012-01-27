
USE Steam
GO

--- Tabela tymczasowa "Rzeczy nie kupionych"

create table #rzeczyniekupione
(id int not null primary key,
nazwa varchar(40) not null unique,
cena money not null,
wielkosc int not null,
opis varchar(400),
check (wielkosc > 0));

go

insert into #rzeczyniekupione
select c.id, c.nazwa, c.cena, c.wielkosc, c.opis
       from Posiadania d right outer join Produkty c
	on d.produkt = c.id
	where wlasciciel is null;

go

select * from #rzeczyniekupione

go

---------- Widoki/Perspektywy

create view Wishlist_info(id, produkt)
as
select  id, produkt
		from ObiektyNaWishlist
		where autorWishlisty = (select steamid
					from Klienci
					where (steamid = 1))

go

select * from Wishlist_info

go

---------- PROCEDURY

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

go

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

go

---------- FUNKCJE

----- Skalarna

create function ilosc_czlonkow_grupy
        (@nazwa_grupy varchar(50))
        returns int
as
begin
        return (Select COUNT(*) from Czlonkostwa where (grupa = @nazwa_grupy))
end

go

PRINT dbo.ilosc_czlonkow_grupy('Nie dla ACTA')

go

----- Tablicowe proste

create function posiadane_produkty
    	(@nick varchar(40))
        returns table
as
        return select id , nazwa 
		from Posiadania d join Produkty c
		on d.produkt = c.id
		where wlasciciel = (select steamid
					from Klienci
					where nazwa_wyswietlana = @nick)

go

Select * from posiadane_produkty('Klient_1')

go

create function wishlista
		(@nick varchar(40))
        returns table
as
        return select nazwa, priorytet
		from ObiektyNaWishlist o join Produkty p
		on o.produkt = p.id
		where autorWishlisty = (select steamid
					from Klienci
					where nazwa_wyswietlana = @nick)

go

Select * from wishlista('Klient_1')
Select * from wishlista('Klient_2')

go

----- Tablicowa złożona

create function achievement
		(@nick varchar(40),
		 @nazwagry varchar(40))
        returns @achievementy table
                (achievement varchar(100), gra varchar(40))
as
begin
        if ((Select id from Produkty where @nazwagry = nazwa) in (Select id from Gry))
            OR ((Select id from Produkty where @nazwagry = nazwa) in (Select id from DLC))
        begin
            insert into @achievementy
            select o.nazwa as nazwa_osiagniecia, p.nazwa as nazwa_gry
                from Osiagniecia o, Produkty p, OsiagnieciaOdblokowane oo
                where (o.idProd = p.id)
                    AND (@nazwagry = p.nazwa)
                    AND (oo.kolekcjoner = @nick)
                    AND (oo.osiagniecie = o.nazwa)
        end
        else
        begin
            insert into @achievementy
            values ('n/d','n/d')
        end
    return
end

go

select * from achievement(1, 'Diablo II')
select * from achievement(4, 'Diablo II')
select * from achievement(1, 'Source SDK')

go

---------- Procedura wyzwalająca inną procedurę

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

go

---------- Kursory (wyswietlajacy i modyfikujacy)

declare @name varchar(40)
DECLARE klienciKursor CURSOR
FOR  select nazwa_wyswietlana from Klienci
OPEN klienciKursor
print 'Zarejestrowani klienci:'
FETCH NEXT from klienciKursor into @name
while @@fetch_status=0
begin
    print @name
    FETCH NEXT from klienciKursor into @name
end
CLOSE klienciKursor
DEALLOCATE klienciKursor

go

DECLARE modKur CURSOR
FOR  select * from Produkty

OPEN modKur
FETCH NEXT from modKur
while @@fetch_status=0
begin
  UPDATE Produkty SET cena = cena * 0.50
  WHERE CURRENT OF modKur
  FETCH NEXT from modKur
end
CLOSE modKur
DEALLOCATE modKur

go
---------- Zapytania
----- Proste

Select * from Produkty
    where cena < (Select AVG(cena) from Produkty)

go

----- Skorelowane

select id, nazwa, cena
    from Produkty pro
        where 3 > (select COUNT(*) from Produkty pod
    where pod.cena > pro.cena)
    order by cena desc

go

----- Z wieloma tabelami

select o.nazwa as nazwa_osiagniecia, p.nazwa as nazwa_gry
                from Osiagniecia o, Produkty p, OsiagnieciaOdblokowane oo
                where (o.idProd = p.id)
                    AND (p.nazwa like '%Diablo%')
                    AND (oo.kolekcjoner = 1)
                    AND (oo.osiagniecie = o.nazwa)

go

----- Funkcje agregujace

create view IluMamyKlientow(ilosc_klientow)
as
    select COUNT(*)
        from Klienci

go

select * from IluMamyKlientow

go

create view IleMamyGrup(ilosc_grup)
as
    select COUNT(*)
        from Grupy

go

select * from IleMamyGrup

go

create view NajdrozszeProdukty(id, nazwa, cena)
as
    select id, nazwa, cena
        from Produkty
            where cena = (select MAX(cena)
		        from Produkty)

go

select * from NajdrozszeProdukty

go

create view NajtanszeProdukty(id, nazwa, cena)
as			
    select id, nazwa, cena
        from Produkty
            where cena = (select MIN(cena)
				from Produkty)
				
go

select * from NajtanszeProdukty

go

---------- Wiecej procedur dodajacych/aktualizujących/usuwających dane

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

go

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

go

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

go

---------- Przyklad uzycia triggerow

insert into ObiektyNaWishlist (autorWishlisty, priorytet, produkt)
values(2, 0, 3)

delete from ObiektyNaWishlist
where priorytet = 0

delete from ObiektyNaWishlist
where priorytet = 1

insert into Posiadania (produkt, wlasciciel)
values (3,2)

---------- Przyklad uzycia INDEKSOW

select Produkty.*
from Produkty with (index(ProduktyPoID),nolock)
where
Produkty.nazwa like '%Diablo%'