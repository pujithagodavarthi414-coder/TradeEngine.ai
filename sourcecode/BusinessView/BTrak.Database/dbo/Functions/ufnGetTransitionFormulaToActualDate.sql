CREATE FUNCTION [dbo].[ufnGetTransitionFormulaToActualDate](@TransitionId UNIQUEIDENTIFIER)
RETURNS DATETIME
BEGIN
    DECLARE @TransitionActualDate DATETIME
    DECLARE @DeadlineFormaula VARCHAR(1000)
    SET @DeadlineFormaula = (SELECT Deadline FROM [WorkflowEligibleStatusTransition] where Id=@TransitionId AND InActiveDateTime IS NULL)
    IF (@DeadlineFormaula = 'D')
    BEGIN
        SET @TransitionActualDate = CONVERT(DATE,GETUTCDATE())
    END    
    IF (@DeadlineFormaula = 'Nearest([Saturday, Wednesday], D)')
    BEGIN
		DECLARE @date DATE = CONVERT(DATE,GETUTCDATE())
		SET @date = CASE WHEN DATENAME(DW,@DATE) = 'SUNDAY' THEN  CAST(DATEADD(DAY,-1,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@DATE) = 'MONDAY' THEN CAST(DATEADD(DAY,-2,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@DATE) = 'TUESDAY' THEN CAST(DATEADD(DAY,-3,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@DATE) = 'WEDNESDAY' THEN CAST(DATEADD(DAY,-1,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@DATE) = 'THURSDAY' THEN CAST(DATEADD(DAY,-1,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@DATE) = 'FRIDAY' THEN CAST(DATEADD(DAY,-2,@DATE) AS DATETIME)
		        ELSE @DATE
		END
        SET @TransitionActualDate = @date
    END
	IF (@DeadlineFormaula = 'Nearest([Saturday, Wednesday], D) +2')
    BEGIN
		DECLARE @deadLinedate DATE = CONVERT(DATE,GETUTCDATE())
		SET @deadLinedate = CASE WHEN DATENAME(DW,@DATE) = 'SUNDAY' THEN  CAST(DATEADD(DAY,-1,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@deadLinedate) = 'MONDAY' THEN CAST(DATEADD(DAY,-2,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@deadLinedate) = 'TUESDAY' THEN CAST(DATEADD(DAY,-3,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@deadLinedate) = 'WEDNESDAY' THEN CAST(DATEADD(DAY,-1,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@deadLinedate) = 'THURSDAY' THEN CAST(DATEADD(DAY,-1,@DATE) AS DATETIME)
		        WHEN DATENAME(DW,@deadLinedate) = 'FRIDAY' THEN CAST(DATEADD(DAY,-2,@DATE) AS DATETIME)
		        ELSE @deadLinedate
		END
        SET @TransitionActualDate = DATEADD(DAY,2,@deadLinedate)
    END    
    RETURN @TransitionActualDate
END