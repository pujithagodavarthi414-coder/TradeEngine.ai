-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertKycStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @KycStatusName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertKycStatus]
(
   @KycStatusId UNIQUEIDENTIFIER = NULL,
   @StatusName NVARCHAR(800)  = NULL,
   @KycStatusName NVARCHAR(800)  = NULL,
   @KycStatusColor NVARCHAR(800)  = NULL,
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

	    IF(@KycStatusName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'KycStatusName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @KycStatusIdCount INT = (SELECT COUNT(1) FROM ClientKycFormStatus WHERE Id = @KycStatusId AND CompanyId = @CompanyId )

		DECLARE @KycStatusNameCount INT = (SELECT COUNT(1) FROM ClientKycFormStatus WHERE StatusName = @KycStatusName AND CompanyId = @CompanyId AND (Id <> @KycStatusId OR @KycStatusId IS NULL) )
		
		IF(@KycStatusIdCount = 0 AND @KycStatusId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'KycStatus')
		END
		ELSE IF(@KycStatusNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'KycStatus')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @KycStatusId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [ClientKycFormStatus] WHERE Id = @KycStatusId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@KycStatusId IS NULL)
				  BEGIN

				  SET @KycStatusId = NEWID()

			        INSERT INTO [dbo].[ClientKycFormStatus](
			                    [Id],
			                    [StatusName],
								[KycStatusName],
								[StatusColor],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @KycStatusId,
			                    @StatusName,
			                    @KycStatusName,
								@KycStatusColor,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [ClientKycFormStatus]
					  SET  [StatusName] = @StatusName,
						   [KycStatusName] = @KycStatusName,
						   [StatusColor] = @KycStatusColor,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @KycStatusId

				   END

			        SELECT Id FROM [dbo].[ClientKycFormStatus] WHERE Id = @KycStatusId

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
