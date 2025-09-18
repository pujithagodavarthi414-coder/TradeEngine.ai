-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertClientTemplateConfiguration] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @TemplateConfigurationName = 'Test',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertClientTemplateConfiguration]
(
   @TemplateConfigurationId UNIQUEIDENTIFIER = NULL,
   @TemplateConfigurationName NVARCHAR(800)  = NULL,
   @TemplateConfiguration NVARCHAR(MAX)  = NULL,
   @ContractTypeId NVARCHAR(MAX) = NULL,
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

	    IF(@TemplateConfigurationName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'TemplateConfigurationName')

		END
		ELSE
		BEGIN
		DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
		
		DECLARE @Currentdate DATETIME = GETDATE()

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @TemplateConfigurationIdCount INT = (SELECT COUNT(1) FROM ClientTemplateConfiguration WHERE Id = @TemplateConfigurationId AND CompanyId = @CompanyId )

		DECLARE @TemplateConfigurationNameCount INT = (SELECT COUNT(1) FROM ClientTemplateConfiguration WHERE TemplateConfigurationName = @TemplateConfigurationName AND CompanyId = @CompanyId AND (Id <> @TemplateConfigurationId OR @TemplateConfigurationId IS NULL) )
		
		IF(@TemplateConfigurationIdCount = 0 AND @TemplateConfigurationId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 2,'TemplateConfiguration')
		END
		ELSE IF(@TemplateConfigurationNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'TemplateConfiguration')

		END		
		ELSE 
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @TemplateConfigurationId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [ClientTemplateConfiguration] WHERE Id = @TemplateConfigurationId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN
			      IF(@TemplateConfigurationId IS NULL)
				  BEGIN

				  SET @TemplateConfigurationId = NEWID()

			        INSERT INTO [dbo].[ClientTemplateConfiguration](
			                    [Id],
								[TemplateConfigurationName],
								[TemplateConfiguration],
								[ContractTypeIds],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @TemplateConfigurationId,
			                    @TemplateConfigurationName,
								@TemplateConfiguration,
			                    @ContractTypeId,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId
			       
				   END
				   ELSE
				   BEGIN

				    UPDATE [ClientTemplateConfiguration]
					  SET  [TemplateConfigurationName] = @TemplateConfigurationName,
					       [TemplateConfiguration] = @TemplateConfiguration,
						   [ContractTypeIds] = @ContractTypeId,
					       CompanyId  = @CompanyId,
					       InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						   UpdatedDateTime  = @Currentdate,
						   UpdatedByUserId = @OperationsPerformedBy
						  WHERE Id = @TemplateConfigurationId

				   END

			        SELECT Id FROM [dbo].[ClientTemplateConfiguration] WHERE Id = @TemplateConfigurationId

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

