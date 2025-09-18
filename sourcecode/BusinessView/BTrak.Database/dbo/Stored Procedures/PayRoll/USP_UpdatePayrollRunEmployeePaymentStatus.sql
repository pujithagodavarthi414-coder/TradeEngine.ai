CREATE PROCEDURE [dbo].[USP_UpdatePayrollRunEmployeePaymentStatus]
(
@PayrollRunEmployeeIds NVARCHAR(max),
@IsProcessedToPay bit
) 
AS
BEGIN
DECLARE @Temptable table
(
Id int identity(1,1) primary key,
PayrollRunEmployeeId UNIQUEIDENTIFIER
)

declare @MaxId int = 0;
declare @Count int = 1;
declare @PayrollEmpId nvarchar(50);
declare @EmpUniqueId uniqueidentifier;
insert into @Temptable(PayrollRunEmployeeId) select * from UfnSplit(@PayrollRunEmployeeIds)

select @MaxId = MAX(Id) from @Temptable


while @MaxId >= @Count
BEGIN
BEGIN TRY
set @PayrollEmpId = (select top 1 PayrollRunEmployeeId from @Temptable where Id = @Count)
set @EmpUniqueId = @PayrollEmpId;
--set @EmpUniqueId = CONVERT(uniqueidentifier,STUFF(STUFF(STUFF(STUFF(@EmpId,9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))
UPDATE PayrollRunEmployee SET IsProcessedToPay = @IsProcessedToPay where Id = @EmpUniqueId

set @Count = @Count +  1
END TRY
 BEGIN CATCH
     THROW
 END CATCH
END
END


