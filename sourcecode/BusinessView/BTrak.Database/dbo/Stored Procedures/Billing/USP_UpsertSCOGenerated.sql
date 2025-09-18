CREATE PROCEDURE [dbo].[USP_UpsertSCOGenerated]
(
	@Id UNIQUEIDENTIFIER =NULL,
    @LeadSubmissionId UNIQUEIDENTIFIER, 
    @ScoDate DateTime = NULL, 
    @CreditsAllocated INT = NULL,
    @ClientId UNIQUEIDENTIFIER,
    @Comments NVARCHAR(MAX)= NULL, 
    @IsScoAccepted BIT = NULL,
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@PerformaPdf NVARCHAR(MAX) = NULL,
	@ScoPdf NVARCHAR(MAX) = NULL,
	@IsForPdfs BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF(@IsForPdfs IS NULL) SET @IsForPdfs = 0

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
				DECLARE @LeadCost Decimal(18,2) = (SELECT QuantityInMT*RateGST FROM LeadContactSubmissions WHERE Id=@LeadSubmissionId)
				DECLARE @Limit Decimal(18,2) = (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId)
				IF(@LeadCost>@Limit)
				BEGIN
					RAISERROR ('ClientCreditLimitExceeded',11, 1)
				END
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			DECLARE @UserId UNIQUEIDENTIFIER = (SELECT UserId FROM Client WHERE Id = @ClientId)
			DECLARE @IsLatest BIT = (CASE WHEN @Id IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM SCOGenerations WHERE Id = @Id ) = @TimeStamp THEN 1 ELSE 0 END END )

					IF (@IsLatest = 1 AND @IsForPdfs <> 1) 
					BEGIN
						DECLARE @CurrentDate DATETIME = GETDATE()

							IF(EXISTS(SELECT Id FROM SCOGenerations WHERE LeadSubmissionId = @LeadSubmissionId AND InActiveDateTime IS NULL))
							BEGIN
								UPDATE SCOGenerations SET InActiveDateTime=@CurrentDate WHERE LeadSubmissionId=@LeadSubmissionId AND InActiveDateTime IS NULL

								UPDATE Client SET AvailableCreditLimit= C.AvailableCreditLimit+(LCS.QuantityInMT*LCS.RateGST)
												FROM LeadContactSubmissions LCS 
												INNER JOIN Client C ON C.Id = LCS.ClientId
												WHERE C.Id=LCS.ClientId AND LCS.Id=@LeadSubmissionId
							END
						
					  IF(@Id IS NULL)
					  BEGIN
					  DECLARE @UniqueLeadId UNIQUEIDENTIFIER = NULL
					  DECLARE @UniqueNumber INT =(SELECT MAX(CAST(SUBSTRING([UniqueScoId],CHARINDEX('-',[UniqueScoId]) + 1 ,LEN([UniqueScoId])) AS INT)) FROM [SCOGenerations])
					  SET @Id = NEWID()
						  INSERT INTO SCOGenerations(Id,
							    			[LeadSubmissionId],
											[UniqueScoId],
											[CreditsAllocated],
											[ClientId],
											[Comments],
											[IsScoAccepted],
							    			CompanyId,
							    			CreatedDateTime,
							    			CreatedByUserId,
							    			InactiveDateTime
							    		   )
							    	SELECT  @Id,
											@LeadSubmissionId,
											'SCO-' + CAST(CASE WHEN @UniqueNumber IS NULL THEN 1 ELSE  @UniqueNumber + 1 END AS NVARCHAR(100)),
											@CreditsAllocated,
											@ClientId,
											@Comments,
											@IsScoAccepted,
							    			@CompanyId,
							    			@CurrentDate,
							    			@OperationsPerformedBy,
										    NULL
								 DECLARE @OldCreditLimt Int = (SELECT CreditLimit FROM Client WHERE Id=@ClientId)
								 DECLARE @OldAvailableCreditLimit Int = (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId)
									UPDATE Client SET AvailableCreditLimit =  AvailableCreditLimit - (SELECT QuantityInMT*RateGST FROM LeadContactSubmissions WHERE Id=@LeadSubmissionId)
									WHERE Id=(SELECT ClientId FROM LeadContactSubmissions WHERE Id=@LeadSubmissionId)
								  UPDATE LeadContactSubmissions SET 
										StatusId=(SELECT Id FROM LeadStages WHERE [Name]='SCO Generated' AND CompanyId=@CompanyId)
									WHERE Id=@LeadSubmissionId
								 

								 INSERT INTO ClientCreditLimitHistory(
													  Id,
													  ClientId,
													  [Description],
													  OldCreditLimit,
													  NewCreditLimit,
													  OldAvailableCreditLimit,
													  NewAvailableCreditLimit,
                                                      Amount,
                                                      ScoId,
                                                      CreatedByUserId,
                                                      CreatedDateTime,
                                                      CompanyId
													 )
											  SELECT  NEWID(),
                                                      @ClientId,
                                                      'Debit-SCO Created',
                                                      @OldCreditLimt,
                                                      (SELECT CreditLimit FROM Client WHERE Id=@ClientId),
                                                      @OldAvailableCreditLimit,
                                                      (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId),
                                                      (SELECT QuantityInMT*RateGST FROM LeadContactSubmissions WHERE Id=@LeadSubmissionId),
                                                      @Id,
                                                      @OperationsPerformedBy,
													  GETDATE(),
                                                      @CompanyId
		              
					   END

					   

						SELECT Id FROM SCOGenerations WHERE Id = @Id
					END
					ELSE IF(@IsForPdfs = 1)
					   BEGIN
						UPDATE SCOGenerations SET PerformaPdf = @PerformaPdf,
												  ScoPdf = @ScoPdf
												  WHERE Id = @Id
						SELECT Id FROM SCOGenerations WHERE Id = @Id
					   END
					ELSE
					  
						RAISERROR(50008,11,1)

				END
		
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO