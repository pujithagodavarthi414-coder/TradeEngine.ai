-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertGrades] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @GradeName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertGrades]
(
   @GradeId UNIQUEIDENTIFIER = NULL,
   @ProductId UNIQUEIDENTIFIER = NULL,
   @GradeName NVARCHAR(800)  = NULL,
   @GstCode NVARCHAR(50)  = NULL,
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
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		IF(EXISTS(SELECT Id FROM MasterContract WHERE GradeId = @GradeId AND @IsArchived=1))
	    BEGIN
	    SET @IsEligibleToArchive = 'ThisGradeUsedInContractsDeleteTheDependenciesAndTryAgain'
	    RAISERROR (@isEligibleToArchive,11, 1)
	    END
	    IF(@GradeName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'GradeName')

		END
		ELSE
		BEGIN
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @GradeIdCount INT = (SELECT COUNT(1) FROM BillingGrade WHERE Id = @GradeId AND CompanyId = @CompanyId )

		DECLARE @GradeNameCount INT = (SELECT COUNT(1) FROM BillingGrade WHERE GradeName = @GradeName AND CompanyId = @CompanyId AND (Id <> @GradeId OR @GradeId IS NULL) )
		
		IF(@GradeIdCount = 0 AND @GradeId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'Grade')
		END
		ELSE IF(@GradeNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Grade')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @GradeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [BillingGrade] WHERE Id = @GradeId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@GradeId IS NULL)
				  BEGIN

				  SET @GradeId = NEWID()

			        INSERT INTO [dbo].[BillingGrade](
			                    [Id],
			                    [GradeName],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId,
								GstCode,
								ProductId)
			             SELECT @GradeId,
			                    @GradeName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId,
								@GstCode,
								@ProductId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [BillingGrade]
					  SET  [GradeName] = @GradeName,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy,
						   ProductId = @ProductId,
						   GstCode = @GstCode
						  WHERE Id = @GradeId

				   END

			        SELECT Id FROM [dbo].BillingGrade WHERE Id = @GradeId

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