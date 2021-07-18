alter procedure spfindbar @pakhamp int, @inp varchar(400),@harga1 int, @harga2 int
as 
set nocount on

declare @tbl table(--table untuk menampilkan hasil dari sp
nambar varchar(50),
ukuran varchar(10),
gambar varchar(50),
harga int
)

if @harga1 is null --set harga1 jika null
begin
	set @harga1=0
end

 if @harga2 is null --set harga2 jika null
begin
	set @harga2=9999999
end

if @inp is null ----set input jika null
begin
	set @inp=''
end

declare @str varchar(50)=cast(@pakhamp as varchar)+','--variable untuk membuat string+',' agar nantinya kalau di like tidak tercampur-campur
insert into @tbl--menjalani query dan memasukan ke table hasil
		select itemhampers.namaitem,ukuranitem.namaukuran,ukuranitem.gambar,ukuranitem.harga
		from itemhampers inner join ukuranitem on itemhampers.iditem=ukuranitem.iditem
		where ukuranitem.refrensi like '%'+@str+'%'  and itemhampers.namaitem like '%'+@inp+'%'  and ukuranitem.harga between @harga1 and @harga2 and ukuranitem.jumlahitem>0

select *--menampilkan semua data di table hasil
from @tbl

return
exec spfindbar 