alter procedure spSignUpCustomer @username varchar(50),@pass varchar(50), @email varchar(50),
@nama varchar(50),@nohp varchar(50),@tanggallahir date,@alamat varchar(50),
@kodepos varchar (50),
@kelurahan varchar(50),
@kecamatan varchar(50),
@kota varchar (50),
@provinsi varchar(50)

as
set nocount on

--insert berdasarkan masukan dari user 
insert into alamat values (@alamat,@kodepos,@kelurahan,@kecamatan,@kota,@provinsi)
declare @al int --variable al untuk memasukan alamat di customer
select top 1 @al=alamat.idalamat
from alamat
order by idalamat desc

insert into Customer values (@username,@pass,@email,@nama,@nohp,@tanggallahir,@al)

return
exec spSignUpCustomer
