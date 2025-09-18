-------------------------------------------------------------------------------  
-- Author       Aruna
-- Created      '2021-05-27 00:00:00.000'  
-- Purpose      To Get The exit titles  
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved  
-------------------------------------------------------------------------------  
--EXEC [dbo].[USP_GetExitConfigurations] @OperationsPerformedBy='77D0EB6D-1490-4CAF-9AEF-C71D7D988585'  
-------------------------------------------------------------------------------  
CREATE PROCEDURE [dbo].[USP_GetExitConfigurations]  
(  
   @OperationsPerformedBy UNIQUEIDENTIFIER  
)  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  BEGIN TRY  
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
   DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))  
  
      IF (@HavePermission = '1')  
      BEGIN  
        
       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))  
          
             SELECT IC.Id AS ExitId,  
             IC.CompanyId,  
             IC.ExitName,  
        IC.IsShow,  
        CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,  
        IC.InActiveDateTime,  
             IC.CreatedDateTime,   
             IC.CreatedByUserId,  
             IC.UpdatedDateTime,  
             IC.UpdatedByUserId,  
        IC.[TimeStamp],  
             TotalCount = COUNT(1) OVER()  
            FROM ExitConfiguration IC WITH (NOLOCK)  
            WHERE IC.CompanyId = @CompanyId   
      AND (InActiveDateTime IS NULL)  
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