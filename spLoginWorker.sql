alter procedure spLoginWorker @id varchar(50), @pw varchar(50)
as 
set nocount on

declare @stat int --variable status untuk di isi di query dan di return

select @stat=count(pegawai.username)--check status apakah ada atau tidak 
from Pegawai
where pegawai.username = @id and pegawai.Pass = @pw--check apakah akun dari input id dan pw user ada atau tidak


return @stat --return status

exec spLoginWorker