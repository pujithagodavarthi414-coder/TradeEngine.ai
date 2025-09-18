CREATE PROCEDURE [dbo].[USP_GetYearlyProductivityReport]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @Date DATETIME = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
		
			IF(@UserId IS NULL) SET @UserId = @OperationsPerformedBy

			IF (@Date IS NULL) SET @Date = GETDATE()

			DECLARE @DateFrom DATETIME = (SELECT DATEADD(YEAR, DATEDIFF(YEAR, 0, @Date), 0))

			DECLARE @DateTo DATETIME = (SELECT DATEADD(YEAR, DATEDIFF(YEAR, -1, @Date), -1))

			IF (@DateTo > GETDATE()) SET @DateTo = GETDATE()

			 SELECT DATEPART(MONTH,T.[Date]) AS [MonthNumber]
			       ,DATENAME(MONTH,T.[Date]) AS [MonthName]
				   ,ISNULL(SUM(RT.Productivity),0) AS Productivity
			 FROM (SELECT DATEADD(DAY,NUMBER,@DateFrom) AS [Date] 
			       FROM MASTER..SPT_VALUES 
				   WHERE [Type] = 'P' 
				     AND NUMBER <=DATEDIFF(DAY,@DateFrom,@DateTo)) T
			 LEFT JOIN (SELECT T.* FROM [dbo].[Ufn_GetProductivityIndexForAnIndividual](@UserId,@DateFrom,@DateTo) T 
			 INNER JOIN UserStory US ON US.Id = T.UserStoryId AND (US.ProjectId = @ProjectId OR @ProjectId IS NULL))RT ON CONVERT(DATE,T.[Date]) = CONVERT(DATE,RT.[DeadlineDate]) 		 
			 GROUP BY DATENAME(MONTH,T.[Date]), DATEPART(MONTH,T.[Date]) 
			 ORDER BY  DATEPART(MONTH,T.[Date])

		END
		ELSE
			
			RAISERROR(@HavePermission,11,1)
	
	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO