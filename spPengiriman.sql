alter procedure spPengiriman @idtransaksi int,@tanggal1 date, @tanggal2 date
as
set nocount on

if @tanggal1 is not null --jika tanggal 1 null maka paket diantar 
begin
		update tanggal set tanggal.tanggalPengiriman=@tanggal1 --update tanggal pengiriman yang tadinya null atau -1
		where tanggal.idTransaksi=@idtransaksi

		update waktu set keterangan='Hampers dalam pengiriman'--update waktu keteranganya
		where waktu.idtransaksi=@idtransaksi

end

if @tanggal2 is not null --jika tanggal 2 tidak null maka paket sudah sampai ke penerima
begin
		update tanggal set tanggal.tanggalSelesai=@tanggal2 --update tanggal selsai
		where tanggal.idTransaksi=@idtransaksi

		update waktu set keterangan='Selesai'--update keterangan menjadi selsai
		where waktu.idtransaksi=@idtransaksi

		update StatusPesanan set statusTiba='True'--update status pemesanan
		where StatusPesanan.idTransaksi=@idtransaksi

end

return
exec spPengiriman