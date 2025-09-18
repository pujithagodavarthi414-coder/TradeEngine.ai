-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-12-13 00:00:00.000'
-- Purpose      To Custom Application Fields Mapping
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved 
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertCustomFieldMapping]
(
  @MappingId UNIQUEIDENTIFIER = NULL,
  @CustomApplicationId UNIQUEIDENTIFIER = NULL,
  @MappingName NVARCHAR(500) = NULL,
  @MappingJson NVARCHAR(MAX) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @Timestamp timestamp = NULL
)
AS
BEGIN
       SET NOCOUNT ON

	   BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		IF (@HavePermission = '1')
		BEGIN
	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT dbo.Ufn_GetCompanyIdBasedOnUserId(@OperationsPerformedBy))
            
		DECLARE @MappingCount INT = (SELECT COUNT(1) FROM CustomFieldsMapping WHERE Id = @MappingId AND CompanyId = @CompanyId)

		DECLARE @MappingNameCount INT = (SELECT COUNT(1) FROM CustomFieldsMapping WHERE MappingName = @MappingName AND (@MappingId IS NULL OR Id <> @MappingId) AND CompanyId = @CompanyId)

		IF(@MappingCount = 0 AND @MappingId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'CustomFieldMapping')

		END

		ELSE IF(@MappingNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'CustomFieldMapping')

		END
		ELSE
		BEGIN

		DECLARE @IsLatest BIT = (CASE WHEN @MappingId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM CustomFieldsMapping WHERE Id = @MappingId) = @TimeStamp THEN 1 ELSE 0 END END )

		IF(@IsLatest = 1)
		BEGIN
		   
			DECLARE @CurrentDate DATETIME = GETDATE()

			If(@MappingId IS NULL)
			BEGIN
					SET @MappingId = NEWID()
					
					INSERT INTO [dbo].[CustomFieldsMapping](
			  		                             [Id],
			  				                     [MappingName],
			  				                     [CustomApplicationId],
			  				                     [MappingJson],
			  				                     [CreatedDateTime],
			  				                     [CreatedByUserId],
												 [CompanyId]
							                    )
					                      SELECT @MappingId,
			  			                         @MappingName,
			  			                   	     @CustomApplicationId,
			  			                   	     @MappingJson,
			  			                   	     @Currentdate,
			  			                   	     @OperationsPerformedBy,
												 @CompanyId
													   							
             END
			 ELSE
			 BEGIN

			        UPDATE [CustomFieldsMapping] 
					         SET MappingName = @MappingName,
								 [CustomApplicationId] =  @CustomApplicationId,
								 [MappingJson] =  @MappingJson,
								 UpdatedDateTime = @CurrentDate,
								 UpdatedByUserId = @OperationsPerformedBy
								 WHERE Id = @MappingId

			 END	
			 
				SELECT Id FROM [dbo].[CustomFieldsMapping] WHERE Id = @MappingId

		 END
		 ELSE
		   
		   RAISERROR(50008,11,1)

		 END
		 END
		END TRY  
	    BEGIN CATCH 
		
		   THROW

	   END CATCH

END