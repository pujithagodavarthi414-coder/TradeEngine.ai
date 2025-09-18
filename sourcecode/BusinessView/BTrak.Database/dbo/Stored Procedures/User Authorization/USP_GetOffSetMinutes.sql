
--Exec  USP_GetOffSetMinutes  @EmployeeId = '3ab95122-0601-4866-9b7b-4a0885efc3ea'
CREATE PROCEDURE [dbo].[USP_GetOffSetMinutes]      
(      
    @EmployeeId UNIQUEIDENTIFIER      
)      
AS      
BEGIN      
BEGIN TRY      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED       
   
   DECLARE @OffsetMinutes BIGINT = 0

 select TOP 1  @OffsetMinutes = T.OffsetMinutes from Employee EMP 
 INNER JOIN [user] U on U.Id = EMP.UserId 
 INNER JOIN TimeZone  T on U.TimeZoneId = T.Id
 where (EMP.Id = @EmployeeId )

 IF(@OffsetMinutes IS NULL OR @OffsetMinutes = 0)
BEGIN

select  @OffsetMinutes = T.OffsetMinutes FROM  [user] U 
 INNER JOIN TimeZone  T on U.TimeZoneId = T.Id
 where (U.Id = @EmployeeId )
   
  END

  SELECT @OffsetMinutes OffsetMinutes

 END TRY        
          
 BEGIN CATCH       
                
    THROW      
              
    END CATCH      
END