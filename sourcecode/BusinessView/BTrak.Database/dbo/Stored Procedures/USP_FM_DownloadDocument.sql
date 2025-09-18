-------------------------------------------------------------------------------------------------------------
--EXEC USP_FM_DownloadDocument 
--@FileIds = N',
--<GenericListOfGuid>
--<ListItems>
--<guid>81430AC4-40F3-4E68-BD78-539A1F606108</guid>
--<guid>81430AC4-40F3-4E68-BD78-539A1F606108</guid>
--</ListItems>
--</GenericListOfGuid>', 
--@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = 'FC361D23-F317-4704-B86F-0D6E7287EEE9'
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_FM_DownloadDocument]
(
  @FileIds XML,
  @OperationsPerformedBy UNIQUEIDENTIFIER,		
  @FeatureId UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	       
		   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		   
          DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		   IF (@HavePermission = '1')
		   BEGIN

			   SELECT DS.[FileId],
			   	      UF.[FileName]
		       FROM  [dbo].[DocumentSet] DS WITH (NOLOCK)
			         JOIN UploadFile UF WITH (NOLOCK) ON UF.Id = DS.FileId AND UF.InActiveDateTime IS NULL
		       WHERE DS.[FileId] IN (SELECT x.y.value('(text())[1]', 'uniqueidentifier') FROM @FileIds.nodes('/GenericListOfGuid/ListItems/guid') AS x(y))
				     
		  END
		  ELSE
			RAISERROR (@HavePermission,11, 1)
		   
	 END TRY  
	 BEGIN CATCH 
		
		  EXEC [dbo].[USP_GetErrorInformation]

	END CATCH

END
GO
