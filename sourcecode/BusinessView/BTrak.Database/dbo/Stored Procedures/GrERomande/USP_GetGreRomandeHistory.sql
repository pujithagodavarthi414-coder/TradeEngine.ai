CREATE PROCEDURE [dbo].[USP_GetGreRomandeHistory]
	@GreRomandeId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))
		IF (@HavePermission = '1')
		BEGIN
		   SELECT GRH.Id AS HistoryId,
		          GRH.GreRomandeId,
		          GRH.FieldName,
				  GRH.OldValue,
				  GRH.NewValue,
				  GRH.[Description],
				  GR.GridInvoice,
				  GRH.CreatedDateTime,
				  GRH.OldJson
		          FROM [dbo].[GreRomandeEHistory]GRH
				 INNER JOIN [dbo].[GrERomande]GR ON GR.Id = GRH.GreRomandeId
				WHERE (@GreRomandeId IS NULL OR GRH.GreRomandeId = @GreRomandeId)
				AND (GRH.FieldName IS NULL OR GRH.FieldName <>'EntryFormAdded')
				AND GRH.InActiveDateTime IS NULL
				ORDER BY GRH.CreatedDateTime DESC
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
	