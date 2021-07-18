alter procedure spTrackProsses @idtransaksi int
 as --sp yang dilakukan oleh customer untuk tracking proses pembuatan hampers 
set nocount on


--query ini untuk melihat semua kebutuhan waktu yang nantinya ditampilkan ke customer
select transaksi.idtransaksi,transaksi.jumlahhampers,transaksi.idHampers,transaksi.tanggalterima,
		waktukonfirmasi.awal,waktukonfirmasi.selesai,waktubuatham.awal,waktubuatham.selesai,waktuisibar.awal,waktuisibar.selesai,
		waktumerapihkan.awal,waktumerapihkan.selesai,Tanggal.tanggalPengiriman,tanggal.tanggalSelesai,waktu.keterangan
from transaksi inner join waktu on waktu.idtransaksi=transaksi.idtransaksi inner join waktukonfirmasi on
waktukonfirmasi.idwaktu=waktu.idwaktu inner join waktubuatham on waktubuatham.idwaktu=
waktu.idwaktu inner join waktuisibar on waktuisibar.idwaktu=waktu.idwaktu
inner join waktumerapihkan on waktu.idwaktu=waktumerapihkan.idwaktu inner join tanggal on tanggal.idTransaksi=
transaksi.idtransaksi
where transaksi.idtransaksi=@idtransaksi

return
exec spTrackProses