-----------------------------------------------------------------------------------------
-- Author       Aswani K
-- Created      '2019-04-04 00:00:00.000'
-- Purpose      To insert/update industry modules
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertIndustryModule] @IndustryId = '744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71',@ModuleId = 'C1224C25-327C-44C6-97C0-B888195FCE9F',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertIndustryModule]
(
  @IndustryModuleId UNIQUEIDENTIFIER = NULL,
  @IndustryId UNIQUEIDENTIFIER,
  @ModuleId UNIQUEIDENTIFIER,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL,
  @IsArchived BIT = NULL
)
AS 
BEGIN    
	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

          IF(@HavePermission = '1')
          BEGIN

			  DECLARE @IsLatest BIT = (CASE WHEN @IndustryModuleId IS NULL THEN 1 ELSE 
			                           CASE WHEN (SELECT [TimeStamp] FROM [IndustryModule] 
									              WHERE Id = (SELECT Id FROM [IndustryModule] WHERE Id = @IndustryModuleId) AND InActiveDateTime IS NULL) = @TimeStamp
                                                  THEN 1 ELSE 0 END END)

			  IF(@IsLatest = 1)
			  BEGIN

			      DECLARE @Currentdate DATETIME = GETDATE()

		          IF(@IndustryModuleId IS NULL)
				  BEGIN

					SET @IndustryModuleId = NEWID()

					INSERT INTO [dbo].[IndustryModule](
					  		     [Id],
					  			 [IndustryId],
					  			 [ModuleId],
								 [CreatedByUserId],
								 [CreatedDateTime],
								 [InActiveDateTime])
					      SELECT @IndustryModuleId,
					  	         @IndustryId,
								 @ModuleId,
								 @OperationsPerformedBy,
								 @Currentdate,
								 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

				 END
				 ELSE
				 BEGIN
					
					UPDATE [dbo].[IndustryModule]
					      SET [IndustryId] = @IndustryId
						      ,[ModuleId] = @ModuleId
							  ,[UpdatedByUserId] = @OperationsPerformedBy
							  ,[UpdatedDateTime] = @Currentdate
							  ,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						WHERE Id = @IndustryModuleId

				 END
				       	     
		          SELECT Id FROM [dbo].[IndustryModule] WHERE Id = @IndustryModuleId

			  END

			  ELSE
			  BEGIN

			      RAISERROR (50008,11, 1)

			  END

          END

		  ELSE
		  BEGIN

		       RAISERROR (@HavePermission,10, 1)

		  END

	END TRY  
	BEGIN CATCH 
		
		  THROW

	END CATCH

END
GO