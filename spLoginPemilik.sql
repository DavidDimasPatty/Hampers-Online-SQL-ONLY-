alter procedure spLoginpemilik @id varchar(50), @pw varchar(50)
as 
set nocount on

declare @stat int

select @stat=count(Pemilik.username)--check status jika ada username dan password seperti input
from Pemilik
where Pemilik.username = @id and Pemilik.Pass = @pw--check akun pemilik apakah ada atau tidak


return @stat --return status dari query tersebut

exec spLoginpemilik