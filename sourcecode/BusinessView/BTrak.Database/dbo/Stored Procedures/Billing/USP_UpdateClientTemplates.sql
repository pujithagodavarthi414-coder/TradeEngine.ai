CREATE PROCEDURE [dbo].[USP_UpdateClientTemplates]
	@ClientId UNIQUEIDENTIFIER = NULL,
	@IsSavingContractTemplates BIT = NULL,
	@IsSavingTradeTemplates BIT = NULL,
	@ContractTemplateIds NVARCHAR(MAX) = NULL,
	@TradeTemplateIds NVARCHAR(MAX) = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

	        DECLARE @HavePermission NVARCHAR(250)  = '1'

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			IF (@HavePermission = '1')
            BEGIN
			     DECLARE @IsLatest BIT = (CASE WHEN @ClientId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM Client WHERE Id = @ClientId) = @TimeStamp THEN 1 ELSE 0 END END)
				 DECLARE @CurrentDate DATETIME = GETDATE()

				 IF(@IsLatest = 1)
                 BEGIN
				     IF(@IsSavingContractTemplates = 1)
					 BEGIN
					         UPDATE [dbo].[Client]
							 SET [ContractTemplateIds] = @ContractTemplateIds,
							     [UpdatedDateTime]     = @CurrentDate,
								 [UpdatedByUserId]     = @OperationsPerformedBy
							 WHERE Id = @ClientId
					 END
					 IF(@IsSavingTradeTemplates = 1)
					 BEGIN
					         UPDATE [dbo].[Client]
							 SET [TradeTemplateIds]    = @TradeTemplateIds,
							     [UpdatedDateTime]     = @CurrentDate,
								 [UpdatedByUserId]     = @OperationsPerformedBy
							 WHERE Id = @ClientId
					 END
					  SELECT @ClientId
				 END
				 ELSE
				 BEGIN
				     RAISERROR(50008,11,1)
				 END
			END
			ELSE
			BEGIN

				RAISERROR(@HavePermission,11,1)

			END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
