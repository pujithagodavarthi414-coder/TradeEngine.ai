  
  
-- EXEC  [dbo].[USP_GetGenericFormRecords] @OperationsPerformedBy = '62722219-fe37-4b8e-b9fd-b70b05fee17c', @FormId = 'a2449d9d-7c43-429c-87d1-1ecd99935e1a'  
  
CREATE PROCEDURE [dbo].[USP_GetGenericFormRecords]  
(  
 @FormId UNIQUEIDENTIFIER = NULL,    
    @OperationsPerformedBy UNIQUEIDENTIFIER,  
    @IsArchived BIT= NULL   
)  
AS  
BEGIN  
  
   SET NOCOUNT ON  
  
   BEGIN TRY  
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
  DECLARE @HavePermission NVARCHAR(250)  = '1' -- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))  
    
  IF (@HavePermission = '1')  
     BEGIN  
      
      
       
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))  
             
           SELECT GFS.Id AS GenericFormSubmittedId  
            ,GFS.FormId  
      ,GFS.CreatedDateTime  
      ,GFS.FormJson  
      ,CASE WHEN GFS.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived  
     FROM GenericFormSubmitted GFS  
    -- INNER Join GenericForm GF ON   GFS.FormId = GF.  
      
          -- WHERE FT.CompanyId = @CompanyId  
          WHERE GFS.InActiveDateTime IS NULL  AND GFS.FormId = @FormId--TODO  
      
    AND (@IsArchived IS NULL   
        OR (@IsArchived = 1 AND GFS.InActiveDateTime IS NOT NULL)   
     OR (@IsArchived = 0 AND GFS.InActiveDateTime IS NULL))  
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