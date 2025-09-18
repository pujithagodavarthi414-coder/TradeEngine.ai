---------------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-02-12 00:00:00.000'
-- Purpose      To get custom tags
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------
-- EXEC [USP_GetCustomTags] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@ReferenceId = ''
----------------------------------------------------------------------------------------
CREATE PROCEDURE [USP_GetCustomTags]
(
 @ReferenceId UNIQUEIDENTIFIER = NULL,
 @Tag NVARCHAR(250) = NULL,
 @TagsList  NVARCHAR(MAX) = NULL,
 @SearchText NVARCHAR(250) = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN

		DECLARE @ReferencesCount INT = (SELECT COUNT(1) FROM CustomTags WHERE ReferenceId = @ReferenceId )

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       

			   SELECT T.TagName AS Tag,T.Id AS TagId,Id
			    FROM Tags T 
				WHERE (@Tag IS NULL OR Id = @Tag)
					  AND T.InActiveDateTime IS NULL
				      AND T.CompanyId = @CompanyId
					  AND (@SearchText IS NULL OR (TagName LIKE '%' + @SearchText + '%'))
					  AND (@TagsList IS NULL OR T.TagName IN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@TagsList,',')))
					  AND (@ReferenceId IS NULL OR T.Id IN (SELECT TagId FROM CustomTags WHERE ReferenceId = @ReferenceId))
			 ORDER BY T.[Order],T.TagName
			
		END
		ELSE

			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
