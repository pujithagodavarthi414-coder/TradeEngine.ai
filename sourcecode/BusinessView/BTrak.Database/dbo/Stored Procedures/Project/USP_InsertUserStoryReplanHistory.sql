--SELECT * FROM UserStoryReplan WHERE GoalId = 'D88AEEC7-860B-4241-9970-E0CD8327C273'
-------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_InsertUserStoryReplanHistory] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',
--@GoalId='D88AEEC7-860B-4241-9970-E0CD8327C273',@GoalReplanTypeId = 'E548CD87-6401-4EEB-8527-6F90F81247FB',
--@UserStoryReplanXML =  '<?xml version="1.0" encoding="utf-8"?>
--<GenericListOfUserStoryReplanChangedValues
--  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
--  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <ListItems>
--      <UserStoryReplanChangedValues>
--          <OldValue xsi:type="xsd:decimal">2.5</OldValue>
--          <NewValue xsi:type="xsd:decimal">8.00</NewValue>
--          <UserStoryId>61FC17E0-7C26-4585-A09C-05A7FD20386E</UserStoryId>
--          <UserStoryReplanTypeId>de88ff80-b0a0-4399-a933-5b2b948329ed</UserStoryReplanTypeId>
--      </UserStoryReplanChangedValues>
--  </ListItems>
--</GenericListOfUserStoryReplanChangedValues>'
----------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertUserStoryReplanHistory]
(
@GoalId UNIQUEIDENTIFIER = NULL,
@SprintId UNIQUEIDENTIFIER = NULL,
@GoalReplanTypeId UNIQUEIDENTIFIER = NULL,
@UserStoryReplanXML XML ,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@UserStoryDeadLine DATETIME = NULL,
@TimeZone NVARCHAR(250) = NULL,
@UserStoryStartDate DATETIME = NULL,
@IsFromSprint BIT = NULL
)
As
BEGIN 
    SET NOCOUNT ON 
    BEGIN   TRY
                
        DECLARE @HavePermission NVARCHAR(250) = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy, (SELECT OBJECT_NAME(@@PROCID))))
                
        IF (@HavePermission='1')
        BEGIN 
          IF(@GoalId IS NULL AND @IsFromSprint = 0)
          BEGIN
            RAISERROR (50011,11,1,'Goal')
          END
		  IF(@SprintId IS NULL AND @IsFromSprint = 1)
          BEGIN
            RAISERROR (50011,11,1,'Sprint')
          END
          IF(@GoalReplanTypeId IS NULL)
          BEGIN
            RAISERROR (50011,11,1,'GoalReplanType')
          END
          ELSE
          BEGIN
          
			DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

			DECLARE @TimeZoneId UNIQUEIDENTIFIER = (SELECT Id FROM TimeZone WHERE TimeZone = @TimeZone)

			DECLARE @CompanyId UNIQUEIDENTIFIER = (
													  SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
												  )
			DECLARE @GoalReplanId UNIQUEIDENTIFIER 
			DECLARE @GoalReplanCount INT

			IF (@IsFromSprint = 1)
			BEGIN
			     SET @GoalReplanId =  (
														 SELECT TOP (1)
															 Id
														 FROM GoalReplan
														 WHERE GoalId = @SprintId
														 ORDER BY CreatedDateTime DESC
										)
				SET @GoalReplanCount = (
											   SELECT COUNT(1) FROM GoalReplan WHERE GoalId = @SprintId
									    )
			END
			ELSE
			BEGIN
			    SET @GoalReplanId =  (
														 SELECT TOP (1)
															 Id
														 FROM GoalReplan
														 WHERE GoalId = @GoalId
														 ORDER BY CreatedDateTime DESC
									)
			   SET @GoalReplanCount = (
											   SELECT COUNT(1) FROM GoalReplan WHERE GoalId = @GoalId
									  )
			END
			
			  

			CREATE TABLE #ReplanHistory
			(
				Id UNIQUEIDENTIFIER,
				OldValue NVARCHAR(250),
				NewValue NVARCHAR(250),
				UserStoryId UNIQUEIDENTIFIER,
				UserStoryReplanTypeId UNIQUEIDENTIFIER,
				[Description] NVARCHAR(MAX),
				
			)

			INSERT INTO #ReplanHistory
			(
				Id,
				OldValue,
				NewValue,
				UserStoryId,
				UserStoryReplanTypeId
			)
			SELECT NEWID(),
				   x.y.value('(OldValue/text())[1]', 'NVARCHAR(250)'),
				   x.y.value('(NewValue/text())[1]', 'NVARCHAR(250)'),
				   x.y.value('(UserStoryId/text())[1]', 'UNIQUEIDENTIFIER'),
				   x.y.value('(UserStoryReplanTypeId/text())[1]', 'UNIQUEIDENTIFIER')
			FROM @UserStoryReplanXML.nodes('/GenericListOfUserStoryReplanChangedValues
																   /ListItems/UserStoryReplanChangedValues') AS x(y)

			UPDATE [dbo].[Userstory]
			SET UserStoryName = CASE
									WHEN IsUserStoryChange = 1 THEN
										RH.NewValue
									ELSE
										US.UserStoryName
								END,
				EstimatedTime = CASE
									WHEN IsEstimatedTimeChange = 1 THEN
										CONVERT(DECIMAL(10, 2), RH.NewValue)
									ELSE
										US.EstimatedTime
								END,

				SprintEstimatedTime = CASE
									WHEN IsEstimatedTimeInSpChange = 1 THEN
										CONVERT(DECIMAL(10, 2), RH.NewValue)
									ELSE
										US.SprintEstimatedTime
								END,

				ActualDeadLineDate = CASE WHEN IsDeadLineChange = 1 AND ActualDeadLineDate IS NULL THEN 
				                              @UserStoryDeadLine
								          ELSE
									          ActualDeadLineDate
							    END,
                ActualDeadLineDateTimeZone = CASE WHEN IsDeadLineChange = 1 AND ActualDeadLineDate IS NULL AND @UserStoryDeadLine IS NOT NULL THEN @TimeZoneId
								                  ELSE NULL END,
				DeadLineDate = CASE
								   WHEN IsDeadLineChange = 1 THEN
									   @UserStoryDeadLine
								   ELSE
									   DeadLineDate
							   END,
                DeadLineDateTimeZone = CASE WHEN IsDeadLineChange = 1 AND @UserStoryDeadLine IS NOT NULL THEN @TimeZoneId   
				                             ELSE NULL END,
				OwnerUserId = CASE
								  WHEN IsOwnerChange = 1 THEN
									  CONVERT(UNIQUEIDENTIFIER, RH.NewValue)
								  ELSE
									  OwnerUserId
							  END,
				DependencyUserId = CASE
									   WHEN IsDependencyChange = 1 THEN
										   CONVERT(UNIQUEIDENTIFIER, RH.NewValue)
									   ELSE
										   DependencyUserId
								   END,
			    StartDate = CASE
									   WHEN IsStartDateChange = 1 THEN
										   @UserStoryStartDate
									   ELSE
										   StartDate
								   END,
				[UpdatedDateTime] = @Currentdate,
				[UpdatedDateTimeZoneId] = @TimeZoneId,
				[UpdatedByUserId] = @OperationsPerformedBy
			FROM [Userstory] US
				JOIN #ReplanHistory RH
					ON RH.UserStoryId = US.Id
					   AND US.InActiveDateTime IS NULL
				JOIN UserStoryReplanType USRT
					ON USRT.Id = RH.UserStoryReplanTypeId

					  UPDATE #ReplanHistory SET [Description] = CASE WHEN USR.IsEstimatedTimeChange = 1 THEN 'UserStoryEstimateChange'
                                                                                            WHEN USR.IsDeadLineChange = 1 THEN 'UserStoryDeadLineChange'
                                                                                            WHEN USR.IsUserStoryChange = 1 THEN 'UserStoryNameChange'
                                                                                            WHEN USR.IsOwnerChange = 1 THEN 'UserStoryOwnerChange'
                                                                                            WHEN USR.IsDependencyChange = 1 THEN 'UserStoryDependencyChange'
																							WHEN USR.IsEstimatedTimeInSpChange = 1 THEN 'UserStoryEstimateChangeInSp'
																							WHEN USR.IsStartDateChange = 1 THEN 'UserStoryStartDateChanged'
                                                                                   END,
                                                             [OldValue]  = ISNULL(CASE WHEN USR.IsOwnerChange = 1 THEN (SELECT FirstName + '' + ISNULL(SurName,'') FROM [User] WHERE Id = CONVERT(UNIQUEIDENTIFIER,RH.OldValue)) 
                                                                                             WHEN USR.IsDependencyChange = 1 THEN (SELECT FirstName + '' + ISNULL(SurName,'') FROM [User] WHERE Id = CONVERT(UNIQUEIDENTIFIER,RH.OldValue)) 
                                                                                             WHEN USR.IsEstimatedTimeChange = 1 THEN (SELECT IIF((FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0)/40)) = 0,'',CONVERT(NVARCHAR,(FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0.0)/40))) + 'w ')
                                                                                                                                          +  IIF(FLOOR((ABS(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0)/40.0) - FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0.0)/40.0))*5) = 0,'',CONVERT(NVARCHAR,FLOOR((ABS(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0.0)/40.0) - FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0.0)/40.0))*5)) + 'd ')
                                                                                                                                    +  IIF(((ABS(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0)/8.0) - FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0.0)/8.0))*8) = 0,'',CONVERT(NVARCHAR,CONVERT(DECIMAL(10,2),(ABS(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0.0)/8.0) - FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.OldValue),0.0)/8.0))*8)) + 'h '))
                                                                                             WHEN USR.IsEstimatedTimeInSpChange = 1 THEN RH.OldValue + 'SP'


																				   ELSE  RH.OldValue END,''),
                                                            [NewValue] = CASE WHEN USR.IsOwnerChange = 1 THEN (SELECT FirstName + '' + ISNULL(SurName,'') FROM [User] WHERE Id = CONVERT(UNIQUEIDENTIFIER,RH.NewValue)) 
                                                                                             WHEN USR.IsDependencyChange = 1 THEN (SELECT FirstName + '' + ISNULL(SurName,'') FROM [User] WHERE Id = CONVERT(UNIQUEIDENTIFIER,RH.NewValue)) 
                                                                                             WHEN USR.IsEstimatedTimeChange = 1 THEN (SELECT IIF((FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0)/40)) = 0,'',CONVERT(NVARCHAR,(FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0.0)/40))) + 'w ')
                                                                                                                                          +  IIF(FLOOR((ABS(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0)/40.0) - FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0.0)/40.0))*5) = 0,'',CONVERT(NVARCHAR,FLOOR((ABS(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0.0)/40.0) - FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0.0)/40.0))*5)) + 'd ')
                                                                                                                                          +  IIF(((ABS(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0)/8.0) - FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0.0)/8.0))*8) = 0,'',CONVERT(NVARCHAR,CONVERT(DECIMAL(10,2),(ABS(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0.0)/8.0) - FLOOR(ISNULL(CONVERT(DECIMAL(10,2),RH.NewValue),0.0)/8.0))*8)) + 'h '))
																					         WHEN USR.IsEstimatedTimeInSpChange = 1 THEN RH.NewValue + 'SP'
																					ELSE  RH.NewValue END
                                                            FROM #ReplanHistory RH JOIN UserStoryReplanType USR ON RH.UserStoryReplanTypeId = USR.Id 

					                  INSERT INTO [dbo].[UserStoryReplan](
                                                    [Id],
                                                    [GoalId],
                                                    [GoalReplanId],
                                                    [GoalReplanCount],
                                                    [UserStoryId],
                                                    [UserStoryReplanTypeId],
                                                    [UserStoryReplanJson],
                                                    [OldValue],
                                                    [NewValue],
                                                    [CreatedDateTime],
													[CreatedDateTimeZoneId],
                                                    [CreatedByUserId])
                                             SELECT RH.Id,
                                                    CASE WHEN @IsFromSprint = 1 THEN @SprintId ELSE @GoalId END,
                                                    @GoalReplanId,
                                                    @GoalReplanCount,
                                                    RH.UserStoryId,
                                                    RH.UserStoryReplanTypeId,
                                                    RH.[Description],
                                                    ISNULL(RH.OldValue,''),
                                                    RH.NewValue,
                                                    @Currentdate,
													@TimeZoneId,
                                                    @OperationsPerformedBy
                                                    FROM #ReplanHistory RH

					  SELECT Id AS ReplanIds FROM #ReplanHistory
            END
        END
        ELSE
                RAISERROR(@HavePermission,11,1)
                
    END TRY
    BEGIN CATCH
            
        THROW
        
    END CATCH
END
GO