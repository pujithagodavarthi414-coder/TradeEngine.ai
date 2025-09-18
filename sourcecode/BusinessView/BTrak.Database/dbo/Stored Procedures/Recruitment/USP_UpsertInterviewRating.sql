CREATE PROCEDURE [dbo].[USP_UpsertInterviewRating]
(
   @InterviewRatingId UNIQUEIDENTIFIER = NULL,
   @InterviewRatingName NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @Value FLOAT,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@InterviewRatingName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'InterviewRating')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @InterviewRatingIdCount INT = (SELECT COUNT(1) FROM InterviewRating  WHERE Id = @InterviewRatingId)

			DECLARE @InterviewRatingCount INT = (SELECT COUNT(1) FROM InterviewRating WHERE InterviewRatingName = @InterviewRatingName AND CompanyId = @CompanyId AND (@InterviewRatingId IS NULL OR @InterviewRatingId <> Id))
       
			DECLARE @IsInUse INT = (select COUNT(1) from CandidateInterviewFeedback CIF
									INNER JOIN InterviewRating IR ON IR.Id = CIF.InterviewRatingId
											WHERE IR.CompanyId=@CompanyId AND CIF.InterviewRatingId = @InterviewRatingId
											)
       
			IF(@IsInUse > 0 AND @IsArchived IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'InterviewRatingUse')

			END
			IF(@InterviewRatingIdCount = 0 AND @InterviewRatingId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'InterviewRating')

			END
			IF (@InterviewRatingCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'InterviewRating')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @InterviewRatingId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [InterviewRating] WHERE Id = @InterviewRatingId  AND CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@InterviewRatingId IS NULL)
					  BEGIN

						 SET @InterviewRatingId = NEWID()

						 INSERT INTO [dbo].[InterviewRating]([Id],
														  [CompanyId],
								                          InterviewRatingName,
								                          [Value],
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @InterviewRatingId,
								                          @CompanyId,
								                          @InterviewRatingName,
														  @Value,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [InterviewRating] SET CompanyId = @CompanyId,
								                  InterviewRatingName = @InterviewRatingName,
									              [Value] = @Value,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @InterviewRatingId

					END
				            
				    SELECT Id FROM [dbo].[InterviewRating] WHERE Id = @InterviewRatingId
				                   
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