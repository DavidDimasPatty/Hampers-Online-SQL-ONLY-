alter procedure spPembayaran @idt varchar(50), @date date, @str varchar(50),@idp int
as
set nocount on--jika customer udah bayar

update DataPembayaran set DATAPEMBAYARAN.tanggalPembayaran=@date,datapembayaran.fotoBukti=@strwhere DataPembayaran.idTransaksi =cast( @idt as varchar)

declare @i int=1
declare @temp varchar(50)=''
while @i<=len(@idt)--while untuk membagi-bagi transaksi yang ada pada kolom idtransaksi
begin
if SUBSTRING(@idt,@i,1)= ','--jika ketemu , maka 
begin
	declare @tot int =cast(@temp as int)
	declare @gen int =0
	select top 1 @gen=waktu.idwaktu
	from transaksi inner join waktu on transaksi.idTransaksi=waktu.idtransaksi
	where transaksi.idTransaksi=@tot
	
	declare @temp1 varchar(500)=''--untuk temporary variable nantinya mendapatkan id barang
	declare @idbarang varchar(500) =''--variable untuk mendapatkan varchar id barang
	select @idbarang=transaksi.idbarang from transaksi where transaksi.idtransaksi=@tot --query untuk mendapatkan varchar id barang
	 declare @k int=1
		while @k<=len(@idbarang)
				begin
					 if SUBSTRING(@idbarang,@k,1)= ',' or SUBSTRING(@idbarang,@k,1)= ';' --jika ketemu , atau ;
						begin
							update UkuranItem set jumlahitem=jumlahitem-1 --update jumlah item menjadi dikurangi 1
							where idukuranitem=@temp1
						end


						else
						begin
							set @temp1=@temp1+SUBSTRING(@idbarang,@k,1)--selain itu variable temp ditambah dengan substring dari id barang
						end


					set @k=@k+1
				end


	update StatusPesanan set statusPembayaran='True' --update status pesanan berdasarkan idtransaksi yang sudah dibagi-bagi
	where idTransaksi=@tot

	insert into MengelolaStatusPesanan values( @idt,@idp) --insert pegawai yang mengurus transaksi

	update waktukonfirmasi set awal=GETDATE()--update waktu konfirmasi
	where idwaktu=@gen
	print @gen
	print @temp
	set @temp=''
end
else
begin
	set @temp=@temp+SUBSTRING(@idt,@i,1)--temp menambah char selanjutnya
end

set @i=@i+1
end


return 

exec spPembayaran
