-------------------------------------------------------------------------------  
-- Author       Aruna 
-- Created      '2021-05-27 00:00:00.000'  
-- Purpose      To Get The resigned user list
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved  
-------------------------------------------------------------------------------  
-- EXEC [dbo].[USP_SearchResignedUsers] @OperationsPerformedBy='77D0EB6D-1490-4CAF-9AEF-C71D7D988585'  
-------------------------------------------------------------------------------  
CREATE PROCEDURE [dbo].[USP_SearchResignedUsers]  
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
        
     	 select U.Id, ER.LastDate,U.InActiveDateTime FROM EmployeeResignation AS ER  
     INNER JOIN Employee EMP ON EMP.Id = ER.EmployeeId  
     INNER JOIN [User] U ON U.Id = EMP.UserId  where CONVERT(VARCHAR(10), ER.LastDate, 111) = CONVERT(VARCHAR(10), getdate(), 111)  
       
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