-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-09 00:00:00.000'
-- Purpose      To Delete CompanyModule
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--DECLARE @Temp TIMESTAMP = (SELECT TimeStamp FROM UserStory WHERE Id = '71F7294B-E9AC-4FEB-A193-D6B761AEF399')
--EXEC [dbo].[USP_DeleteCompanyModule] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@CompanyModuleId='71F7294B-E9AC-4FEB-A193-D6B761AEF399'
--,@TimeStamp = @Temp

CREATE PROCEDURE [dbo].[USP_DeleteCompanyModule]
(
    @CompanyModuleId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    DECLARE @ProcName NVARCHAR(250) = (SELECT OBJECT_NAME(@@PROCID))
        
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,@ProcName))
			        
		IF (@HavePermission = '1')
		BEGIN

			DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
												FROM [CompanyModule] WHERE Id = @CompanyModuleId) = @TimeStamp
										  THEN 1 ELSE 0 END)
        
			IF(@IsLatest = 1)
			BEGIN

				DECLARE @CurrentDate DATETIME = GETDATE()

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				    UPDATE [CompanyModule]
				     SET   InActiveDateTime = @CurrentDate,
					       UpdatedDateTime  = @CurrentDate,
						   UpdatedByUserId  = @OperationsPerformedBy
						 WHERE Id = @CompanyModuleId AND CompanyId = @CompanyId
				 
				SELECT Id FROM [dbo].[CompanyModule] WHERE Id = @CompanyModuleId

			END
			ELSE
				RAISERROR (50015,11, 1)

		END
		ELSE
			RAISERROR (@HavePermission,11, 1)

    END TRY
    BEGIN CATCH

        EXEC USP_GetErrorInformation

    END CATCH
END
GO
