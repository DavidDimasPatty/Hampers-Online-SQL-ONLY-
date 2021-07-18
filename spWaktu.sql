alter procedure spWaktu @idtransaksi int, @wskonfirmasi datetime,@wsbuatham datetime,
@wsisibar datetime,@wsmerapihkan datetime,@cancel datetime
as --sp yang digunakan worker jika ada proses pengerjaan yang telah selsai
set nocount on

declare @gen int=0 --variable untuk mendapatkan idtransaksi
select top 1 @gen=waktu.idwaktu
from waktu inner join transaksi on transaksi.idTransaksi=waktu.idtransaksi
where transaksi.idtransaksi=@idtransaksi


if @wskonfirmasi is not null --jika worker sudah beres konfirmasi
begin
	update waktukonfirmasi set selesai=@wskonfirmasi--variable waktukonfirmasi update
	where waktukonfirmasi.idwaktu=@gen
	update waktubuatham set awal=GETDATE()--langsung update waktu awal pembuatan hampers 
	where waktubuatham.idwaktu=@gen
	update tanggal set tanggalProses=GETDATE()--langsung update tanggal proses pembuatan hampers 
	where Tanggal.idTransaksi=@idtransaksi
	update waktu set keterangan='Pembuatan Hampers'--update keterangan pada waktu
	where waktu.idwaktu=@gen
end

if @wsbuatham is not null--jika worker sudah selsai buat hampers
begin
	update waktubuatham set selesai=@wsbuatham --waktubuat ham diupdate 
	where waktubuatham.idwaktu=@gen
	update waktuisibar set awal=GETDATE() -- langsung update waktu isi barang 
	where waktuisibar.idwaktu=@gen
	update waktu set keterangan='Pengisian Barang'--keterangan update
	where waktu.idwaktu=@gen
end

if @wsisibar is not null --jika worker sudah selsai isi barang
begin
	update waktuisibar set selesai=@wsisibar --update waktu selsai isi barang
	where waktuisibar.idwaktu=@gen
	update waktumerapihkan set awal=GETDATE()--update awal mulai waktu merapihkan
	where waktumerapihkan.idwaktu=@gen
	update waktu set keterangan='Touch Up Hampers'--keterangan update
	where waktu.idwaktu=@gen
end

if @wsmerapihkan is not null -- jika worker sudah selsai 
begin
	update waktumerapihkan set selesai=@wsmerapihkan--update waktu selsai merapihkan
	where waktumerapihkan.idwaktu=@gen
	update StatusPesanan set statusDiproses='true'--status proses true
	where StatusPesanan.idTransaksi=@idtransaksi
	update waktu set keterangan='Menunggu Pengiriman'--keterangan update
	where waktu.idwaktu=@gen
end

if @cancel is not null
begin
	update tanggal set tanggalPembatalan=@cancel
	where Tanggal.idTransaksi=@idtransaksi
	update waktu set keterangan='Pembatalan Cancel'
	where waktu.idwaktu=@gen
end

return

exec spWaktu