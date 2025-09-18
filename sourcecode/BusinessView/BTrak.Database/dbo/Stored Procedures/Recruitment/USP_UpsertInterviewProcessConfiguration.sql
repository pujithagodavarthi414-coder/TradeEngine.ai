--EXEC [dbo].[USP_UpsertInterviewProcessConfiguration] @InterviewProcessId='a59c6a14-4931-460c-9fe6-082ffe8b3291',
--@IsInitial=1,
--@OperationsPerformedBy='498C2AC7-A670-42F7-AF90-2B35624617E8',@JobOpeningId='aa9cce00-c590-499c-82c7-1c3cacb9b78b'
--@InterviewTypeIds='<?xml version=\"1.0\" encoding=\"utf-16\"?><GenericListOfNullableOfGuid xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><ListItems><guid>78a5c0e6-4b1a-46cd-b4b1-c2cf87d76970</guid><guid>705b1115-1707-46f4-9757-1b0ad4b6b4fc</guid><guid>1bdc905e-696e-40e3-837e-4384467d7792</guid><guid>7e934499-0f02-4e5a-bb39-7c7b2d1df92d</guid></ListItems></GenericListOfNullableOfGuid>'
CREATE PROCEDURE [dbo].[USP_UpsertInterviewProcessConfiguration]
(
   @InterviewProcessConfigurationId UNIQUEIDENTIFIER = NULL,
   @InterviewTypeId UNIQUEIDENTIFIER = NULL,
   @InterviewProcessId UNIQUEIDENTIFIER = NULL,
   @IsInitial INT,
   @JobOpeningId UNIQUEIDENTIFIER = NULL,
   @CandidateId UNIQUEIDENTIFIER = NULL,
   @IsPhoneCalling  BIT = NULL,
   @IsVideoCalling  BIT = NULL,
   @InterviewTypeIds XML = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @StatusId UNIQUEIDENTIFIER = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 --   IF(@InterviewTypeId IS NULL)
		--BEGIN

		--   RAISERROR(50011,16, 2, 'InterviewTypeId')

		--END
		--IF(@InterviewProcessId IS NULL)
		--BEGIN

		--   RAISERROR(50011,16, 2, 'InterviewProcessId')

		--END
		--ELSE
		--BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @InterviewProcessConfigurationIdCount INT = (SELECT COUNT(1) FROM InterviewProcessConfiguration  WHERE Id = @InterviewProcessConfigurationId)

			--DECLARE @InterviewProcessConfigurationCount INT = (SELECT COUNT(1) FROM InterviewProcessConfiguration WHERE InterviewTypeId = @InterviewTypeId AND InterviewProcessId = @InterviewProcessId AND (@InterviewProcessConfigurationId IS NULL OR @InterviewProcessConfigurationId <> Id))
       
			--IF(@InterviewProcessConfigurationIdCount = 0 AND @InterviewProcessConfigurationId IS NOT NULL)
			--BEGIN

			--    RAISERROR(50002,16, 2,'InterviewProcessConfiguration')

			--END
			--IF (@InterviewProcessConfigurationCount > 0)
			--BEGIN

			--	RAISERROR(50001,11,1,'InterviewProcessConfiguration')

			--END
			--ELSE        
			--BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = '1'--(CASE WHEN @InterviewProcessConfigurationId IS NULL THEN 1 
						                    --ELSE CASE WHEN (SELECT [TimeStamp] FROM [InterviewProcessConfiguration] WHERE Id = @InterviewProcessConfigurationId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@IsInitial = 1)
					  BEGIN
					  --DECLARE @DefaultStatus UNIQUEIDENTIFIER = (SELECT ID FROM ScheduleStatus WHERE [Order]='1' AND CompanyId=@CompanyId)
									IF(@JobOpeningId IS NOT NULL AND @CandidateId IS NULL)
									BEGIN
										 UPDATE InterviewProcessConfiguration
										 SET InActiveDateTime=GETDATE()
										 WHERE 
										 CandidateId IS NULL
										 AND JobOpeningId=@JobOpeningId
										 AND InActiveDateTime IS NULL
									END
									IF(@JobOpeningId IS NOT NULL AND @CandidateId IS NOT NULL)
									BEGIN
										 UPDATE InterviewProcessConfiguration
										 SET InActiveDateTime=GETDATE()
										 WHERE 
										 CandidateId = @CandidateId
										 AND JobOpeningId = @JobOpeningId
										 AND InActiveDateTime IS NULL
										 UPDATE CandidateInterviewSchedule
										 SET InActiveDateTime = GETDATE()
										 WHERE
										 CandidateId = @CandidateId
										 AND JobOpeningId = @JobOpeningId
										 AND InActiveDateTime IS NULL
									END
							CREATE TABLE #TempInterviewProcessConfiguration
							(
						      [Order] INT IDENTITY(1, 1),
						      Id UNIQUEIDENTIFIER

						    )
							INSERT INTO #TempInterviewProcessConfiguration(Id)
							 SELECT Id
								    FROM [InterviewProcessTypeConfiguration]
								   WHERE InterviewProcessId = @InterviewProcessId
								         AND InActiveDateTime IS NULL

							INSERT INTO [dbo].[InterviewProcessConfiguration](
                                               [Id]
											   ,[JobOpeningId]
											   ,[CandidateId]
											   --,StatusId
											   --,[InterviewProcessId]
                                               --,[InterviewTypeId]
											   ,InterviewProcessTypeConfigurationId
											   ,[Order]
											   ,CreatedByUserId
											   ,CreatedDateTime
                                               )
                                   SELECT NEWID()
										  ,@JobOpeningId
										  ,@CandidateId
										  --,@DefaultStatus
										  --,@InterviewProcessId
										  --,TIPC.InterviewTypeId
										  ,TIPC.Id
										  ,TIPC.[Order]
								          ,@OperationsPerformedBy
										  ,@Currentdate
                                   FROM #TempInterviewProcessConfiguration TIPC
								   IF(@JobOpeningId IS NOT NULL AND @CandidateId IS NULL)
									BEGIN
										 UPDATE JobOpening
										 SET InterviewProcessId=@InterviewProcessId
										 WHERE Id=@JobOpeningId AND @JobOpeningId IS NOT NULL
									END
									--@JobOpeningId IS NOT NULL AND 
									IF(@CandidateId IS NOT NULL)
									BEGIN
										 UPDATE CandidateJobOpening
										 SET InterviewProcessId = @InterviewProcessId
										 WHERE CandidateId = @CandidateId AND JobOpeningId = @JobOpeningId
									END
		
							         
					END
					ELSE
					BEGIN
					IF(@InterviewTypeIds IS NOT NULL)
					BEGIN
        CREATE TABLE #Temp
        (
            [Order] INT IDENTITY(1, 1),
            InterviewProcessConfigurationId UNIQUEIDENTIFIER
        )
        INSERT INTO #Temp(InterviewProcessConfigurationId)
        SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') 
        FROM @InterviewTypeIds.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS x(y)

        UPDATE [InterviewProcessConfiguration]
        SET [Order] = T.[Order],
            [UpdatedDateTime] = @Currentdate,
            [UpdatedByUserId] = @OperationsPerformedBy
        FROM #Temp T  WHERE T.InterviewProcessConfigurationId = [InterviewProcessConfiguration].Id
		END
		ELSE
		BEGIN
						                UPDATE [dbo].[InterviewProcessConfiguration] SET
																				 [IsPhoneCalling]		  = @IsPhoneCalling
																				 ,[IsVideoCalling]		  = @IsVideoCalling
																				 --,[StatusId]			  = @StatusId
																				 ,[UpdatedByUserId]		  = @OperationsPerformedBy
																				 ,[UpdatedDateTime]		  = @Currentdate
																				 WHERE Id=@InterviewProcessConfigurationId 

					END
					END
				            
				    SELECT Id FROM [dbo].[InterviewProcessConfiguration] WHERE Id = @InterviewProcessConfigurationId
				                   
				  END
				  ELSE
				     
				      RAISERROR (50008,11, 1)
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			--END
	--END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
