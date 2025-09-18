-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or update the Break Type
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertBreakType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@BreakTypeName ='Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertBreakType]
(
   @BreakId UNIQUEIDENTIFIER = NULL,
   @BreakTypeName NVARCHAR(800) = NULL,
   @IsPaid BIT = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@BreakTypeName = '') SET @BreakTypeName = NULL

	    IF(@BreakTypeName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'BreakTypeName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @BreakIdCount INT = (SELECT COUNT(1) FROM BreakType WHERE Id = @BreakId AND CompanyId = @CompanyId)

		DECLARE @BreakTypeNameCount INT = (SELECT COUNT(1) FROM BreakType WHERE BreakName = @BreakTypeName AND CompanyId = @CompanyId AND (Id <> @BreakId OR @BreakId IS NULL) AND InactiveDateTime IS NULL)

		IF(@BreakIdCount = 0 AND @BreakId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'BreakType')
		END

		ELSE IF(@BreakTypeNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'BreakType')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) -- Not in excel
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @BreakId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM BreakType WHERE Id = @BreakId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					IF (@BreakId IS NULL)
					BEGIN

					SET @BreakId = NEWID()
			        INSERT INTO [dbo].BreakType(
			                    [Id],
			                    BreakName,
								IsPaid,
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @BreakId,
			                    @BreakTypeName,
								@IsPaid,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				   UPDATE [dbo].BreakType
							SET BreakName				 = 		   @BreakTypeName,
								IsPaid					 = 		   @IsPaid,
			                    [InActiveDateTime]		 = 		   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime]		 = 		   @Currentdate,
			                    [UpdatedByUserId]		 = 		   @OperationsPerformedBy,
								CompanyId				 = 		   @CompanyId
								WHERE Id = @BreakId

				   END
			        SELECT Id FROM [dbo].BreakType WHERE Id = @BreakId

					END	
					ELSE

			  		RAISERROR (50008,11, 1)
				END
				
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
			END
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO