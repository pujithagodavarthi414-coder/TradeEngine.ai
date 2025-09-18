-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-05-20 00:00:00.000'
-- Purpose      To Save or update the Grade
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertGrade] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @GradeName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertGrade]
(
   @GradeId UNIQUEIDENTIFIER = NULL,
   @GradeName NVARCHAR(800)  = NULL,
   @GradeOrder INT = NULL,
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

		IF(@GradeName = '') SET @GradeName = NULL

	    IF(@GradeName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'GradeName')

		END
		ELSE
		BEGIN
		
		DECLARE @Currentdate DATETIME = GETDATE()

		IF(@IsArchived = 1 AND @GradeId IS NOT NULL)
		BEGIN
		 
			 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT EG.Id FROM EmployeeGrade EG
			           INNER JOIN Employee E ON E.Id = EG.EmployeeId
					              AND E.InActiveDateTime IS NULL
			           WHERE EG.GradeId = @GradeId AND (EG.ActiveTo IS NULL OR EG.ActiveTo > @Currentdate)))
	         BEGIN
	         
	             SET @IsEligibleToArchive = 'ThisGradeIsUsedInEmployeeGradePleaseDeleteTheDependenciesAndTryAgain'
	         
	         END
	         --ELSE IF(EXISTS(SELECT EGH.Id FROM EmployeeGradeHistory EGH 
			       --         INNER JOIN Employee E ON E.Id = EGH.EmployeeId
					     --         AND E.InActiveDateTime IS NULL
			       --         WHERE EGH.GradeId = @GradeId AND (EGH.ActiveTo IS NULL OR EGH.ActiveTo > @Currentdate)))
	         --BEGIN
	         
	         --    SET @IsEligibleToArchive = 'ThisGradeIsUsedInEmployeeGradeHistoryPleaseDeleteTheDependenciesAndTryAgain'
	          
	         --END

		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@IsEligibleToArchive,11, 1)
		     
		     END

	    END

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @GradeIdCount INT = (SELECT COUNT(1) FROM Grade WHERE Id = @GradeId AND CompanyId = @CompanyId )

		DECLARE @GradeNameCount INT = (SELECT COUNT(1) FROM Grade WHERE GradeName = @GradeName AND CompanyId = @CompanyId AND (Id <> @GradeId OR @GradeId IS NULL) )
		
		DECLARE @GradeOrderCount INT = (SELECT COUNT(1) FROM Grade WHERE GradeOrder = @GradeOrder AND InActiveDateTime IS NULL AND CompanyId = @CompanyId AND (Id <> @GradeId OR @GradeId IS NULL) )
		
		IF(@GradeOrder IS NULL) SET @GradeOrder = ISNULL((SELECT MAX(GradeOrder) FROM Grade WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId),0) + 1

		IF(@GradeIdCount = 0 AND @GradeId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Grade')
		END
		ELSE IF(@GradeNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Grade')

		END		
		ELSE IF(@GradeOrder IS NOT NULL AND @GradeOrderCount > 0)
		BEGIN
			
			RAISERROR(50001,16,1,'GradeOrder')

		END
		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @GradeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM Grade WHERE Id = @GradeId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

			        
			      IF(@GradeId IS NULL)
				  BEGIN

				  SET @GradeId = NEWID()

			        INSERT INTO [dbo].[Grade](
			                    [Id],
			                    [GradeName],
								[GradeOrder],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @GradeId,
			                    @GradeName,
								@GradeOrder,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [Grade]
					  SET  [GradeName] = @GradeName,
					       CompanyId  = @CompanyId,
						   [GradeOrder] = @GradeOrder,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @GradeId

				   END

			        SELECT Id FROM [dbo].Grade WHERE Id = @GradeId

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