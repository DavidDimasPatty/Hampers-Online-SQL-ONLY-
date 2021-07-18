alter procedure spResOrder @id int 
as--sp untuk melihat order yang sudah berjalan
set nocount on


if @id is not null--jika idnya null
begin
	select * --select semua kolom di table transaksi dan status pesanan yang memenuhi kondisi di where 
	from transaksi inner join StatusPesanan on transaksi.idTransaksi=StatusPesanan.idTransaksi
	where StatusPesanan.statusPembayaran = 'true' and StatusPesanan.statusDiproses='true' and transaksi.idtransaksi=@id
end

else
begin --sama seperti kondisi di if bedanya tidak ada id
	select *
	from transaksi inner join StatusPesanan on transaksi.idTransaksi=StatusPesanan.idTransaksi
	where StatusPesanan.statusPembayaran = 'true' and StatusPesanan.statusDiproses='true' 

end

return
exec spResOrder