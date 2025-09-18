-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-27 00:00:00.000'
-- Purpose      To Get LeaveTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetLeaveTypes_New]@OperationsPerformedBy='AFE9F662-F258-4875-AA80-A3384A8E27CC',@SortDirection=N'DESC',@IsApplyLeavePage=1
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLeaveTypes_New]
(
  @LeaveTypeId UNIQUEIDENTIFIER = NULL,
  @LeaveTypeName NVARCHAR(100) = NULL,
  @IsArchived BIT = 0,
  @IsApplyLeavePage BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @SearchText NVARCHAR(600) = NULL,
  @SortBy NVARCHAR(40) = NULL,
  @SortDirection NVARCHAR(20) = 'ASC',
  @PageNumber INT = 1,
  @PageSize INT = 10,
  @UserId UNIQUEIDENTIFIER = NULL
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
		   
		    SET @SearchText = '%'+@SearchText + '%'
		   
	         IF(@LeaveTypeId = '00000000-0000-0000-0000-000000000000') SET  @LeaveTypeId = NULL
		     
	         IF(@LeaveTypeName = '') SET  @LeaveTypeName = NULL
		     
			 SELECT LeaveTypeId
			        ,MasterLeaveTypeName
					,MasterLeaveTypeId
					,LeaveTypeName
					,LeaveTypeShortName
					,[TimeStamp]
					,LeaveTypeColor
					,NoOfLeaves
					,IsArchived
					,IsToIncludeHolidays
					,LeaveFrequencyCount
					,TotalCount = COUNT(1) OVER()
			 FROM 
			 (
	          SELECT LT.Id AS LeaveTypeId,
				    MLT.MasterLeaveTypeName,
				    LT.MasterLeaveTypeId,
                    LT.LeaveTypeName,
                    LT.LeaveShortName AS LeaveTypeShortName,
				    LT.[TimeStamp],
					LT.LeaveTypeColor,
					ISNULL(LF.Leaves,0) AS NoOfLeaves,
                    CASE WHEN LT.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
					LT.IsIncludeHolidays AS IsToIncludeHolidays,
					LTInner.LeaveTypesCount AS LeaveFrequencyCount
                    FROM LeaveType LT
				    INNER JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId
					LEFT JOIN (SELECT COUNT(1) LeaveTypesCount,LeaveTypeId FROM LeaveFrequency WHERE InActiveDateTime IS NULL 
					           GROUP BY LeaveTypeId) LTInner ON LTInner.LeaveTypeId = LT.Id
                    LEFT JOIN (SELECT LeaveTypeId,SUM(NoOfLeaves) AS Leaves 
					                  FROM LeaveFrequency LF 
									  WHERE  InActiveDateTime IS NULL
									  GROUP BY LeaveTypeId) LF ON LF.LeaveTypeId = LT.Id
                    WHERE LT.CompanyId = @CompanyId
                      AND (@LeaveTypeId IS NULL OR LT.Id = @LeaveTypeId)
                      AND (@IsArchived IS NULL OR (@IsArchived = 0 AND LT.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND LT.InActiveDateTime IS NOT NULL))
                      AND (@IsApplyLeavePage IS NULL OR @IsApplyLeavePage = 0 OR (@IsApplyLeavePage = 1 AND LT.Id IN (SELECT [LeaveTypeId] from [dbo].[Ufn_GetEligibleLeaveTypes](ISNULL(@UserId,@OperationsPerformedBy)))))
			   ) Temp
			WHERE (@SearchText IS NULL OR (LeaveTypeName LIKE @SearchText)
			                             OR (LeaveTypeShortName LIKE @SearchText)
										 OR (CAST(NoOfLeaves AS NVARCHAR(50)) LIKE @SearchText
										 OR (CAST(LeaveFrequencyCount AS NVARCHAR(50)) LIKE @SearchText
										 )))
		    ORDER BY 
			        CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE  WHEN(@SortBy = 'LeaveTypeShortName') THEN CAST(LeaveTypeShortName AS SQL_VARIANT)
						       WHEN(@SortBy = 'LeaveTypeName') THEN CAST(LeaveTypeName AS SQL_VARIANT)
							   WHEN @SortBy = 'NoOfLeaves' THEN NoOfLeaves
						       WHEN(@SortBy = 'LeaveFrequencyCount') THEN LeaveFrequencyCount
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                         CASE  WHEN(@SortBy = 'LeaveTypeShortName') THEN CAST(LeaveTypeShortName AS SQL_VARIANT)
						       WHEN(@SortBy = 'LeaveTypeName') THEN CAST(LeaveTypeName AS SQL_VARIANT)
							   WHEN @SortBy = 'NoOfLeaves' THEN NoOfLeaves
						       WHEN(@SortBy = 'LeaveFrequencyCount') THEN LeaveFrequencyCount
                          END
                      END DESC 

					OFFSET ((@PageNumber - 1) * @PageSize) ROWS
					
		            FETCH NEXT @PageSize ROWS ONLY	
		      
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