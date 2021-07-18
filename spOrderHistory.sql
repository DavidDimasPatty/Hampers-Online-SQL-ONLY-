alter PROCEDURE spOrderHistory @inpnamapak varchar(500),@ukuran varchar(50) ,@idc int,@pengiriman1 date,@pengiriman2 date
as
set nocount on
declare @tbl table(--table yang merupakan hasil dari sp ini
idTransaksi int,
jumlahhampers int,
idHampers varchar(50),
idbarang varchar(50),
tanggalterima date,
HargaTotal int,
nama varchar(50),
keterangan varchar(50),
TanggalPemesanan datetime
)

declare @pac table (
ukur int
) 


if(@pengiriman1 is null)--jika tanggal pengiriman 1 null
begin
	set @pengiriman1=cast('1980-10-10' as date)--set tanggal bawah
end
if(@pengiriman2 is null)--jika tanggal pengiriman 2 null
begin
	set @pengiriman2=cast('2099-10-10' as date)--set tanggal atas
end

 if @ukuran is null and @inpnamapak is null --jika ukuran null dan namapaket null
begin
			insert into @tbl --dimasukan ke table query ini intinya mencari semua transaksi yang pernah customer lakukan
			select transaksi.idTransaksi,transaksi.jumlahhampers,transaksi.idHampers,transaksi.idbarang,transaksi.tanggalterima,transaksi.HargaTotal,penerima.nama,waktu.keterangan,waktukonfirmasi.awal
			from transaksi inner join Penerima on transaksi.idTransaksi=Penerima.idtransaksi inner join waktu on waktu.idtransaksi=transaksi.idTransaksi inner join waktukonfirmasi on waktu.idwaktu=waktukonfirmasi.idwaktu
			where  transaksi.idCustomer=@idc and transaksi.tanggalterima between @pengiriman1 and @pengiriman2 
end


else if(@inpnamapak is null)--jika nama paket null
begin
declare history1 cursor --declare cursor untuk melihat semua baris yang ukuran hampersnya seperti ukuran
		for
		select UkuranHampers.idukuran
		from UkuranHampers
		where UkuranHampers.jenisUkuran like '%'+@ukuran+'%'
		open history1
		declare @ukure int =0-- variable untuk dimasukan hasil dari kolom cursor
		fetch next from history1 into @ukure
		
		while @@FETCH_STATUS=0
		begin
			declare @lik1 varchar(50)=cast(@ukure as varchar)+','--menggabungkan varchar agar tidak ambigu like nya
			insert into @tbl 
			select transaksi.idTransaksi,transaksi.jumlahhampers,transaksi.idHampers,transaksi.idbarang,transaksi.tanggalterima,transaksi.HargaTotal,penerima.nama,waktu.keterangan,waktukonfirmasi.awal
			from transaksi inner join Penerima on transaksi.idTransaksi=Penerima.idtransaksi inner join waktu on waktu.idtransaksi=transaksi.idTransaksi inner join waktukonfirmasi on waktu.idwaktu=waktukonfirmasi.idwaktu
			where transaksi.idHampers like '%'+@lik1+'%' and transaksi.idCustomer=@idc and transaksi.tanggalterima between @pengiriman1 and @pengiriman2 
			
			fetch next from history1 into @ukure			
		end

		close history1
		deallocate history1



end
else if(@ukuran is null)--jika ukurannya null 
begin
		declare @ukure1 int =0

declare history1 cursor --memakai cursor 
		for
	select dbo.hampers.idHampers
	from dbo.Hampers 
	where hampers.namahampers like '%'+@inpnamapak+'%'--mencari semua nama hampers yang seperti input  
		open history1
		fetch next from history1 into @ukure1
		while @@FETCH_STATUS=0
		begin
			declare @lik varchar(50)=cast(@ukure1 as varchar)+','--menggabungkan varchar agar tidak ambigu like nya
			insert into @tbl 
			select transaksi.idTransaksi,transaksi.jumlahhampers,transaksi.idHampers,transaksi.idbarang,transaksi.tanggalterima,transaksi.HargaTotal,penerima.nama,waktu.keterangan,waktukonfirmasi.awal
			from transaksi inner join Penerima on transaksi.idTransaksi=Penerima.idtransaksi inner join waktu on waktu.idtransaksi=transaksi.idTransaksi inner join waktukonfirmasi on waktu.idwaktu=waktukonfirmasi.idwaktu
			where transaksi.idHampers like  '%'+@lik+'%' and transaksi.idCustomer=@idc and transaksi.tanggalterima between @pengiriman1 and @pengiriman2 
			
			fetch next from history1 into @ukure1			
		end

		close history1
		deallocate history1



end


else if (@ukuran is not null and @inpnamapak is not null)--jika inputannya tidak ada null
begin
declare history1 cursor--memanggil cursor
		for 
	select UkuranHampers.idukuran--query cursor
	from Hampers inner join UkuranHampers on Hampers.idHampers=UkuranHampers.idHampers
	where hampers.namahampers like '%'+@inpnamapak+'%' and UkuranHampers.jenisUkuran like '%'+@ukuran+'%'
		open history1
		declare @ukure2 int =0 --variable yang nantinya diisi setiap iterasi cursor
		fetch next from history1 into @ukure2
		print @@FETCH_STATUS
		while @@FETCH_STATUS=0
		begin
			declare @lik2 varchar(50)=cast(@ukure2 as varchar)+','
			insert into @tbl 
			select transaksi.idTransaksi,transaksi.jumlahhampers,transaksi.idHampers,transaksi.idbarang,transaksi.tanggalterima,transaksi.HargaTotal,penerima.nama,waktu.keterangan,waktukonfirmasi.awal
			from transaksi inner join Penerima on transaksi.idTransaksi=Penerima.idtransaksi inner join waktu on waktu.idtransaksi=transaksi.idTransaksi inner join waktukonfirmasi on waktu.idwaktu=waktukonfirmasi.idwaktu
			where transaksi.idHampers like '%'+@lik2+'%' and transaksi.idCustomer=@idc and transaksi.tanggalterima between @pengiriman1 and @pengiriman2 
			
			fetch next from history1 into @ukure2			
		end

		close history1
		deallocate history1


end

	
	select *
	from @tbl 

	

	return

exec spOrderHistory
