CREATE PROCEDURE [dbo].[USP_GetEntryFormField]
	@EntryFormId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
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

			SELECT EF.Id AS EntryFormId,
				   EF.DisplayName,
				   EF.FieldName,
				   EF.IsDisplay,
				   EF.Unit,
				   EF.[TimeStamp],
				   EFF.FieldTypeName,
				   EF.FieldTypeId,
				   EF.GRDId,
				   EF.SelectedGrdIds,
				   SelectedGrdNames = (STUFF((SELECT ',' + G.[Name] [text()]
		   							 FROM (SELECT [Value] FROM [dbo].[Ufn_StringSplit](EF.SelectedGrdIds,',')) WRC
		   							 INNER JOIN [GRD] G ON G.Id = WRC.[Value] AND G.CompanyId = @CompanyId
		   					  FOR XML PATH(''), TYPE).value('.','NVARCHAR(1000)'),1,1,''))
				FROM [dbo].[EntryFormField]EF
				INNER JOIN [dbo].[EntryFormFieldType]EFF ON EFF.Id = EF.FieldTypeId
				
				WHERE EF.CompanyId = @CompanyId
				AND EF.InActiveDateTime IS NULL
				AND (@EntryFormId IS NULL OR EF.Id = @EntryFormId)
				AND	(@SearchText IS NULL
					OR EF.DisplayName LIKE @SearchText
					OR EF.FieldName LIKE @SearchText
					OR EFF.FieldTypeName LIKE @SearchText)
					
				ORDER BY EF.DisplayName ASC
		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
