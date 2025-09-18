 CREATE FUNCTION [dbo].[Ufn_GetDatesWithText]
(
@Text NVARCHAR(100) = NULL
)
RETURNS @Dates TABLE
(
    StartDate DATETIME,
	EndDate DATETIME
)
BEGIN

              DECLARE @StartDate DATETIME
              DECLARE @EndDate DATETIME
              DECLARE @Date DATETIME = GETDATE()

	            IF(@Text  = 'Today')
                 BEGIN
                     SELECT @EndDate = @Date
                     SELECT @StartDate = @Date
                 END 
                 ELSE IF(@Text = 'Yesterday')
                 BEGIN
                     SELECT @EndDate = DATEADD(DAY, -1 , @Date)
                     SELECT @StartDate =  DATEADD(DAY, -1 , @Date)
                 END  
                 ELSE IF(@Text = 'Thisweek' )
                 BEGIN
                     SELECT @EndDate = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Date), CAST(@Date AS DATE))
                     SELECT @StartDate = DATEADD(dd, -(DATEPART(dw, @EndDate)-1), CAST(@EndDate AS DATE))
                 END
                 ELSE IF(@Text = 'Lastweek' )
                 BEGIN
                     SET @EndDate = DATEADD(DAY,  0-DATEPART(WEEKDAY, @Date), GETDATE())  
                     SET @StartDate =  DATEADD(DAY, -6-DATEPART(WEEKDAY, @Date), GETDATE())
                 END 
                ELSE IF(@Text = 'Thismonth')
                 BEGIN
                     SELECT @StartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date), 0)
                     SELECT @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))
                 END
                 ELSE IF(@Text = 'Lastmonth' )
                 BEGIN
                     SET @StartDate  =  DATEADD(mm, DATEDIFF(mm, 0, @Date) - 1, 0)
                     SET @EndDate =  DATEADD(DAY, -(DAY(GETDATE())), @Date)
                 END
                 ELSE IF(@Text = 'Last24hours'   )
                 BEGIN
                     SET @StartDate  =  DATEADD(hh, -24, @Date)
                     SET  @EndDate = @Date
                 END
                 ELSE IF(@Text = 'Last48hours' ) 
                 BEGIN
                      SET @EndDate = @Date
                      SET @StartDate  =  DATEADD(hh, -48, @Date)
                 END
                 ELSE IF(@Text = 'Last7days')
                 BEGIN
                      SET @EndDate  = @Date
                      SET @StartDate =   DATEADD(DD, -6, @Date)
                 END
                ELSE IF(@Text = 'Last14days'  )
                 BEGIN
                     SET @EndDate  = @Date
                      SET  @StartDate =  DATEADD(DD, -13, @Date)
                 END                 
                 ELSE IF(@Text = 'Last30days' )
                 BEGIN
                      SET @EndDate  = @Date
                      SET @StartDate =   DATEADD(DD, -29, @Date)
                 END                
                 ELSE IF(@Text = 'Last60days')
                 BEGIN
                     SET @EndDate  = @Date
                      SET  @StartDate =   DATEADD(DD, -59, @Date)
                 END                
                 ELSE IF(@Text = 'Last90days' )
                 BEGIN
                      SET @EndDate  = @Date
                      SET @StartDate =  DATEADD(DD, -89, @Date)
                 END
				INSERT INTO @Dates(StartDate,EndDate)
				SELECT @StartDate AS StartDate,@EndDate AS EndDate
		RETURN
END