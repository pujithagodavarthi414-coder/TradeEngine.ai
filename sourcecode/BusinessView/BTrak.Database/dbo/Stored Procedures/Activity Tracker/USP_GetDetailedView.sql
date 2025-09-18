-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-09-17 00:00:00.000'
-- Purpose      To Get the Time Usage Of Websites and Applications By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetDetailedView] @UserId = '
--<ListItems>
--<ListRecords>
--<ListItem>
--	<ListItemId>127133F1-4427-4149-9DD6-B02E0E036971</ListItemId>
--</ListItem>
--</ListRecords>
--</ListItems>',@OperationPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @RoleId = '<ListItems>
--<ListRecords>
--<ListItem>
--	<ListItemId>4D5ADF0F-88DF-462C-A987-38AC05AEAB0C</ListItemId>
--</ListItem>
--</ListRecords>
--</ListItems>',@DateFrom='2019-11-26',@DateTo='2019-11-27'

CREATE PROCEDURE [dbo].[USP_GetDetailedView](
@UserId XML = NULL ,
@RoleId XML = NULL,
@BranchId XML = NULL,
@OperationPerformedBy UNIQUEIDENTIFIER,
@DateFrom DATE = NULL,
@DateTo DATE = NULL,
@SearchText [NVARCHAR](800) = NULL,
@SortBy NVARCHAR(250) = NULL,
@SortDirection NVARCHAR(50) = NULL,
@PageNo INT = 1,
@PageSize INT = 10,
@IsApp BIT = NULL,
@IsTrailExpired BIT = NULL
)
AS
BEGIN
SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   BEGIN TRY
		IF (@OperationPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationPerformedBy = NULL

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationPerformedBy)

		DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = (@OperationPerformedBy))
		
		DECLARE @NutralApplicationType UNIQUEIDENTIFIER = 'A5149B84-7074-4098-A1E4-6C218CA4DE5D' -- Neutral

		DECLARE @CanAccessAllEmployee INT = (SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationPerformedBy)

        IF (@HavePermission = '1')
        BEGIN
				IF(@SortDirection IS NULL )
				BEGIN
					SET @SortDirection = 'DESC'
				END
				
				DECLARE @OrderByColumn NVARCHAR(250) 

				IF(@SortBy IS NULL)
				BEGIN

					SET @SortBy = 'name'

				END
				ELSE
				BEGIN

					SET @SortBy = @SortBy

				END

				IF(@SearchText = '') SET @SearchText   = NULL SET @SearchText = '%'+ @SearchText +'%';

				IF(@DateFrom IS NULL) SET @DateFrom = CONVERT(DATE,GETDATE())

				IF(@IsTrailExpired = 1) SET @DateFrom = DATEADD(DAY,-6, CONVERT(DATE,GETDATE()));

				IF (@DateTo IS NULL)
				BEGIN
					SET @DateTo = @DateFrom
				END
					
				DECLARE @LastDate DATETIME = (SELECT MAX(CreatedDateTime) FROM TrackerDetailedData WHERE CompanyId = @CompanyId)
				
				 DECLARE @DateFrom1 DATETIME,@DateTo1 DATETIME, @DateFrom2 DATETIME,@DateTo2 DATETIME
				 
				 SELECT @DateFrom2 = @DateFrom,@DateTo2 = @DateTo

				 IF(@LastDate > @DateFrom)
				 BEGIN
				 
				 	SELECT @DateFrom1 = @DateFrom
				 	       ,@DateFrom2 = DATEADD(DAY,1,@LastDate)
				 		   ,@DateTo1 = IIF(@LastDate > @DateTo,@DateTo,@LastDate)
				 
				 END

				SELECT *, TotalCount = COUNT(1) OVER() 
				FROM (
					SELECT UserId,[Name],ProfileImage,ApplicationName,ApplicationTypeName,BranchId,
					(SUM(SpentValue)/1000.0) AS SpentValue
					 FROM (
					       SELECT U.Id AS UserId,CONCAT(U.FirstName,' ',U.SurName) AS [Name],U.ProfileImage,
							      AbsoluteAppName AS ApplicationName,ApplicationTypeName,EB.BranchId,
								SUM(DATEDIFF(MS, '00:00:00.000', SpentTime)) AS SpentValue
							FROM [User] AS U
							INNER JOIN (SELECT UserId FROM [dbo].[Ufn_TrackingUserList](@RoleId, @BranchId, @UserId, @OperationPerformedBy, NULL)) UInner ON UInner.UserId = U.Id
							INNER JOIN Employee AS E  ON U.Id = E.UserId
							INNER JOIN (SELECT ApplicationId,OtherApplication AbsoluteAppName,T.ApplicationTypeName,SpentTime
							                   ,UserId,IsApp
							            FROM UserActivityTime UA
											 INNER JOIn [User] AS U ON UA.UserId = U.Id AND U.CompanyId = @CompanyId
							                 INNER JOIN ApplicationType AS T ON UA.ApplicationTypeId = T.Id 
									    WHERE UA.InActiveDateTime IS NULL
									    AND ( UA.CreatedDateTime BETWEEN @DateFrom2 AND @DateTo2)
										UNION ALL
										SELECT UAH.ApplicationId,UAH.ApplicationName,UAH.ApplicationTypeName,UAH.SpentTime,UAH.UserId
											   ,UAH.IsApp
										FROM TrackerDetailedData UAH
										WHERE UAH.CreatedDateTime BETWEEN @DateFrom1 AND @DateTo1
										      AND UAH.CompanyId = @CompanyId
										--UNION ALL
										--SELECT NULL,'Idle Time','Neutral',CONVERT(VARCHAR, DATEADD(S,TotalIdleTime * 60, 0), 108)
										--     ,UserId,1
										--FROM [dbo].[Ufn_GetUserIdleTime](@DateFrom,@DateTo,@CompanyId)
										) AS UA ON ( U.Id = UA.UserId )
							INNER JOIN EmployeeBranch AS EB ON EB.EmployeeId = E.Id
								       AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE()))
											 LEFT JOIN ActivityTrackerApplicationUrl AS A ON (UA.ApplicationId = A.Id)
							WHERE U.CompanyId = @CompanyId
							AND (@IsApp IS NULL OR @IsApp = UA.IsApp)
							GROUP BY U.Id,UA.ApplicationId,UA.AbsoluteAppName,ApplicationTypeName,A.AppUrlName,U.FirstName,U.SurName,U.ProfileImage,EB.BranchId
							) TT WHERE ApplicationName <> ''
						GROUP BY UserId,[Name],ProfileImage,ApplicationName,ApplicationTypeName,BranchId
						) T
						WHERE (@SearchText IS NULL OR (T.ApplicationName LIKE '%'+ @SearchText +'%' ) OR (T.[Name] LIKE @SearchText))  
							--OR (CONVERT(NVARCHAR(10),DATEPART(HOUR, SpentTime))+'h' LIKE @SearchText) OR (CONVERT(NVARCHAR(10),DATEPART(MINUTE, SpentTime))+'m' LIKE @SearchText) OR 
							--(CONVERT(NVARCHAR(10),DATEPART(SECOND, SpentTime))+'s' LIKE @SearchText) OR 
							--(CONVERT(NVARCHAR(10),DATEPART(HOUR, SpentTime))+'h '+CONVERT(NVARCHAR(10),DATEPART(MINUTE, SpentTime))+'m '+ (CONVERT(NVARCHAR(10),DATEPART(SECOND, SpentTime)))+'s'  LIKE @SearchText))
						ORDER BY 
						CASE WHEN @SortDirection = 'ASC' THEN
							CASE WHEN @SortBy = 'name' THEN  CAST([Name] AS SQL_VARIANT) 
								 WHEN @SortBy = 'spentValue' THEN T.SpentValue
								 WHEN @SortBy = 'timeValue' THEN T.SpentValue
								 WHEN @SortBy = 'applicationName' THEN CONVERT(NVARCHAR,T.ApplicationName)
						END
						END ASC,
						CASE WHEN @SortDirection = 'DESC' THEN
							CASE WHEN @SortBy = 'name' THEN CAST([Name] AS SQL_VARIANT) 
								 WHEN @SortBy = 'spentValue' THEN T.SpentValue
								 WHEN @SortBy = 'timeValue' THEN T.SpentValue
								 WHEN @SortBy = 'applicationName' THEN CONVERT(NVARCHAR,T.ApplicationName)
							END
						END DESC
				
						OFFSET ((@PageNo - 1) * @PageSize) ROWS 
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
GO
