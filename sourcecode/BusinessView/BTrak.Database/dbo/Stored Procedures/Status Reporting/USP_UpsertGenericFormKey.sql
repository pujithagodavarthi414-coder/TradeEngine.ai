-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-09-30 00:00:00.000'
-- Purpose      To Update or Save Generic Form Keys
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertGenericFormKey] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@GenericFormId = 'D3238916-4958-4C61-9F53-1C67F9B793AA',@Key = 'TestFiled'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertGenericFormKey]
(
	@GenericFormKeyId UNIQUEIDENTIFIER = NULL,
    @GenericFormId UNIQUEIDENTIFIER = NULL,
    @Key NVARCHAR(150),
	@IsDefault BIT = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER,
    @IsArchived BIT = NULL,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
     IF (@HavePermission = '1')
     BEGIN
	  IF (@GenericFormKeyId = '00000000-0000-0000-0000-000000000000') SET @GenericFormKeyId = NULL

	  IF(@GenericFormId IS NULL)
	  BEGIN
		   
		   RAISERROR(50011,16, 2, 'GenericForm')

	  END
	  ELSE 
	  BEGIN

			DECLARE @GenericFormKeyIdCount INT = (SELECT COUNT(1) FROM GenericFormKey WHERE Id = @GenericFormKeyId)

			IF(@GenericFormKeyIdCount = 0 AND @GenericFormKeyId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16,1,'GenericFormKey')

			END
			ELSE
			BEGIN

			DECLARE @IsLatest BIT = (CASE WHEN @GenericFormKeyId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] 
			                                                                                 FROM GenericFormKey 
																							 WHERE Id = @GenericFormKeyId) = @TimeStamp 
																				        THEN 1 ELSE 0 END END)

			IF(@IsLatest = 1)
			BEGIN

				DECLARE @Currentdate DATETIME = GETDATE()

				IF(@GenericFormKeyId IS NULL)
				BEGIN
					
					SET @GenericFormKeyId = NEWID()

					INSERT INTO [dbo].[GenericFormKey](
					            [Id],
								[GenericFormId],
								[Key],
								[IsDefault],
					            [CreatedDateTime],
					            [CreatedByUserId],
								[InActiveDateTime]
								)
					     SELECT @GenericFormKeyId,
								@GenericFormId,
								@Key,
								ISNULL(@IsDefault,0),
					            @Currentdate,
								@OperationsPerformedBy,
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

				END
				ELSE
				BEGIN
					
					UPDATE [dbo].[GenericFormKey]
					    SET [GenericFormId] = @GenericFormId
						    ,[Key] = @Key
							,[IsDefault] = ISNULL(@IsDefault,0)
							,[UpdatedByUserId] = @OperationsPerformedBy
							,[UpdatedDateTime] = @Currentdate
							,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						WHERE Id = @GenericFormKeyId

				END
				   
				SELECT Id FROM [GenericFormSubmitted] WHERE Id = @GenericFormKeyId

			END

			ELSE
			   
			   RAISERROR(50008,11,1)

		END

      END
	END
    END TRY
    BEGIN CATCH

         THROW

    END CATCH
END
GO

