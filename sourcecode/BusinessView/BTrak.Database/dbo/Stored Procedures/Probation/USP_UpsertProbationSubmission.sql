--EXEC [dbo].[USP_UpsertProbationSubmission] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProbationSubmission]
(
	@ProbationId UNIQUEIDENTIFIER = NULL,
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

			IF (@ProbationId =  '00000000-0000-0000-0000-000000000000') SET @ProbationId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ConfigurationIdCount INT = (SELECT COUNT(1) FROM ProbationConfiguration WHERE Id = @ConfigurationId AND CompanyId = @CompanyId )
			
			DECLARE @ProbationIdCount INT = (SELECT COUNT(1) FROM ProbationSubmission WHERE Id = @ProbationId)
			
			IF (@ConfigurationIdCount = 0 AND @ConfigurationId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'ConfigurationName')

			END
			ELSE IF (@ProbationIdCount = 0 AND @ProbationId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'Probation')

			END
			ELSE
			BEGIN
				DECLARE @CurrentDate DATETIME = GETDATE()

				IF(@ProbationId IS NULL)
				BEGIN

					  SET @ProbationId = NEWID()

						  INSERT INTO ProbationSubmission(Id,
							    			[ConfigurationId],
											IsOpen,
											IsShare,
											OfUserId,
							    			CreatedDateTime,
							    			CreatedByUserId
							    		   )
							    	SELECT  @ProbationId,
											@ConfigurationId,
											@IsOpen,
											@IsShare,
											@OfUserId,
							    			@CurrentDate,
							    			@OperationsPerformedBy
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE ProbationSubmission
					     SET  IsOpen = @IsOpen,
							  IsShare = @IsShare,
							  PdfUrl = @PdfUrl,
							  UpdatedByUserId = @OperationsPerformedBy,
							  UpdatedDateTime = @CurrentDate,
							  InActiveDateTime = IIF((@IsArchived = 1),GETDATE(),NULL),
							  ClosedByUserId = IIF((@IsOpen = 0),@OperationsPerformedBy,NULL)
							 WHERE Id = @ProbationId

					   END

				SELECT Id FROM ProbationSubmission WHERE Id = @ProbationId
					
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