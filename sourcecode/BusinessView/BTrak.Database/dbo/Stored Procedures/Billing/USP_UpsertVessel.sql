-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertVessel] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @VesselName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertVessel]
(
   @VesselId UNIQUEIDENTIFIER = NULL,
   @ProductId UNIQUEIDENTIFIER = NULL,
   @VesselName NVARCHAR(800)  = NULL,
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

	    IF(@VesselName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'VesselName')

		END
		ELSE
		BEGIN
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @VesselIdCount INT = (SELECT COUNT(1) FROM Vessel WHERE Id = @VesselId AND CompanyId = @CompanyId )

		DECLARE @VesselNameCount INT = (SELECT COUNT(1) FROM Vessel WHERE VesselName = @VesselName AND CompanyId = @CompanyId AND (Id <> @VesselId OR @VesselId IS NULL) )
		
		IF(@VesselIdCount = 0 AND @VesselId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Vessel')
		END
		ELSE IF(@VesselNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Vessel')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @VesselId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [Vessel] WHERE Id = @VesselId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@VesselId IS NULL)
				  BEGIN

				  SET @VesselId = NEWID()

			        INSERT INTO [dbo].[Vessel](
			                    [Id],
			                    [VesselName],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @VesselId,
			                    @VesselName,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [Vessel]
					  SET  [VesselName] = @VesselName,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @VesselId

				   END

			        SELECT Id FROM [dbo].[Vessel] WHERE Id = @VesselId

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