--EXEC [GetDateWiseProductivityIndex] '2020-05-31','2020-05-31','8EBCC84D-CC59-4D52-9CD1-87BEE2441BF2','8EBCC84D-CC59-4D52-9CD1-87BEE2441BF2'
CREATE PROCEDURE [dbo].[GetDateWiseProductivityIndex]
(
  @DateFrom DATETIME,
  @DateTo DATETIME,
  @UserId UNIQUEIDENTIFIER,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	  DECLARE @Days TABLE(
			                    RowNumber INT IDENTITY(1,1),
                                [Date] DATE,
							    UserId UNIQUEIDENTIFIER,
								CompanyId UNIQUEIDENTIFIER,
								ProductivityIndex FLOAT,
								GRPIndex FLOAT,
								CompletedUserStoresCount INT,
	                            QAApprovedUserStoriesCount INT,
	                            ReopenedUserStoresCount INT,
								UserStoriesBouncedBackOnceCount INT,
                                UserStoriesBouncedBackMoreThanOnceCount INT,
								PercentageOfBouncedUserStories DECIMAL,
								PercentageOfQAApprovedUserStories DECIMAL
                               )
            INSERT INTO @Days([Date],UserId,CompanyId)
            SELECT T.[Date],@UserId,@CompanyId
			FROM
			(SELECT DATEADD(DAY, NUMBER,@DateFrom) AS [Date]
            FROM MASTER..SPT_VALUES
            WHERE TYPE='P'
            AND NUMBER<=DATEDIFF(DAY,@DateFrom,@DateTo)) T
			DECLARE @totalcount INT = 0;
			SET @totalcount = (SELECT COUNT(1) FROM @Days)
			DECLARE @Date DATE
			While(@totalcount > 0)
			BEGIN 
			
				SET @Date = (SELECT [Date] FROM @Days WHERE RowNumber = @totalcount)
			    UPDATE @Days
			    SET ProductivityIndex = PRI.ProductivityIndex,
				GRPIndex = PRI.GRPIndex,
				CompletedUserStoresCount = PRI.CompletedUserStoresCount,
				QAApprovedUserStoriesCount = PRI.QAApprovedUserStoriesCount,
				ReopenedUserStoresCount = PRI.ReopenedUserStoresCount,
				UserStoriesBouncedBackOnceCount = PRI.UserStoriesBouncedBackOnceCount,
				UserStoriesBouncedBackMoreThanOnceCount = PRI.UserStoriesBouncedBackMoreThanOnceCount,
				PercentageOfBouncedUserStories = CAST((CASE WHEN PRI.CompletedUserStoresCount = 0 THEN 0 ELSE (PRI.ReopenedUserStoresCount*1.0/PRI.CompletedUserStoresCount*1.0)*100  END)
				AS NUMERIC(10,2)),
				PercentageOfQAApprovedUserStories = CAST((CASE WHEN PRI.CompletedUserStoresCount = 0 THEN 0 ELSE (PRI.QAApprovedUserStoriesCount*1.0/PRI.CompletedUserStoresCount*1.0)*100 END) 
				AS NUMERIC(10,2))
			    FROM @Days D
		        JOIN (SELECT [Date],
				SUM(ISNULL(ProductivityIndex,0)) ProductivityIndex,
				SUM(ISNULL(GRPIndex,0)) GRPIndex,
				SUM(ISNULL(CompletedUserStoresCount,0)) CompletedUserStoresCount,
				SUM(ISNULL(QAApprovedUserStoriesCount,0)) QAApprovedUserStoriesCount,
				SUM(ISNULL(ReopenedUserStoresCount,0)) ReopenedUserStoresCount,
				SUM(ISNULL(UserStoriesBouncedBackOnceCount,0)) UserStoriesBouncedBackOnceCount,
				SUM(ISNULL(UserStoriesBouncedBackMoreThanOnceCount,0)) UserStoriesBouncedBackMoreThanOnceCount
			    FROM [dbo].[Ufn_ProductivityIndexForDevelopersDateWise](@Date,@Date,@UserId,@CompanyId)
				GROUP BY [Date]) PRI ON PRI.[Date] = @Date
				WHERE D.[Date] =  @Date
				SET @totalcount = @totalcount-1
			END

			select * from @Days


	END TRY 
	BEGIN CATCH 
		
		 THROW

	END CATCH
END
GO