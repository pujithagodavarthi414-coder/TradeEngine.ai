-------------------------------------------------------------------------------
-- Author       RanadheerRanaVelaga
-- Created      '2019-07-08 00:00:00.000'
-- Purpose      To Save or Update Project Tag
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertProjectTag]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProjectId = '53C96173-0651-48BD-88A9-7FC79E836CCE',@Tags = 'user,Tier'
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertProjectTag
(
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @Tags NVARCHAR(250) = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	
	SET NOCOUNT ON 
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

			IF (@Tags = '') SET @Tags = NULL

			IF (@ProjectId IS NULL)
			BEGIN

				RAISERROR(50011,11,1,'Goal')

			END
			ELSE
			BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				DECLARE @IsLatest INT = (CASE WHEN (SELECT [TimeStamp] FROM Project WHERE Id = @ProjectId) = @TimeStamp THEN 1 ELSE 0 END)

				IF(@IsLatest = 1)
				BEGIN
				
					DECLARE @CurrentDate DATETIME = GETDATE()

					 UPDATE [Project]
					   SET CompanyId = @CompanyId,
						   InActiveDateTime = CASE WHEN [InActiveDateTime] IS NULL THEN NULL ELSE @CurrentDate END,
						   Tag = @Tags,
						   UpdatedDateTime = @CurrentDate,
						   UpdatedByUserId = @OperationsPerformedBy
						   WHERE Id = @ProjectId

					SELECT Id FROM Project WHERE Id = @ProjectId
				END
				ELSE
					
					RAISERROR(50008,11,1)

			END
		END
		ELSE

			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO