CREATE PROCEDURE [dbo].[USP_ProductivityJobProcedure]
@DateFrom DATETIME = NULL,
@DateTo DATETIME = NULL
AS
BEGIN
 SET NOCOUNT ON
 SET  TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 BEGIN TRY
    CREATE TABLE #CompanyIds
		(
			Id INT IDENTITY(1,1),
			CompanyId UNIQUEIDENTIFIER
		)
	Create Table #UserIds
		(
			Id INT IDENTITY(1,1),
			UserId UNIQUEIDENTIFIER
		)
	--Collect All Company Ids
	SET @DateFrom = CONVERT(DATE,ISNULL(@DateFrom,DATEADD(DAY,-1,GETDATE())))
	SET @DateTo = CONVERT(DATE,ISNULL(@DateTo,DATEADD(DAY,-1,GETDATE())))
	INSERT INTO #CompanyIds
	SELECT Id FROM Company WHERE InActiveDateTime IS NULL
	DECLARE @CompanyIdsCount INT, @CompanyIdsCounter INT = 1, @CompanyId UNIQUEIDENTIFIER
	SELECT @CompanyIdsCount = COUNT(1) FROM #CompanyIds
	
	--Collect all Individual Company UserIds by using Collected Company ids
	WHILE (@DateFrom <= @DateTo)
	BEGIN
	WHILE(@CompanyIdsCounter <= @CompanyIdsCount)
	BEGIN
		SELECT @CompanyId = CompanyId FROM #CompanyIds WHERE Id = @CompanyIdsCounter
		INSERT INTO #UserIds
		SELECT Id FROM [User] WHERE CompanyId = @CompanyId and InActiveDateTime IS NULL
	SELECT @CompanyIdsCounter = @CompanyIdsCounter + 1
	END
	DECLARE @UserIdsCount INT, @UserIdsCounter INT = 1, @UserId UNIQUEIDENTIFIER
	SELECT @UserIdsCount = COUNT(1) FROM #UserIds
	
	--Run Job proc for every User
	WHILE(@UserIdsCounter <= @UserIdsCount)
	BEGIN
		SELECT @UserId = UserId FROM #UserIds WHERE Id = @UserIdsCounter
		EXEC [dbo].[USP_ProductivityDasboardJob] @UserId = @UserId, @Date = @DateFrom
		SELECT @UserIdsCounter = @UserIdsCounter + 1
	END
	SET @DateFrom = CONVERT(DATE,DATEADD(DAY,1,@DateFrom))
END
 END TRY
 BEGIN CATCH

    THROW

END CATCH
END
GO