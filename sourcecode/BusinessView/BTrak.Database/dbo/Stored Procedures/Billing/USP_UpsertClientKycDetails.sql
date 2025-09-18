CREATE PROCEDURE [dbo].[USP_UpsertClientKycDetails]
(
   @ClientId UNIQUEIDENTIFIER,
   @OperationsPerformedBy UNIQUEIDENTIFIER

)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

		    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

            IF (@HavePermission = '1')
            BEGIN	              
				
				UPDATE Client SET [KycFormStatusId] = (SELECT Id FROM [ClientKycFormStatus] WHERE [StatusName]='Pending' AND CompanyId = @CompanyId)
				WHERE Id=@ClientId
				
				SELECT @ClientId

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
