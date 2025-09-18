-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertClientKycConfiguration] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[USP_UpsertClientKycConfiguration]
(
	@ConfigurationId UNIQUEIDENTIFIER NULL,
	@ClientTypeId UNIQUEIDENTIFIER = NULL,
	@LegalEntityTypeId UNIQUEIDENTIFIER = NULL,
	@ConfigurationName NVARCHAR(150),
	@FormBgColor NVARCHAR(150),
	@SelectedRoles NVARCHAR(MAX),
	--@SelectedLegalEntities NVARCHAR(MAX),
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

			DECLARE @ConfigurationIdCount INT = (SELECT COUNT(1) FROM [ClientKycConfiguration] WHERE Id = @ConfigurationId AND CompanyId = @CompanyId )
			
			--DECLARE @ConfigurationsCount INT = (SELECT COUNT(1) FROM [ClientKycConfiguration] WHERE [Name] = @ConfigurationName AND (@ConfigurationId IS NULL OR Id <> @ConfigurationId) AND CompanyId = @CompanyId ) 
			IF(EXISTS(SELECT Id FROM [Client] WHERE ClientKycId = @ConfigurationId AND InActiveDateTime IS NULL) AND @IsArchived = 1 AND @ConfigurationId IS NOT NULL)
	        BEGIN
	        
	          RAISERROR('ThisConfigurationIsUsedPleaseDeleteTheDependenciesAndTryAgain',11,1)
	        
	        END ELSE
		
			 IF (@ConfigurationIdCount = 0 AND @ConfigurationId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'ConfigurationName')

				END
			
			ELSE
			BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @ConfigurationId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [ClientKycConfiguration] WHERE Id = @ConfigurationId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@ConfigurationId IS NULL)
					  BEGIN

					  SET @ConfigurationId = NEWID()

						  INSERT INTO [ClientKycConfiguration](Id,
							    			[Name],
											[SelectedRoles],
											--[SelectedLegalEntities],
											[FormJson],
							    			CompanyId,
											IsDraft,
							    			CreatedDateTime,
							    			CreatedByUserId,
							    			InactiveDateTime,
											[ClientTypeId],
											LegalEntityTypeId,
											FormBgColor
							    		   )
							    	SELECT  @ConfigurationId,
											@ConfigurationName,
											@SelectedRoles,
											--@SelectedLegalEntities,
											@FormJson,
							    			@CompanyId,
											@IsDraft,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
										    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
											@ClientTypeId,
											@LegalEntityTypeId,
											@FormBgColor
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE [ClientKycConfiguration]
					     SET  [Name] = @ConfigurationName,
							  FormJson = @FormJson,
							  SelectedRoles = @SelectedRoles,
							  --SelectedLegalEntities = @SelectedLegalEntities,
							  IsDraft = @IsDraft,
							  [ClientTypeId]=@ClientTypeId,
							  LegalEntityTypeId=@LegalEntityTypeId,
							  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
							  UpdatedDateTime = @CurrentDate,
							  UpdatedByUserId = @OperationsPerformedBy,
							  FormBgColor = @FormBgColor
							 WHERE Id = @ConfigurationId

					   END

						SELECT Id FROM [ClientKycConfiguration] WHERE Id = @ConfigurationId
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