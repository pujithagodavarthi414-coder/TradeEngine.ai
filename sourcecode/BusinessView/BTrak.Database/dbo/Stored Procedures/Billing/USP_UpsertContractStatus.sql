-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertContractStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ContractStatusName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertContractStatus]
(
   @ContractStatusId UNIQUEIDENTIFIER = NULL,
   @StatusName NVARCHAR(800)  = NULL,
   @ContractStatusName NVARCHAR(800)  = NULL,
   @ContractStatusColor NVARCHAR(800)  = NULL,
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

	    IF(@ContractStatusName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ContractStatusName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @ContractStatusIdCount INT = (SELECT COUNT(1) FROM [ContractStatus] WHERE Id = @ContractStatusId AND CompanyId = @CompanyId )

		DECLARE @ContractStatusNameCount INT = (SELECT COUNT(1) FROM [ContractStatus] WHERE StatusName = @ContractStatusName AND CompanyId = @CompanyId AND (Id <> @ContractStatusId OR @ContractStatusId IS NULL) )
		
		IF(@ContractStatusIdCount = 0 AND @ContractStatusId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'ContractStatus')
		END
		ELSE IF(@ContractStatusNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'ContractStatus')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @ContractStatusId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [ContractStatus] WHERE Id = @ContractStatusId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@ContractStatusId IS NULL)
				  BEGIN

				  SET @ContractStatusId = NEWID()

			        INSERT INTO [dbo].[ContractStatus](
			                    [Id],
			                    [StatusName],
								[ContractStatusName],
								[StatusColor],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @ContractStatusId,
			                    @StatusName,
			                    @ContractStatusName,
								@ContractStatusColor,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [ContractStatus]
					  SET  [StatusName] = @StatusName,
						   [ContractStatusName] = @ContractStatusName,
						   [StatusColor] = @ContractStatusColor,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @ContractStatusId

				   END

			        SELECT Id FROM [dbo].[ContractStatus] WHERE Id = @ContractStatusId

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
