-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-13 00:00:00.000'
-- Purpose      To Save the Audit
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_InsertAudit]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@AuditJson='Test'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_InsertAudit]
(
    @AuditJson NVARCHAR(MAX) = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL,
	@IsOldAudit BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON  
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

		IF(@AuditJson = '') SET @AuditJson = NULL

		IF(@AuditJson IS NULL)
		BEGIN 
         RAISERROR(50011,16, 2, 'AduitJson')
		END
		ELSE
		BEGIN

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        DECLARE @AuditId UNIQUEIDENTIFIER = NEWID()

        INSERT INTO [dbo].[Audit](
                    [Id],
                    [AuditJson],
					[IsOldAudit],
                    [CreatedDateTime],
                    [CreatedByUserId],
					[FeatureId]
                   )
             SELECT @AuditId,
                    @AuditJson,
                    @IsOldAudit,
					GETDATE(),
                    @OperationsPerformedBy,
					@FeatureId
                           
        SELECT Id FROM [dbo].[Audit] WHERE Id = @AuditId
        
		END
	END
	END TRY
    BEGIN CATCH

             THROW

    END CATCH
END
GO