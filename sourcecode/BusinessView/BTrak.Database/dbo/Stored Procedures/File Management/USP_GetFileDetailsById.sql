-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-04 00:00:00.000'
-- Purpose      To Get the FileDetails By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Updated By   Sai Praneeth Mamidi
-- Created      '2019-11-12 00:00:00.000'
-- Purpose      To Get the File Details By Id
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetFileDetailsById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@FileIdsXml='<GenericListOfNullableOfGuid xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
---<ListItems>
--<guid>30a67250-9db2-4a21-bb03-1e9d02430110</guid>
--<guid>e26c18de-633c-4b50-b335-4983f46fef13</guid>
--</ListItems>
--</GenericListOfNullableOfGuid>'

CREATE PROCEDURE [dbo].[USP_GetFileDetailsById]
(
	@FileIdsXml XML = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

			CREATE  TABLE #FileIdsTable(
										[FileId] UNIQUEIDENTIFIER,
									   )
			INSERT INTO #FileIdsTable(FileId)
			SELECT  x.y.value('(text())[1]','UNIQUEIDENTIFIER')
					   FROM @FileIdsXml.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT UF.Id AS FileId,
				   UF.[FileName],
				   UF.FileExtension,
				   UF.FilePath,
				   UF.FileSize,  
				   UF.FolderId,
				   UF.StoreId,
				   UF.ReferenceId,
				   UF.ReferenceTypeId,
				   IsArchived = CASE WHEN UF.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
				   UF.CreatedDateTime,
				   UF.CreatedByUserId,
				   UF.[TimeStamp]
			 FROM #FileIdsTable FT WITH (NOLOCK) 
			 JOIN UploadFile UF ON UF.Id = FT.FileId
			 WHERE UF.CompanyId = @CompanyId

		END
        ELSE
        BEGIN
        
                RAISERROR (@HavePermission,11, 1)
                
        END
	END TRY  
	BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

	END CATCH
END