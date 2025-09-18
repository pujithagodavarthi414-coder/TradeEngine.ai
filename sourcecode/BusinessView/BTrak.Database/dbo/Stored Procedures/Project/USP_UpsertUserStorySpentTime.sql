-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-20 00:00:00.000'
-- Purpose      To Save or Update the UserStorySpentTime
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStorySpentTime] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId='A69A1636-9EE6-4BC3-8F73-04CF0DC56C3D',@SpentTime='20',
--@Comment='TEST',@DateFrom='2019-03-12',@DateTo='2019-03-13',@RemainingEstimateTypeId='8008E5E4-9060-41AF-80EC-BCB5BAF7C22C'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertUserStorySpentTime]
(
    @UserStorySpentTimeId  UNIQUEIDENTIFIER = NULL,
    @UserStoryId  UNIQUEIDENTIFIER = NULL,
    @SpentTime  FLOAT = NULL,
    @Comment NVARCHAR(MAX) = NULL,
    @TimeZone NVARCHAR(250) = NULL,
    @DateFrom DATETIMEOFFSET = NULL,
    @DateTo DATETIMEOFFSET = NULL,
    @RemainingEstimateTypeId UNIQUEIDENTIFIER = NULL,
    @RemainingTimeSetOrReducedBy  FLOAT = NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@StartTime DateTime = NULL,
	@EndTime DateTime = NULL,
	@BreakType BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
         DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		 DECLARE @UserStoryName NVARCHAR(900) = (SELECT UserStoryName FROM [dbo].[UserStory] WHERE Id = @UserStoryId)
					DECLARE @UserStoryStatusName NVARCHAR(900) = (SELECT [Status] FROM [dbo].[UserStoryStatus]USS INNER JOIN [dbo].[UserStory]US ON
					                                              USS.Id = US.UserStoryStatusId WHERE US.Id = @UserStoryId)
         IF(@Comment IS NULL)
					 BEGIN
					    SET @Comment = @UserStoryName + ' ' + '-'+ ' '+ @UserStoryStatusName
					 END
		 IF(@HavePermission = '1')
         BEGIN
			 IF(@Comment IS NOT NULL AND @SpentTime IS NOT NULL AND @DateFrom IS NOT NULL AND @DateTo IS NOT NULL)
			 BEGIN
				 IF (@SpentTime <= 0)
				 BEGIN
					RAISERROR(50022,16,1)
				 END
				 ELSE IF (@SpentTime * 60.000 < 5)
				 BEGIN
					RAISERROR(50021,16,1)
				 END
				 ELSE
				 BEGIN
					
					DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			         SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
                     DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)
          
					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
					DECLARE @EstimatedTime FLOAT = ISNULL((SELECT EstimatedTime FROM UserStory WHERE Id = @UserStoryId),0)
          
					DECLARE @RemainingTimeOfUserStory FLOAT = (SELECT TOP(1) RemainingTimeInMin  FROM UserStorySpentTime WHERE UserStoryId = @UserStoryId ORDER BY CreatedDateTime DESC)
          
					DECLARE @UserInputValue INT = 0
          
					DECLARE @SetToTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM LogTimeOption WHERE IsSetTo = 1)
          
					DECLARE @UseExistingEstimateHoursTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM LogTimeOption WHERE IsUseExistingEstimateHours = 1)
          
					DECLARE @AdjustAutomaticallyTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM LogTimeOption WHERE IsAdjustAutomatically = 1 )
          
					DECLARE @ReduceByTypeId  UNIQUEIDENTIFIER = (SELECT Id FROM LogTimeOption WHERE IsReduceBy = 1)

					
          
					DECLARE @RemainingTimeInMin FLOAT = 0
           
					IF(@RemainingEstimateTypeId IS NULL)
					BEGIN
					SET @RemainingEstimateTypeId = (SELECT Id FROM LogTimeOption WHERE IsAdjustAutomatically = 1)
					END
          
					SET @RemainingTimeOfUserStory = CASE WHEN (@RemainingTimeOfUserStory IS NULL AND @RemainingEstimateTypeId = @AdjustAutomaticallyTypeId) 
												   THEN (ISNULL(@EstimatedTime,0) - ISNULL(@SpentTime,0)) * 60.000 
												   WHEN (@RemainingTimeOfUserStory IS NOT NULL AND @RemainingEstimateTypeId = @AdjustAutomaticallyTypeId) 
												   THEN ISNULL(@RemainingTimeOfUserStory,0) - ISNULL(@SpentTime,0 ) * 60.000
												   WHEN (@RemainingTimeOfUserStory IS NULL AND @RemainingEstimateTypeId = @ReduceByTypeId) 
												   THEN (ISNULL(@EstimatedTime,0) - ISNULL(@SpentTime,0) - ISNULL(@RemainingTimeSetOrReducedBy,0)) * 60.000
												   WHEN (@RemainingTimeOfUserStory IS NOT NULL AND @RemainingEstimateTypeId = @ReduceByTypeId) 
												   THEN ISNULL(@RemainingTimeOfUserStory,0) - ISNULL(@SpentTime,0) - ISNULL(@RemainingTimeSetOrReducedBy,0) * 60.000
												END 
          
					  IF(@RemainingTimeOfUserStory < 0)
					  BEGIN
						SET @RemainingTimeOfUserStory = 0
					  END
					  ELSE
					  BEGIN
						SET @RemainingTimeInMin =	CASE WHEN (@RemainingEstimateTypeId = @SetToTypeId) THEN ISNULL(@RemainingTimeSetOrReducedBy * 60.000,0) 
													  WHEN @RemainingEstimateTypeId = @UseExistingEstimateHoursTypeId THEN @EstimatedTime * 60.000
													  WHEN @RemainingEstimateTypeId = @ReduceByTypeId THEN @RemainingTimeOfUserStory 
													  ELSE @RemainingTimeOfUserStory
													END
					  END
          
					  DECLARE @IsLatest BIT = (CASE WHEN @UserStorySpentTimeId IS NULL 
														  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																				   FROM Skill WHERE Id = @UserStorySpentTimeId) = @TimeStamp
																			THEN 1 ELSE 0 END END)
					
            
						IF(@IsLatest = 1)
						BEGIN
							IF(@UserStorySpentTimeId IS NULL)
							BEGIN
								SET @UserStorySpentTimeId = NEWID()
								INSERT INTO [dbo].[UserStorySpentTime](
											   [Id],
											   [UserStoryId],
											   [SpentTimeInMin],
											   [Comment],
											   [UserId],
											   [DateFrom],
											   [DateFromTimeZoneId],
											   [DateTo],
											   [DateToTimeZoneId],
											   [LogTimeOptionId],
											   [UserInput],
											   [RemainingTimeInMin],
											   [CreatedDateTime],
											   [CreatedByUserId],
											   [InActiveDateTime],
											   [StartTime],
											   [StartTimeTimeZoneId],
											   [EndTime],
											   [EndTimeTimeZoneId],
											   [BreakType],
											   [CreatedDateTimeZoneId])
										SELECT @UserStorySpentTimeId,
											   @UserStoryId,
											   @SpentTime*60.00,
											   @Comment,
											   @OperationsPerformedBy,
											   @DateFrom,
											   CASE WHEN @DateFrom IS NOT NULL THEN @TimeZoneId ELSE NULL END,
											   @DateTo,
											   CASE WHEN @DateTo IS NOT NULL THEN @TimeZoneId ELSE NULL END,
											   @RemainingEstimateTypeId,
											   @UserInputValue,
											   @RemainingTimeInMin,
											   @Currentdate,
											   @OperationsPerformedBy,
											   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
											   @StartTime,
											   CASE WHEN @StartTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
											   @EndTime,
											   CASE WHEN @EndTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
											   @BreakType,
											   @TimeZoneId
											  
                            
							END
							ELSE IF (@UserStorySpentTimeId IS NOT NULL)
							BEGIN

							UPDATE [dbo].[UserStorySpentTime]
								SET [UserStoryId]			   =  	    @UserStoryId,
									   [SpentTimeInMin]		   =  	    @SpentTime*60.00,
									   [Comment]			   =  	    @Comment,
									   [UserId]				   =  	    @OperationsPerformedBy,
									   [DateFrom]			   =  	    @DateFrom,
									   [DateTo]				   =  	    @DateTo,
									   [DateFromTimeZoneId]    =        CASE WHEN @DateFrom IS NOT NULL THEN @TimeZoneId ELSE NULL END,
									   [DateToTimeZoneId]      =        CASE WHEN @DateTo IS NOT NULL THEN @TimeZoneId ELSE NULL END,
									   [LogTimeOptionId]	   =  	    @RemainingEstimateTypeId,
									   [UserInput]			   =  	    @UserInputValue,
									   [RemainingTimeInMin]    =  	    @RemainingTimeInMin,
									   [UpdatedDateTime]	   =  	    @Currentdate,
									   [updatedByUserId]	   =  	    @OperationsPerformedBy,
									   [InActiveDateTime]	   =  	    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									   [StartTime]             =        @StartTime,
									   [StartTimeTimeZoneId]   =        CASE WHEN @StartTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
									   [EndTime]               =        @EndTime,
									   [EndTimeTimeZoneId]     =        CASE WHEN @EndTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
									   [BreakType]             =        @BreakType
								WHERE Id = @UserStorySpentTimeId

						END

							SELECT Id FROM [dbo].[UserStorySpentTime] WHERE Id =@UserStorySpentTimeId
						END 
						ELSE
						RAISERROR (50008,11, 1)
					END
			 END
			 ELSE IF((@StartTime IS NOT NULL AND @EndTime IS NULL) OR (@StartTime IS NULL AND @EndTime IS NULL))
		 BEGIN
		 DECLARE @Presentdate DATETIME = SYSDATETIMEOFFSET()
		 SET @UserStorySpentTimeId = NEWID()

		 IF EXISTS(SELECT 1 FROM [dbo].[UserStorySpentTime] WHERE UserStoryId <> @UserStoryId AND UserId = @OperationsPerformedBy AND StartTime IS NOT NULL AND EndTime IS NULL)
		 BEGIN
		 UPDATE [dbo].[UserStorySpentTime] SET EndTime = GETUTCDATE(), UpdatedByUserId = @OperationsPerformedBy WHERE UserStoryId <> @UserStoryId AND UserId = @OperationsPerformedBy AND StartTime IS NOT NULL AND EndTime IS NULL
		 END


			INSERT INTO [dbo].[UserStorySpentTime](
                               [Id],
                               [UserStoryId],
                               [SpentTimeInMin],
                               [Comment],
                               [UserId],
                               [DateFrom],
							   [DateFromTimeZoneId],
                               [DateTo],
							   [DateToTimeZoneId],
                               [LogTimeOptionId],
                               [UserInput],
                               [RemainingTimeInMin],
                               [CreatedDateTime],
                               [CreatedByUserId],
                               [InActiveDateTime],
							   [StartTime],
							   [StartTimeTimeZoneId],
							   [EndTime],
							   [EndTimeTimeZoneId],
							   [BreakType])
                        SELECT @UserStorySpentTimeId,
                               @UserStoryId,
                               @SpentTime*60.00,
                               @Comment,
                               @OperationsPerformedBy,
                               @DateFrom,
							   CASE WHEN @DateFrom IS NOT NULL THEN @TimeZoneId ELSE NULL END,
							   @DateTo,
                               CASE WHEN @DateTo IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                               @RemainingEstimateTypeId,
                               @UserInputValue,
                               @RemainingTimeInMin,
                               @Presentdate,
                               @OperationsPerformedBy,
                               CASE WHEN @IsArchived = 1 THEN @Presentdate ELSE NULL END,
							   @StartTime,
							   CASE WHEN @EndTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
							   @EndTime,
							   CASE WHEN @EndTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
							   @BreakType

							  SELECT Id FROM UserStory WHERE Id = @UserStoryId

		 END
		 ELSE IF (@StartTime IS NOT NULL AND @EndTime IS NOT NULL)
		 BEGIN
		 UPDATE [dbo].[UserStorySpentTime]
						SET [UserStoryId]			   =  	    @UserStoryId,
                               [SpentTimeInMin]		   =  	    @SpentTime*60.00,
                               [Comment]			   =  	    @Comment,
                               [UserId]				   =  	    @OperationsPerformedBy,
                               [DateFrom]			   =  	    @DateFrom,
							   [DateFromTimeZoneId]    =        CASE WHEN @DateFrom IS NOT NULL THEN @TimeZoneId ELSE NULL END,
							   [DateToTimeZoneId]      =        CASE WHEN @DateTo IS NOT NULL THEN @TimeZoneId ELSE NULL END,
                               [DateTo]				   =  	    @DateTo,
                               [LogTimeOptionId]	   =  	    @RemainingEstimateTypeId,
                               [UserInput]			   =  	    @UserInputValue,
                               [RemainingTimeInMin]    =  	    @RemainingTimeInMin,
                               [UpdatedDateTime]	   =  	    @Presentdate,
                               [updatedByUserId]	   =  	    @OperationsPerformedBy,
                               [InActiveDateTime]	   =  	    CASE WHEN @IsArchived = 1 THEN @Presentdate ELSE NULL END,
							   [StartTime]             =        @StartTime,
							   [StartTimeTimeZoneId]   =        CASE WHEN @StartTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
							   [EndTimeTimeZoneId]     =        CASE WHEN @EndTime IS NOT NULL THEN @TimeZoneId ELSE NULL END,
							   [EndTime]               =        @EndTime,
							   [BreakType]             =        @BreakType
						WHERE  CAST(StartTime AS datetime) = @StartTime AND UserStoryId = @UserStoryId AND CreatedByUserId = @OperationsPerformedBy
						SELECT Id FROM UserStory WHERE Id = @UserStoryId
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
