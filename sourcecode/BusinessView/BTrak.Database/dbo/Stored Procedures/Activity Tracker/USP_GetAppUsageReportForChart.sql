---------------------------------------------------------------------------------
---- Author       Praneeth Kumar Reddy Salukooti
---- Created      '2020-07-08 00:00:00.000'
---- Purpose      To Get the App Usage Report
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
----  EXEC [dbo].[USP_GetAppUsageReportForChart] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
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
    
CREATE PROCEDURE [dbo].[USP_GetAppUsageReportForChart](
@UserId XML = NULL ,
@RoleId XML = NULL,
@BranchId XML = NULL,
@DateFrom DATE = NULL,
@DateTo DATE = NULL,
@SearchText [NVARCHAR](800) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@IsTrailExpired BIT = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
	 SET TRANSACTION  ISOLATION LEVEL READ UNCOMMITTED
	   BEGIN TRY
			
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			ELSE
			BEGIN
			   DECLARE @HavePermission NVARCHAR(250)  =  '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 

				 IF (@HavePermission = '1')
				 BEGIN

					IF(@SearchText   = '') SET @SearchText   = NULL SET @SearchText = '%'+ @SearchText +'%';

				   IF (@DateFrom IS NULL) SET @DateFrom = CONVERT(DATE,GETDATE())

					IF (@DateTo IS NULL)
					BEGIN

						SET @DateTo = @DateFrom

					END

					IF(@IsTrailExpired = 1) SET @DateFrom = DATEADD(DAY,-6, CONVERT(DATE,GETDATE()))
					
					SELECT UserId 
					INTO #FilteredUsers
					FROM [dbo].[Ufn_TrackingUserList](@RoleId, @BranchId, @UserId, @OperationsPerformedBy, NULL)

					SELECT TOP 5 * FROM (
							SELECT UAS.AppUrlImage, UAS.ApplicationName,
							  (SUM(UAS.[TimeInMillisecond])/1000.0) SpentValue
							FROM UserActivityAppSummary UAS
								 INNER JOIN #FilteredUsers UInner ON UInner.UserId = UAS.UserId
							WHERE UAS.CompanyId = @CompanyId
								 AND UAS.CreatedDateTime BETWEEN @DateFrom AND @DateTo
							GROUP BY UAS.AppUrlImage, UAS.ApplicationName
						)TT
						WHERE (@SearchText IS NULL OR (TT.ApplicationName LIKE '%'+ @SearchText +'%' ))
						ORDER BY SpentValue DESC
				 END
			END
		END TRY
		BEGIN CATCH
        
			THROW

	    END CATCH
END
GO