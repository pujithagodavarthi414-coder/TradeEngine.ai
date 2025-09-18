--EXEC [dbo].[USP_GetEmployeeExpectedBurndownDetail] @UserId='E14096C9-4051-4D6D-8AE9-4C2FCFF23A38',@Date='2020-12-08',@DateFrom='2020-12-01',@DateTo='2020-12-08'

CREATE PROCEDURE [dbo].[USP_GetEmployeeExpectedBurndownDetail]
(
  @UserId UNIQUEIDENTIFIER ,
  @DateFrom DATETIME = NULL,
  @DateTo DATETIME = NULL,
  @Date DATETIME = NULL
) 
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@UserId,(SELECT OBJECT_NAME(@@PROCID))))
	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
		IF (@HavePermission = '1')
	    BEGIN   

		IF(@DateFrom IS NULL AND @Date IS NULL)
		BEGIN
		SET @DateFrom = (SELECT dbo.Ufn_GetRequiredPreviousDateExcludingNonWorkingDays (30))

		IF ((SELECT COUNT(1) FROM ProductivityDataPoints WHERE CONVERT(DATE,CreatedDateTime) = CONVERT(DATE,@DateFrom)) = 0)
		BEGIN
			SET @DateFrom = (SELECT MIN(CreatedDateTime) FROM ProductivityDataPoints)
		END
		END
		ELSE 
		SET @DateFrom = ISNULL(@DateFrom,@Date)
		IF(@DateTo IS NULL AND @Date IS NULL)
		BEGIN
		SET @DateTo = GETDATE()
		END
		ELSE 
		SET @DateTo = ISNULL(@DateTo,@Date)
		DECLARE @Data Table
		(
		  [date] DateTime,
		  Expected int,
		  Actual int
		)
                
		DECLARE @Dates Table
		(
			[Date] DateTime,
			IsWeekend BIT,
			IsHoliday BIT
		)
		WHILE ( @DateFrom <= @DateTo)
		BEGIN
		
			INSERT INTO @Dates ([Date], isWeekend) VALUES( @DateFrom,  IIF(DATEPART(WEEKDAY, @DateFrom) IN (7, 1), 1, 0 ))
			SELECT @DateFrom = DATEADD(DAY, 1, @DateFrom)

		END

		UPDATE @Dates SET isHoliday = 1 FROM @Dates D JOIN Holiday H ON D.[date] = H.[Date] AND H.CompanyId = @CompanyId
		
		INSERT INTO @Data ([Date],Expected)
		SELECT [Date],PD.[Hours] from @Dates D
		LEFT JOIN [ProductivityDataPoints] PD ON Convert(Date,CreatedDateTime) = Convert(Date,D.[Date]) AND PD.UserId = @UserId
		WHERE (IsWeekend IS NULL OR IsWeekend = 0) AND (isHoliday IS NULL OR IsHoliday = 0)

		DECLARE @SelectedDate DATETIME 

		DECLARE DATE_CURSOR CURSOR FOR  
		SELECT [Date] FROM @Dates WHERE (IsHoliday IS NULL OR IsHoliday = 0) AND (IsWeekend IS NULL OR IsWeekend = 0)
		
		OPEN DATE_CURSOR   
		FETCH NEXT FROM DATE_CURSOR INTO @SelectedDate
		
		WHILE @@FETCH_STATUS = 0   
		BEGIN   
		
			UPDATE @Data SET Actual = CASE WHEN Estimate IS NULL THEN 0 ELSE Estimate END
			FROM @Data D JOIN
			(SELECT SUM(EstimatedTime) Estimate FROM UserStory U
				JOIN Goal G ON U.GoalId = G.Id
				JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId
				INNER JOIN UserStoryStatus USS WITH (NOLOCK) ON USS.Id = U.UserStoryStatusId AND U.InActiveDateTime IS NULL
				AND (USS.TaskStatusId = 'F2B40370-D558-438A-8982-55C052226581' OR USS.TaskStatusId = N'166DC7C2-2935-4A97-B630-406D53EB14BC'
				 OR USS.TaskStatusId = '6BE79737-CE7C-4454-9DA1-C3ED3516C7F0')
				--AND (USS.IsNew = 1 OR USS.IsBlocked = 1 OR USS.IsInprogress = 1 OR USS.IsAnalysisCompleted = 1 OR IsDevInprogress = 1 OR USS.IsNotStarted = 1)
				WHERE CONVERT(DATE,U.DeadLineDate) <= CONVERT(DATE,@SelectedDate) AND OwnerUSerId = @UserId
				AND (G.IsApproved IS NOT NULL)
							AND (G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL)
							AND (P.InActiveDateTime IS NULL )
							AND (U.ArchivedDateTime IS NULL AND U.InActiveDateTime IS NULL)
							AND (U.ParkedDateTime IS NULL)
							)z ON CONVERT(DATE,@SelectedDate) = CONVERT(DATE,D.[date])     
		
			FETCH NEXT FROM DATE_CURSOR INTO @SelectedDate   

		END   
		
		CLOSE DATE_CURSOR   
		DEALLOCATE DATE_CURSOR

		SELECT * FROM @Data 

	END
	END TRY
    BEGIN CATCH
        THROW
    END CATCH
END