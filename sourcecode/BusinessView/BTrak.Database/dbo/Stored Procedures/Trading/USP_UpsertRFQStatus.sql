CREATE PROCEDURE [dbo].[USP_UpsertRFQStatus]
(
   @RFQStatusId UNIQUEIDENTIFIER = NULL,
   @StatusName NVARCHAR(800)  = NULL,
   @RFQStatusName NVARCHAR(800)  = NULL,
   @RFQStatusColor NVARCHAR(800)  = NULL,
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

	    IF(@RFQStatusName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ContractStatusName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @RFQStatusIdCount INT = (SELECT COUNT(1) FROM [RFQStatus] WHERE Id = @RFQStatusId AND CompanyId = @CompanyId )

		DECLARE @RFQStatusNameCount INT = (SELECT COUNT(1) FROM [RFQStatus] WHERE StatusName = @RFQStatusName AND CompanyId = @CompanyId AND (Id <> @RFQStatusId OR @RFQStatusId IS NULL) )
		
		IF(@RFQStatusIdCount = 0 AND @RFQStatusId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'ContractStatus')
		END
		ELSE IF(@RFQStatusNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'ContractStatus')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @RFQStatusId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [RFQStatus] WHERE Id = @RFQStatusId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@RFQStatusId IS NULL)
				  BEGIN

				  SET @RFQStatusId = NEWID()

			        INSERT INTO [dbo].[RFQStatus](
			                    [Id],
			                    [StatusName],
								[RFQStatusName],
								[StatusColor],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @RFQStatusId,
			                    @StatusName,
			                    @RFQStatusName,
								@RFQStatusColor,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [RFQStatus]
					  SET  [StatusName] = @StatusName,
						   [RFQStatusName] = @RFQStatusName,
						   [StatusColor] = @RFQStatusColor,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @RFQStatusId

				   END

			        SELECT Id FROM [dbo].[RFQStatus] WHERE Id = @RFQStatusId

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
