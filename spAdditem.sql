alter procedure spbarangAdd @iditem int,@nama varchar(50),@kategori varchar(50),@ukur varchar(50),
@gam varchar(500),@ukuran int,@jumlah int,@refrensi varchar(500),@harga int
as
set nocount on

if(@iditem is  null) --jika id itemnya  null
begin
insert into ItemHampers values (@nama,@kategori)
declare @q int =0
select @q=ItemHampers.idItem-- variable q untuk mendapatkan id hampers
from ItemHampers
order by idItem desc
insert into UkuranItem values (@q,@ukur,@gam, @ukuran,@jumlah,@refrensi,@harga)
end

if @iditem is not null --jika iditemnya tidak null
begin
insert into UkuranItem values (@iditem,@ukur,@gam, @ukuran,@jumlah,@refrensi,@harga)
end

return
exec spbarangAdd