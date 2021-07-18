alter procedure spbarangEdit @iditem int,@nama varchar(50),@kategori varchar(50),@ukur varchar(50),
@gam varchar(500),@ukuran int,@jumlah int,@refrensi varchar(500),@harga int
as
set nocount on

update ItemHampers set namaitem=@nama,Kategoriitem=@kategori --update dari table item hampers berdasarkan input
where iditem=@iditem

update UkuranItem set NamaUkuran=@ukur,Gambar =@gam, Ukuran=@ukuran,jumlahitem=@jumlah, --update dari table ukuran item berdasarkan input
		refrensi=@refrensi,harga=@harga
where idItem=@iditem and Ukuran like '%'+@ukuran+'%'

declare @har int=0 --variable untuk menyimpan id ukuran item
select top 1 @har=UkuranItem.idItem--mencari id ukuran item untuk dimasukan ke histori barang
from UkuranItem inner join itemhampers on ukuranitem.iditem=itemhampers.iditem
where itemhampers.idItem=@iditem and Ukuran like '%'+@ukuran+'%'


insert into HistoriBarang values(@iditem,@har,getdate(),@harga)--mencatat perubahan harga histori barang

return
exec spbarangEdit