CREATE PROCEDURE [dbo].[USP_GetGRD]
(
	@Id UNIQUEIDENTIFIER = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF(@HavePermission = '1')
		BEGIN				
			
			IF(@CompanyId = '00000000-0000-0000-0000-000000000000') SET @CompanyId = NULL

			IF(@CompanyId IS NULL)
			BEGIN
			
			SET @CompanyId  = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			END

			DECLARE @TVAValue DECIMAL(18, 2) = (SELECT TOP(1)TVAValue FROM [dbo].[TVA] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)
			IF(@SearchText = '') SET @SearchText = NULL
		   
			SET @SearchText = '%'+ @SearchText +'%'

			SELECT Id,
				   StartDate,
				   EndDate,
				   [Name],
				   RepriseTariff,
				   AutoCTariff,
				   @TVAValue AS TVAValue,
				   [TimeStamp]
				FROM [dbo].[GRD]
				WHERE CompanyId = @CompanyId
				AND InActiveDateTime IS NULL
				AND (@Id IS NULL OR Id = @Id)

				AND	(@SearchText IS NULL
					OR [Name] LIKE @SearchText
					OR RepriseTariff LIKE @SearchText
					OR AutoCTariff LIKE @SearchText
					OR (REPLACE(CONVERT(NVARCHAR,StartDate,106),' ','-')) LIKE @SearchText
					OR (REPLACE(CONVERT(NVARCHAR,EndDate,106),' ','-')) LIKE @SearchText)

				ORDER BY [Name] ASC
		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END