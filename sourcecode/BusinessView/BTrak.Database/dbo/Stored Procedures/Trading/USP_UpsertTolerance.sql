-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertTolerance] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ToleranceName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTolerance]
(
   @ToleranceId UNIQUEIDENTIFIER = NULL,
   @ToleranceName NVARCHAR(800)  = NULL,
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

	    IF(@ToleranceName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ToleranceName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		--IF(EXISTS(SELECT Id FROM Client WHERE ToleranceId = @ToleranceId AND @IsArchived=1))
	 --   BEGIN
	 --   SET @IsEligibleToArchive = 'ThisToleranceUsedInClientDeleteTheDependenciesAndTryAgain'
	 --   RAISERROR (@isEligibleToArchive,11, 1)
	 --   END
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @ToleranceIdCount INT = (SELECT COUNT(1) FROM [Tolerance] WHERE Id = @ToleranceId AND CompanyId = @CompanyId )

		DECLARE @ToleranceNameCount INT = (SELECT COUNT(1) FROM [Tolerance] WHERE ToleranceName = @ToleranceName AND CompanyId = @CompanyId AND (Id <> @ToleranceId OR @ToleranceId IS NULL) )
		
		IF(@ToleranceIdCount = 0 AND @ToleranceId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'Tolerance')
		END
		ELSE IF(@ToleranceNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Tolerance')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @ToleranceId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [Tolerance] WHERE Id = @ToleranceId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@ToleranceId IS NULL)
				  BEGIN

				  SET @ToleranceId = NEWID()

			        INSERT INTO [dbo].[Tolerance](
			                    [Id],
			                    [ToleranceName],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @ToleranceId,
			                    @ToleranceName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [Tolerance]
					  SET  [ToleranceName] = @ToleranceName,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @ToleranceId

				   END

			        SELECT Id FROM [dbo].[Tolerance] WHERE Id = @ToleranceId

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