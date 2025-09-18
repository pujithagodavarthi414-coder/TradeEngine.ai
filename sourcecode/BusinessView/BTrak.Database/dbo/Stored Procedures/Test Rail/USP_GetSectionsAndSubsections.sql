-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-28 00:00:00.000'
-- Purpose      To Get Sections And Subsections upto n levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetSectionsAndSubsections] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetSectionsAndSubsections]
(
	@TestSuiteId UNIQUEIDENTIFIER = NULL,
	@operationsPerformedBy UNIQUEIDENTIFIER
)
AS 
SET NOCOUNT ON
BEGIN
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN

			IF(@TestSuiteId = '00000000-0000-0000-0000-000000000000') SET @TestSuiteId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT TSSInner.Id,
			       TSSInner.SectionName AS [Value],
				   TSSInner.ParentSectionId,
				   TSSInner.OriginalName,
				   TSSInner.[TimeStamp],
				   TSSInner.[Description],
				   TSSInner.TestSuiteId,
				   (CASE WHEN TSS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchive
			FROM TestSuiteSection TSS WITH (NOLOCK)
			     CROSS APPLY [dbo].[Ufn_GetMultiSubSections](TSS.Id) TSSInner
				 INNER JOIN TestSuite TS WITH (NOLOCK) ON TS.Id = TSS.TestSuiteId AND TS.InActiveDateTime IS NULL 
				 INNER JOIN Project P WITH (NOLOCK) ON P.Id = TS.ProjectId AND P.InActiveDateTime IS NULL 
			WHERE TSS.ParentSectionId IS NULL 
			      AND (@TestSuiteId IS NULL OR TSS.TestSuiteId = @TestSuiteId)
				  AND TSS.InActiveDateTime IS NULL
				  AND P.CompanyId = @CompanyId
				ORDER BY TSS.CreatedDateTime,TSSInner.Path2
			OPTION (MAXRECURSION 0)


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
GO