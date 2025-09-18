-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-09-17 00:00:00.000'
-- Purpose      To Get the Total Time Usage Of Applications By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTotalTimeUsageOfApplications] @UserId = '
--<ListItems>
--<ListRecords>
--<ListItem>
--	<ListItemId>127133F1-4427-4149-9DD6-B02E0E036971</ListItemId>
--</ListItem>
--</ListRecords>
--</ListItems>',@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@DateFrom='2019-09-13',@DateTo ='2019-09-21'

CREATE PROCEDURE [dbo].[USP_GetTotalTimeUsageOfApplications](
@UserId XML = NULL ,
@RoleId XML = NULL,
@BranchId XML = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER ,
@DateFrom DATE ,
@DateTo DATE = NULL,
@SortBy NVARCHAR(250) = NULL,
@SortDirection NVARCHAR(50) = NULL,
@PageNo INT = 1,
@PageSize INT = 10,
@IsTrailExpired BIT = NULL,
@IsForDashboard BIT = NULL
)
AS
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   BEGIN TRY
		IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

		DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = (@OperationsPerformedBy))

        IF (@HavePermission = '1')
        BEGIN

		IF (@DateTo IS NULL)
		BEGIN
			SET @DateTo = @DateFrom
		END
		IF(@SortDirection IS NULL OR @SortDirection = '')
		BEGIN
			SET @SortDirection = 'ASC'
		END

		IF(@IsTrailExpired = 1) SET @DateFrom = DATEADD(DAY,-6, CONVERT(DATE,GETDATE())); --TODO

		DECLARE @OrderByColumn NVARCHAR(250) 

		IF(@IsForDashboard IS NULL) SET @IsForDashboard = 0

		IF(@SortBy IS NULL OR @SortBy = '')
		BEGIN
			SET @SortBy = 'name'
		END
		ELSE
		BEGIN
			SET @SortBy = @SortBy
		END
			   SELECT UserId,[Name],ProfileImage,OperationDate
			          ,[NeutralInMS] / 1000.0 [Neutral]
					  ,[ProductiveInMS] / 1000.0 [Productive]
					  ,[UnProductiveInMs] / 1000.0 [UnProductive]
					  ,IdleInMin * 60 AS Idle
					  ,(([NeutralInMS] + [ProductiveInMS] + [UnProductiveInMs]) / 1000.0) + (IdleInMin * 60) TotalTime
					  ,TotalCount
			   FROM (
				  SELECT UTS.UserId
				         ,U.[Name],U.ProfileImage
						,UTS.CreatedDateTime AS OperationDate
				        ,UTS.Neutral AS [NeutralInMS]
				        ,UTS.Productive AS [ProductiveInMS]
				        ,UTS.UnProductive AS [UnProductiveInMs]
				        ,UTS.IdleInMinutes AS IdleInMin
						,U.TotalCount
				  FROM UserActivityTimeSummary UTS
				       INNER JOIN 
					   ( SELECT Filters.UserId,CONCAT(U.FirstName,' ',U.SurName) AS [Name],U.ProfileImage,TotalCount = COUNT(1) OVER() 
					     FROM (SELECT UserId FROM [dbo].[Ufn_TrackingUserList](@RoleId, @BranchId, @UserId, @OperationsPerformedBy, NULL)) Filters --ON Filters.UserId = UTS.UserId
						 INNER JOIN [User] U ON U.Id = Filters.UserId 
						 ORDER BY CASE WHEN @SortDirection = 'ASC' THEN U.FirstName END ASC
						          ,CASE WHEN @SortDirection = 'DESC' THEN U.FirstName END DESC ,U.SurName ASC
								  OFFSET ((@PageNo - 1) * @PageSize) ROWS 
							  FETCH NEXT @PageSize ROWS ONLY
						) U ON U.UserId = UTS.UserId
				  
				  WHERE UTS.CompanyId = @CompanyId
						 AND UTS.CreatedDateTime BETWEEN @DateFrom AND @DateTo
				 --GROUP BY UTS.UserId,CONCAT(U.FirstName,' ',U.SurName),U.ProfileImage,UTS.CreatedDateTime
			  ) T
			 
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
GO
