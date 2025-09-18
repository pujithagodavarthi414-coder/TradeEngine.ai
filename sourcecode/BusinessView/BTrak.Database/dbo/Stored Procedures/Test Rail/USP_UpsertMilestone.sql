-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the Milestone
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the Milestone
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertMilestone]
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@ProjectId='A483A084-7232-4101-9579-4662243D184A'
--,@Title = 'Sprint12'
--,@Description='MileStone'
--,@TestSuiteId='D8352F75-1152-4BCB-A896-7DFBD66FA803'
--,@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d'

CREATE PROCEDURE [dbo].[USP_UpsertMilestone]
(
    @MilestoneId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @Title NVARCHAR(250) = NULL,
	@ParentMilestoneId UNIQUEIDENTIFIER = NULL,
    @Description NVARCHAR(1000) = NULL, 
	@StartDate DATETIMEOFFSET = NULL,
	@EndDate DATETIMEOFFSET = NULL,
	@IsCompleted BIT = NULL,
    @IsArchived BIT = NULL,
	@IsStarted BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
      IF(@HavePermission = '1')
      BEGIN

		IF(@Title = '') SET @Title = NULL

	    IF(@Title IS NULL)
		BEGIN
			
		    RAISERROR(50011,16, 2, 'MileStoneName')

		END
		ELSE
		BEGIN
		    
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @MileStoneIdCount INT = (SELECT COUNT(1) FROM Milestone WHERE Id = @MilestoneId)
			
			DECLARE @TitlesCount INT = (SELECT COUNT(1) FROM [dbo].[Milestone] WHERE [Title] = @Title AND ProjectId = @ProjectId AND (Id <> @MilestoneId OR @MilestoneId IS NULL) AND InactiveDateTime IS NULL)
			  
		    IF(@MileStoneIdCount = 0 AND @MilestoneId IS NOT NULL)
		    BEGIN
		    	RAISERROR(50002,16, 1,'MileStone')
		    END
			ELSE IF(@TitlesCount > 0)
			BEGIN

				RAISERROR(50001,16,1,'MileStone')

			END	
			ELSE
		    BEGIN
				
					DECLARE @IsLatest BIT = (CASE WHEN @MilestoneId IS NULL 
					                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																		 FROM [Milestone] WHERE Id = @MilestoneId) = @TimeStamp
																   THEN 1 ELSE 0 END END)
					IF(@IsLatest = 1)
					BEGIN
					
						 DECLARE @Currentdate DATETIME = GETDATE()
						
						 DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'MilestoneCreatedOrUpdated' AND CompanyId = @CompanyId)
					     
					     DECLARE @NewMilestoneId UNIQUEIDENTIFIER = NEWID()
					     
					     DECLARE @VersionNumber INT,@OriginalCreatedDateTime DateTime
					     
						 DECLARE @FieldName NVARCHAR(100)

						    IF(@MilestoneId IS NULL)
						    BEGIN
						    
							 SET @MilestoneId = NEWID()

						     INSERT INTO [dbo].[Milestone](
						                 [Id],
						                 [ProjectId],
						    			 [Title],
						    			 [ParentMilestoneId],
						                 [Description],
						    			 [StartDate],
						    			 [EndDate],
						    			 [IsCompleted],
						                 [InActiveDateTime],
						    			 [IsStarted],
						                 [CreatedDateTime],
						                 [CreatedByUserId]
										 )
						           SELECT @MilestoneId,
						                  @ProjectId,
						                  @Title,
						    			  @ParentMilestoneId,
						                  @Description,
						    			  @StartDate,
						    			  @EndDate,
						    			  @IsCompleted,
						                  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						    			  @IsStarted,
						                  @Currentdate,
						                  @OperationsPerformedBy
						    			 
										  SET @FieldName = 'MileStoneCreated'

                                         EXEC [dbo].[USP_InsertTestCaseHistory] @OperationsPerformedBy=@OperationsPerformedBy,@FieldName= @FieldName,@NewValue = @Title,@ConfigurationId = @ConfigurationId,@ReferenceId = @MilestoneId,@Description = 'VersionAdded'

                               END
							   ELSE
							   BEGIN

								EXEC [USP_InsertTestRailAuditHistory] @MilestoneId = @MilestoneId,
									                                  @MileStoneProjectId = @ProjectId,
						    		                                  @MileStoneTitle = @Title,
						    		                                  @MileStoneParentMilestoneId = @ParentMilestoneId,
						                                              @MileStoneDescription = @Description,
						    		                                  @MileStoneStartDate = @StartDate,
						    		                                  @MileStoneEndDate = @EndDate,
						    		                                  @MileStoneIsCompleted = @IsCompleted,
						                                              @MileStoneIsArchived = @IsArchived,
						    		                                  @MileStoneIsStarted = @IsStarted,
									                                  @OperationsPerformedBy = @OperationsPerformedBy

							       UPDATE  [dbo].[Milestone] 
							         SET   
						                   [ProjectId]          = @ProjectId,
						    		       [Title]              = @Title,
						    		       [ParentMilestoneId]  = @ParentMilestoneId,
						                   [Description]        = @Description,
						    		       [StartDate]          = @StartDate,
						    		       [EndDate]            = @EndDate,
						    		       [IsCompleted]        = @IsCompleted,
						                   [InActiveDateTime]   = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
						    		       [IsStarted]          = @IsStarted,
									       [UpdatedByUserId]    = @OperationsPerformedBy,
									       [UpdatedDateTime]    = @Currentdate
									       WHERE Id = @MilestoneId

							   END

                           IF(@IsCompleted = 1)
						   BEGIN
											     
                                            UPDATE TestRun 
									         SET IsCompleted = 1,
							                     UpdatedDateTime = @Currentdate,
												 UpdatedByUserId = @OperationsPerformedBy
												 FROM TestRun TR 
											     WHERE TR.MilestoneId = @MilestoneId 
													  AND TR.InActiveDateTime IS NULL 
													  AND TR.IsCompleted <> 1  
						  
						   END

						SELECT Id FROM [dbo].[Milestone] where Id = @MilestoneId

					END
					ELSE
						RAISERROR (50008,11, 1)

				END
			
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
GO