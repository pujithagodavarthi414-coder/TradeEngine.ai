-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or update the Designation
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertDesignation] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @DesignationName='Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertDesignation]
(
   @DesignationId UNIQUEIDENTIFIER = NULL,
   @DesignationName NVARCHAR(800)  = NULL,
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

		IF(@DesignationName = '') SET @DesignationName = NULL

	    IF(@DesignationName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'DesignationName')

		END
		ELSE
		BEGIN

		IF(@IsArchived = 1)
		BEGIN
		 
			 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	
	         IF(EXISTS(SELECT Id FROM EmployeeWorkExperience WHERE DesignationId = @DesignationId ))
	         BEGIN
	         
	             SET @IsEligibleToArchive = 'ThisDesignationIUsedInEmployeeWorkExperiencePleaseDeleteTheDependenciesAndTryAgain'
	         
	         END
	         ELSE IF(EXISTS(SELECT Id FROM Job WHERE DesignationId = @DesignationId))
	         BEGIN
	         
	             SET @IsEligibleToArchive = 'ThisDesignationUsedInJobPleaseDeleteTheDependenciesAndTryAgain'
	          
	         END

		     IF(@IsEligibleToArchive <> '1')
		     BEGIN
		     
		         RAISERROR (@IsEligibleToArchive,11, 1)
		     
		     END

	    END

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @DesignationIdCount INT = (SELECT COUNT(1) FROM Designation WHERE Id = @DesignationId AND CompanyId = @CompanyId )

		DECLARE @DesignationNameCount INT = (SELECT COUNT(1) FROM Designation WHERE DesignationName = @DesignationName AND CompanyId = @CompanyId AND (Id <> @DesignationId OR @DesignationId IS NULL) )

		IF(@DesignationIdCount = 0 AND @DesignationId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Designation')
		END
		ELSE IF(@DesignationNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Designation')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @DesignationId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM Designation WHERE Id = @DesignationId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

				  DECLARE @Currentdate DATETIME = GETDATE()
			        
			      IF(@DesignationId IS NULL)
				  BEGIN

				  SET @DesignationId = NEWID()

			        INSERT INTO [dbo].Designation(
			                    [Id],
			                    [DesignationName],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @DesignationId,
			                    @DesignationName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [Designation]
					  SET  DesignationName = @DesignationName,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @DesignationId

				   END

			        SELECT Id FROM [dbo].Designation WHERE Id = @DesignationId

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