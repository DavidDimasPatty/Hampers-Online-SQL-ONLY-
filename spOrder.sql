alter procedure spOrder  
@idc int, --idcustomer
@banyak int,
@jh int, --jumlah hampers
@idukuranhampers varchar(100),
@idbarang varchar(100),
@tanggal varchar(50),
@namap varchar(50),
@alamat varchar (50),
@nohp varchar(50),
@kodepos varchar (50),
@kelurahan varchar(50),
@kecamatan varchar(50),
@kota varchar (50),
@provinsi varchar(50)
as
set nocount on
--KEBIJAKAN INPUT:
--2
--1,2|3|
--1,3,4,5,6;1,3,2,4|2,2,1|
--david|fai|
--02-07-2021|02-07-2021|
--jl.bandung|jl.bogor|
--0943|32423|
--DST

declare @tbl table(
idpaket varchar(50),
jumpers int,
penerima varchar(50),
namabarang varchar(50),
hargatotal int
)

declare @pen table(
idt int,
idc int,
nama varchar(50),
alamat varchar(50),
nohp varchar (50)
)

declare @totalharga int=0
declare @i int =1--Semua variable huruf dari i sampai z adalah variable untuk iterasi
declare @j int =1
declare @k int=1
declare @a int=1
declare @b int=1
declare @c int=1
declare @d int=1
declare @e int=1
declare @f int=1
declare @g int=1
declare @h int=1
declare @z int=1
declare @hargatotal2 int=0--variable untuk mencatat harga per transaksi general 
declare @hargatotal int =0--variable untuk mencatat harga per transaksi
declare @buatidsimpen varchar(50)=''--mencatat idtransaksi untuk disimpan di transaksi

	while @i<=@banyak
	begin
		
				declare @nambar varchar(500)=''--variable mencatat namabarang setiap iterasi
				declare @jum int=0--variable mencatat jumlah setiap iterasi
				declare @hargasatuan int=0--variable untuk mencatat harga satuan per transaksi
				declare @temp varchar(500)=''--mencatat id hampers
				declare @ukuran varchar(500)=''--mencatat idukuran hampers
				declare @temp1 varchar(500)='' --mencatat nama item pada masing masing hampers
				declare @temp2 varchar(500)=''--mencatat tanggal pada setiap transaksi
				declare @temp3 varchar(500)=''--mencatat nama penerima 
				declare @temp4 varchar(500)='' --mencatat nama jalan pada alamat
				declare @temp5 varchar(500)='' --mencatat no hp
				declare @temp6 varchar(500)='' --mencatat kodepos
				declare @temp7 varchar(500)='' --mencatat kota
				declare @temp8 varchar(500)='' --mencatat kelurahan
				declare @temp9 varchar(500)='' --mencatat kecamatan
				declare @temp10 varchar(500)='' --mencatat provinsi
		
		
			--inti dari algoritma ini adalah substring menggunakan input oleh user
			--dan nantinya akan dimasukan kedalam table transaksi,transaksigeneral,alamat,dan penerima 
				while @j<=len(@idukuranhampers)--mencatat idukuranhampers berdasarkan panjang input @idukuranhampers
				begin
			
						if SUBSTRING(@idukuranhampers,@j,1)= '|'-- jika ketemu | maka berhenti
						begin
								set @jum=@jum+1
								set @j=@j+1
								break
						end

						else if SUBSTRING(@idukuranhampers,@j,1)= ',' --jika ketemu , maka dimasukan ke dalam variable dan nanti variable tersebut 
						begin										 --akan di insert ke table yang berkaitan dalam kasus ini table transaksi
							declare @con int =cast(@ukuran as int)
							declare @simpen int=0
					
							select top 1 @simpen=UkuranHampers.harga
							from UkuranHampers
							where idukuran=@ukuran
							set @jum=@jum+1;
							set @hargasatuan=@hargasatuan+@simpen
							set @hargatotal=@hargatotal+@simpen
							set @temp=@temp+','
							set @ukuran=''
						end

						else
						begin
							set @temp=@temp+SUBSTRING(@idukuranhampers,@j,1)--temp akan ditambahkan  setiap memasuki kondisi tersebut
							set @ukuran=@ukuran+SUBSTRING(@idukuranhampers,@j,1)
						end

					set @j=@j+1
				end

				--iterasi diulangi terus menerus sampai i<=banyak dengan cara yang sama untuk mengambil data
				--dan dimasukan ke table
				while @k<=len(@idbarang)
				begin
					if SUBSTRING(@idbarang,@k,1)= '|'
						begin
							if @temp1 is not null
							begin 
									declare @simpenn1 int=0
									select top 1 @simpenn1=Historibarang.hargaitem
									from historibarang
									where idbarang=@temp1
									order by historibarang.tanggal desc
									set @hargasatuan=@hargasatuan+@simpenn1
									set @hargatotal=@hargatotal+@simpen
									set @nambar=@nambar+@temp1
									set @temp1=''
							end
							set @k=@k+1
							break
						end

						else if SUBSTRING(@idbarang,@k,1)= ',' or SUBSTRING(@idbarang,@k,1)= ';'
						begin
							declare @con1 int =cast(@temp1 as int)
							declare @simpen1 int=0
					
							select top 1 @simpen1=Historibarang.hargaitem
							from historibarang
							where idbarang=@temp1
							order by historibarang.tanggal desc
					
							set @hargasatuan=@hargasatuan+@simpen1
							set @hargatotal=@hargatotal+@simpen
							set @nambar=@nambar+@temp1
							set @temp1=''
					
						end


						else
						begin
							set @temp1=@temp1+SUBSTRING(@idbarang,@k,1)
						end


					set @k=@k+1
				end

				while @a<=len(@tanggal)
				begin
					if SUBSTRING(@tanggal,@a,1)= '|'
						begin
				
							set @a=@a+1
							break
						end

						else
						begin
							set @temp2=@temp2+SUBSTRING(@tanggal,@a,1)
						end


					set @a=@a+1
				end

				while @b<=len(@namap)
				begin
					if SUBSTRING(@namap,@b,1)= '|'
									begin
							
							set @b=@b+1
									break
									end

					else
						begin
						set @temp3=@temp3+SUBSTRING(@namap,@b,1)
					end
					set @b=@b+1
				end

				while @c<=len(@alamat)
				begin

		
					if SUBSTRING(@alamat,@c,1)= '|'
									begin
							
							set @c=@c+1
										break
									end

					else
						begin
						set @temp4=@temp4+SUBSTRING(@alamat,@c,1)
					end
					set @c=@c+1
				end


				while @d<=len(@nohp)
				begin
		
					if SUBSTRING(@nohp,@d,1)= '|'
									begin
							
							set @d=@d+1
										break
									end

					else
					begin
						set @temp5=@temp5+SUBSTRING(@nohp,@d,1)
				
					end
					set @d=@d+1
				end

						while @e<=len(@kodepos)
				begin
		
					if SUBSTRING(@kodepos,@e,1)= '|'
									begin
							
							set @e=@e+1
										break
									end

					else
					begin
						set @temp6=@temp6+SUBSTRING(@kodepos,@e,1)
				
					end
					set @e=@e+1
				end
						while @f<=len(@kota)
				begin
		
					if SUBSTRING(@kota,@f,1)= '|'
									begin
							
							set @f=@f+1
										break
									end

					else
					begin
						set @temp7=@temp7+SUBSTRING(@kota,@f,1)
				
					end
					set @f=@f+1
				end
						while @g<=len(@kelurahan)
				begin
		
					if SUBSTRING(@kelurahan,@g,1)= '|'
									begin
							
							set @g=@g+1
										break
									end

					else
					begin
						set @temp8=@temp8+SUBSTRING(@kelurahan,@g,1)
				
					end
					set @g=@g+1
				end

						while @h<=len(@kecamatan)
				begin
		
					if SUBSTRING(@kecamatan,@h,1)= '|'
									begin
							
							set @h=@h+1
										break
									end

					else
					begin
						set @temp9=@temp9+SUBSTRING(@kecamatan,@h,1)
				
					end
					set @h=@h+1
				end

				while @z<=len(@provinsi)
				begin
					print @z
					if SUBSTRING(@provinsi,@z,1)= '|'
									begin			
							set @z=@z+1
										break
									end

					else
					begin	
						set @temp10=@temp10+SUBSTRING(@provinsi,@z,1)
				
						end
					set @z=@z+1
				end


				---section untuk insert data-data ke table
				insert into @tbl values(@temp,@jum,@temp3,@nambar,@hargasatuan)
				insert into @pen values(1,@idc,@temp3,@temp4,@temp5)
				insert into  transaksi values (@idc,@jum,@temp,@nambar,@temp2,@hargasatuan)
				insert into alamat values(@temp6,@temp4,@temp8,@temp9,@temp7,@temp10) 
				set @hargatotal2=@hargasatuan+@hargatotal2
				declare @buatid int =0
	
	
				select top 1 @buatid=transaksi.idTransaksi --query untuk mencari id transaksi dan dimasukan ke variable buatid
				from transaksi
				order by transaksi.idTransaksi desc
		
				set @buatidsimpen=@buatidsimpen+''+cast (@buatid as varchar)+','

				declare @al varchar(50)--query untuk mencari id alamat untuk dimasukan ke dalam variable al
				select top 1 @al=alamat.idalamat
				from alamat
				order by idalamat desc
		
				--variable al dimasukan ke dalam penerima 
				insert into Penerima values(@buatid,@idc,@temp3,@al,@temp5)
				insert into waktu values (@buatid,'Orderan Masuk')
		
				declare @wakt int=0
				select top 1 @wakt=waktu.idwaktu 
				from waktu
				order by idwaktu desc

				--section penginputan waktu
				insert into waktukonfirmasi values (@wakt,GETDATE(),null)
				insert into tanggal values (@buatid,null,null,null,null,null)
				insert into statuspesanan values (@buatid,null,null,null,null)
				set @i=@i+1
		
	end
	insert into datapembayaran values(@idc,@buatidsimpen,@hargatotal,null,null)
	insert into transaksigeneral values (@idc,@jh,@idukuranhampers,@idbarang,@tanggal,@hargatotal2)
	

select *
from @tbl

select *
from @pen

return
	
exec spOrder














