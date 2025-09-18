----------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-02-24 00:00:00.000'
-- Purpose      To Get Custom Application Tag Keys 
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetCustomApplicationTagKeys] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetCustomApplicationTagKeys]
(
	@GenericFormKeyId UNIQUEIDENTIFIER = NULL,
	@GenericFormLabel NVARCHAR(250) = NULL,
	@OperationsPerformedby UNIQUEIDENTIFIER
)
AS
BEGIN
		SET NOCOUNT ON
		SET TRANSACTION ISOLATION  LEVEL READ UNCOMMITTED
		
		BEGIN TRY

			IF(@GenericFormKeyId = '00000000-0000-0000-0000-000000000000') SET @GenericFormKeyId = NULL

			IF(@GenericFormLabel = '') SET @GenericFormLabel = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedby))
			
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN

				SELECT CAK.GenericFormKeyId
					   ,GFK.[Label] AS FilterName
					   ,GFK.[Key] AS FilterKey
				FROM CustomApplicationKey CAK INNER JOIN GenericFormKey GFK ON GFK.Id = CAK.GenericFormKeyId
					            AND GFK.InActiveDateTime IS NULL
					            AND CAK.InActiveDateTime IS NULL
								AND CAK.IsTag = 1 AND CAK.IsTag IS NOT NULL
					 INNER JOIN GenericForm GF ON GF.Id = CAK.GenericFormId
					            AND GF.InActiveDateTime IS NULL
					 INNER JOIN FormType FT ON FT.Id = GF.FormTypeId
					            AND FT.InActiveDateTime IS NULL
				WHERE FT.CompanyId = @CompanyId
				      AND (@GenericFormKeyId IS NULL OR CAK.GenericFormKeyId = @GenericFormKeyId)
				      AND (@GenericFormLabel IS NULL OR GFK.Label LIKE '%' + @GenericFormLabel + '%')
				GROUP BY CAK.GenericFormKeyId,GFK.[Label],GFK.[Key] 

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