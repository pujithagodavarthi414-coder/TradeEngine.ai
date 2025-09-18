-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-05-02 00:00:00.000'
-- Purpose      To Save or update the performance
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertPerformance] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPerformance]
(
	@PerformanceId UNIQUEIDENTIFIER = NULL,
	@ConfigurationId UNIQUEIDENTIFIER = NULL,
	@FormData NVARCHAR(MAX),
    @IsDraft BIT = NULL,
    @IsSubmitted BIT = NULL,
    @IsApproved BIT = NULL,
    @ApprovedBy UNIQUEIDENTIFIER = NULL,
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
			
			DECLARE @PerformanceIdCount INT = (SELECT COUNT(1) FROM Performance WHERE Id = @PerformanceId)
			
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

						  INSERT INTO Performance(Id,
							    			[ConfigurationId],
											[FormData],
							    			[IsDraft],
											IsApproved,
											IsSubmitted,
							    			CreatedDateTime,
							    			CreatedByUserId,
											SubmitedDatetime
							    		   )
							    	SELECT  @PerformanceId,
											@ConfigurationId,
											@FormData,
											@IsDraft,
											0,
							    			@IsSubmitted,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
											IIF(ISNULL(@IsSubmitted,0) = 1,GETDATE(),NULL)
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE Performance
					     SET  FormData = @FormData,
							  IsSubmitted = @IsSubmitted,
							  IsDraft = @IsDraft,
							  IsApproved = @IsApproved,
							  ApprovedBy = @ApprovedBy,
							  UpdatedDateTime = @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy,
							  SubmitedDatetime = IIF((@IsSubmitted = 1 AND IsApproved = 0),GETDATE(),SubmitedDatetime),
							  ApprovedDatetime = IIF(@IsApproved = 1,GETDATE(),NULL)
							 WHERE Id = @PerformanceId

					   END

				SELECT Id FROM Performance WHERE Id = @PerformanceId
					
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