-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-02-01 00:00:00.000'
-- Purpose      To Get Custom Application Tags
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_GetCustomApplicationTag] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
 
CREATE PROCEDURE [dbo].[USP_GetCustomApplicationTag]
(
	@CustomApplicationTagId UNIQUEIDENTIFIER = NULL,
	@SearchTagText NVARCHAR(800),
	@GenericFormKeyId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@CustomApplicationTagId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationTagId = NULL
		
		IF(@SearchTagText = '') SET @SearchTagText = NULL
		
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy AND InActiveDateTime IS NULL AND IsActive = 1)

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		IF (@HavePermission = '1')
        BEGIN
			
			SELECT CAT.Id AS CustomApplicationTagId
			       ,CAT.TagValue
			       ,CA.CustomApplicationName
				   ,GF.FormName
				   ,GFK.[Key]
			FROM CustomApplicationTag CAT
			     INNER JOIN GenericFormSubmitted GFS ON GFS.Id = CAT.GenericFormSubmittedId
				            AND GFS.InActiveDateTime IS NULL
			     INNER JOIN CustomApplication CA ON CA.Id = GFS.CustomApplicationId
				            AND CAT.InActiveDateTime IS NULL
				            AND CA.InActiveDateTime IS NULL
				 INNER JOIN GenericForm GF ON GF.Id = GFS.FormId
				            AND GF.InActiveDateTime IS NULL
				 INNER JOIN FormType FT ON FT.Id = GF.FormTypeId 
				            AND FT.CompanyId = @CompanyId
							AND FT.InActiveDateTime IS NULL
				 INNER JOIN GenericFormKey GFK ON GFK.Id = CAT.GenericFormKeyId
							AND GFK.InActiveDateTime IS NULL
			WHERE (@CustomApplicationTagId IS NULL OR CAT.Id = @CustomApplicationTagId)
			      AND (@GenericFormKeyId IS NULL OR CAT.GenericFormKeyId = @GenericFormKeyId)
			       AND (@SearchTagText IS NULL OR CAT.TagValue LIKE ('%' + @SearchTagText + '%'))

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