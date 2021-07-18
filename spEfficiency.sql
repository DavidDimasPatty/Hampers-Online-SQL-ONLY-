alter procedure spEfficiency @idtrans int
as
set nocount on

declare @tbl table(--table untuk melihat efisiensi akhir jika @idtrans sudah diketahui
idtrans int,
konfirmasia datetime,
konfirmasis datetime,
buathama datetime,
buathams datetime,
isibara datetime,
isibars datetime,
rapiha datetime,
rapihs datetime

)

declare @hasil table(--table untuk menyimpan effisiensi hasil
idtrans int,
selisihkonfirmasi int,
selisihbuatham int,
selisihbar int,
selisihrapih int,
rata int
)

if @idtrans is null --inisiasi jika @idtrans null
begin
	set @idtrans=-1
end

if(@idtrans=-1)--jika @idtrans null
	begin	
		declare effisien cursor--melakukan cursor pada setiap baris sesuai query
		for
		select transaksi.idTransaksi,waktukonfirmasi.awal,waktukonfirmasi.selesai,waktubuatham.awal,waktubuatham.selesai,
			waktuisibar.awal,waktuisibar.selesai,waktumerapihkan.awal,waktumerapihkan.selesai
		from transaksi inner join waktu on waktu.idtransaksi=transaksi.idTransaksi inner join
			waktukonfirmasi on waktukonfirmasi.idwaktu=waktu.idwaktu inner join waktubuatham on waktubuatham.idwaktu=waktu.idwaktu
			inner join waktuisibar on waktuisibar.idwaktu=waktu.idwaktu inner join waktumerapihkan on 
			waktumerapihkan.idwaktu=waktu.idwaktu --untuk melihat setiap waktu pada setiap transaksi
		order by idtransaksi
		open effisien
			declare	@idtrans1 int=0
			declare	@konfirmasia datetime --variable untuk menyimpan date time konfirmasi awal pada setiap iterasi
			declare	@konfirmasis datetime --variable untuk menyimpan date time konfirmasi akhir pada setiap iterasi
			declare	@buathama datetime --variable untuk menyimpan date time pembuatan hampers awal pada setiap iterasi
			declare	@buathams datetime --variable untuk menyimpan date time pembuatan hampers akhir pada setiap iterasi
			declare	@isibara datetime --variable untuk menyimpan date time isi barang di hampers awal pada setiap iterasi
			declare	@isibars datetime --variable untuk menyimpan date time isi barang di hampers akhir pada setiap iterasi
			declare	@rapiha datetime --variable untuk menyimpan date time merapihkan hampers awal pada setiap iterasi
			declare	@rapihs datetime --variable untuk menyimpan date time merapihkan hampers akhir pada setiap iterasi
			

		fetch next from effisien into @idtrans1,@konfirmasia,@konfirmasis, --mengambil data selanjutnya dan dimasuki variable yang sudah diinisiasi
@buathama ,@buathams ,@isibara,@isibars,@rapiha,@rapihs

		
		print @@fetch_status
		while @@FETCH_STATUS=0
		begin
			
			insert into @hasil 
			select @idtrans1,* from dbo.efficiencyfunction(@konfirmasia,@konfirmasis, --manggil fungsi effisiensi lalu insert ke hasil
					@buathama,@buathams,@isibara,@isibars,
					@rapiha,@rapihs)
				
			fetch next from effisien into @idtrans1,@konfirmasia,@konfirmasis,
@buathama ,@buathams ,@isibara,@isibars,@rapiha,@rapihs			
		end

		close effisien
		deallocate effisien
	end
else -- jika ada idt
	begin
	insert into @tbl
	select top 1 transaksi.idTransaksi,waktukonfirmasi.awal,waktukonfirmasi.selesai,waktubuatham.awal,waktubuatham.selesai,
			waktuisibar.awal,waktuisibar.selesai,waktumerapihkan.awal,waktumerapihkan.selesai
		from transaksi inner join waktu on waktu.idtransaksi=transaksi.idTransaksi inner join
			waktukonfirmasi on waktukonfirmasi.idwaktu=waktu.idwaktu inner join waktubuatham on waktubuatham.idwaktu=waktu.idwaktu
			inner join waktuisibar on waktuisibar.idwaktu=waktu.idwaktu inner join waktumerapihkan on 
			waktumerapihkan.idwaktu=waktu.idwaktu
	where transaksi.idTransaksi=@idtrans

			declare	@konfirmasia2 datetime --penjelasan masing masing variable sama seperti jika @idt tidak ada
			declare	@konfirmasis2 datetime
			declare	@buathama2 datetime
			declare	@buathams2 datetime
			declare	@isibara2 datetime
			declare	@isibars2 datetime
			declare	@rapiha2 datetime
			declare	@rapihs2 datetime
		select @konfirmasia2=tbl.konfirmasia from @tbl as tbl --masing masing variable dimasuki column tbl
		select @konfirmasis2=tbl.konfirmasis from @tbl as tbl
		select @buathama2=tbl.buathama from @tbl as tbl
		select @buathams2=tbl.buathams from @tbl as tbl
		select @isibara2=tbl.isibara from @tbl as tbl
		select @isibars2=tbl.isibars from @tbl as tbl
		select @rapiha2=tbl.rapiha from @tbl as tbl
		select @rapihs2=tbl.rapihs from @tbl as tbl
		
		insert into @hasil 
			select @idtrans,* from dbo.efficiencyfunction(@konfirmasia2,@konfirmasis2,
					@buathama2,@buathams2,@isibara2,@isibars2,
					@rapiha2,@rapihs2)
		end
		
		select * --menampilkan semua isi dari table hasil
		from @hasil
	
	return 
	exec spEfficiency
