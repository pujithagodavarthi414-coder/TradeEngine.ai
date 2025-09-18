CREATE PROCEDURE [dbo].[USP_UpsertJobOpeningSkill]
(
   @JobOpeningSkillId UNIQUEIDENTIFIER = NULL,
   @JobOpeningId UNIQUEIDENTIFIER = NULL,
   @SkillId UNIQUEIDENTIFIER = NULL,
   @MinExperience FLOAT,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@JobOpeningId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'JobOpeningId')

		END
		IF(@SkillId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'SkillId')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @JobOpeningSkillIdCount INT = (SELECT COUNT(1) FROM JobOpeningSkill  WHERE Id = @JobOpeningSkillId)

			DECLARE @JobOpeningSkillCount INT = (SELECT COUNT(1) FROM JobOpeningSkill WHERE JobOpeningId = @JobOpeningId AND SkillId = @SkillId AND (@JobOpeningSkillId IS NULL OR @JobOpeningSkillId <> Id))
       
			IF(@JobOpeningSkillIdCount = 0 AND @JobOpeningSkillId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'JobOpeningSkill')

			END
			IF (@JobOpeningSkillCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'JobOpeningSkill')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @JobOpeningSkillId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [JobOpeningSkill] WHERE Id = @JobOpeningSkillId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@JobOpeningSkillId IS NULL)
					  BEGIN

						 SET @JobOpeningSkillId = NEWID()

						 INSERT INTO [dbo].[JobOpeningSkill]([Id],
														  JobOpeningId,
								                          SkillId,
														  MinExperience,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @JobOpeningSkillId,
								                          @JobOpeningId,
								                          @SkillId,
														  @MinExperience,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy		
							         
					END
					ELSE
					BEGIN

						UPDATE [JobOpeningSkill] SET JobOpeningId = @JobOpeningId,
								                  SkillId = @SkillId,
												  MinExperience = @MinExperience,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @JobOpeningSkillId

					END
				            
				    SELECT Id FROM [dbo].[JobOpeningSkill] WHERE Id = @JobOpeningSkillId
				                   
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
