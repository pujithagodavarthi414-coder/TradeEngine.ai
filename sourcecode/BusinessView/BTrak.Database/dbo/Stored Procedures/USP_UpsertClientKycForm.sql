CREATE PROCEDURE [dbo].[USP_UpsertClientKycForm]
(
	@ConfigurationId UNIQUEIDENTIFIER NULL,
	@ClientId UNIQUEIDENTIFIER NULL,
	@FormJson NVARCHAR(MAX) = NULL,
    @FormData NVARCHAR(MAX) = NULL,
	@IsArchived BIT = 0,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsSubmitted BIT = 0
)
AS
BEGIN
				DECLARE @CurrentDate DATETIME = GETDATE()

				IF(@IsArchived IS NULL)SET @IsArchived = 0
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@ConfigurationId =  '00000000-0000-0000-0000-000000000000') SET @ConfigurationId = NULL


			IF(@IsArchived = 0)
			BEGIN

			                      UPDATE [Client]
										 SET  KycFormData = @FormData,
											  UpdatedDateTime = @CurrentDate,
											  UpdatedByUserId = @OperationsPerformedBy,
											  [KycFormStatusId] = CASE WHEN @IsSubmitted = 1 THEN 
																							(SELECT Id FROM [ClientKycFormStatus] WHERE [StatusName]='Submitted' AND CompanyId = @CompanyId) 
																							ELSE 
																							(SELECT KycFormStatusId FROM [Client] WHERE Id = @ClientId) 
																							END
											  
										WHERE Id = @ClientId
		    END
			ELSE 
			BEGIN

			UPDATE [User]
			     SET IsActive = 0
				 WHERE Id = (SELECT TOP 1 UserId FROM Client WHERE Id = @ClientId)

				 --UPDATE Client SET InactiveDateTime = GETDATE() WHERE Id = @ClientId

			END
			SELECT Id FROM [Client] WHERE Id = @ClientId
END
