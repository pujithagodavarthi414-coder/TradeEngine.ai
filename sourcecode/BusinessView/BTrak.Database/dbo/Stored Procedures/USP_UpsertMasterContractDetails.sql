-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertMasterContractDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[USP_UpsertMasterContractDetails]
(
	@ContractId UNIQUEIDENTIFIER NULL,
	@ClientTypeId UNIQUEIDENTIFIER = NULL,
	@ContractName NVARCHAR(150),
	@SelectedRoles NVARCHAR(MAX),
	@FormJson NVARCHAR(MAX),
    @IsDraft BIT = NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@RateOrTon   NVARCHAR(150),
	@GradeId UNIQUEIDENTIFIER = NULL,
	@ProductId UNIQUEIDENTIFIER = NULL,
	@ContractQuantity int = null,
	@RemaningQuantity  int = null,
	@UsedQuantity  int = null,
	@ContractUniqueName NVARCHAR(150)= null,
	@ContractDocument NVARCHAR(150)= null,
	@ContractDateFrom Date= null,
	@ContractDateTo Date= null,
	@ClientId Date= null,
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
			
			IF (@ContractId =  '00000000-0000-0000-0000-000000000000') SET @ContractId = NULL

			IF (@ContractName = ' ' ) SET @ContractName = NULL
		
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ConfigurationIdCount INT = (SELECT COUNT(1) FROM [ClientKycConfiguration] WHERE Id = @ContractId AND CompanyId = @CompanyId )
			
			DECLARE @ConfigurationsCount INT = (SELECT COUNT(1) FROM [ClientKycConfiguration] WHERE [Name] = @ContractName AND (@ContractId IS NULL OR Id <> @ContractId) AND CompanyId = @CompanyId ) 

		
			 IF (@ConfigurationIdCount = 0 AND @ContractId IS NOT NULL)
			BEGIN
				    
					RAISERROR(50002,16,1,'ContractName')

				END
			ELSE IF(@ConfigurationsCount > 0)
			BEGIN
				
					RAISERROR(50001,16,1,'ContractName')

				END
			ELSE
			BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @ContractId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [ClientKycConfiguration] WHERE Id = @ContractId ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1) 
					BEGIN
						
						DECLARE @CurrentDate DATETIME = GETDATE()

					  IF(@ContractId IS NULL)
					  BEGIN

					  SET @ContractId = NEWID()

						  INSERT INTO [MasterContract](Id
							    			 ,[CompanyId]
											 ,[ContractName]
											 ,[ClientId]
											 ,[ContractUniqueName]
											 ,[ProductId]
											 ,[GradeId]
											 ,[RateOrTon]
											 ,[ContractQuantity]
											 ,[UsedQuantity]
											 ,[RemaningQuantity]
											 ,[CreatedDateTime]
											 ,[CreatedByUserId]
											 ,[ContractDocument]
											 ,[ContractDateFrom]
											 ,[ContractDateTo]
																		    		   )
							    	SELECT  @ContractId,
											@CompanyId,
											@ContractName,
											@ClientId,
											@ContractQuantity,
							    			@ProductId,
											@GradeId,
											@RateOrTon,
											@ContractQuantity,
											@UsedQuantity,
											@RemaningQuantity,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
											@ContractDocument,
											@ContractDateFrom,
											@ContractDateTo,
										    CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
											@ClientTypeId
		              
					   END
					   ELSE
					   BEGIN

					   UPDATE [MasterContract]
								  SET [ContractName]    = @ContractName,
								  [ClientId]			 = @ClientId,
								  [ContractUniqueName]	 = @ContractQuantity,
								  [ProductId]			 = @ProductId,
								  [GradeId]				 = @GradeId,
								  [RateOrTon]			 = @RateOrTon,
								  [ContractQuantity]	 = @ContractQuantity,
								  [UsedQuantity]		 = @UsedQuantity,
								  [RemaningQuantity]	 = @RemaningQuantity,
								  [ContractDocument]	 = @ContractDocument,
								  [ContractDateFrom]	 = @ContractDateFrom,
								  [ContractDateTo]		 = @ContractDateTo,
									InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
									UpdatedDateTime = @CurrentDate,
							       UpdatedByUserId = @OperationsPerformedBy
								 WHERE Id = @ContractId

					   END

						SELECT Id FROM MasterContract WHERE Id = @ContractId
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