CREATE PROCEDURE [dbo].[USP_GetTVA]
(
	@Id UNIQUEIDENTIFIER = NULL,
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
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF(@SearchText = '') SET @SearchText = NULL
		   
			SET @SearchText = '%'+ @SearchText +'%'

			SELECT Id,
				   StartDate,
				   EndDate,
				   TVAValue,
				   [TimeStamp],
				   CreatedByUserId,
				   CreatedDateTime
				FROM [dbo].[TVA]
				WHERE CompanyId = @CompanyId
				AND InActiveDateTime IS NULL
				AND (@Id IS NULL OR Id = @Id)
				AND	(@SearchText IS NULL
					OR TVAValue LIKE @SearchText
					OR (REPLACE(CONVERT(NVARCHAR,StartDate,106),' ','-')) LIKE @SearchText
					OR (REPLACE(CONVERT(NVARCHAR,EndDate,106),' ','-')) LIKE @SearchText)

				ORDER BY StartDate DESC
		END
		ELSE   
		RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END