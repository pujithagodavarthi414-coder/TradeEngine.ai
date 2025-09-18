CREATE PROCEDURE [dbo].[USP_ArchivePayRoll]
(
@PayrollRunId UNIQUEIDENTIFIER,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@TimeStamp TIMESTAMP = NULL,
@IsArchived BIT = NULL
)
AS
BEGIN

DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
IF (@HavePermission = '1')
BEGIN
			         
DECLARE @IsLatest BIT = (CASE WHEN @PayRollRunId IS NULL 
			                                       THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                   FROM [PayRollRun] WHERE Id = @PayRollRunId  AND CompanyId = @CompanyId) = @TimeStamp
			         												THEN 1 ELSE 0 END END)

IF(@IsLatest = 1)
BEGIN
			         
     UPDATE PayRollRun
     SET [InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
     WHERE Id = @PayRollRunId

	 SELECT Id AS PayRollRunId FROM [dbo].[PayRollRun] WHERE Id = @PayRollRunId
END									                       
ELSE
BEGIN
			         
	RAISERROR (50008,11, 1)
END	
END			         
ELSE
BEGIN
			         
	RAISERROR (@HavePermission,11, 1)
			         		
END
END
