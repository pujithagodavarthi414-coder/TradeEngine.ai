CREATE PROCEDURE [dbo].[USP_UpsertPurchaseConfiguration]
(
	@ConfigurationId UNIQUEIDENTIFIER NULL,
	@ConfigurationName NVARCHAR(150),
	@SelectedRoles NVARCHAR(MAX),
	@FormJson NVARCHAR(MAX),
    @IsDraft BIT = NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@ConfigurationId =  '00000000-0000-0000-0000-000000000000') SET @ConfigurationId = NULL

			IF (@ConfigurationName = ' ' ) SET @ConfigurationName = NULL
		
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ConfigurationIdCount INT = (SELECT COUNT(1) FROM [ContractPurchase] WHERE Id = @ConfigurationId AND CompanyId = @CompanyId )
			
			DECLARE @ConfigurationsCount INT = (SELECT COUNT(1) FROM [ContractPurchase] WHERE [Name] = @ConfigurationName AND (@ConfigurationId IS NULL OR Id <> @ConfigurationId) AND CompanyId = @CompanyId ) 

			 IF (@ConfigurationIdCount = 0 AND @ConfigurationId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'ConfigurationName')

				END
			ELSE IF(@ConfigurationsCount > 0)
			BEGIN
				
					RAISERROR(50001,16,1,'ConfigurationName')

				END
			ELSE
			BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @ConfigurationId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [ContractPurchase] WHERE Id = @ConfigurationId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@ConfigurationId IS NULL)
					  BEGIN

					  SET @ConfigurationId = NEWID()

						  INSERT INTO [ContractPurchase](Id,
							    			[Name],
											[SelectedRoles],
											[FormJson],
							    			CompanyId,
											IsDraft,
							    			CreatedDateTime,
							    			CreatedByUserId,
							    			InactiveDateTime
							    		   )
							    	SELECT  @ConfigurationId,
											@ConfigurationName,
											@SelectedRoles,
											@FormJson,
							    			@CompanyId,
											@IsDraft,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
										    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE [ContractPurchase]
					     SET  [Name] = @ConfigurationName,
							  FormJson = @FormJson,
							  SelectedRoles = @SelectedRoles,
							  IsDraft = @IsDraft,
							  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							  UpdatedDateTime = @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy
							 WHERE Id = @ConfigurationId

					   END

						SELECT Id FROM [ContractPurchase] WHERE Id = @ConfigurationId
					END
					ELSE
					  
						RAISERROR(50008,11,1)

				END
		
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO