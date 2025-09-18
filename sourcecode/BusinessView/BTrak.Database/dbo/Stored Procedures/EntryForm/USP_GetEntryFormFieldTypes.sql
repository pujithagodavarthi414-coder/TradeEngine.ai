CREATE PROCEDURE [dbo].[USP_GetEntryFormFieldTypes]
	@EntryFormTypeId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
AS
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF(@HavePermission = '1')
		BEGIN				
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF(@SearchText = '') SET @SearchText = NULL
		   
			SET @SearchText = '%'+ @SearchText +'%'

			SELECT EFF.Id AS Id,
			       EFF.FieldTypeName
				FROM  [dbo].[EntryFormFieldType]EFF 
				WHERE EFF.CompanyId = @CompanyId
				AND EFF.InActiveDateTime IS NULL
				AND (@EntryFormTypeId IS NULL OR EFF.Id = @EntryFormTypeId)
				AND	(@SearchText IS NULL
					OR EFF.FieldTypeName LIKE @SearchText)
					
				ORDER BY EFF.FieldTypeName ASC
		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
