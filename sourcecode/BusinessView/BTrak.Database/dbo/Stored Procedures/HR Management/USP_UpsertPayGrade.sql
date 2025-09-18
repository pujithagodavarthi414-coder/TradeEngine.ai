-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or update the PayGrade
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertPayGrade] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@PayGradeName='Test',@IsArchived = 0
 -------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayGrade]
(
   @PayGradeId UNIQUEIDENTIFIER = NULL,
   @PayGradeName NVARCHAR(800) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@PayGradeName = '') SET @PayGradeName = NULL

		IF(@IsArchived = 1 AND @PayGradeId IS NOT NULL)
        BEGIN
		
		 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	     IF(EXISTS(SELECT Id FROM [PayGradeRate] WHERE PayGradeId = @PayGradeId))
	     BEGIN
	     
	     SET @IsEligibleToArchive = 'ThisPayGradeUsedInPayGradeRatePleaseDeleteTheDependenciesAndTryAgain'
	     
	     END
	     ELSE IF(EXISTS(SELECT Id FROM [EmployeeSalary] WHERE SalaryPayGradeId = @PayGradeId))
	     BEGIN
	     
	     SET @IsEligibleToArchive = 'ThisPayGradeUsedInPayGradeRatePleaseDeleteTheDependenciesAndTryAgain'
	     
	     END
		 
		 IF(@IsEligibleToArchive <> '1')
		 BEGIN
		 
		     RAISERROR (@isEligibleToArchive,11, 1)
		 
		 END

	    END

	    IF(@PayGradeName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'PayGradeName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @PayGradeIdCount INT = (SELECT COUNT(1) FROM PayGrade WHERE Id = @PayGradeId AND CompanyId = @CompanyId)

		DECLARE @PayGradeNameCount INT = (SELECT COUNT(1) FROM PayGrade WHERE PayGradeName = @PayGradeName AND CompanyId = @CompanyId AND (Id <> @PayGradeId OR @PayGradeId IS NULL))

		IF(@PayGradeIdCount = 0 AND @PaygradeId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'PayGrade')
		END

		ELSE IF(@PayGradeNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'PayGrade')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @PaygradeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM PayGrade WHERE Id = @PaygradeId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			        DECLARE @NewPayGradeId UNIQUEIDENTIFIER = NEWID()
					IF(@PayGradeId IS NULL)
					BEGIN

					SET @PayGradeId = NEWID()
			        INSERT INTO [dbo].PayGrade(
			                    [Id],
			                    PayGradeName,
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @PayGradeId,
			                    @PayGradeName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				   UPDATE [dbo].PayGrade
						SET		PayGradeName		   =   		  @PayGradeName,
			                    [InActiveDateTime]	   =   		  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime]	   =   		  @Currentdate,
			                    [UpdatedByUserId]	   =   		  @OperationsPerformedBy,
								CompanyId			   =   		 @CompanyId
								WHERE Id = @PayGradeId

				   END
			        SELECT Id FROM [dbo].PayGrade WHERE Id = @PayGradeId

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