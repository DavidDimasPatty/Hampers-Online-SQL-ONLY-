alter function efficiencyfunction 
(
	@konfirmasia datetime,
	@konfirmasis datetime,
	@buathama datetime,
    @buathams datetime,
    @isibara datetime,
    @isibars datetime,
	@rapiha datetime,
	@rapihs datetime
    
)
returns @tbl table(
selisihkonfirmasi int,
selisihbuatham int,
selisihbar int,
selisihrapih int,
rata int
)
as
begin
	insert into @tbl values (datediff(hour,@konfirmasia,@konfirmasis),datediff(hour,@buathama,@buathams),
	datediff(hour,@isibara,@isibars),datediff(hour,@rapiha,@rapihs),(datediff(hour,@konfirmasia,@konfirmasis)+datediff(hour,@buathama,@buathams)+
	datediff(hour,@isibara,@isibars)+datediff(hour,@rapiha,@rapihs))/4)
	return
end