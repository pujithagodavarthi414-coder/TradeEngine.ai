-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get the permissions History Details By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetPermissions] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPermissions]
(
   @PermissionId  UNIQUEIDENTIFIER = NULL, 
   @UserId  UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy  UNIQUEIDENTIFIER ,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection NVARCHAR(100)=NULL,
   @SearchText  NVARCHAR(100)=NULL,
   @PageNumber INT = 1,
   @PageSize INT = 10,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @PermissionReasonId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

        IF (@HavePermission = '1')
        BEGIN
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        IF(@PermissionId = '00000000-0000-0000-0000-000000000000') SET  @PermissionId = NULL

        IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL

         SET @SearchText ='%'+ @SearchText +'%'

         SELECT P.Id AS PermissionId,
                P.UserId,
                P.[Date],               
                P.Duration,
                P.DurationInMinutes,
                P.IsMorning,
                ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'') AS FullName,
                U.ProfileImage,
                P.PermissionReasonId AS ReasonId,
                PR.ReasonName,
                P.CreatedDateTime,
                P.CreatedByUserId,
                P.UpdatedDateTime,
                P.UpdatedByUserId,
                CASE WHEN P.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived,
                P.[Timestamp],
                TotalCount = COUNT(1) OVER()
           FROM [dbo].[Permission] P WITH (NOLOCK)
                INNER JOIN [User] U WITH (NOLOCK) ON P.UserId = U.Id 
				INNER JOIN [Employee] E ON E.UserId = U.Id
	            INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                       AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                           AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                INNER JOIN [PermissionReason] PR ON P.PermissionReasonId = PR.Id 
           WHERE U.CompanyId = @CompanyId 
                AND P.InactiveDateTime IS NULL
                AND (@PermissionId IS NULL OR P.Id = @PermissionId)
                AND (@PermissionReasonId IS NULL OR P.PermissionReasonId = @PermissionReasonId)
                AND (@UserId IS NULL OR P.UserId = @UserId)
                AND (@DateFrom IS NULL OR P.[Date] >= CONVERT(DATE,@DateFrom))
                AND (@DateTo IS NULL OR P.[Date] <= CONVERT(DATE,@DateTo))
                AND (@SearchText IS NULL OR (CONVERT(NVARCHAR(250),P.[Date]) LIKE @SearchText)
                                         OR (CONVERT(NVARCHAR(250),P.Duration) LIKE @SearchText)
                                         OR (CONVERT(NVARCHAR(250),P.DurationInMinutes) LIKE @SearchText)
                                         OR (CONVERT(NVARCHAR(250),P.IsMorning) LIKE @SearchText)
                                         OR ((U.FirstName+' '+U.SurName) LIKE @SearchText)
                                         OR (CONVERT(NVARCHAR(250),P.PermissionReasonId) LIKE @SearchText)
                                         OR (CONVERT(NVARCHAR(250),PR.ReasonName) LIKE @SearchText)
                                         OR (CONVERT(NVARCHAR(250),P.CreatedByUserId) LIKE @SearchText)
                                         OR (CONVERT(NVARCHAR(250),P.UpdatedByUserId) LIKE @SearchText)
                                         OR (CONVERT(NVARCHAR(250),P.CreatedDateTime,121) LIKE @SearchText)
                                           OR (CONVERT(NVARCHAR(250),P.UpdatedDateTime,121) LIKE @SearchText))
            ORDER BY  CASE WHEN( @SortDirection = 'DESC' OR @SortDirection IS NULL )THEN
                                                          CASE  WHEN @SortBy = 'UserId' THEN CONVERT(varchar(200),P.UserId)
                                                                WHEN @SortBy = 'Duration' THEN CONVERT(varchar(200),P.Duration)
                                                                WHEN @SortBy = 'DurationInMinutes' THEN CONVERT(varchar(200),P.DurationInMinutes)
                                                                WHEN @SortBy = 'IsMorning' THEN CONVERT(varchar(200),P.IsMorning)
                                                                WHEN @SortBy = 'FullName' THEN CONVERT(varchar(200),(U.FirstName+' '+U.SurName))
                                                                WHEN @SortBy = 'PermissionReasonId' THEN CONVERT(varchar(200),P.PermissionReasonId)
                                                                WHEN @SortBy = 'ReasonName' THEN CONVERT(varchar(200),PR.ReasonName)
                                                                WHEN @SortBy = 'Date' THEN CONVERT(varchar(200),P.[Date],101)
                                                                WHEN @SortBy = 'CreatedDateTime' THEN CONVERT(varchar(200),P.CreatedDateTime,101)
                                                                WHEN @SortBy = 'UpdatedDateTime' THEN CONVERT(varchar(200),P.UpdatedDateTime,121)
                                                                WHEN @SortBy IS NULL THEN CONVERT(varchar(200),P.[Date],101)
                                                           END
                                    END DESC,
                                    CASE WHEN @SortDirection = 'ASC' THEN                                                                
                                                          CASE  WHEN @SortBy = 'UserId' THEN CONVERT(varchar(200),P.UserId)
                                                                WHEN @SortBy = 'Duration' THEN CONVERT(varchar(200),P.Duration)
                                                                WHEN @SortBy = 'DurationInMinutes' THEN CONVERT(varchar(200),P.DurationInMinutes)
                                                                WHEN @SortBy = 'IsMorning' THEN CONVERT(varchar(200),P.IsMorning)
                                                                WHEN @SortBy = 'FullName' THEN CONVERT(varchar(200),(U.FirstName+' '+U.SurName))
                                                                WHEN @SortBy = 'PermissionReasonId' THEN CONVERT(varchar(200),P.PermissionReasonId)
                                                                WHEN @SortBy = 'ReasonName' THEN CONVERT(varchar(200),PR.ReasonName)
                                                                WHEN @SortBy = 'Date' THEN CONVERT(varchar(200),P.[Date],101)
                                                                WHEN @SortBy = 'CreatedDateTime' THEN CONVERT(varchar(200),P.CreatedDateTime,101)
                                                                WHEN @SortBy = 'UpdatedDateTime' THEN CONVERT(varchar(200),P.UpdatedDateTime,121)
                                                           END
                                      END ASC
                OFFSET ((@PageNumber - 1) * @PageSize) ROWS
                FETCH NEXT @PageSize ROWS ONLY
            END
            ELSE
                
                RAISERROR(@HavePermission,11,1)
    
     END TRY  
     BEGIN CATCH 
        
        THROW
    END CATCH
END
GO