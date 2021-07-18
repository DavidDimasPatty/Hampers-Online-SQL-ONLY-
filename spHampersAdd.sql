alter procedure spHampersAdd @idh int, @tgl1 date,@tgl2 date,
@ket varchar(500), @nama varchar(50),@kategori varchar(50),
@ukur varchar(50), @isi int,@harga int

as
set nocount on

if(@idh is null)--jika ingin menambah hampers baru dan ukuran hampersnya
begin
insert into Hampers values (@nama,@tgl1,@tgl2,@kategori)--kategori jika lebih dari 2 diisi dengan , (contoh valentine,wisuda)

declare @q int=0 --variable untuk mendapatkan id

select top 1 @q=hampers.idhampers --dapat id dari hampers yang baru saja dimasukan
from hampers
order by idhampers desc
insert into UkuranHampers values (@q,@ukur,@isi,@harga)
end

if @idh is not null--jika HANYA ingin menambah ukuran hampers ke hampers yang sudah ada
begin
insert into UkuranHampers values (@idh,@ukur,@isi,@harga)
end

return
exec spHampersEdit