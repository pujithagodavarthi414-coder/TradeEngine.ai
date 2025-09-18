-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save TestRailAudit
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save TestRailAudit
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestRailAudit]
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@AuditJson = 'New TestRun Added with Number of test cases'
--,@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestRailAudit]
(
	@AuditJson NVARCHAR(MAX) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
			
					DECLARE @Currentdate DATETIME  = GETDATE()
					
					DECLARE @TestRailAuditId UNIQUEIDENTIFIER = NEWID()

					     INSERT INTO [dbo].[TestRailAudit](
					                 [Id],
					                 [AuditJson],
									 [CompanyId],
					                 [CreatedDateTime],
					                 [CreatedByUserId])
					          SELECT @TestRailAuditId,
									 @AuditJson,
									 (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)),
					                 @Currentdate,
									 @OperationsPerformedBy
					
					SELECT Id FROM [dbo].[TestRailAudit] where Id = @TestRailAuditId
               

    END TRY
    BEGIN CATCH
        
        EXEC USP_GetErrorInformation

    END CATCH
END
GO