CREATE PROCEDURE [dbo].[USP_GetAppUsageCompleteReport]
(
	@UserId XML = NULL ,
	@DateFrom DATE = NULL,
	@DateTo DATE = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsTrailExpired BIT = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
	   BEGIN TRY
			
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			ELSE
			BEGIN
			   DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

			   SET @DateFrom = (SELECT CAST(CAST(@DateFrom AS DATE) AS DATETIME))
			   SET @DateTo = (SELECT CAST(CAST(@DateTo AS DATE) AS DATETIME))
			 
				 IF (@HavePermission = '1')
				 BEGIN
				 
					CREATE TABLE #UserIdList
					(
					 Id INT IDENTITY(1,1) PRIMARY KEY,
					 UserId UNIQUEIDENTIFIER NULL
					)
					
					IF (@DateTo IS NULL)
					BEGIN
						SET @DateTo = @DateFrom
					END

					IF(@IsTrailExpired = 1) SET @DateFrom = DATEADD(DAY,-6, GETDATE());

				    CREATE TABLE #DATESACTIVITY
				    (
				    	RefDate DATETIME,
				    	UserId UNIQUEIDENTIFIER,
				    	ResourceId INT IDENTITY(1,1)
				    )
				    
					IF(@UserId IS NOT NULL)
					BEGIN
							--DELETE FROM #UserIdList WHERE UserId = '00000000-0000-0000-0000-000000000000'
							INSERT INTO #UserIdList (UserId)
							SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
							FROM  @UserId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
					END

					CREATE TABLE #AppUsageReport
					(
                     UserId UNIQUEIDENTIFIER,
                     UserName VARCHAR(250),
                     CreatedDate DATETIME,
                     ApplicationTypeName VARCHAR(50),
                     StartTime DATETIME,
                     EndTime DATETIME,
                     SpentTime INT
					)
					IF(CONVERT(DATE,GETDATE()) BETWEEN @DateFrom AND @DateTo)
					BEGIN

						INSERT INTO #AppUsageReport(UserId,UserName,CreatedDate,ApplicationTypeName,StartTime,EndTime,SpentTime)
						SELECT A.UserId,UserName,CreatedDate,ApplicationTypeName,StartTime,EndTime,SpentTime FROM Ufn_AppUsageReport(GETDATE(),@OperationsPerformedBy)A

					END

					;WITH cte AS(
						SELECT @DateFrom RefDate
						UNION ALL
						SELECT DATEADD(dd, 1, RefDate) FROM cte WHERE RefDate < @DateTo
					)

					INSERT INTO #DATESACTIVITY
					SELECT distinct RefDate, UserId FROM cte
					INNER JOIN #UserIdList ON 1 = 1
					ORDER BY UserId, RefDate ASC

					SELECT DISTINCT UAT.UserId
					       ,UAT.UserName
						   ,UAT.CreatedDate
						   ,U.ProfileImage
						   ,UAT.ApplicationTypeName
						   ,UAT.StartTime,EndTime
						   ,D.ResourceId
						   ,UAT.SpentTime 
					FROM UserTimelineData UAT
						 INNER JOIN #DATESACTIVITY D ON D.RefDate = UAT.CreatedDate AND D.UserId = UAT.UserId
					     INNER JOIN #UserIdList UL ON UL.UserId = UAT.UserId AND UAT.CreatedDate BETWEEN @DateFrom AND @DateTo
						 INNER JOIN [User] U ON U.Id = UAT.UserId
						 UNION ALL
						SELECT DISTINCT A.UserId,
						       A.UserName,
							   A.CreatedDate,
							   U.ProfileImage,
							   A.ApplicationTypeName,
							   A.StartTime,
							   A.EndTime ,
							   D.ResourceId,
							   A.SpentTime
						 FROM [User]U INNER JOIN #UserIdList UL ON U.Id = UL.UserId 
						              INNER JOIN #AppUsageReport A ON A.UserId = U.Id 
									  INNER JOIN #DATESACTIVITY D ON D.UserId = A.UserId AND CAST(D.RefDate AS date) = CAST(A.CreatedDate AS date)
						 
					
				 END
			END
		END TRY
		BEGIN CATCH
        
			THROW

	    END CATCH
END
GO

----------------------------------------------------------------------------------------
--Data Base Job for saving Activity timeline data
----------------------------------------------------------------------------------------
  --      DECLARE @UserId UNIQUEIDENTIFIER,@CompanyId UNIQUEIDENTIFIER,@Date DATETIME = NULL --'2020-08-04'
		--DECLARE Cursor_Script CURSOR
  --      FOR SELECT Id AS ComapnyId
  --          FROM Company
         
  --      OPEN Cursor_Script
         
  --          FETCH NEXT FROM Cursor_Script INTO 
  --              @CompanyId
             
  --          WHILE @@FETCH_STATUS = 0
  --          BEGIN
               
  --             SET @UserId = (SELECT TOP(1) U.Id FROM [User] U 
		--	                  WHERE U.CompanyId = @CompanyId)
               
              
  --              IF(@CompanyId IS NOT NULL AND @UserId IS NOT NULL)
  --              BEGIN
                    
		--			EXEC [dbo].[USP_AppUsageReport] @Date = @Date,@OperationsPerformedBy = @UserId

  --              END

  --              FETCH NEXT FROM Cursor_Script INTO 
  --              @CompanyId
                
  --              SELECT @UserId = NULL
        
  --          END
             
  --      CLOSE Cursor_Script
         
  --      DEALLOCATE Cursor_Script
----------------------------------------------------------------------------------------
