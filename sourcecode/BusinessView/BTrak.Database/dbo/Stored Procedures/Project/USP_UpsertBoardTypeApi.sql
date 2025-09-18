------------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-09 00:00:00.000'
-- Purpose      To Save or Update BoardTypeApi
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_UpsertBoardTypeApi] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ApiName='abc'

CREATE PROCEDURE [dbo].[USP_UpsertBoardTypeApi]
(
  @BoardTypeApiId UNIQUEIDENTIFIER = NULL,
  @ApiName NVARCHAR(100) = NULL,
  @ApiUrl NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
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

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @BoardTypeApiIdCount INT = (SELECT COUNT(1) FROM BoardTypeApi WHERE Id = @BoardTypeApiId)

			DECLARE @ApiNameCount INT = (SELECT COUNT(1) FROM BoardTypeApi WHERE ApiName = @ApiName )

			DECLARE @UpdateApiNameCount INT = (SELECT COUNT(1) FROM BoardTypeApi WHERE ApiName = @ApiName AND Id <> @BoardTypeApiId)

			IF(@BoardTypeApiIdCount = 0 AND @BoardTypeApiId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16, 1,'BoardTypeApi')

			END

			ELSE IF(@ApiNameCount > 0 AND @BoardTypeApiId IS NULL)
			BEGIN

				RAISERROR(50001,16,1,'BoardTypeApi')

			END

			ELSE IF(@UpdateApiNameCount > 0 AND @BoardTypeApiId IS NOT NULL)
			BEGIN

				RAISERROR(50001,16,1,'BoardTypeApi')

			END

			ELSE
			BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @BoardTypeApiId IS NULL THEN 1 ELSE 
		                         CASE WHEN (SELECT [TimeStamp] FROM BoardTypeApi WHERE Id = @BoardTypeApiId) = @TimeStamp THEN 1 ELSE 0 END END )
								 
				IF (@IsLatest = 1)
				BEGIN

						DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()


		                IF(@BoardTypeApiId IS NOT NULL)
		                BEGIN
		                
		                	UPDATE [dbo].[BoardTypeApi]
		                    SET ApiName = @ApiName,
		                	    ApiUrl = @ApiUrl,
		                		--CompanyId = @CompanyId,
		                	    UpdatedDateTime = @Currentdate,
		                	    UpdatedByUserId = @OperationsPerformedBy,
								[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
		                    WHERE Id = @BoardTypeApiId 
		                
		                END
		                ELSE
		                BEGIN
		                
		                	SELECT @BoardTypeApiId = NEWID()
		                
		                	INSERT INTO [dbo].[BoardTypeApi](
		                	            [Id],
		                	            [ApiName],
		                	            [ApiUrl],
		                			--	[CompanyId],
		                	            [CreatedDateTime],
		                	            [CreatedByUserId],
										[InActiveDateTime])
		                	     SELECT @BoardTypeApiId,
		                	            @ApiName,
		                	            @ApiUrl,
		                				--@CompanyId,
		                	            @Currentdate,
		                	            @OperationsPerformedBy,
										CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
		                END
		                
		                SELECT Id FROM [dbo].[BoardTypeApi] WHERE Id = @BoardTypeApiId

				END
				ELSE
				    
					  RAISERROR(50008,11,1)
			END
		END
		ELSE
        BEGIN
                
		  RAISERROR (@HavePermission,11, 1)
                   
        END 

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO