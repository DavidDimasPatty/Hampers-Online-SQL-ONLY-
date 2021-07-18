alter procedure spBarangPrice @id varchar(50)--melihat harga barang sebelumnya
as
set nocount on
declare @tbl table(
IdHistoriHarga int ,
IdBarang int ,
HargaJual int,
TanggalBerlaku date, 
selisih int,
iterasi int
) 

declare harga cursor--memakai cursor harga
for
select idhistori,IdBarang,hargaitem,Tanggal --cursor terhadap query (mencari yang id barangnya = @id)
from Historibarang
where idbarang=@id
order by Tanggal

open harga

declare @idhistori int=0--variable yang nantinya diisi untuk setiap iterasi cursor
declare @idbarang int=0--variable yang nantinya diisi untuk setiap iterasi cursor
declare @hargajual int=0--variable yang nantinya diisi untuk setiap iterasi cursor
declare @tanggal date --variable yang nantinya diisi untuk setiap iterasi cursor
declare @tanggal2 date--sebagai variable temporary harga
declare @tanggal3 date
declare @iterasi int=0
declare @sel int=0 --menyimpan selisih perubahan tanggal


fetch next from harga into @idhistori,@idbarang,@hargajual,@tanggal
set @tanggal2=@tanggal
while @@FETCH_STATUS=0
begin
		SELECT @sel=DATEDIFF(day, @tanggal2, @tanggal) --selisih tanggal perubahan
		set @tanggal2=@tanggal
		insert into @tbl values (@idhistori,@idbarang,@hargajual,@tanggal,@sel,@iterasi) --data masuk ke @tbl
		set @iterasi=@iterasi+1
	
	fetch next from harga into @idhistori,@idbarang,@hargajual,@tanggal			
end

select *
from @tbl

close harga
deallocate harga
