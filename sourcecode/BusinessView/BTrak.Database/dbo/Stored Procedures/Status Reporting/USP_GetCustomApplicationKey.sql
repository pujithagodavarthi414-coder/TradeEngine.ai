	---------------------------------------------------------------------------
	-- Author       Geetha Ch
	-- Created      '2019-09-30 00:00:00.000'
	-- Purpose      To Get the Custom Application Key by applying different filters
	-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
	-------------------------------------------------------------------------------
	--EXEC  [dbo].[USP_GetCustomApplicationKey] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@CustomApplicationId='B3F38F05-CAE1-4597-BCA4-9CC18E71BB2D'

	CREATE PROCEDURE [dbo].[USP_GetCustomApplicationKey]
	(
		 @CustomApplicationId UNIQUEIDENTIFIER = NULL
		,@OperationsPerformedBy UNIQUEIDENTIFIER
		,@IsArchived BIT = NULL
	)
	AS
	BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
			IF (@HavePermission = '1')
			BEGIN
			 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				 SELECT CAK.Id AS CustomApplicationKeyId
					  ,GFK.[Key]
					  ,CAK.CustomApplicationId
					  ,CAK.GenericFormKeyId
					  ,CAK.IsDefault
                      ,CAK.IsPrivate
					  ,CAK.IsTag
                      ,CAK.IsTrendsEnable
				 FROM CustomApplicationKey CAK
					  INNER JOIN GenericFormKey GFK ON GFK.Id = CAK.GenericFormKeyId AND GFK.InActiveDateTime IS NULL
					  INNER JOIN GenericForm GF ON GF.Id = GFK.GenericFormId
					  INNER JOIN FormType FT ON FT.Id = GF.FormTypeId AND FT.CompanyId = @CompanyId
				 WHERE (@CustomApplicationId IS NULL OR  CAK.CustomApplicationId  = @CustomApplicationId)
					   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CAK.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CAK.InActiveDateTime IS NULL))
					   
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