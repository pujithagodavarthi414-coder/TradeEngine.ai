CREATE PROCEDURE [dbo].[USP_UpsertVesselConfirmationStatus]
(
   @StatusId UNIQUEIDENTIFIER = NULL,
   @StatusName NVARCHAR(800)  = NULL,
   @VesselConfirmationStatusName NVARCHAR(800)  = NULL,
   @StatusColor NVARCHAR(800)  = NULL,
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

	    IF(@VesselConfirmationStatusName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ContractStatusName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @StatusIdCount INT = (SELECT COUNT(1) FROM [VesselConfirmationStatus] WHERE Id = @StatusId AND CompanyId = @CompanyId )

		DECLARE @VesselConfirmationStatusNameCount INT = (SELECT COUNT(1) FROM [VesselConfirmationStatus] WHERE StatusName = @VesselConfirmationStatusName AND CompanyId = @CompanyId AND (Id <> @StatusId OR @StatusId IS NULL) )
		
		IF(@StatusIdCount = 0 AND @StatusId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'VesselConfirmationStatus')
		END
		ELSE IF(@VesselConfirmationStatusNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'VesselConfirmationStatus')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @StatusId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [VesselConfirmationStatus] WHERE Id = @StatusId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@StatusId IS NULL)
				  BEGIN

				  SET @StatusId = NEWID()

			        INSERT INTO [dbo].[VesselConfirmationStatus](
			                    [Id],
			                    [StatusName],
								[VesselConfirmationStatusName],
								[StatusColor],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @StatusId,
			                    @StatusName,
			                    @VesselConfirmationStatusName,
								@StatusColor,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [VesselConfirmationStatus]
					  SET  [StatusName] = @StatusName,
						   [VesselConfirmationStatusName] = @VesselConfirmationStatusName,
						   [StatusColor] = @StatusColor,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @StatusId

				   END

			        SELECT Id FROM [dbo].[VesselConfirmationStatus] WHERE Id = @StatusId

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