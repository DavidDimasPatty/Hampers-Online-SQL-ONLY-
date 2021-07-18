alter procedure spHampersEdit @idh int, @tgl1 date,@tgl2 date,
@ket varchar(500), @nama varchar(50),@kategori varchar(50),
@ukur int, @isi int,@harga int

as
set nocount on

update Hampers set hampers.namahampers=@nama,tanggalbukahampers=@tgl1 --update berdasarkan input user terhadap table hampers
,tanggaltutuphampers=@tgl2,kategori=@kategori--kategori jika lebih dari 2 diisi dengan , (contoh valentine,wisuda)
where idhampers=@idh

update UkuranHampers set jumlahisi=@isi,
harga=@harga
where idhampers=@idh and jenisukuran=@ukur --update berdasarkan input user terhadap table ukuran hampers

return
exec spHampersEdit