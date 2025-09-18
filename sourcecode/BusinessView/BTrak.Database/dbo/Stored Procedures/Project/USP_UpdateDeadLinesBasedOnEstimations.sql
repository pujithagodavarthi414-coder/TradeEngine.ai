CREATE PROCEDURE [dbo].[USP_UpdateDeadLinesBasedOnEstimations]
(
  @UserStoryIds XML, 
  @Date DATETIME,
  @GoalId UNIQUEIDENTIFIER,
  @WorkingHoursPerDay DECIMAL = 0,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
	          DECLARE @Currentdate DATETIME = GETDATE()
              Declare @TempUserStoryTable table
               (
                UserStoryId UNIQUEIDENTIFIER,
                EstimatedTime DECIMAL,
				SumOfEstimates DECIMAL,
				CalculatedDays DECIMAL(10,3),
				NewDeadLineDate DATETIME,
				OldDeadLineDate DATETIME
               )
			 
			  IF(@UserStoryIds IS NOT NULL)
			   BEGIN
			    INSERT INTO @TempUserStoryTable(
				                [UserStoryId]
                               )
		               SELECT x.y.value('(text())[1]', 'uniqueidentifier')
					   FROM @UserStoryIds.nodes('GenericListOfGuid/ListItems/guid') AS x(y)
			   END
			   ELSE
			   BEGIN
			   INSERT INTO @TempUserStoryTable(
				                [UserStoryId]
                               )
		               SELECT Id FROM UserStory WHERE GoalId = @GoalId
			   END

			  UPDATE @TempUserStoryTable
			  SET EstimatedTime = US.EstimatedTime,
			  OldDeadLineDate = US.DeadLineDate
			  FROM @TempUserStoryTable AS TUS
			  INNER JOIN UserStory US ON US.Id = TUS.UserStoryId

			  DECLARE @SumOfEstimatedTimes DECIMAL = 0
			  DECLARE @EstimatedTime DECIMAL
			  DECLARE @UserStoryId UNIQUEIDENTIFIER

			  DECLARE TempUserStoryTable_CURSOR CURSOR FOR
              SELECT UserStoryId FROM @TempUserStoryTable
              
              OPEN TempUserStoryTable_CURSOR
              FETCH NEXT FROM TempUserStoryTable_CURSOR INTO @UserStoryId
               
              WHILE @@FETCH_STATUS = 0
              BEGIN
			  SELECT @EstimatedTime = (select top(1) EstimatedTime from UserStory where Id = @UserStoryId)
			  SELECT @SumOfEstimatedTimes = @SumOfEstimatedTimes + @EstimatedTime
	            
				UPDATE @TempUserStoryTable
			    SET SumOfEstimates = @SumOfEstimatedTimes WHERE UserStoryId = @UserStoryId 
	            
              FETCH NEXT FROM TempUserStoryTable_CURSOR INTO @UserStoryId
              END
               
              CLOSE TempUserStoryTable_CURSOR
              DEALLOCATE TempUserStoryTable_CURSOR

			  UPDATE @TempUserStoryTable
			  SET CalculatedDays = CEILING((SumOfEstimates/@WorkingHoursPerDay))
			  FROM @TempUserStoryTable AS TUS

			  UPDATE @TempUserStoryTable
			  SET NewDeadLineDate = [dbo].[Ufn_GetDatewithOutNonWorkingDays]((@Date-1), TUS.CalculatedDays)
			  FROM @TempUserStoryTable AS TUS

			  UPDATE UserStory
			  SET DeadLineDate = TUST.NewDeadLineDate
			  FROM @TempUserStoryTable TUST 
			  INNER JOIN UserStory AS US ON US.Id = TUST.UserStoryId

			  INSERT INTO [Audit](
                             	[Id],
                             	[AuditJson],
                             	[CreatedDateTime],
                             	[CreatedByUserId],
                             	[IsOldAudit])
                       SELECT NEWID(), 
                               (select @OperationsPerformedBy as UserId ,
								TUST.UserStoryId AS UserStoryId,
								null AS FeatureId,
						        @Currentdate AS CreatedDateTime,
								'null' AS FieldName,
								'null' AS UserName,
								'null' AS CreatedDate,
								'Dead Line Set from <em>'+
								ISNULL(CONVERT(NVARCHAR(100), TUST.OldDeadLineDate, 103) ,'null')
								+'</em> to <em>'+ISNULL(CONVERT(NVARCHAR(100), TUST.NewDeadLineDate, 103),'null') +'</em></br>' AS [Description]
						        FOR JSON PATH,WITHOUT_ARRAY_WRAPPER),
                             	@Currentdate,
                             	@OperationsPerformedBy,
                             	0
								FROM @TempUserStoryTable AS TUST

			  SELECT GoalId FROM UserStory WHERE Id IN (SELECT UserStoryId FROM @TempUserStoryTable) GROUP BY GoalId

   END TRY  
   BEGIN CATCH

       SELECT ERROR_NUMBER() AS ErrorNumber,
              ERROR_SEVERITY() AS ErrorSeverity,
              ERROR_STATE() AS ErrorState,
              ERROR_PROCEDURE() AS ErrorProcedure,
              ERROR_LINE() AS ErrorLine,
              ERROR_MESSAGE() AS ErrorMessage

   END CATCH
END
GO