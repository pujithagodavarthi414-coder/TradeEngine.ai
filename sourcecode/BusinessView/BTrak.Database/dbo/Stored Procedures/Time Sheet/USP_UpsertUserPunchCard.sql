-----------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-20 00:00:00.000'
-- Purpose      Save Or Update the PunchCard
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertUserPunchCard] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ButtonTypeId='0693F575-D25D-49F3-8E94-142AE33C7EFC',@ButtonClickedDate=80.0389
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserPunchCard]
(
    @ButtonTypeId  UNIQUEIDENTIFIER = NULL,
	@ButtonClickedDate DateTimeOffset = NULL,
	@TimeZone NVARCHAR(250) = NULL,
    @Latitude  FLOAT = NULL,
    @Longitude FLOAT = NULL,    
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @IsMobilePunchCard  BIT = NULL,
    @IsFeed BIT = NULL,
	@UserReason NVARCHAR(MAX) = NULL,
    @DeviceId NVARCHAR(500),
    @AutoTimeSheet BIT = 0
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
           
           IF(@OperationsPerformedBy IS NULL OR @OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
           BEGIN
            DECLARE @ModeConfig TABLE
	        (
		        ShiftBased BIT,
		        PunchCardBased BIT,
		        IsActiveShift BIT NULL,
		        ModeTypeEnum INT,
		        UserId UNIQUEIDENTIFIER
	        )

            IF(@AutoTimeSheet IS NULL) SET @AutoTimeSheet = 0

            INSERT INTO @ModeConfig (ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum)
		    SELECT TOP 1 ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, GETUTCDATE())

            IF((SELECT TOP 1 PunchCardBased FROM @ModeConfig ) <> 1)
            BEGIN
                SET @OperationsPerformedBy = (SELECT TOP 1 UserId FROM @ModeConfig)
            END
            
           END

            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			            
            IF (@HavePermission = '1')
            BEGIN
               
                 IF (@IsFeed IS NULL) SET @IsFeed = 0

				 DECLARE @TimeZoneId UNIQUEIDENTIFIER = (SELECT Id FROM TimeZone WHERE TimeZone = @TimeZone)

				 IF(@ButtonClickedDate IS NULL) SET @ButtonClickedDate = GETUTCDATE()

                 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                 
                 IF(CASE WHEN @IsMobilePunchCard = 1 THEN (SELECT COUNT(1)                       
                     FROM [CompanyLocation]CL WITH(NOLOCK)  
                     WHERE CL.CompanyId = @CompanyId
                          AND (CONVERT(DECIMAL(10,3),CL.Longitude)) = (CONVERT(DECIMAL(10,3),@Longitude))
                          AND (CONVERT(DECIMAL(10,3),CL.Latitude)) = (CONVERT(DECIMAL(10,3),@Latitude))) ELSE 1 END = 1)
                 BEGIN
                    
                    DECLARE @Currentdate DATETIME  = GETUTCDATE()
                    DECLARE @TimeSheetId UNIQUEIDENTIFIER
                    DECLARE @Id UNIQUEIDENTIFIER
                    DECLARE @MaxOfficeWorkingHours AS INT
		            DECLARE @PreviousDayIntime DATETIME,@PreviousDayOutTime DATETIME,@IsExist BIT = 1
                    DECLARE @LatestUnFinishedTimeSheetId UNIQUEIDENTIFIER

		            SET @MaxOfficeWorkingHours = (SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = (SELECT CompanyId FROM [User] U WHERE U.Id = @OperationsPerformedBy) AND [Key] = 'MaximumWorkingHours')
                    
		            SELECT @PreviousDayIntime = Intime ,@PreviousDayOutTime = @ButtonClickedDate
		                   ,@IsExist = IIF(OutTime IS NULL,0,1)
                           ,@LatestUnFinishedTimeSheetId = Id
		            FROM TimeSheet T WHERE UserId = @OperationsPerformedBy AND [Date] = DATEADD(DAY,-1,(CONVERT(DATE, @ButtonClickedDate)))

		            DECLARE @PreviousDayWorkingHours INT = DATEDIFF(SECOND,@PreviousDayIntime,@PreviousDayOutTime) --Converting automatically from different timezones

                    DECLARE @IsStart BIT ,@IsFinish BIT,@IsLunchStart BIT, @IsLunchEnd BIT, @BreakOut BIT, @BreakIn BIT,@UnFinishedDate DATETIME
					 
					SET @TimeSheetId =  (SELECT Id FROM TimeSheet WHERE ([Date] = CONVERT(DATE,@ButtonClickedDate)) AND UserId = @OperationsPerformedBy)

					IF
                    (
                        @TimeSheetId IS NULL 
                        AND @LatestUnFinishedTimeSheetId IS NOT NULL 
                        AND (@IsExist = 0 AND @PreviousDayWorkingHours < (@MaxOfficeWorkingHours * 3600))
                        --AND @AutoTimeSheet = 0
                    )
                    BEGIN
                        SET @TimeSheetId = @LatestUnFinishedTimeSheetId
                    END
					
					SELECT @UnFinishedDate = [Date] FROM TimeSheet WHERE Id = @TimeSheetId

                    SELECT @IsStart=BT.IsStart,
                           @IsFinish=BT.IsFinish ,
                           @IsLunchStart = IsLunchStart, 
                           @IsLunchEnd = IsLunchEnd, 
                           @BreakOut = BreakOut, 
                           @BreakIn = IsBreakIn FROM ButtonType BT WHERE Id = @ButtonTypeId AND InActiveDateTime IS NULL
                    
                            IF(@IsStart=1 OR @IsLunchStart=1 OR @IsFinish=1 OR @IsLunchEnd =1)
                            BEGIN
                           
                                IF(@TimeSheetId IS NULL)
                                BEGIN
                                
                                     SET @TimeSheetId = NEWID()
                                    
                                     INSERT INTO [dbo].[TimeSheet](
                                                 [Id],
                                                 [UserId],
                                                 [Date],
                                                 [InTime],
                                                 [LunchBreakStartTime],
                                                 [LunchBreakEndTime],
                                                 [IsFeed],
                                                 [OutTime],
												 [InTimeTimeZone],
												 [OutTimeTimeZone],
												 [LunchBreakStartTimeZone],
												 [LunchBreakEndTimeZone],
                                                 [CreatedDateTime],
                                                 [CreatedByUserId]
                                                 )
                                          SELECT @TimeSheetId,
                                                 @OperationsPerformedBy,
                                                 CONVERT(DATE,@ButtonClickedDate),
                                                 CASE WHEN @IsStart = 1 THEN @ButtonClickedDate ELSE NULL END,
                                                 CASE WHEN @IsLunchStart = 1 THEN @ButtonClickedDate ELSE NULL END,
                                                 CASE WHEN @IsLunchEnd = 1 THEN @ButtonClickedDate ELSE NULL END,
                                                 @IsFeed,
                                                 CASE WHEN @IsFinish = 1 THEN @ButtonClickedDate ELSE NULL END,
                                                 CASE WHEN @IsStart = 1 THEN @TimeZoneId ELSE NULL END,
                                                 CASE WHEN @IsFinish = 1 THEN @TimeZoneId ELSE NULL END,
                                                 CASE WHEN @IsLunchStart = 1 THEN @TimeZoneId ELSE NULL END,
                                                 CASE WHEN @IsLunchEnd = 1 THEN @TimeZoneId ELSE NULL END,
                                                 @Currentdate,
                                                 @OperationsPerformedBy
                                                 WHERE @IsStart=1
                                 END  
                                    
                                 ELSE
                                 BEGIN
                                 
                                        DECLARE @LunchBreakStartTime DATETIMEOFFSET,@LunchBreakStartTimeZone UNIQUEIDENTIFIER,@LunchBreakEndTime DATETIMEOFFSET, @LunchBreakEndTimeZone UNIQUEIDENTIFIER,@OutTime  DATETIMEOFFSET,@OutTimeTimeZone UNIQUEIDENTIFIER ,@InTime DATETIMEOFFSET 
                                        
                                        SELECT @LunchBreakEndTime = LunchBreakEndTime,@LunchBreakStartTimeZone = LunchBreakStartTimeZone,@LunchBreakEndTimeZone = LunchBreakEndTimeZone, @LunchBreakStartTime=LunchBreakStartTime,@OutTime=OutTime,@OutTimeTimeZone = OutTimeTimeZone,@InTime = InTime FROM TimeSheet WHERE Id = @TimeSheetId  
                                        
                                        IF(@InTime IS NOT NULL AND (@LunchBreakEndTime IS NULL OR @LunchBreakEndTime IS NOT NULL) 
                                        AND (@LunchBreakEndTime IS NULL OR @LunchBreakEndTime IS NOT NULL) 
                                        AND (@OutTime IS NULL OR @OutTime IS NOT NULL) AND @IsStart = 1)
                                        BEGIN
                                            IF(@AutoTimeSheet = 0)
                                                RAISERROR('YouHaveAlreadyStarted',11,1)
                                        END
                                        ELSE IF(@InTime IS NOT NULL AND @LunchBreakStartTime IS NOT NULL AND (@LunchBreakEndTime IS NULL OR @LunchBreakEndTime IS NOT NULL) AND @OutTime IS NULL AND @IsLunchStart = 1)
                                            RAISERROR('YouHaveAlreadyEnteredLunchStart',11,1)
                                        ELSE IF(@InTime IS NOT NULL AND @LunchBreakStartTime IS NOT NULL AND @LunchBreakEndTime IS NOT NULL AND @OutTime IS NULL AND @IsLunchEnd = 1)
                                            RAISERROR('YouHaveAlreadyEnteredLunchEnd',11,1)
                                        ELSE IF(@InTime IS NOT NULL AND @LunchBreakStartTime IS NOT NULL AND @LunchBreakEndTime IS NOT NULL AND @OutTime IS NOT NULL AND @IsFinish = 1)
                                            RAISERROR('YouHaveAlreadyLeft',11,1)
                                        ELSE
                                        BEGIN
                                            UPDATE [dbo].[TimeSheet]
                                               SET 
                                                  [LunchBreakStartTime]= CASE WHEN @IsLunchStart = 1 THEN @ButtonClickedDate ELSE @LunchBreakStartTime END,
                                                  [LunchBreakEndTime] = CASE WHEN @IsLunchEnd = 1 THEN @ButtonClickedDate ELSE @LunchBreakEndTime END,
                                                  [IsFeed] = @IsFeed,
                                                  [OutTime] = CASE WHEN @IsFinish = 1 THEN @ButtonClickedDate ELSE @OutTime END,
                                                  [OutTimeTimeZone] = CASE WHEN @IsFinish = 1 THEN @TimeZoneId ELSE @OutTimeTimeZone END,
                                                  [LunchBreakStartTimeZone] = CASE WHEN @IsLunchStart = 1 THEN @TimeZoneId ELSE @LunchBreakStartTimeZone END,
                                                  [LunchBreakEndTimeZone] = CASE WHEN @IsLunchEnd = 1 THEN @TimeZoneId ELSE @LunchBreakEndTimeZone END,
                                                  [UpdatedDateTime] = @Currentdate,
												  [UserReason]=@UserReason,
                                                  [UpdatedByUserId] = @OperationsPerformedBy
                                            WHERE Id = @TimeSheetId
                                       END
                                 END
                              
                                 SET @Id = (SELECT Id FROM TimeSheet WHERE Id=@TimeSheetId)
                            
                         END    
                                         
                         ELSE
                         BEGIN
                         IF(@BreakOut = 1)
                         BEGIN
                                DECLARE @BreaksCount INT = (SELECT Count(1) FROM UserBreak WHERE UserId= @OperationsPerformedBy 
								                            AND [Date] = @UnFinishedDate AND BreakIn IS NOT NULL AND BreakOut IS NULL)
                                
                                IF(@BreaksCount = 0)
                                     RAISERROR ('YouHaveNotEnteredBreakIn',11, 1)
                         END
                        
                         DECLARE @UserBreakId UNIQUEIDENTIFIER-- = NEWID()
						 SELECT @UserBreakId = Id FROM UserBreak WHERE ([Date] = @UnFinishedDate) AND UserId= @OperationsPerformedBy 
						           AND BreakOut IS NULL AND BreakIn IS NOT NULL 
                         DECLARE @UserBreakCount INT = (SELECT Count(1) FROM UserBreak 
						                                WHERE UserId= @OperationsPerformedBy AND [Date] = @UnFinishedDate 
														      AND BreakIn IS NOT NULL AND BreakOut IS NULL)
                                
                         IF(@UserBreakCount >= 1 and @BreakIn = 1)
                             RAISERROR ('YouHaveAlreadyEnteredBreakIn',11, 1)                                                                     
                        
                         IF(@UserBreakId IS NULL)
                         BEGIN
                              
							  SET @UserBreakId = NEWID()
                              
							  INSERT INTO [dbo].[UserBreak](
                                             [Id],
                                             [UserId],
                                             [IsOfficeBreak],
                                             [Date],
                                             [BreakIn],
											 [BreakInTimeZone]
                                             )
                                      SELECT @UserBreakId,
                                             @OperationsPerformedBy,
                                             0,
                                             @UnFinishedDate,
                                             @ButtonClickedDate,
											 @TimeZoneId
                                            
                          END
                          ELSE
                          BEGIN
                                 UPDATE [dbo].[UserBreak]
                                    SET [BreakOut] = @ButtonClickedDate,
										[BreakOutTimeZone] = @TimeZoneId
                                    WHERE UserId = @OperationsPerformedBy AND @BreakOut =1 AND BreakOut IS NULL AND Id = @UserBreakId
                                                      
                          END                                     
                        
                         SET @Id =( SELECT Id FROM UserBreak WHERE Id= @UserBreakId )
                        END                   
                  
                    INSERT INTO [dbo].[TimeSheetHistory](
                                [Id],
                                [TimeSheetId],
                                [UserBreakId],
                                [OldValue],
                                [NewValue],
                                [FieldName],                                          
                                [CreatedDateTime],
                                [CreatedByUserId])
                      SELECT NEWID(),
                             @TimesheetId,
                             @UserBreakId,
                             NULL,
                             CONVERT(VARCHAR(50),@ButtonClickedDate,121),
                             CASE WHEN @IsStart = 1 THEN 'Started' 
                                  WHEN @IsFinish = 1 THEN 'Finished' 
                                  WHEN @IsLunchStart =1 THEN 'LunchStarted'
                                  WHEN @IsLunchEnd = 1 THEN 'LunchEnded' 
                                  WHEN @BreakIn = 1 THEN 'BreakStarted' 
                                  WHEN @BreakOut = 1 THEN 'BreakEnded' 
                                  END,
                             @Currentdate,
                             @OperationsPerformedBy
                  IF(@Id IS NULL)
                  SELECT 0 as IsUpdated
                  ELSE
                  SELECT 1 as IsUpdated 
                      
                 END
                 ELSE
                 RAISERROR( 'YouAreNotInCompanyLocation',11,1)
                       
      END
            ELSE
                RAISERROR (@HavePermission,11, 1)
                
   
    END TRY
    BEGIN CATCH
        
          THROW
    END CATCH
END
GO