alter procedure spIncome @tanggal1 datetime, @tanggal2 datetime
as
set nocount on

declare @tbl table (--table untuk menyimpan hasil dari query yang nanti dijalankan
id_pembayaran int,
TanggalPembayaran date,
jumlah int,
namabarang varchar(1000),
namaC varchar(50),
alamat varchar(50),
HargaTotal int
)

if @tanggal1 is null --jika tanggal1 null
begin
	set @tanggal1='1980-10-10'--set tanggal 1 menjadi tanggal bawah
end

if @tanggal2 is null ----jika tanggal2 null
begin
	set @tanggal2='2050-10-10'--set tanggal 1 menjadi tanggal atas
end

declare @harga int

insert into @tbl
	select DataPembayaran.idPembayaran,DataPembayaran.tanggalPembayaran,transaksi.jumlahhampers,transaksi.idhampers,Customer.Nama,Customer.idalamat,transaksi.HargaTotal
	from DataPembayaran inner join transaksi on DataPembayaran.idtransaksi=transaksi.idtransaksi inner join Customer on transaksi.idCustomer=Customer.idCustomer
	where DataPembayaran.tanggalPembayaran between @tanggal1 AND @tanggal2 --mendapatkan semua transaksi beserta harga totalnya berdasarkan range tanggal tertentu

select *--menampilkan isi dari table 
from @tbl

select @harga=count(hargatotal)
from @tbl

return @harga

return

exec spIncome