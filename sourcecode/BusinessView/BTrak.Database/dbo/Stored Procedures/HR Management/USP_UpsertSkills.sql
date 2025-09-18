-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Save or update the Skill
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertSkills] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SkillName='Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertSkills]
(
   @SkillId UNIQUEIDENTIFIER = NULL,
   @SkillName NVARCHAR(800)  = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@SkillName = '') SET @SkillName = NULL

		IF(@IsArchived = 1 AND @SkillId IS NOT NULL)
        BEGIN
		
		      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	          IF(EXISTS(SELECT Id FROM [EmployeeSkill] WHERE SkillId = @SkillId ))
	          BEGIN
	          
	          SET @IsEligibleToArchive = 'ThisSkillUsedInEducationSkillPleaseDeleteTheDependenciesAndTryAgain'
	          
	          END
		      
		      IF(@IsEligibleToArchive <> '1')
		      BEGIN
		      
		          RAISERROR (@isEligibleToArchive,11, 1)
		      
		      END

	    END

	    IF(@SkillName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'SkillName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @SkillIdCount INT = (SELECT COUNT(1) FROM Skill WHERE Id = @SkillId AND CompanyId = @CompanyId )

		DECLARE @SkillNameCount INT = (SELECT COUNT(1) FROM Skill WHERE SkillName = @SkillName AND CompanyId = @CompanyId AND (Id <> @SkillId OR @SkillId IS NULL) )

		IF(@SkillIdCount = 0 AND @SkillId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Skill')
		END

		ELSE IF(@SkillNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Skill')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @SkillId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM Skill WHERE Id = @SkillId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			        IF(@SkillId IS NULL)
					BEGIN

					SET @SkillId = NEWID()

					INSERT INTO [dbo].Skill(
			                    [Id],
			                    [SkillName],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @SkillId,
			                    @SkillName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
					END
					ELSE
					BEGIN

					UPDATE [Skill]
					  SET [SkillName] = @SkillName,
					      InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						  CompanyId = @CompanyId,
						  UpdatedDateTime = @Currentdate,
						  UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @SkillId 

					END
			       
			        SELECT Id FROM [dbo].Skill WHERE Id = @SkillId

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