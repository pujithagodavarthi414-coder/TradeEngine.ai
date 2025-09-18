CREATE PROCEDURE [dbo].[USP_ProduceProductivityData]
(
	@Date DATETIME = NULL
)
AS
BEGIN   
    SET NOCOUNT ON;
    IF(@Date IS NULL) SET @Date = GETUTCDATE()

	DECLARE @IsHoliday BIT = CASE WHEN (SELECT [Date] FROM Holiday WHERE CONVERT(DATE,[Date])= CONVERT(DATE,@Date)) IS NULL THEN 0 ELSE 1 END
	IF (DATEPART(WEEKDAY, @Date) NOT IN (7, 1) AND @IsHoliday = 0)
	BEGIN
		DECLARE @dataCount INT = (SELECT COUNT(1) FROM ProductivityDataPoints Where CONVERT(Date, CreatedDateTime) = CONVERT(DATE,@Date))

		IF(@dataCount = 0)
		BEGIN
		INSERT INTO [ProductivityDataPoints] (Id,UserId,CreatedDateTime,CreatedByUserId,[CompanyId])
		SELECT NEWID(),Id, @Date,'0B2921A9-E930-4013-9047-670B5352F308','4AFEB444-E826-4F95-AC41-2175E36A0C16' from [User] Where IsActive = 1
		GROUP BY Id
		END

        UPDATE [ProductivityDataPoints] SET [Hours] = CASE WHEN z.ExpectedHours < 0 THEN 0 ELSE z.ExpectedHours END
		FROM [ProductivityDataPoints] PD JOIN
		(SELECT (ISNULL(PD.[Hours],0) - ISNULL(EP.[Hours],0) + ISNULL(SUM(EstimatedTime),0)) ExpectedHours ,PD.UserId UserId FROM [ProductivityDataPoints] PD 
				LEFT JOIN ExpectedProductiveHours EP ON PD.UserId = EP.UserId AND CONVERT(DATE,@Date) BETWEEN EP.FromDate AND EP.ToDate
				LEFT JOIN UserStory U ON U.OwnerUserId = PD.UserId AND CONVERT(DATE,U.CreatedDateTime) = CONVERT(DATE,@Date)
				WHERE CONVERT(DATE,PD.CreatedDateTime) = (SELECT dbo.Ufn_GetRequiredPreviousDateExcludingNonWorkingDays (1))
				GROUP BY PD.UserId,PD.[Hours],EP.[Hours] ) z ON z.UserId = PD.UserId AND CONVERT(DATE,PD.CreatedDateTime) = CONVERT(DATE,@Date)
	END
END