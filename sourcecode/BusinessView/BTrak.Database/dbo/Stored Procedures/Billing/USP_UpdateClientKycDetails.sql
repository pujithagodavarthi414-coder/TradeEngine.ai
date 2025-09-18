-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpdateClientKycDetails] @ClientId='77e60727-1695-4de6-bb3e-bd2aaee52781'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateClientKycDetails]
(
   @ClientId UNIQUEIDENTIFIER = NULL,
   @FormData NVARCHAR(MAX) = NULL,
   @FormJson NVARCHAR(MAX) = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @KycSubmittedDate DATETIME = NULL,
   @CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	    IF(@ClientId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'ClientId')

		END
		ELSE
		BEGIN
		
		DECLARE @Currentdate DATETIME = GETDATE()

			DECLARE @HavePermission NVARCHAR(250)  = '1'

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @ClientId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [Client] WHERE Id = @ClientId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
				DECLARE @UserId UNIQUEIDENTIFIER = (SELECT UserId FROM Client WHERE Id=@ClientId)
			    IF(@IsLatest = 1)
				BEGIN

				    UPDATE [Client]
					  SET  [KycFormData] = @FormData,
					       [CompanyId] = @CompanyId,
						   [KycSubmittedDate] = @Currentdate,
						   [UpdatedDateTime]  = @Currentdate,
						   [KycFormStatusId] = (SELECT Id FROM [ClientKycFormStatus] WHERE [StatusName]='Submitted' AND CompanyId = @CompanyId)
						   --UpdatedByUserId = @
						  WHERE Id = @ClientId

						INSERT INTO [dbo].[ClientKycFormHistory](
									[Id],
									[UserId],
									[ClientId],
									[OldValue],
									[NewValue],
									[Description],
									[CreatedByUserId],
									[CreatedDateTime],
									[CompanyId]
									)
							 SELECT NEWID(),
								    @UserId,
									@ClientId,
									(SELECT KycStatusName FROM [ClientKycFormStatus] WHERE [StatusName]='Pending' AND CompanyId = @CompanyId),
									(SELECT KycStatusName FROM [ClientKycFormStatus] WHERE [StatusName]='Submitted' AND CompanyId = @CompanyId),
									'KYC form submitted',
									@UserId,
									@Currentdate,
									@CompanyId
			        SELECT @ClientId

			    END	
					ELSE

			  		RAISERROR (50008,11, 1)
				END
				
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
			END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO