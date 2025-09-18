CREATE PROCEDURE [dbo].[USP_UpsertInterviewTypeQualifyingConfiguration]
(
   @InterviewTypeQualifyingConfigurationId UNIQUEIDENTIFIER = NULL,
   @InterviewRatingId UNIQUEIDENTIFIER,
   @InterviewTypeId UNIQUEIDENTIFIER,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@InterviewRatingId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'InterviewRatingId')

		END
		IF(@InterviewTypeId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'InterviewTypeId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @InterviewTypeQualifyingConfigurationIdCount INT = (SELECT COUNT(1) FROM InterviewTypeQualifyingConfiguration WHERE Id = @InterviewTypeQualifyingConfigurationId)

			DECLARE @InterviewTypeQualifyingConfigurationCount INT = (SELECT COUNT(1) FROM InterviewTypeQualifyingConfiguration WHERE InterviewRatingId = @InterviewRatingId AND InterviewTypeId = @InterviewTypeId AND (@InterviewTypeQualifyingConfigurationId IS NULL OR @InterviewTypeQualifyingConfigurationId <> Id))
       
			IF(@InterviewTypeQualifyingConfigurationIdCount = 0 AND @InterviewTypeQualifyingConfigurationId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'InterviewTypeQualifyingConfiguration')

			END
			IF (@InterviewTypeQualifyingConfigurationCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'InterviewTypeQualifyingConfiguration')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @InterviewTypeQualifyingConfigurationId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [InterviewTypeQualifyingConfiguration] WHERE Id = @InterviewTypeQualifyingConfigurationId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@InterviewTypeQualifyingConfigurationId IS NULL)
					  BEGIN

						 SET @InterviewTypeQualifyingConfigurationId = NEWID()

						 INSERT INTO [dbo].[InterviewTypeQualifyingConfiguration]([Id],
														  InterviewRatingId,
								                          InterviewTypeId,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @InterviewTypeQualifyingConfigurationId,
								                          @InterviewRatingId,
								                          @InterviewTypeId,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [InterviewTypeQualifyingConfiguration] SET InterviewRatingId = @InterviewRatingId,
								                  InterviewTypeId = @InterviewTypeId,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @InterviewTypeQualifyingConfigurationId

					END
				            
				    SELECT Id FROM [dbo].[InterviewTypeQualifyingConfiguration] WHERE Id = @InterviewTypeQualifyingConfigurationId
				                   
				  END
				  ELSE
				     
				      RAISERROR (50008,11, 1)
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			END
	END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO
