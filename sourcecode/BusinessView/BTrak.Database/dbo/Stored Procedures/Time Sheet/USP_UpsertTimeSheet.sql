-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-17 00:00:00.000'
-- Purpose      Save or update the timesheet
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTimeSheet]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@Date= '2019-07-16 09:57:34.593',@UserId='127133F1-4427-4149-9DD6-B02E0E036971',
--@IsFeed = 1,@InTime ='2019-07-16 09:05:31.617',@OutTime ='2019-07-16 01:01:24.617',@IsNextDay = 1

CREATE PROCEDURE [dbo].[USP_UpsertTimeSheet]
(
  @ButtonTypeId  UNIQUEIDENTIFIER = NULL,
  @TimesheetId   UNIQUEIDENTIFIER = NULL,
  @UserId UNIQUEIDENTIFIER = NULL,
  @Date DATETIME = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @InTime DATETIMEOFFSET = NULL,
  @LunchBreakStartTime DATETIMEOFFSET = NULL,
  @LunchBreakEndTime DATETIMEOFFSET = NULL,
  @OutTime DATETIMEOFFSET = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @IsFeed BIT = 0,
  @IsNextDay  BIT = NULL,
  @BreakInTime  DATETIMEOFFSET = NULL,
  @BreakOutTime DATETIMEOFFSET = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
         
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       		   
			   DECLARE @TimeZoneId UNIQUEIDENTIFIER = (SELECT Id FROM TimeZone WHERE TimeZone = @TimeZone)

			   DECLARE @Currentdate DATETIME = GETDATE()

               IF(@IsFeed IS NULL) SET @IsFeed = 0

			   DECLARE @InTimeTable DATETIMEOFFSET = NULL ,@LunchBreakStartTimeTable DATETIMEOFFSET,@LunchBreakEndTimeTable DATETIMEOFFSET ,@OutTimeTable DATETIMEOFFSET
                    
               SELECT @InTimeTable = InTime ,@LunchBreakStartTimeTable= LunchBreakStartTime , @LunchBreakEndTimeTable = LunchBreakEndTime ,@OutTimeTable = OutTime FROM TimeSheet WHERE UserId  = @UserId AND [Date] = @Date --Id = @TimesheetId

			   DECLARE @IsIntimeGiven BIT 
			   SET  @IsIntimeGiven = CASE WHEN (SELECT Intime from TimeSheet WHERE [Date]=@Date AND @UserId = UserId) IS NULL THEN 0 ELSE 1 END
			
	
				IF(@IsIntimeGiven = 0 AND @InTime IS NULL AND @IsFeed = 0)
				BEGIN

				 RAISERROR('InTimeCantBeEmpty',11,1)

				END

				 ELSE
				                    
               --IF(@InTime IS NOT NULL OR @OutTime IS NOT NULL OR @LunchBreakStartTime IS NOT NULL OR @LunchBreakEndTime IS NOT NULL)
               --BEGIN
                    
                    DECLARE @TimesheetIdCount INT = (SELECT COUNT(1) FROM TimeSheet WHERE Id = @TimesheetId)
         
                     IF(@TimesheetIdCount = 0 AND @TimesheetId IS NOT NULL)
                     BEGIN

                         RAISERROR(50002,16, 1,'TimeSheet')

                     END

					 ELSE IF (@LunchBreakStartTime < @InTime)
						BEGIN
							RAISERROR('LunchInMustBeGreaterThanStartTime',11,1)
						END
					ELSE IF (@LunchBreakStartTime IS NULL AND @LunchBreakEndTime IS NOT NULL)
						BEGIN
							RAISERROR('LunchInCantBeEmpty',11,1)
						END

					ELSE IF (@LunchBreakStartTime > @LunchBreakEndTime)
						BEGIN
							RAISERROR('LunchInMustBeGreaterThanLunchend',11,1)
						END

                     ELSE
                     BEGIN

                         DECLARE @IsNextDayEnd BIT

                         IF(@IsFeed = 1) SET @TimeSheetId = (SELECT Id FROM TimeSheet WHERE ([Date] = CONVERT(DATE,ISNULL(@Date,@Currentdate))) AND UserId = @UserId)
                             
                         IF (@TimesheetId IS NOT NULL)
                         BEGIN
                                
                              DECLARE @OriginalIntime DATETIMEOFFSET,@OriginalLunchBreakStartTime DATETIMEOFFSET,@OriginalLunchBreakEndTime DATETIMEOFFSET,@OriginalOutTime DATETIMEOFFSET  
                              DECLARE @OriginalIntimeTimeZone UNIQUEIDENTIFIER,@OriginalLunchBreakStartTimeTimeZone UNIQUEIDENTIFIER,@OriginalLunchBreakEndTimeTimeZone UNIQUEIDENTIFIER,@OriginalOutTimeTimeZone UNIQUEIDENTIFIER  
                                 
                              SELECT @OriginalIntime = InTime,@OriginalLunchBreakStartTime = LunchBreakStartTime,@OriginalLunchBreakEndTime = LunchBreakEndTime,@OriginalOutTime = OutTime FROM Timesheet WHERE Id = @TimeSheetId AND @IsFeed = 1
                              SELECT @OriginalIntimeTimeZone = InTimeTimeZone,@OriginalLunchBreakStartTimeTimeZone = LunchBreakStartTimeZone,@OriginalLunchBreakEndTimeTimeZone = LunchBreakEndTimeZone,@OriginalOutTimeTimeZone = OutTimeTimeZone FROM Timesheet WHERE Id = @TimeSheetId AND @IsFeed = 1

							  SET @IsNextDayEnd  = CASE WHEN ISNULL(@InTime,@OriginalIntime) IS NOT NULL AND ISNULL(@OutTime,@OriginalOutTime) IS NOT NULL 
													THEN CASE WHEN (ISNULL(@InTime,@OriginalIntime) >= ISNULL(@OutTime,@OriginalOutTime)) 
							                                  THEN CASE WHEN  ISNULL(@IsNextDay,0) = 1 THEN 1 ELSE 0 END
													     ELSE 1 END
													  ELSE 1 END
                              IF(@IsNextDayEnd = 0)
                              BEGIN
                                  
                                  RAISERROR(50018,16, 1)

                              END
                              ELSE
                              BEGIN
                                
                                      UPDATE [dbo].[TimeSheet]
                                              SET [Id] = @TimesheetId,
                                                  [UserId] = @UserId,
                                                  [Date] = @Date,
                                                  [InTime] = ISNULL(@InTime,CASE WHEN @IsFeed = 1 THEN NULL ELSE @OriginalIntime END),
                                                  [InTimeTimeZone] = IIF(@InTime IS NOT NULL,@TimeZoneId, CASE WHEN @IsFeed = 1 THEN NULL ELSE @OriginalIntimeTimeZone END),
                                                  [LunchBreakStartTime] = ISNULL(@LunchBreakStartTime,	CASE WHEN @IsFeed = 1 THEN NULL ELSE @OriginalLunchBreakStartTime END),
                                                  [LunchBreakStartTimeZone] = IIF(@LunchBreakStartTime IS NOT NULL,@TimeZoneId, CASE WHEN @IsFeed = 1 THEN NULL ELSE @OriginalLunchBreakStartTimeTimeZone END),
                                                  [LunchBreakEndTime] = ISNULL(@LunchBreakEndTime,CASE WHEN @IsFeed = 1 THEN NULL ELSE @OriginalLunchBreakEndTime END),
                                                  [LunchBreakEndTimeZone] = IIF(@LunchBreakEndTime IS NOT NULL,@TimeZoneId, CASE WHEN @IsFeed = 1 THEN NULL ELSE @OriginalLunchBreakEndTimeTimeZone END),
                                                  [OutTime] = CASE WHEN (@IsNextDay = 1 AND @OutTime IS NOT NULL)THEN DATEADD( DD,1, ISNULL(@OutTime,@OriginalOutTime)) ELSE ISNULL(@OutTime,CASE WHEN @IsFeed = 1 THEN NULL ELSE  @OriginalOutTime END) END ,
                                                  [OutTimeTimeZone] = IIF((CASE WHEN (@IsNextDay = 1 AND @OutTime IS NOT NULL)THEN DATEADD( DD,1, ISNULL(@OutTime,@OriginalOutTime)) ELSE ISNULL(@OutTime,CASE WHEN @IsFeed = 1 THEN NULL ELSE  @OriginalOutTime END) END) IS NOT NULL , @TimeZoneId, @OriginalOutTimeTimeZone),
												  [UpdatedDateTime] = @Currentdate,
                                                  [UpdatedByUserId] = @OperationsPerformedBy,
                                                  [IsFeed] = @IsFeed,
                                                  [ButtonTypeId] = @ButtonTypeId,
                                                  [Time] = NULL
                                         WHERE Id = @TimesheetId

										IF(SELECT COUNT(1) FROM TimeSheet WHERE Id = @TimesheetId AND OutTime IS NOT NULL) > 0
										BEGIN
											DECLARE @EMPLOYEEID UNIQUEIDENTIFIER, @EMPLOYEEIDJSON NVARCHAR(MAX) 

											SELECT @EMPLOYEEID = E.Id
											FROM [User] U
											INNER JOIN Employee E ON E.UserId = U.Id
											WHERE U.Id = @UserId

											DECLARE @ROSTERDATE DATETIME = CONVERT(DATE, @DATE)
											EXEC  [dbo].[USP_GetEmployeeRosterRatesWithTimeSheetData] @ROSTERDATE, @ROSTERDATE, @EMPLOYEEID, @OperationsPerformedBy
											
											EXEC [dbo].[USP_GetPermanentEmployeePayments] @OperationsPerformedBy, @ROSTERDATE, @ROSTERDATE, 0, @EMPLOYEEID
										END
                                END

                           END

                           ELSE
                           BEGIN

							 SET @IsNextDayEnd  = CASE WHEN @InTime IS NOT NULL AND @OutTime IS NOT NULL 
													THEN CASE WHEN @InTime >= @OutTime
							                                  THEN CASE WHEN  ISNULL(@IsNextDay,0) = 1 THEN 1 ELSE 0 END
													     ELSE 1 END
													  ELSE 1 END

                                  IF(@IsNextDayEnd = 0)
                                  BEGIN
                                      
                                      RAISERROR(50018,16, 1)
                                  END

                                  ELSE
                                  BEGIN
                                
                                     SET  @TimesheetId  =  NEWID()
                                      
                                     INSERT INTO [dbo].[TimeSheet](
                                                      [Id],
                                                      [UserId],
                                                      [Date],
                                                      [InTime],
                                                      [LunchBreakStartTime],
                                                      [LunchBreakEndTime],
                                                      [OutTime],
													  [InTimeTimeZone],
													  [OutTimeTimeZone],
													  [LunchBreakStartTimeZone],
													  [LunchBreakEndTimeZone],
                                                      [CreatedDateTime],
                                                      [CreatedByUserId],
                                                      [IsFeed],
                                                      [ButtonTypeId],
                                                      [Time]
                                                      )
                                             SELECT @TimesheetId,
                                                      @UserId,
                                                      @Date,
                                                      @InTime,
                                                      @LunchBreakStartTime,
                                                      @LunchBreakEndTime,
                                                      CASE WHEN @IsNextDay = 1 THEN DATEADD( DD,1,@OutTime) ELSE @OutTime END,
													  IIF(@InTime IS NOT NULL, @TimeZoneId, NULL),
													  IIF(@OutTime IS NOT NULL, @TimeZoneId, NULL),
													  IIF(@LunchBreakStartTime IS NOT NULL, @TimeZoneId, NULL),
													  IIF(@LunchBreakEndTime IS NOT NULL, @TimeZoneId, NULL),
                                                      @Currentdate,
                                                      @OperationsPerformedBy,
                                                      @IsFeed,
                                                      @ButtonTypeId,
                                                      NULL
											
										IF(SELECT COUNT(1) FROM TimeSheet WHERE Id = @TimesheetId AND OutTime IS NOT NULL) > 0
										BEGIN
											DECLARE @EMPLOYEEID2 UNIQUEIDENTIFIER, @EMPLOYEEIDJSON2 NVARCHAR(MAX) 

											SELECT @EMPLOYEEID2 = E.Id
											FROM [User] U
											INNER JOIN Employee E ON E.UserId = U.Id
											WHERE U.Id = @UserId

											DECLARE @ROSTERDATE2 DATETIME = CONVERT(DATE, @DATE)
											 EXEC  [dbo].[USP_GetEmployeeRosterRatesWithTimeSheetData] @ROSTERDATE2, @ROSTERDATE2, @EMPLOYEEID2, @OperationsPerformedBy
											 EXEC [dbo].[USP_GetPermanentEmployeePayments] @OperationsPerformedBy, @ROSTERDATE2, @ROSTERDATE2, 0, @EMPLOYEEID2
										END
                                                      
                                   END
                              END                     
                                    IF(@InTime IS NOT NULL AND (@InTimeTable IS NULL OR @InTime<> @InTimeTable))
                                    BEGIN
                                          INSERT INTO [dbo].[TimeSheetHistory](
                                                   [Id],
                                                  [TimeSheetId],
                                                  [OldValue],
                                                  [NewValue],
                                                  [FieldName],                                          
                                                  [CreatedDateTime],
                                                  [CreatedByUserId])
                                          SELECT NEWID(),
                                                  @TimesheetId,
                                                  CONVERT(VARCHAR(50),@InTimeTable,121),
                                                  CONVERT(VARCHAR(50),@InTime,121),
                                                  'Started',
                                                  @Currentdate,
                                                  @OperationsPerformedBy
                                                  
                                       END
                                    IF(@OutTime IS NOT NULL AND (@OutTimeTable IS NULL OR @OutTime <> @OutTimeTable))
                                    BEGIN
                                    
                                    INSERT INTO [dbo].[TimeSheetHistory](
                                                   [Id],
                                                  [TimeSheetId],
                                                  [OldValue],
                                                  [NewValue],
                                                  [FieldName],                                          
                                                  [CreatedDateTime],
                                                  [CreatedByUserId])
                                          SELECT NEWID(),
                                                  @TimesheetId,
                                                  CONVERT(VARCHAR(50), @OutTimeTable,121),
                                                  CONVERT(VARCHAR(50),@OutTime,121),
                                                  'Finished',
                                                  @Currentdate,
                                                  @OperationsPerformedBy
                                    END
                                     IF(@LunchBreakStartTime IS NOT NULL AND (@LunchBreakStartTimeTable IS NULL  OR @LunchBreakStartTime <> @LunchBreakStartTimeTable))
                                     BEGIN
                                     
                                      INSERT INTO [dbo].[TimeSheetHistory](
                                                    [Id],
                                                   [TimeSheetId],
                                                   [OldValue],
                                                   [NewValue],
                                                   [FieldName],                                          
                                                   [CreatedDateTime],
                                                   [CreatedByUserId])
                                           SELECT NEWID(),
                                                   @TimesheetId,
                                                   CONVERT(VARCHAR(50),@LunchBreakStartTimeTable,121),
                                                   CONVERT(VARCHAR(50),@LunchBreakStartTime,121),
                                                   'LunchStart',
                                                   @Currentdate,
                                                   @OperationsPerformedBy
                                     END
                                    
                                    IF(@LunchBreakEndTime IS NOT NULL AND (@LunchBreakEndTimeTable IS  NULL  OR @LunchBreakEndTime <> @LunchBreakEndTimeTable))
                                    BEGIN
                                     INSERT INTO [dbo].[TimeSheetHistory](
                                                  [Id],
                                                  [TimeSheetId],
                                                  [OldValue],
                                                  [NewValue],
                                                  [FieldName],                                          
                                                  [CreatedDateTime],
                                                  [CreatedByUserId])
                                          SELECT NEWID(),
                                                  @TimesheetId,
                                                  CONVERT(VARCHAR(50),@LunchBreakEndTimeTable,121),
                                                  CONVERT(VARCHAR(50),@LunchBreakEndTime,121),
                                                  'LunchEnd',
                                                  @Currentdate,
                                                  @OperationsPerformedBy
                                    END
                         
                          SELECT Id FROM [dbo].[TimeSheet] where Id = @TimesheetId
                     END
                 --END : TODO : Allowing intime with null

                     IF(@BreakInTime IS NOT NULL OR @BreakOutTime IS NOT NULL)
                     BEGIN

                        DECLARE @IsTimeSheetExist BIT = CASE WHEN EXISTS(SELECT Id FROM TimeSheet WHERE [Date] = ISNULL(@Date,CONVERT(DATE,@Currentdate)) 
                                                                          AND (@IsFeed = 0 OR InTime IS NOT NULL) --TODO : Added for intime null Records
                                                                          AND UserId = CASE WHEN @IsFeed = 1 THEN @UserId ELSE @OperationsPerformedBy END) THEN 1 ELSE 0 END
                        
                        IF(@IsTimeSheetExist = 1)   
                        BEGIN
                            
                             DECLARE @UserBreakId UNIQUEIDENTIFIER-- = NEWID()
                             
                             DECLARE @BreakInTimeTable DATETIMEOFFSET      
							        
                             SELECT @BreakInTimeTable = BreakIn, 
                                    @UserBreakId= Id FROM UserBreak 
                                        WHERE ([Date] = ISNULL(@Date,CONVERT(DATE,@Currentdate))) AND UserId= @UserId AND BreakOut IS NULL AND BreakIn IS NOT NULL   
										   
							IF(@BreakOutTime < @BreakInTime 
								OR @BreakInTime < @InTime OR @BreakOutTime < @InTime
								OR @BreakInTime < @InTimeTable OR @BreakOutTime < @InTimeTable
								OR @OutTime < @BreakInTime OR @OutTime < @BreakInTimeTable
								OR @OutTime < @BreakOutTime OR @OutTimeTable < @BreakOutTime
								OR @OutTimeTable < @BreakInTime OR @OutTimeTable < @BreakInTimeTable
								OR (@BreakInTimeTable IS NOT NULL AND @BreakOutTime < @BreakInTimeTable))
                            BEGIN
                                RAISERROR('PleaseEnterTheValidBreakDetails',11,1)
                            END    
							          
                            IF(@BreakInTime IS NOT NULL AND @BreakOutTime IS NULL AND @Date = CONVERT(DATE,@Currentdate))
                            BEGIN
                                
                                DECLARE @UserBreakCount INT = (SELECT Count(1) FROM UserBreak WHERE UserId= @UserId AND [Date] = CONVERT(DATE,@Currentdate) AND BreakIn IS NOT NULL AND BreakOut IS NULL)
                                
                                IF(@UserBreakCount >= 1)
                                    RAISERROR ('YouHaveAlreadyEnteredBreakIn',11, 1)
                               
                                    
                            END

                            IF(@BreakInTime IS NOT NULL)
                            BEGIN
                                
                                DECLARE @BreakCount INT = (SELECT Count(1) FROM UserBreak WHERE UserId= @UserId AND BreakIn IS NOT NULL AND BreakOut IS NULL)
                                
                                IF(@BreakCount >= 1)
                                    RAISERROR ('PleaseUpdateBreakoutTimeForPreviousBreak',11, 1)
                               
                                    
                            END
                             IF(@UserBreakId IS NULL)
                             BEGIN
                              SET @UserBreakId = NEWID()
                              INSERT INTO [dbo].[UserBreak](
                                             [Id],
                                             [UserId],
                                             [IsOfficeBreak],
                                             [Date],
                                             [BreakIn],
                                             [BreakOut],
											 [BreakInTimeZone],
											 [BreakOutTimeZone]
                                             )
                                      SELECT @UserBreakId,
                                             @UserId,
                                             0,
                                             ISNULL(@Date,CONVERT(DATE,@Currentdate)),
                                             @BreakInTime,
                                             @BreakOutTime,
											 IIF(@BreakInTime IS NOT NULL,@TimeZoneId, NULL),
											 IIF(@BreakOutTime IS NOT NULL,@TimeZoneId, NULL)
                              
                              END
                              ELSE
                              BEGIN
                              
                              UPDATE   [dbo].[UserBreak]
                                        SET  [BreakIn] = @BreakInTimeTable ,                                 
                                             [BreakOut] = @BreakOutTime,
											 [BreakInTimeZone] = IIF(@BreakInTime IS NOT NULL,@TimeZoneId, NULL),
											 [BreakOutTimeZone] = IIF(@BreakOutTime IS NOT NULL,@TimeZoneId, NULL)
                                        WHERE UserId = @UserId AND Id = @UserBreakId 
                                
                              END 
                             IF(@BreakInTimeTable IS NULL OR @BreakInTime <> @BreakInTimeTable)
                             BEGIN
                             INSERT INTO [dbo].[TimeSheetHistory](
                                            [Id],
                                            [UserBreakId],
                                            [OldValue],
                                            [NewValue],
                                            [FieldName],                                          
                                            [CreatedDateTime],
                                            [CreatedByUserId])
                                       SELECT NEWID(),
                                              @UserBreakId,
                                              NULL,
                                              CONVERT(VARCHAR(50),@BreakOutTime,121),
                                              'BreakStarted',
                                              @Currentdate,
                                              @OperationsPerformedBy 
                              END
                              IF(@BreakOutTime IS NOT NULL)
                              BEGIN
                            
                             INSERT INTO [dbo].[TimeSheetHistory](
                                            [Id],
                                            [UserBreakId],
                                            [OldValue],
                                            [NewValue],
                                            [FieldName],                                          
                                            [CreatedDateTime],
                                            [CreatedByUserId])
                                     SELECT NEWID(),
                                            @UserBreakId,
                                            NULL,
                                            CONVERT(VARCHAR(50),@BreakOutTime,121),
                                           'BreakEnded',
                                            @Currentdate,
                                            @OperationsPerformedBy 
                              END
                             SELECT Id FROM UserBreak WHERE Id= @UserBreakId 
                       END
                       ELSE
                            RAISERROR ('YouHaveNotStartedYet!',11, 1)
                            
                     END
            END
      ELSE
      BEGIN
              
        RAISERROR (@HavePermission,11, 1)
                 
      END
    END TRY  
    BEGIN CATCH 
        
        THROW
    END CATCH
END