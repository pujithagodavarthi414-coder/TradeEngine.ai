-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or update the Rate type
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertRatetype] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TypeName ='Test',@Rate = '25'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertRatetype]
(
   @RatetypeId UNIQUEIDENTIFIER = NULL,
   @TypeName NVARCHAR(800) = NULL,
   @Rate NVARCHAR(800) = NULL,
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

		IF(@TypeName = '') SET @TypeName = NULL

		IF(@Rate = '') SET @Rate = NULL

	    IF(@TypeName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'TypeName')

		END
		ELSE IF(@Rate IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Rate')

		END
		ELSE
		BEGIN

		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				DECLARE @RatetypeIdCount INT = (SELECT COUNT(1) FROM [dbo].[RateType] WHERE Id = @RatetypeId AND CompanyId = @CompanyId)

				DECLARE @TypeNameCount INT = (SELECT COUNT(1) FROM [dbo].[RateType] WHERE [Type] = @TypeName AND CompanyId = @CompanyId AND (Id <> @RatetypeId OR @RatetypeId IS NULL))

				IF(@RatetypeIdCount = 0 AND @RatetypeId IS NOT NULL)
				BEGIN
					
					RAISERROR(50002,16, 1,'RateType')

				END

				ELSE IF(@TypeNameCount > 0)
				BEGIN

					RAISERROR(50001,16,1,'RateType')

				END		

				ELSE
				BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @RatetypeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [dbo].[RateType] WHERE Id = @RatetypeId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					IF(@RatetypeId IS NULL)
					BEGIN

						SET @RatetypeId = NEWID()
						
						INSERT INTO [dbo].[RateType](
						            [Id],
						            [Type],
									Rate,
						            [InActiveDateTime],
						            [CreatedDateTime],
						            [CreatedByUserId],
									CompanyId)
						     SELECT @RatetypeId,
						            @TypeName,
									@Rate,
						            CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						            @Currentdate,
						            @OperationsPerformedBy,
									@CompanyId
			       END
				   ELSE
				   BEGIN

						UPDATE [dbo].[RateType]
						SET [Type] = @TypeName
						    ,[Rate] = @Rate
							,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							,CompanyId = @CompanyId
							,[UpdatedDateTime] = @Currentdate
							,[UpdatedByUserId] = @OperationsPerformedBy
						WHERE Id = @RatetypeId

				   END
			        
					SELECT Id FROM [dbo].[RateType] WHERE Id = @RatetypeId

					END	
					ELSE
			  			RAISERROR (50008,11, 1)

				 END	

				END
				
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO
