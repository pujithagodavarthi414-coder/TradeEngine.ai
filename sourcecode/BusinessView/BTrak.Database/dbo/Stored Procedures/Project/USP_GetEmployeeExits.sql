-------------------------------------------------------------------------------  
-- Author       Aruna 
-- Created      '2021-05-27 00:00:00.000'  
-- Purpose      To Get The exit checklist of employee  
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved  
-------------------------------------------------------------------------------  
--EXEC [dbo].[USP_GetEmployeeExits] @OperationsPerformedBy='77D0EB6D-1490-4CAF-9AEF-C71D7D988585'  
-------------------------------------------------------------------------------  
CREATE PROCEDURE [dbo].[USP_GetEmployeeExits]  
(  
   @UserId UNIQUEIDENTIFIER = NULL,  
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
            
    DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT Id FROM Project WHERE ProjectName = 'Exit Project' AND CompanyId = @CompanyId)  
          
           SELECT US.UserStoryName AS ExitName  
                     ,US.OwnerUserId AS AssignedToId  
                    ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS AssignedToName  
                    ,U.ProfileImage AS AssignedToImage  
                    ,USS.[Status]  
              FROM UserStory US  
                   INNER JOIN [User] U On U.Id = US.OwnerUserId  
                INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId  
              WHERE ProjectId = @ProjectId  
                    AND (@UserId IS NULL  
                      OR US.UserStoryName LIKE '%(' + (SELECT EmployeeNumber FROM Employee E WHERE E.UserId = @UserId) + ')%'  
        OR US.OwnerUserId = @UserId)          
       
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