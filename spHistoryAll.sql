alter procedure spHistoryAll @idc int
as--sp untuk menampilkan seluruh transaksi general yang pernah dilakukan oleh customer
set nocount on


select *
from transaksigeneral
where idCustomer=@idc --menampilkan seluruh row yang idcustomernya sesuai idc dan diurutkan dari yang terbaru
order by idTransaksi desc

return

exec spHistoryAll
