 -------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-16 00:00:00.000'
-- Purpose      To Get Languages select * from Language
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetLanguages] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLanguages]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @LanguageId UNIQUEIDENTIFIER = NULL,
	 @LanguageName NVARCHAR(250) = NULL,
	 @IsArchived BIT = NULL,    
     @SearchText NVARCHAR(250) = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		 		          
         IF (@HavePermission = '1')
         BEGIN
 
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		 
            IF(@SearchText = '') SET @SearchText = NULL
            
            SET @SearchText = '%'+ @SearchText +'%'
 
            IF(@LanguageId = '00000000-0000-0000-0000-000000000000') SET @LanguageId = NULL
            
            SELECT L.Id AS LanguageId,
		   	       L.CompanyId,
		   	       L.LanguageName,
		   	       L.InActiveDateTime,
		   	       L.CreatedDateTime ,
		   	       L.CreatedByUserId,
		   	       L.[TimeStamp],
				  (CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(*) OVER()
           FROM [Language] AS L		        
           WHERE L.CompanyId = @CompanyId
		        AND (@SearchText IS NULL OR (L.LanguageName LIKE  '%'+ @SearchText +'%'))
		   	    AND (@LanguageId IS NULL OR L.Id = @LanguageId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND L.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND L.InActiveDateTime IS NULL))
		   	    
           ORDER BY L.LanguageName ASC

 
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
 Go