-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-14 00:00:00.000'
-- Purpose      To Get the Employee Presence By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetEmployeePresence_New]  @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@PageSize = 100

CREATE PROCEDURE [dbo].[USP_GetEmployeePresence_New] 
(
   @BranchId UNIQUEIDENTIFIER = NULL,
   @WorkingStatus VARCHAR(100) =  NULL,
   @TeamLeadId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection NVARCHAR(100)=NULL,
   @SearchText  NVARCHAR(100)=NULL,
   @PageNumber INT = 1,
   @PageSize INT = 10
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY 
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	       DECLARE @CompanyId  UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	       SET @SearchText = '%'+ @SearchText+'%'
   	       
           IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL
	       
           IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000') SET @TeamLeadId = NULL
	       
           IF(@WorkingStatus = '') SET @WorkingStatus = NULL

		   IF(@SortDirection IS NULL )
	       BEGIN
		   
	       	   SET @SortDirection = 'ASC'
		   
	       END
	       
	       DECLARE @OrderByColumn NVARCHAR(250) 
		   
	       IF(@SortBy IS NULL)
	       BEGIN
		   
	       	   SET @SortBy = 'FullName'
		   
	       END
	       ELSE
	       BEGIN
		   
	       	   SET @SortBy = @SortBy
		   
	       END
    
               SELECT R.UserId,
			          [Status],
					  FullName,
			          TotalCount = COUNT(1) OVER() 
					  FROM (SELECT UserId,
			                         FullName,
					                 ISNULL([Status],'Outside')[Status]
									 
					    FROM(SELECT Z.UserId,
					                FullName, 
								    CASE WHEN BreakIn <= GETUTCDATE() AND BreakOut IS NULL THEN 'OutSide' ELSE Z.[Status] END AS [Status]
                              FROM (SELECT T.UserId,
							               FullName,
										   CASE WHEN LA.Id IS NOT NULL THEN     
                                           CASE WHEN LA.LeaveTypeId IN (SELECT Id FROM LeaveType WHERE 1=1) THEN 'InSide' ELSE 'OutSide' END 
                                           ELSE T.[Status] END AS [Status]
                                    FROM (SELECT Temp.UserId,
									             FullName,
                                                 CASE WHEN TS.Id IS NOT NULL THEN 
												 CASE WHEN TS.OutTime IS NOT NULL THEN 'OutSide'
													  WHEN (TS.LunchBreakStartTime IS NOT NULL AND TS.LunchBreakEndTime IS NULL AND TS.OutTime IS NULL) THEN 'OutSide' 
													  WHEN (TS.LunchBreakStartTime IS NOT NULL AND TS.LunchBreakEndTime IS NOT NULL AND TS.OutTime IS NOT NULL) THEN 'OutSide'
													  ELSE 'InSide' END ELSE Temp.[Status] 
											     END AS [Status]
                                           FROM (SELECT  U.Id AS UserId,ISNULL(U.FirstName,'') +' ' + ISNULL(U.SurName,'') AS FullName,NULL AS [Status]
                                                  FROM [User] U WITH (NOLOCK)
												  INNER JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InactiveDateTime IS NULL
                                                  LEFT JOIN EmployeeBranch EB WITH (NOLOCK) ON EB.EmployeeId = E.Id AND E.InactiveDateTime IS NULL
												            AND ActiveTo IS NULL 
                                                            AND (@TeamLeadId IS NULL OR U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@TeamLeadId,@CompanyId)))
                                           WHERE IsActive = 1 AND U.CompanyId = @CompanyId) Temp  
										   LEFT JOIN TimeSheet TS WITH (NOLOCK) ON Temp.UserId = TS.UserId  AND TS.[Date] = CONVERT(DATE,GETUTCDATE())) T
                                           LEFT JOIN LeaveApplication LA WITH (NOLOCK) ON T.UserId = LA.UserId 
										        AND CONVERT(DATE,GETUTCDATE()) BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo) Z 
                                           LEFT JOIN UserBreak UBT WITH (NOLOCK) ON Z.UserId = UBT.UserId  AND UBT.[Date] = CONVERT(DATE,GETUTCDATE()))R)R
										   JOIN Employee EY WITH (NOLOCK) ON EY.UserId = R.UserId  AND EY.InActiveDateTime IS NULL
										   JOIN EmployeeBranch EB ON EB.EmployeeId = EY.Id  AND EB.ActiveTo IS NULL
                                           WHERE (@WorkingStatus IS NULL OR R.[Status] = @WorkingStatus) 
												  AND ( @BranchId IS NULL OR EB.BranchId  = @BranchId)
												  AND (@SearchText IS NULL 
												       OR (CONVERT(NVARCHAR(250), R.UserId) LIKE  @SearchText)
												       OR (CONVERT(NVARCHAR(250), R.FullName) LIKE  @SearchText)
							                           OR (CONVERT(NVARCHAR(250), R.[Status]) LIKE  @SearchText)
													   )
                                           GROUP BY R.UserId,FullName,[Status]       
                                           ORDER BY 
										   CASE WHEN (@SortDirection= 'ASC') THEN
                                                CASE WHEN @SortBy = 'UserId'  THEN CONVERT(VARCHAR(200),R.UserId)
                                                     WHEN @SortBy = 'FullName' THEN CONVERT(VARCHAR(200),R.FullName)
                                                     WHEN @SortBy = 'Status' THEN CONVERT(VARCHAR(200),R.[Status])
                                                 END
                                            END ASC,
                                           CASE WHEN @SortDirection = 'DESC' THEN
                                                 CASE WHEN @SortBy = 'UserId'  THEN CONVERT(VARCHAR(200),R.UserId)
                                                      WHEN @SortBy = 'FullName' THEN CONVERT(VARCHAR(200),R.FullName)
                                                      WHEN @SortBy = 'Status' THEN CONVERT(VARCHAR(200),R.[Status])
                                                 END
                                          END DESC

					OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                    
                    FETCH NEXT @PageSize ROWS ONLY

     END TRY  
     BEGIN CATCH 
        
           THROW

    END CATCH
END