------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetCompanyLevelComplianceAndProductivity] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@Variant=10,@NoOfDays = 5
------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetCompanyLevelComplianceAndProductivity]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @Variant FLOAT = NULL,
  @NoOfDays INT = NULL
) 
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
	    BEGIN
              DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
             
              IF(@Variant IS NULL OR @Variant = 0) SET @Variant = 10

			  IF(@NoOfDays IS NULL OR @NoOfDays = 0) SET @NoOfDays = 1

			  DECLARE @DateFrom datetime = (SELECT dbo.Ufn_GetRequiredPreviousDateExcludingNonWorkingDays (@NoOfDays))

			  DECLARE @DateTo DateTime = DATEADD(DAY, -1, GETDATE())

			  DECLARE @CompliantHours NUMERIC(10,3) = (SELECT CAST([Value] AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like '%SpentTime%' AND [CompanyId] = @CompanyId)

              DECLARE @LeadwithMembers TABLE
              (
                 RowNumber INT IDENTITY(1,1),
                 EmployeeUserId UNIQUEIDENTIFIER,
				 IsCompliant BIT
              )
              
              INSERT INTO @LeadwithMembers(EmployeeUserId)
			  SELECT Id FROM [User] WHERE CompanyId = @CompanyId AND IsActive = 1
                     
              DECLARE @Count INT  = (SELECT COUNT(1) FROM @LeadwithMembers)
    
              DECLARE @UserId UNIQUEIDENTIFIER
			  DECLARE @SpentTime FLOAT
			  DECLARE @BreakTime FLOAT 
			  DECLARE @LogTime FLOAT
			  DECLARE @SpentTimeVariance FLOAT 
			  DECLARE @ExpectedLogTime FLOAT
			  DECLARE @CompliantSpentTime FLOAT
                   
                
			DECLARE @Dates Table
			(
				[Date] DateTime,
				IsWeekend BIT,
				IsHoliday BIT
			)
			WHILE ( @DateFrom < @DateTo)
			BEGIN
			
				INSERT INTO @Dates ([Date], isWeekend) VALUES( @DateFrom,  IIF(DATEPART(WEEKDAY, @DateFrom) IN (7, 1), 1, NULL ))
				SELECT @DateFrom = DATEADD(DAY, 1, @DateFrom)

			END

			UPDATE @Dates SET isHoliday = 1 FROM @Dates D JOIN Holiday H ON D.[date] = H.[Date]
			
			DECLARE @SelectedDate DATETIME
			
			DECLARE DATE_CURSOR CURSOR FOR  
			SELECT [Date] FROM @Dates WHERE (IsHoliday IS NULL OR IsHoliday = 0) AND (IsWeekend IS NULL OR IsWeekend = 0)
			
			OPEN DATE_CURSOR   
			FETCH NEXT FROM DATE_CURSOR INTO @SelectedDate
			
			WHILE @@FETCH_STATUS = 0   
			BEGIN   
			
				DECLARE @ComplianceAndProductvityToDate TABLE
				(
					[Company compliance] DECIMAL(10,2),
					[Company productivity] DECIMAL(10,2),
					[Date] DateTime
				)
				INSERT INTO @ComplianceAndProductvityToDate([Date])
				SELECT @SelectedDate 
			
				WHILE(@Count > 0)
			    BEGIN
			                  
			           SET @UserId =  (SELECT EmployeeUserId FROM @LeadwithMembers E WHERE RowNumber = @Count)
			
			           SET @SpentTime  = (SELECT ((ISNULL(DATEDIFF(MINUTE, TS.InTime, (CASE WHEN @SelectedDate = CAST(GETDATE() AS Date)
			                                                  AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() ELSE TS.OutTime END)),0) -
			                                                  ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)))
			                                         FROM TimeSheet TS
			                                         WHERE [Date] = @SelectedDate AND UserId = @UserId
			                                         GROUP BY TS.UserId,TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.InTime,TS.OutTime)
			                           
			           SET @BreakTime = (SELECT SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)) BreakTime
			                                       FROM UserBreak UB
			                                       WHERE [Date] = @SelectedDate AND UB.UserId = @UserId
			                                       GROUP BY UB.UserId,UB.[Date])
			           SET @SpentTime = (ISNULL(@SpentTime,0) - ISNULL(@BreakTime,0))/60
			           
			           SET @LogTime = (SELECT SUM(SpentTimeInMin/60.0) SpentTime
			                                     FROM UserStory US
			                                     JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND @UserId = UST.CreatedByUserId
			                                     WHERE CONVERT(DATE,UST.CreatedDateTime) = @SelectedDate AND UST.CreatedByUserId = @UserId AND US.InActiveDateTime IS NULL
			                                     GROUP BY CONVERT(DATE,UST.CreatedDateTime))
					
						SET @CompliantSpentTime = (CASE WHEN @SpentTime >= @CompliantHours THEN @CompliantHours ELSE @SpentTime END)*(1/(@Variant*1.0))
						
						SET @SpentTimeVariance = @CompliantSpentTime*(1.0/@Variant) 

						SET @ExpectedLogTime = (CASE WHEN @UserId IN (SELECT UserId FROM ExpectedLoggingHours WHERE CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) THEN (SELECT [Hours] FROM ExpectedLoggingHours WHERE UserId = @UserId) ELSE (@CompliantSpentTime - ISNULL(@SpentTimeVariance ,0)) END) 
						
			             UPDATE @LeadwithMembers SET IsCompliant = CASE WHEN @LogTime >= @ExpectedLogTime THEN 1 ELSE 0 END WHERE RowNumber = @Count
			
			             SET @Count = @Count -1
			               
			         END
			
					 DECLARE @IsCompliantCount FLOAT = (SELECT COUNT(1)*1.0 FROM @LeadwithMembers WHERE IsCompliant = 1)
			
					 DECLARE @TotalEmpCount FLOAT = (SELECT COUNT(1)*1.0 FROM @LeadwithMembers)
			
					 DECLARE @productivity FLOAT = (SELECT SUM(ProductivityIndex) FROM [Ufn_ProductivityIndexofAnIndividual](@SelectedDate,@SelectedDate,Null,@CompanyId))
				
				UPDATE @ComplianceAndProductvityToDate SET [Company compliance] = CAST((@IsCompliantCount/@TotalEmpCount)*100 AS DECIMAL(10,2)) WHERE CONVERT(Date,[Date]) = @SelectedDate
			
				UPDATE @ComplianceAndProductvityToDate SET [Company productivity] = CAST(((@productivity*1.0)/@TotalEmpCount) AS DECIMAL(10,2)) WHERE CONVERT(Date,[Date]) = @SelectedDate
			
				FETCH NEXT FROM DATE_CURSOR INTO @SelectedDate   

			END   
			
			CLOSE DATE_CURSOR   
			DEALLOCATE DATE_CURSOR

			SELECT * FROM @ComplianceAndProductvityToDate

    END
	END TRY
    BEGIN CATCH

        THROW

    END CATCH
END