CREATE PROCEDURE [dbo].[USP_UpsertInterviewProcess]
(
   @InterviewProcessId UNIQUEIDENTIFIER = NULL,
   @InterviewProcessName NVARCHAR(50) = NULL,
   @InterviewTypeId XML = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

		SET NOCOUNT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@InterviewProcessName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'InterviewProcess')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @InterviewProcessIdCount INT = (SELECT COUNT(1) FROM InterviewProcess  WHERE Id = @InterviewProcessId)

			DECLARE @InterviewProcessCount INT = (SELECT COUNT(1) FROM InterviewProcess WHERE InterviewProcessName = @InterviewProcessName AND CompanyId = @CompanyId AND (@InterviewProcessId IS NULL OR @InterviewProcessId <> Id))

			DECLARE @IsUsedInJob INT = (SELECT COUNT(1) FROM JobOpening WHERE InterviewProcessId = @InterviewProcessId)
			DECLARE @IsUsedInCadidate INT = (SELECT COUNT(1) FROM CandidateJobOpening WHERE InterviewProcessId = @InterviewProcessId)

			
       
			IF(@IsArchived = 1 AND (@IsUsedInJob > 0 OR @IsUsedInCadidate > 0))
			BEGIN

			    RAISERROR ('InterviewProcessHavingDependencies',11, 1)

			END
       
			IF(@InterviewProcessIdCount = 0 AND @InterviewProcessId IS NOT NULL)
			BEGIN

			    RAISERROR(50002,16, 2,'InterviewProcess')

			END
			IF (@InterviewProcessCount > 0)
			BEGIN

				RAISERROR(50001,11,1,'InterviewProcess')

			END
			ELSE        
			BEGIN
       
			    DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				
				IF (@HavePermission = '1')
				BEGIN
				     	
				   DECLARE @IsLatest BIT = (CASE WHEN @InterviewProcessId IS NULL THEN 1 
						                         ELSE CASE WHEN (SELECT [TimeStamp] FROM [InterviewProcess] WHERE Id = @InterviewProcessId  AND CompanyId = @CompanyId) = @TimeStamp THEN 1 ELSE 0 END END)
				     
				   IF(@IsLatest = 1)
				   BEGIN
				     
				      DECLARE @Currentdate DATETIME = GETDATE()
				             
			          IF(@InterviewProcessId IS NULL)
					  BEGIN

						 SET @InterviewProcessId = NEWID()

						 INSERT INTO [dbo].[InterviewProcess]([Id],
														  [CompanyId],
								                          InterviewProcessName,
								                          [InActiveDateTime],
								                          [CreatedDateTime],
								                          [CreatedByUserId])
								                   SELECT @InterviewProcessId,
								                          @CompanyId,
								                          @InterviewProcessName,
								                          CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
								                          @Currentdate,
								                          @OperationsPerformedBy
				
						INSERT INTO [dbo].[InterviewProcessTypeConfiguration](
                                               [Id]
											   ,[InterviewProcessId]
                                               ,[InterviewTypeId]
											   ,CreatedByUserId
											   ,CreatedDateTime
                                               )
                                   SELECT NEWID()
										  ,@InterviewProcessId
										  ,X.Y.value('(text())[1]','UNIQUEIDENTIFIER')
								          ,@OperationsPerformedBy
										  ,@Currentdate
                                   FROM @InterviewTypeId.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS X(Y)

								   
					END
					ELSE
					BEGIN

						UPDATE [InterviewProcess] SET CompanyId = @CompanyId,
								                  InterviewProcessName = @InterviewProcessName,
									              InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									              UpdatedDateTime = @Currentdate,
									              UpdatedByUserId = @OperationsPerformedBy
						WHERE Id = @InterviewProcessId

					

					
                                  DECLARE @InterViewTypesList TABLE
					            (
									[Id] UNIQUEIDENTIFIER
					            )
							   
							   INSERT INTO @InterViewTypesList
							   ([Id])
                                   SELECT X.Y.value('(text())[1]','UNIQUEIDENTIFIER')
                                   FROM @InterviewTypeId.nodes('GenericListOfNullableOfGuid/ListItems/guid') AS X(Y)

							   UPDATE [InterviewProcessTypeConfiguration] SET InactiveDateTime = @Currentdate
                                                         ,UpdatedByUserId = @OperationsPerformedBy
                                                         ,UpdatedDateTime = @Currentdate
                                           WHERE [InterviewProcessId] = @InterviewProcessId AND ID NOT IN (SELECT Id FROM @InterViewTypesList)

								INSERT INTO [dbo].[InterviewProcessTypeConfiguration](
                                               [Id]
											   ,[InterviewProcessId]
                                               ,[InterviewTypeId]
											   ,CreatedByUserId
											   ,CreatedDateTime
                                               )
                                   SELECT NEWID()
										  ,@InterviewProcessId
										  ,Id
								          ,@OperationsPerformedBy
										  ,@Currentdate
								FROM @InterViewTypesList 
								WHERE Id NOT IN (Select Id From [InterviewProcessTypeConfiguration] 
													WHERE InterviewProcessId=@InterviewProcessId AND InActiveDateTime IS NULL)

                      END
				            
				    SELECT Id FROM [dbo].[InterviewProcess] WHERE Id = @InterviewProcessId
				                   
				  END
				  ELSE
				     
				      RAISERROR (50008,11, 1)
				     
				END
				ELSE
				BEGIN
				     
					RAISERROR (@HavePermission,11, 1)
				     		
			    END

			END
	END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
