---------------------------------------------------------------------------------
---- Author       Praneeth Kumar Reddy Salukooti
---- Created      '2019-10-24 00:00:00.000'
---- Purpose      To Get the App Usage Report
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
----  EXEC [dbo].[USP_GetAppUsageReport] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
----  ,@UserId = '<ListItems>
----  <ListRecords>
----  <ListItem>
----  <ListItemId>0B2921A9-E930-4013-9047-670B5352F308</ListItemId>
----  </ListItem>
----  </ListRecords>
----  </ListItems>'
----  ,@BranchId = '<ListItems>
----  <ListRecords>
----  <ListItem>
----  <ListItemId>63053486-89D4-47B6-AB2A-934A9F238812</ListItemId>
----  </ListItem>
----  </ListRecords>
----  </ListItems>'
----  ,@RoleId = '<ListItems>
----  <ListRecords>
----  <ListItem>
----  <ListItemId>4D5ADF0F-88DF-462C-A987-38AC05AEAB0C</ListItemId>
----  </ListItem>
----  </ListRecords>
----  </ListItems>'
    

CREATE PROCEDURE [dbo].[USP_GetAppUsageReport](
@UserId XML = NULL ,
@RoleId XML = NULL,
@BranchId XML = NULL,
@DateFrom DATE = NULL,
@DateTo DATE = NULL,
@SearchText [NVARCHAR](800) = NULL,
@PageNo INT = 1,
@PageSize INT = 10,
@ApplicationType [NVARCHAR](50) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@IsTrailExpired BIT = NULL,
@IsIdleNotRequired BIT = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
	 SET TRANSACTION  ISOLATION LEVEL READ UNCOMMITTED
	   BEGIN TRY
			
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			ELSE
			BEGIN
			   DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 

				 IF (@HavePermission = '1')
				 BEGIN

					IF(@SearchText   = '') SET @SearchText   = NULL SET @SearchText = '%'+ @SearchText +'%';

				   IF (@DateFrom IS NULL) SET @DateFrom = CONVERT(DATE,GETDATE())

				   IF(@IsIdleNotRequired IS NULL) SET @IsIdleNotRequired = 0

					IF (@DateTo IS NULL)
					BEGIN
						SET @DateTo = @DateFrom
					END

					IF(@IsTrailExpired = 1) SET @DateFrom = DATEADD(DAY,-6, CONVERT(DATE,GETDATE()));

					--IF(DATEDIFF(DAY,@DateFrom,@DateTo) > 7) SET @DateFrom = DATEADD(DAY,-7,@DateTo)

					SELECT UserId 
					INTO #FilteredUsers
					FROM [dbo].[Ufn_TrackingUserList](@RoleId, @BranchId, @UserId, @OperationsPerformedBy, NULL)

					SELECT *,TotalCount = COUNT(1) OVER() FROM (
							SELECT UAS.AppUrlImage,UAS.ApplicationId, UAS.ApplicationName
						      ,APT.Id AS ApplicationTypeId,APT.ApplicationTypeName,
							  (SUM(UAS.[TimeInMillisecond])/1000.0) SpentValue
							FROM UserActivityAppSummary UAS
							     INNER JOIN ApplicationType AS APT ON UAS.ApplicationTypeName = APT.ApplicationTypeName 
								 INNER JOIN #FilteredUsers UInner ON UInner.UserId = UAS.UserId
							WHERE UAS.CompanyId = @CompanyId
								 AND UAS.CreatedDateTime BETWEEN @DateFrom AND @DateTo
							GROUP BY UAS.AppUrlImage,UAS.ApplicationId, UAS.ApplicationName,APT.Id ,APT.ApplicationTypeName
						)TT 
						--WHERE (@SearchText IS NULL OR (TT.ApplicationName LIKE '%'+ @SearchText +'%' ) OR
						--	(CONVERT(NVARCHAR(10),DATEPART(HOUR, SpentTime))+'h' LIKE @SearchText) OR (CONVERT(NVARCHAR(10),DATEPART(MINUTE, SpentTime))+'m' LIKE @SearchText) OR 
						--	(CONVERT(NVARCHAR(10),DATEPART(SECOND, SpentTime))+'s' LIKE @SearchText) OR 
						--	(CONVERT(NVARCHAR(10),DATEPART(HOUR, SpentTime))+'h '+CONVERT(NVARCHAR(10),DATEPART(MINUTE, SpentTime))+'m '+ (CONVERT(NVARCHAR(10),DATEPART(SECOND, SpentTime)))+'s'  LIKE @SearchText))
					    WHERE (@SearchText IS NULL OR (TT.ApplicationName LIKE '%'+ @SearchText +'%' ))
						      AND (@ApplicationType = TT.ApplicationTypeName OR (@ApplicationType IS NULL AND TT.ApplicationTypeName = 'Neutral'))
						ORDER BY SpentValue DESC
						OFFSET ((@PageNo - 1) * @PageSize) ROWS 
						FETCH NEXT @PageSize ROWS ONLY
				 END
			END
		END TRY
		BEGIN CATCH
        
			THROW

	    END CATCH
END
GO