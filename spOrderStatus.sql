alter procedure spOrderStatus @idstatus int, @statdit varchar(50),@statdip varchar(50)
, @stattib varchar (50), @statpem varchar (50) 
as --sp yang digunakan untuk update status pesanan dan ditampilkan ke customer
set nocount on

if(@statdit is null)--jika status diterima null
begin
	select top 1 StatusPesanan.statusDiterima from StatusPesanan where StatusPesanan.idStatus=@idstatus
end
if(@statdip is null)--jika status diproses null
begin
	select top 1 StatusPesanan.statusDiproses from StatusPesanan where StatusPesanan.idStatus=@idstatus
end
if(@stattib is null)--jika status tiba tidak null
begin
	select top 1 StatusPesanan.statusTiba from StatusPesanan where StatusPesanan.idStatus=@idstatus
end
if(@statpem is null)--jika status diproses null
begin
	select top 1 StatusPesanan.statusPembayaran from StatusPesanan where StatusPesanan.idStatus=@idstatus
end

update StatusPesanan 
set statusDiterima=@statdit, statusDiproses=@statdip, statusTiba=@stattib, statusPembayaran=@statpem
where StatusPesanan.idStatus=@idstatus

return
exec spOrderStatus