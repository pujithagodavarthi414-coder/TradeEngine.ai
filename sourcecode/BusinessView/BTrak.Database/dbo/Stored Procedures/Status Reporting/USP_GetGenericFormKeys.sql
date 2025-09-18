---------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-09-30 00:00:00.000'
-- Purpose      To Get the Generic Form Keys by applying different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetGenericFormKeys] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetGenericFormKeys]
(
	@GenericFormKeyId UNIQUEIDENTIFIER = NULL,		
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@GenericFormId UNIQUEIDENTIFIER = NULL,
	@Key NVARCHAR(150) = NULL,
	@IsArchived BIT= NULL	
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		  
		   IF(@GenericFormKeyId = '00000000-0000-0000-0000-000000000000') SET @GenericFormKeyId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT GFK.Id AS GenericFormKeyId
		          ,GFK.GenericFormId
				  ,GFK.[Key]
				  ,GFK.IsDefault
				  ,GFK.CreatedByUserId
				  ,GFK.CreatedDateTime
				  ,GFK.Label
				  ,CASE WHEN GFK.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived
		   FROM GenericFormKey GFK
		        INNER JOIN GenericForm GF ON GF.Id = GFK.GenericFormId
			    INNER JOIN FormType FT ON FT.Id = GF.FormTypeId
				          AND FT.InActiveDateTime IS NULL
           WHERE FT.CompanyId = @CompanyId
		        AND GFK.InActiveDateTime IS NULL --TODO
				AND (@GenericFormKeyId IS NULL OR GFK.Id = @GenericFormKeyId)
		        AND (@GenericFormId IS NULL OR GFK.GenericFormId = @GenericFormId)
		        AND (@Key IS NULL OR GFK.GenericFormId = @Key)
				AND (@IsArchived IS NULL 
				    OR (@IsArchived = 1 AND GFK.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND GFK.InActiveDateTime IS NULL))
           ORDER BY GFK.[Key] ASC

        END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
