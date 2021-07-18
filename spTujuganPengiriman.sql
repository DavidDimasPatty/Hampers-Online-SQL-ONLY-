alter procedure spTujuanPengiriman @idt int
as--sp untuk worker melihat lokasi pengiriman si paket
set nocount on

declare @tbl table( --table yang menyimpan hasil dari sp ini
alamat varchar(500),
kodepos varchar(50),
provinsi varchar(50),
kota varchar(50),
kecamatan varchar(50),
kel varchar(50)
)

declare @al varchar(50)--mendapatkan id dari alamat si penerima

select @al=penerima.alamat-- inisialisasi var al dari query ini 
from penerima inner join transaksi on transaksi.idtransaksi =
penerima.idtransaksi
where transaksi.idtransaksi=@idt

insert into @tbl --query untuk memasukan ke table tujuan dari query ini adalah untuk mendapatkan semua informasi lokasi penerima
select alamat.namajalan,alamat.kodepos,provinsi.namaprov,
kota1.namakota,kecamatan.namakec,kelurahan.namakel
from alamat inner join  provinsi on alamat.idprovinsi=provinsi.idprovinsi
inner join kota1 on alamat.idkota=kota1.idkota inner join
kecamatan on kecamatan.idkec=alamat.idkec inner join 
kelurahan on kelurahan.idkel=alamat.idkel
where alamat.idalamat = cast(@al as int)


select *
from @tbl
return 

exec spTujuanPengiriman

