CREATE PROCEDURE [dbo].[USP_UpsertCompanyModule]
	@ModuleIds NVARCHAR(250) = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
	     DECLARE @HavePermission NVARCHAR(250)  = '1'
		 DECLARE @CurrentDate DATETIME = GETDATE()
		  IF(@HavePermission = '1')
          BEGIN
		     
		              INSERT INTO [dbo].[CompanyModule](
					                               [Id],
												   [ModuleId],
												   [CompanyId],
												   [IsActive],
												   [IsEnabled],
												   [CreatedDateTime],
												   [CreatedByUserId]
					                               )
									      SELECT NEWID(),
										         CONVERT(UNIQUEIDENTIFIER, [VALUE]),
												 @CompanyId,
												 1,
												 1,
												 @CurrentDate,
												 @OperationsPerformedBy
										 FROM [dbo].[Ufn_StringSplit](@ModuleIds, ',') 
						SELECT @CompanyId
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
