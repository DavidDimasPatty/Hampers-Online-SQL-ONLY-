alter procedure spAllHampers @inp varchar(50),@katpa varchar(50),@harga1 int, @harga2 int
as 
set nocount on
declare @tbl table(--table hasil yang nantinya dihasilkan
namahamp varchar(50),
ukuran varchar(50),
namakategori varchar(50),
tanggalbuka date,
tanggaltutup date,
harga int
)


if @harga1 is null --set jika harga bawah tidak diinisiasi oleh user
begin
	set @harga1=0
end

if @harga2 is null --set jika harga atas tidak diinisiasi oleh user
begin
	set @harga2=999999999
end


if(@katpa is null and @inp is null)--jika user tidak menginput kategori dan searching nama hampers
	begin
		insert into @tbl --insert ke table semua hampers 
		select hampers.namahampers,ukuranhampers.jenisukuran,Hampers.kategori,Hampers.tanggalBukaHampers,Hampers.tanggalTutupHampers,ukuranhampers.harga
		from hampers inner join UkuranHampers on hampers.idHampers=UkuranHampers.idHampers  
		where ukuranhampers.harga between  @harga1 and @harga2 and hampers.tanggalbukahampers>=getdate() and hampers.tanggaltutuphampers<=getdate()--mendapatkan semua hampers diantara range harga 
	end

if(@katpa is not null and @inp is null) --jika user tidak menginput nama hampers
	begin
		declare @i int=1;--variable untuk melakukan iterasi
		declare @temp varchar(50)=''
		while @i<=len(@katpa)--dicheck setiap string
		begin
			if SUBSTRING(@katpa,@i,1)= ',' --jika di string ada ,
			begin
					insert into @tbl --insert ke table berdasarkan @temp yang sudah mengconcat huruf
					select hampers.namahampers,ukuranhampers.jenisukuran,Hampers.kategori,Hampers.tanggalBukaHampers,Hampers.tanggalTutupHampers,ukuranhampers.harga
					from hampers inner join UkuranHampers on hampers.idHampers=UkuranHampers.idHampers 
					where hampers.kategori like '%'+@temp+'%' and ukuranhampers.harga between @harga1 and @harga2 and hampers.tanggalbukahampers>=getdate() and hampers.tanggaltutuphampers<=getdate()
					print @temp
				set @temp=''--temp dikosongkan
				set @i=@i+1
			end
			else
			begin
				set @temp=@temp+SUBSTRING(@katpa,@i,1)--variable temp menambahkan tiap string
				set @i=@i+1
			end
		end

	end

if(@katpa is null and @inp is not null)--jika namanya tidak kosong 
	begin
	
		insert into @tbl --memasukan ke table berdasarkan query dibawah
		select hampers.namahampers,ukuranhampers.jenisukuran,Hampers.kategori,Hampers.tanggalBukaHampers,Hampers.tanggalTutupHampers,ukuranhampers.harga
		from hampers inner join UkuranHampers on hampers.idHampers=UkuranHampers.idHampers 
		where hampers.namahampers like '%'+@inp+'%' and ukuranhampers.harga between @harga1 and @harga2 and hampers.tanggalbukahampers>=getdate() and hampers.tanggaltutuphampers<=getdate() --mendapatkan semua hampers yang namanya seperti input dan sesuai dengan rentang harga
	end

 if(@katpa is not null and @inp is not null)--jika inp user tidak ada yang kosong
declare @i1 int=1;
		declare @temp1 varchar(50)=''
		while @i1<=len(@katpa) --melakukan iterasi seperti jika kategori tidak null sebelumnnya
		begin
			if SUBSTRING(@katpa,@i1,1)= ','
			begin
					insert into @tbl --dimasukan ke table berdasarkan query
					select hampers.namahampers,ukuranhampers.jenisukuran,Hampers.kategori,Hampers.tanggalBukaHampers,Hampers.tanggalTutupHampers,ukuranhampers.harga
					from hampers inner join UkuranHampers on hampers.idHampers=UkuranHampers.idHampers 
					where hampers.namahampers like '%'+@inp+'%'and hampers.kategori like '%'+@temp+'%' and ukuranhampers.harga between @harga1 and @harga2 and hampers.tanggalbukahampers>=getdate() and hampers.tanggaltutuphampers<=getdate()
				set @temp1=''--kosongkan temp
				set @i1=@i1+1
			end
			else
			begin
				set @temp1=@temp1+SUBSTRING(@katpa,@i1,1)--menambahkan tiap huruf
				set @i1=@i1+1
			end
		end




select *
from @tbl
return
exec spAllHampers
