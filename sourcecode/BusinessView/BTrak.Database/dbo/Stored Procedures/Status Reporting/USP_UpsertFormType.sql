-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-24 00:00:00.000'
-- Purpose      To Save or Update the FormType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved select * from  FormType 
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertFormType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FormTypeName='test',@FormTypeId = 'C2DD423E-31EF-4455-A4DC-F75C201B765A',@TimeStamp = 0x0000000000001636

CREATE PROCEDURE [dbo].[USP_UpsertFormType]
(
  @FormTypeId UNIQUEIDENTIFIER = NULL,
  @FormTypeName  NVARCHAR(500) = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
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

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @FormTypeIdCount INT = (SELECT COUNT(1) FROM FormType WHERE Id = @FormTypeId AND CompanyId = @CompanyId)

		DECLARE @FormTypeNameCount INT = (SELECT COUNT(1) FROM FormType WHERE FormTypeName = @FormTypeName AND CompanyId = @CompanyId AND (@FormTypeId IS NULL OR Id <> @FormTypeId) AND CompanyId = @CompanyId)

		DECLARE @IsToRaiseFkError BIT = (CASE WHEN EXISTS(SELECT Id FROM GenericForm WHERE FormTypeId = @FormTypeId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)

		IF(@FormTypeIdCount = 0 AND @FormTypeId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'FormType')

		END

		ELSE IF(@FormTypeNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'FormType')

		END
		ELSE IF (@IsArchived = 1 AND @IsToRaiseFkError = 1)
		BEGIN

			RAISERROR('DeleteFormTypeInGenericFormBeforeDeletingThisRecord',16,1)

		END

		ELSE
		BEGIN

		DECLARE @IsLatest BIT = (CASE WHEN @FormTypeId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM FormType WHERE Id = @FormTypeId) = @TimeStamp THEN 1 ELSE 0 END END )

		IF(@IsLatest = 1)
		BEGIN
		   
		DECLARE @CurrentDate DATETIME = GETDATE()

		If(@FormTypeId IS NULL)
		BEGIN
					SET @FormTypeId = NEWID()
					
					INSERT INTO [dbo].[FormType](
			  		                             [Id],
			  				                     [FormTypeName],
			  				                     InActiveDateTime,
			  				                     [CompanyId],
			  				                     [CreatedDateTime],
			  				                     [CreatedByUserId]
							                    )
					                      SELECT @FormTypeId,
			  			                         @FormTypeName,
			  			                   	     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			  			                   	     @CompanyId,
			  			                   	     @Currentdate,
			  			                   	     @OperationsPerformedBy
													   							
             END
			 ELSE
			 BEGIN

			        UPDATE [FormType] 
					         SET FormTypeName = @FormTypeName,
							     InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
								 CompanyId =  @CompanyId,
								 UpdatedDateTime = @CurrentDate,
								 UpdatedByUserId = @OperationsPerformedBy
								 WHERE Id = @FormTypeId

			 END
			
			SELECT Id FROM [dbo].[FormType] WHERE Id = @FormTypeId

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