CREATE PROCEDURE [dbo].[UpsertLeaveHistory]
(
	@OldValue NVARCHAR(MAX),
	@NewValue NVARCHAR(MAX),
	@LeaveApplicationId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@Description NVARCHAR(60)
)
AS
BEGIN

 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
 IF (@HavePermission = '1')
 BEGIN

	INSERT INTO LeaveApplicationStatusSetHistory(
												 Id,
												 OldValue,
												 NewValue,
												 LeaveStatusId,
												 [Description],
												 CreatedByUserId,
												 CreatedDateTime,
												 LeaveApplicationId
												)
										 SELECT NEWID(),
												@OldValue,
												@NewValue,
												(SELECT Id FROM LeaveStatus WHERE CompanyId = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) AND IsWaitingForApproval = 1),
												@Description,
												@OperationsPerformedBy,
												GETDATE(),
												@LeaveApplicationId
 END
END