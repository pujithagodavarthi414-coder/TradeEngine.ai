CREATE PROCEDURE [dbo].[USP_SearchFiles]
(
	@MessageType nvarchar(800),
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN TRY

	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	 SELECT [Id],
			[CompanyId],
			[MessageTypeName],
			[CreatedDateTime],
			[CreatedByUserId],
			[UpdatedDateTime],
			[UpdatedByUserId],
			TotalCount = COUNT(1) OVER()
	FROM [MessageType]
	WHERE [MessageTypeName] = @MessageType
		  AND [CompanyId] = @CompanyId

	END TRY
	BEGIN CATCH

		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH

END
GO