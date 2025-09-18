  
-- Author       Aruna   
-- Created      '2021-06-03 00:00:00.000'    
-- Purpose      To set resigned user status  
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved    
-------------------------------------------------------------------------------    
      
--EXEC [dbo].[USP_UpdateResignedUserStatus] @EmployeeId='3AB95122-0601-4866-9B7B-4A0885EFC3EA'    
    
CREATE PROCEDURE [dbo].[USP_UpdateResignedUserStatus]    
(    
    @EmployeeId UNIQUEIDENTIFIER    
)    
AS    
BEGIN    
BEGIN TRY    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

 DECLARE @LastDate Datetime =( Select ER.LastDate from EmployeeResignation ER
 INNER JOIN Employee EMP ON EMP.id = ER.EmployeeId
 where EMP.id = @EmployeeId)
 
 IF(@LastDate IS NOT NULL)
 BEGIN
 DECLARE @UserId UNIQUEIDENTIFIER  = (select U.Id from Employee EMP
     INNER JOIN [User] U ON U.Id = EMP.UserId  where EMP.id = @EmployeeId) --CONVERT(VARCHAR(10), ER.LastDate, 111) = CONVERT(VARCHAR(10), getdate(), 111)    
         
UPDATE ActivityTrackerDesktop SET InActiveDateTime = GETUTCDATE() WHERE Id =     
         (SELECT TOP 1 DesktopId FROM [User] WHERE Id = @UserId)   
    
UPDATE [dbo].[User] SET  InActiveDateTime = GETUTCDATE(), IsActive = 0, UpdatedDateTime = GETUTCDATE(),DesktopId =null WHERE Id = @UserId         
  
 END
    
 END TRY      
        
 BEGIN CATCH     
              
    THROW    
            
    END CATCH    
END