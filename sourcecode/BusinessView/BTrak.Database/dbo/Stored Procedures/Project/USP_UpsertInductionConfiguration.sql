-------------------------------------------------------------------------------
-- Author       Anupam sai kumar vuyyuru
-- Created      '2020-06-10 00:00:00.000'
-- Purpose      To Save or Update the InductionConfiguration
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertInductionConfiguration]
(
  @InductionId UNIQUEIDENTIFIER = NULL,
  @InductionName  NVARCHAR(500) = NULL,
  @IsShow BIT = NULL,
  @IsArchived BIT = NULL,
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

		DECLARE @InductionIdCount INT = (SELECT COUNT(1) FROM InductionConfiguration WHERE Id = @InductionId AND CompanyId = @CompanyId)

		DECLARE @InductionNameCount INT = (SELECT COUNT(1) FROM InductionConfiguration WHERE InductionName = @InductionName AND InActiveDateTime IS NULL AND CompanyId = @CompanyId AND (@InductionId IS NULL OR Id <> @InductionId))

		IF(@InductionIdCount = 0 AND @InductionId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'InductionConfiguration')

		END
		ELSE IF(@InductionNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'InductionConfiguration')

		END
		ELSE
		BEGIN
		   
		DECLARE @CurrentDate DATETIME = GETDATE()

		If(@InductionId IS NULL)
		BEGIN
					SET @InductionId = NEWID()
					
					INSERT INTO [dbo].[InductionConfiguration](
			  		                             [Id],
			  				                     [InductionName],
												 [IsShow],
												 InActiveDateTime,
			  				                     [CompanyId],
			  				                     [CreatedDateTime],
			  				                     [CreatedByUserId]
							                    )
					                      SELECT @InductionId,
			  			                         @InductionName,
												 @IsShow,
			  			                   	     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			  			                   	     @CompanyId,
			  			                   	     @Currentdate,
			  			                   	     @OperationsPerformedBy
													   							
             END
			 ELSE
			 BEGIN

			        UPDATE [InductionConfiguration] 
					         SET InductionName = @InductionName,
								 IsShow = @IsShow,
							     InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
								 CompanyId =  @CompanyId,
								 UpdatedDateTime = @CurrentDate,
								 UpdatedByUserId = @OperationsPerformedBy
								 WHERE Id = @InductionId

			 END
			
			SELECT Id FROM [dbo].[InductionConfiguration] WHERE Id = @InductionId

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