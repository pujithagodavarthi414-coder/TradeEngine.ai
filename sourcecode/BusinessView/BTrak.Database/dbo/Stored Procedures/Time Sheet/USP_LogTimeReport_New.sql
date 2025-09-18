-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-18 00:00:00.000'
-- Purpose      To Get The LogTime Report By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_LogTimeReport_New] @CompanyId='4AFEB444-E826-4F95-AC41-2175E36A0C16',@PageNo=1,@PageSize=10
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_LogTimeReport_New]
	(
   @SelectedDate DATETIME = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @TeamLeadId UNIQUEIDENTIFIER = NULL,
   @PageLoad BIT = 1,
   @CompanyId UNIQUEIDENTIFIER,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @PageNo INT,
   @PageSize INT
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@TeamLeadId,(SELECT OBJECT_NAME(@@PROCID))))
              
  IF (@HavePermission = '1')
  BEGIN

   IF(@PageLoad = 1)
    BEGIN
        IF((SELECT IsAdmin FROM [User] WHERE Id = @TeamLeadId) = 1)
            SET @TeamLeadId = NULL
   END

  DECLARE @IsReporting INT = (SELECT COUNT(Id) FROM EmployeeReportTo WHERE ReportToEmployeeId = (SELECT Id FROM Employee WHERE UserId = @TeamLeadId))
 
  DECLARE @CompliantHours NUMERIC(10,3) = (SELECT CAST([Value] AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like '%SpentTime%' AND [CompanyId] = @CompanyId)
  
  IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
  
  IF(@IsReporting <> 0)
  BEGIN
        SELECT * FROM [dbo].[Ufn_GetLogTimeReport_New](@SelectedDate,@BranchId,@TeamLeadId,@CompanyId,@EntityId,@CompliantHours)
		WHERE UserId <> @TeamLeadId 
		  ORDER BY UserName DESC
		  OFFSET ((@PageNo - 1) * @PageSize) ROWS
	      FETCH NEXT @PageSize ROWS ONLY;
  END
  ELSE
  BEGIN
	SELECT * FROM [dbo].[Ufn_GetLogTimeReport_New](@SelectedDate,@BranchId,@TeamLeadId,@CompanyId,@EntityId,@CompliantHours)
	 ORDER BY UserName DESC
		  OFFSET ((@PageNo - 1) * @PageSize) ROWS
	      FETCH NEXT @PageSize ROWS ONLY;

   
  END
  END
	  ELSE
      BEGIN
              
		RAISERROR (@HavePermission,11, 1)
                    
     END 
END
