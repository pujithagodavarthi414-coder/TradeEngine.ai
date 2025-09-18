--EXEC [dbo].USP_UpsertCandidateJob @OperationsPerformedBy = '242FCC54-4336-4389-82C1-4CBA6028870E' ,@JobOpeningId='e6a95c94-61b0-4c9d-b53c-4894bd70bbd4',@CandidateJson='[{"jobOpeningId":"f482402c-6413-4799-af56-e567d5d930f5","isJobOpening":true,"canJobOpeningId":"0402402d-299e-4cd2-bce8-f670b1715049","candidateId":"b70e9dc9-261b-4308-9d8a-7f90cb04b64c"}]'
CREATE PROCEDURE [dbo].[USP_UpsertCandidateJob]
(
	@CandidateId UNIQUEIDENTIFIER=NULL,
	@JobOpeningId UNIQUEIDENTIFIER = NULL,
    @CandidateJson NVARCHAR(max),
    @PageSize INT = NULL,
    @TimeStamp TIMESTAMP = NULL,
	@HiringStatusId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CandidateJobOpeningId UNIQUEIDENTIFIER=NULL,
	@IsArchived BIT = NULL,
	@IsJob BIT = NULL
)	
AS
BEGIN
IF(@IsArchived IS NOT NULL)
	BEGIN
	UPDATE CandidateJobOpening SET InActiveDateTime = GETDATE(),UpdatedDateTime =GETDATE() WHERE Id = @CandidateJobOpeningId
	END
	ELSE
		BEGIN
				CREATE TABLE #CandidateJob
				 (
				 CandidateJobId UNIQUEIDENTIFIER,
				 CandidateId UNIQUEIDENTIFIER,
				 JobJoiningId UNIQUEIDENTIFIER,
				 IsJobOpening NVARCHAR(10),
				 Isvalid int,
				 IsDuplicate NVARCHAR(10),
				 IsDuplicateCan NVARCHAR(10)
				 )
					IF(@JobOpeningId = '00000000-0000-0000-0000-000000000000') SET  @JobOpeningId = NULL
					IF(@CandidateId = '00000000-0000-0000-0000-000000000000') SET  @CandidateId = NULL
					 IF(@HiringStatusId = '00000000-0000-0000-0000-000000000000') SET @HiringStatusId = NULL

					 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					SET @HiringStatusId=(Select Id From HiringStatus Where [Order]='1' AND CompanyId=@CompanyId)

					INSERT INTO #CandidateJob(CandidateJobId,CandidateId,IsJobOpening,JobJoiningId,Isvalid,IsDuplicate,IsDuplicateCan)
					SELECT *,(SELECT count(email) from Candidate where Email = (select Email from Candidate where Id = candidateId)),
					(SELECT top(1)'YES' FROM candidatejobopening where  InActiveDateTime IS NULL AND JobOpeningId=@JobOpeningId AND
					candidateId in (select Id from candidate where InActiveDateTime IS NULL  AND Email = (select Email from Candidate where Id = candidateId))),
					(SELECT top(1)'YES' FROM candidatejobopening where  InActiveDateTime IS NULL AND JobOpeningId=JobOpeningId AND
					candidateId in (select Id from candidate where InActiveDateTime IS NULL  AND Email = (select Email from Candidate where Id = @CandidateId)))
					FROM OPENJSON(@CandidateJson) WITH (canJobOpeningId UNIQUEIDENTIFIER, candidateId UNIQUEIDENTIFIER, isJobOpening NVARCHAR(10),jobOpeningId UNIQUEIDENTIFIER)

					DECLARE @isClosed BIT = CASE WHEN (SELECT JobOpeningStatusId FROM JobOpening where Id = @JobOpeningId 
										AND JobOpeningStatusId = (SELECT Id FROM JobOpeningStatus WHERE [Status]='Closed' AND CompanyId =@CompanyId)) IS NOT NULL THEN 1 ELSE 0 END
					DECLARE @isValid int = (select max(isvalid) from #CandidateJob)
					DECLARE @IsDuplicate NVARCHAR(10) = (SELECT TOP(1) IsDuplicate FROM #CandidateJob where IsDuplicate IS NOT NULL )
					DECLARE @IsDuplicate1 NVARCHAR(10) = (SELECT TOP(1) IsDuplicateCan FROM #CandidateJob where IsDuplicateCan IS NOT NULL )
					
					--IF (@isClosed = 1 OR @IsJob = 1 )
					--BEGIN

					--	RAISERROR(50001,11,1,'CandidateJobOpening')

					--END
					--ELSE
					
					--IF (@isValid > 1 AND @IsDuplicate ='YES' )
					--BEGIN

					--	RAISERROR(50001,11,1,'CandidateJobOpening')

					--END
					--ELSE
					IF (@isValid > 1 AND @IsDuplicate1 ='YES' )
					BEGIN

						RAISERROR(50001,11,1,'CandidateJobOpening')

					END
					ELSE
					IF(@CandidateId IS null)
					BEGIN
						MERGE CandidateJobOpening bi
						USING #CandidateJob bo
						ON bi.Id = bo.CandidateJobId AND  bi.CandidateId=bo.CandidateId AND bi.Jobopeningid=@JobOpeningId
						WHEN MATCHED  THEN
						  UPDATE
						  SET bi.InactiveDatetime =  IIF(bo.isJobOpening='true' ,null,getdate())
						  WHEN NOT MATCHED BY TARGET THEN
						  INSERT (Id, JobOpeningId, CandidateId,AppliedDatetime,CreatedDatetime,HiringStatusId,CreatedByUserId,Inactivedatetime)
						  VALUES (newId(), JobJoiningId,bo.CandidateId,getdate(),getdate(),@HiringStatusId,@OperationsPerformedBy,IIF(bo.isJobOpening='true' ,null,getdate()));

						  SELECT CAST (@JobOpeningId AS uniqueidentifier)
					END
					ELSE IF(@JobOpeningId IS null)
					BEGIN
							  MERGE CandidateJobOpening bi
							  USING #CandidateJob bo
							  ON   bi.CandidateId=@CandidateId AND bi.Jobopeningid=bo.JobJoiningId
						  WHEN MATCHED  THEN
						  UPDATE SET bi.InactiveDatetime =  IIF(bo.isJobOpening='true' ,null,getdate())
						  WHEN NOT MATCHED BY TARGET THEN
						  INSERT (Id, JobOpeningId, CandidateId,AppliedDatetime,CreatedDatetime,HiringStatusId,CreatedByUserId,Inactivedatetime)
						  VALUES (newId(), JobJoiningId,@CandidateId,getdate(),getdate(),@HiringStatusId,@OperationsPerformedBy,IIF(bo.isJobOpening='true' ,null,getdate()));

							SELECT CAST (@CandidateId AS uniqueidentifier)
			END
END
END