--EXEC [USP_GetActivityReport] '589BE7AE-E5FA-4BDB-B5C4-F44834151BA4'
CREATE PROCEDURE [dbo].[USP_GetActivityReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@OnDate DATETIME = NULL,
	@IsApp BIT = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@OnDate IS NULL) SET @OnDate = GETUTCDATE()
		
		DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 

		IF(@HavePermission = '1')
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy) 
			
			SELECT * 
					,CONVERT(VARCHAR,(TotalTimeInMS/60000) / 60) + 'h:' + ISNULL(CONVERT(VARCHAR,ROUND((TotalTimeInMS/60000) % 60,2)),'00') + 'm' AS TotalTime
			        ,SUM(CASE WHEN ApplicationTypeName = 'Neutral' THEN TotalTimeInMS ELSE 0 END) OVER() AS Neutral
			        ,SUM(CASE WHEN ApplicationTypeName = 'Productive' THEN TotalTimeInMS ELSE 0 END) OVER() AS Productive
			        ,SUM(CASE WHEN ApplicationTypeName = 'UnProductive' THEN TotalTimeInMS ELSE 0 END) OVER() AS UnProductive
			FROM (
				SELECT TOP(5) *
				FROM (
				SELECT UAS.TimeInMillisecond TotalTimeInMS
				 ,UAS.ApplicationTypeName
				 ,UAS.ApplicationName AS AppUrlName
				 ,UAS.AppUrlImage
				FROM UserActivityAppSummary UAS
				WHERE UAS.CreatedDateTime = CONVERT(DATE,@OnDate)
					  AND UAS.CompanyId = @CompanyId
					  AND (@IsApp IS NULL OR UAS.IsApp = @IsApp)
					  AND (UAS.UserId = @OperationsPerformedBy)
				) TT ORDER BY TotalTimeInMS DESC
			) T

		END
		ELSE
		BEGIN
			
			RAISERROR(@HavePermission,11,1)

		END

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO