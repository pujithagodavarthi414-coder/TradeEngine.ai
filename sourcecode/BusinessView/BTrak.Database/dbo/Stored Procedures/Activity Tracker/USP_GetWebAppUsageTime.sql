-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-09-17 00:00:00.000'
-- Purpose      To Get the Time Usage Of Websites and Applications By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetWebAppUsageTime] @UserId = '
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
--Summary changes
/*
Need to get data from UserActivityHistoricalData and remove usage of UserActivityTime table and idletime related changes
*/
CREATE PROCEDURE [dbo].[USP_GetWebAppUsageTime] 
(
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
				 
			   SELECT UserId 
			   INTO #FilteredUsers
			   FROM [dbo].[Ufn_TrackingUserList](@RoleId, @BranchId, @UserId, @OperationPerformedBy, NULL)

				SELECT *, TotalCount = COUNT(1) OVER() 
				FROM (
					    SELECT UAS.UserId,CONCAT(U.FirstName,' ',U.SurName) AS [Name]
						       ,U.ProfileImage,UAS.ApplicationName,UAS.ApplicationTypeName,EB.BranchId
							  ,(SUM(UAS.TimeInMillisecond)/1000.0) SpentValue
						FROM UserActivityAppSummary UAS
							 INNER JOIN (SELECT UserId FROM [dbo].[Ufn_TrackingUserList](@RoleId, @BranchId, @UserId, @OperationPerformedBy, NULL)) UInner ON UInner.UserId = UAS.UserId
						     INNER JOIN [User] U ON U.Id = UAS.UserId 
							 INNER JOIN Employee E ON E.UserId = U.Id
							 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
								       AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() 
									        AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE()))
										--AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= @DateFrom 
										--AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= @DateTo))
							WHERE UAS.CreatedDateTime BETWEEN @DateFrom AND @DateTo 
						           AND (@IsApp IS NULL OR @IsApp = UAS.IsApp)
						    GROUP BY UAS.UserId,CONCAT(U.FirstName,' ',U.SurName)
						       ,U.ProfileImage,UAS.ApplicationName,UAS.ApplicationTypeName,EB.BranchId
						) T
						WHERE ApplicationName <> '' 
						AND (@SearchText IS NULL OR (T.ApplicationName LIKE '%'+ @SearchText +'%' ) OR (T.[Name] LIKE @SearchText))
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
