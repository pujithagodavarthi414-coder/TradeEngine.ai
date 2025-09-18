CREATE PROCEDURE [dbo].[USP_GetMessageFieldType]
	@MessageId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(MAX) = NULL,
	@OPerationsPerformedBy UNIQUEIDENTIFIER = NULL
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

			SELECT EF.Id AS MessageId,
				   EF.DisplayText,
				   EF.IsDisplay,
				   EF.[TimeStamp],
				   EF.MessageType,
				   EF.GRDId,
				   EF.SelectedGrdIds,
				   SelectedGrdNames = (STUFF((SELECT ',' + G.[Name] [text()]
		   							 FROM (SELECT [Value] FROM [dbo].[Ufn_StringSplit](EF.SelectedGrdIds,',')) WRC
		   							 INNER JOIN [GRD] G ON G.Id = WRC.[Value] AND G.CompanyId = @CompanyId
		   					  FOR XML PATH(''), TYPE).value('.','NVARCHAR(1000)'),1,1,''))
				FROM [dbo].[MessageFieldMaster]EF
				WHERE EF.CompanyId = @CompanyId
				AND EF.InActiveDateTime IS NULL
				AND (@MessageId IS NULL OR EF.Id = @MessageId)
				AND	(@SearchText IS NULL
					OR EF.DisplayText LIKE @SearchText
					OR EF.MessageType LIKE @SearchText
				)
					
				ORDER BY EF.MessageType ASC
		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END

