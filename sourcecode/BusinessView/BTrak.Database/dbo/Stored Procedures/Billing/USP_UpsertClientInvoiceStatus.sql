-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertClientInvoiceStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @InvoiceStatusName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertClientInvoiceStatus]
(
   @InvoiceStatusId UNIQUEIDENTIFIER = NULL,
   @StatusName NVARCHAR(800)  = NULL,
   @InvoiceStatusName NVARCHAR(800)  = NULL,
   @InvoiceStatusColor NVARCHAR(800)  = NULL,
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

	    IF(@InvoiceStatusName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'InvoiceStatusName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @InvoiceStatusIdCount INT = (SELECT COUNT(1) FROM [ClientInvoiceStatus] WHERE Id = @InvoiceStatusId AND CompanyId = @CompanyId )

		DECLARE @InvoiceStatusNameCount INT = (SELECT COUNT(1) FROM [ClientInvoiceStatus] WHERE StatusName = @InvoiceStatusName AND CompanyId = @CompanyId AND (Id <> @InvoiceStatusId OR @InvoiceStatusId IS NULL) )
		
		IF(@InvoiceStatusIdCount = 0 AND @InvoiceStatusId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'InvoiceStatus')
		END
		ELSE IF(@InvoiceStatusNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'InvoiceStatus')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @InvoiceStatusId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [ClientInvoiceStatus] WHERE Id = @InvoiceStatusId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@InvoiceStatusId IS NULL)
				  BEGIN

				  SET @InvoiceStatusId = NEWID()

			        INSERT INTO [dbo].[ClientInvoiceStatus](
			                    [Id],
			                    [StatusName],
								[InvoiceStatusName],
								[StatusColor],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @InvoiceStatusId,
			                    @StatusName,
			                    @InvoiceStatusName,
								@InvoiceStatusColor,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [ClientInvoiceStatus]
					  SET  [StatusName] = @StatusName,
						   [InvoiceStatusName] = @InvoiceStatusName,
						   [StatusColor] = @InvoiceStatusColor,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @InvoiceStatusId

				   END

			        SELECT Id FROM [dbo].[ClientInvoiceStatus] WHERE Id = @InvoiceStatusId

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
