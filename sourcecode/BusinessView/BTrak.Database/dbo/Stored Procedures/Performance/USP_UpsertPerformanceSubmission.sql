-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-05-02 00:00:00.000'
-- Purpose      To Save or update the performance
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertPerformanceSubmission] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPerformanceSubmission]
(
	@PerformanceId UNIQUEIDENTIFIER = NULL,
	@ConfigurationId UNIQUEIDENTIFIER = NULL,
	@OfUserId UNIQUEIDENTIFIER = NULL,
	@IsShare BIT = NULL,
    @IsOpen BIT = NULL,
	@IsArchived BIT = NULL,
	@PdfUrl NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@ConfigurationId =  '00000000-0000-0000-0000-000000000000') SET @ConfigurationId = NULL

			IF (@PerformanceId =  '00000000-0000-0000-0000-000000000000') SET @PerformanceId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ConfigurationIdCount INT = (SELECT COUNT(1) FROM PerformanceConfiguration WHERE Id = @ConfigurationId AND CompanyId = @CompanyId )
			
			DECLARE @PerformanceIdCount INT = (SELECT COUNT(1) FROM PerformanceSubmission WHERE Id = @PerformanceId)
			
			IF (@ConfigurationIdCount = 0 AND @ConfigurationId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'ConfigurationName')

			END
			ELSE IF (@PerformanceIdCount = 0 AND @PerformanceId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'Performance')

			END
			ELSE
			BEGIN
				DECLARE @CurrentDate DATETIME = GETDATE()

				IF(@PerformanceId IS NULL)
				BEGIN

					  SET @PerformanceId = NEWID()

						  INSERT INTO PerformanceSubmission(Id,
							    			[ConfigurationId],
											IsOpen,
											IsShare,
											OfUserId,
							    			CreatedDateTime,
							    			CreatedByUserId
							    		   )
							    	SELECT  @PerformanceId,
											@ConfigurationId,
											@IsOpen,
											@IsShare,
											@OfUserId,
							    			@CurrentDate,
							    			@OperationsPerformedBy
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE PerformanceSubmission
					     SET  IsOpen = @IsOpen,
							  IsShare = @IsShare,
							  PdfUrl = @PdfUrl,
							  UpdatedByUserId = @OperationsPerformedBy,
							  UpdatedDateTime = @CurrentDate,
							  InActiveDateTime = IIF((@IsArchived = 1),GETDATE(),NULL),
							  ClosedByUserId = IIF((@IsOpen = 0),@OperationsPerformedBy,NULL)
							 WHERE Id = @PerformanceId

					   END

				SELECT Id FROM PerformanceSubmission WHERE Id = @PerformanceId
					
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