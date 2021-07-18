alter procedure spLoginCustomer @id varchar(50), @pw varchar(50)
as 
set nocount on

declare @stat int --untuk return hasil jika ada user dengan username dan password //optional

select @stat=count(Customer.username)
from Customer
where Customer.username = @id and Customer.Pass = @pw--mencari customer dengan username dan password seperti input


return @stat--return status

exec spLoginCustomer