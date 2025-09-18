-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertLegalEntity] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @LegalEntityName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLegalEntity]
(
   @LegalEntityId UNIQUEIDENTIFIER = NULL,
   @LegalEntityName NVARCHAR(800)  = NULL,
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

	    IF(@LegalEntityName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'LegalEntityName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		IF(EXISTS(SELECT Id FROM Client WHERE LegalEntityId = @LegalEntityId AND @IsArchived=1))
	    BEGIN
	    SET @IsEligibleToArchive = 'ThisLegalEntityUsedInClientDeleteTheDependenciesAndTryAgain'
	    RAISERROR (@isEligibleToArchive,11, 1)
	    END
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @LegalEntityIdCount INT = (SELECT COUNT(1) FROM LegalEntity WHERE Id = @LegalEntityId AND CompanyId = @CompanyId )

		DECLARE @LegalEntityNameCount INT = (SELECT COUNT(1) FROM LegalEntity WHERE LegalEntityName = @LegalEntityName AND CompanyId = @CompanyId AND (Id <> @LegalEntityId OR @LegalEntityId IS NULL) )
		
		IF(@LegalEntityIdCount = 0 AND @LegalEntityId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'LegalEntity')
		END
		ELSE IF(@LegalEntityNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'LegalEntity')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @LegalEntityId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [LegalEntity] WHERE Id = @LegalEntityId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@LegalEntityId IS NULL)
				  BEGIN

				  SET @LegalEntityId = NEWID()

			        INSERT INTO [dbo].[LegalEntity](
			                    [Id],
			                    [LegalEntityName],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @LegalEntityId,
			                    @LegalEntityName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [LegalEntity]
					  SET  [LegalEntityName] = @LegalEntityName,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @LegalEntityId

				   END

			        SELECT Id FROM [dbo].[LegalEntity] WHERE Id = @LegalEntityId

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