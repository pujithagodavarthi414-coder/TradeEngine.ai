CREATE PROCEDURE [dbo].[USP_UpsertEmployeeBonus]
(
@Id UNIQUEIDENTIFIER NULL,
@EmployeeIds NVARCHAR(max),
@Bonus DECIMAL(10,4),
@UserId UNIQUEIDENTIFIER,
@PayrollRunEmployeeId UNIQUEIDENTIFIER NULL,
@IsArchived bit,
@IsApproved bit,
@IsCtcType BIT,
@PayRollComponentId UNIQUEIDENTIFIER = NULL,
@Percentage DECIMAL(18,4) = NULL,
@GeneratedDate DATETIME = NULL
) 
AS
BEGIN
DECLARE @Temptable table
(
Id int identity(1,1) primary key,
EmployeeId UNIQUEIDENTIFIER
)

declare @MaxId int = 0;
declare @Count int = 1;
declare @EmpId nvarchar(50);
declare @EmpUniqueId uniqueidentifier;
insert into @Temptable(EmployeeId) select * from UfnSplit(@EmployeeIds)

select @MaxId = MAX(Id) from @Temptable


while @MaxId >= @Count
BEGIN
BEGIN TRY
set @EmpId = (select top 1 EmployeeId from @Temptable where Id = @Count)

set @EmpUniqueId = @EmpId

IF(@Id IS NULL)
BEGIN
INSERT INTO EmployeeBonus(Id, EmployeeId,  Bonus, GeneratedDate ,CreatedDateTime, CreatedByUserId, PayRollComponentId,IsCtcType,[Percentage],[IsApproved],[IsArchived]) 
VALUES(NEWID(), @EmpUniqueId, @Bonus, @GeneratedDate, GETDATE(), @UserId,@PayRollComponentId,@IsCtcType,@Percentage,1,0)
END
ELSE
BEGIN
UPDATE EmployeeBonus set EmployeeId = @EmpUniqueId, Bonus = @Bonus,  GeneratedDate = @GeneratedDate, IsArchived = @IsArchived, UpdatedDateTime = GETDATE(), UpdatedByUserId = @UserId,
PayRollComponentId = @PayRollComponentId, IsCtcType = @IsCtcType,[Percentage] = @Percentage where Id = @Id
END
set @Count = @Count +  1
END TRY
 BEGIN CATCH
     THROW
 END CATCH
END
END