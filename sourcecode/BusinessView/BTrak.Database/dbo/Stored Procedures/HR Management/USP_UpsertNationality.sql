-------------------------------------------------------------------------------
-- Author       Madhuru Gummalla
-- Created      '2019-07-05 00:00:00.000'
-- Purpose      To Save or update the Nationality
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertNationality] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@NationalityName='Bangladeshi',@IsArchived = 0

CREATE PROCEDURE [dbo].[USP_UpsertNationality]
(
   @NationalityId UNIQUEIDENTIFIER = NULL,
   @NationalityName NVARCHAR(800)  = NULL,
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

		IF(@NationalityName = '') SET @NationalityName = NULL

		IF(@IsArchived = 1 AND @NationalityId IS NOT NULL)
		BEGIN
		 
		     DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM Employee WHERE NationalityId = @NationalityId))
	         BEGIN
	         
	         SET @IsEligibleToArchive = 'ThisNationalityUsedInEmployeePleaseDeleteTheDependenciesAndTryAgain'
	         
	         END
		     
		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@isEligibleToArchive,11, 1)
		     
		     END

	    END

	    IF(@NationalityName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'NationalityName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @NationalityIdCount INT = (SELECT COUNT(1) FROM Nationality WHERE Id = @NationalityId AND CompanyId = @CompanyId)

		DECLARE @NationalityNameCount INT = (SELECT COUNT(1) FROM Nationality WHERE NationalityName = @NationalityName AND CompanyId = @CompanyId AND (Id <> @NationalityId OR @NationalityId IS NULL))

		IF(@NationalityIdCount = 0 AND @NationalityId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Nationality')
		END

		ELSE IF(@NationalityNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Nationality')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @NationalityId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM Nationality WHERE Id = @NationalityId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					IF(@NationalityId IS NULL)
					BEGIN

					SET @NationalityId = NEWID()

			        INSERT INTO [dbo].Nationality(
			                    [Id],
			                    [NationalityName],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @NationalityId,
			                    @NationalityName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
					END
					ELSE
					BEGIN

					UPDATE [dbo].Nationality
			              SET   [NationalityName] = @NationalityName, 
			                    [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime] = @Currentdate,
			                    [UpdatedByUserId] = @OperationsPerformedBy,
								CompanyId = @CompanyId
								WHERE Id = @NationalityId

					END
			       
			        SELECT Id FROM [dbo].Nationality WHERE Id = @NationalityId

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