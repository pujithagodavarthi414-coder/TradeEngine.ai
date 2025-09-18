CREATE PROCEDURE [dbo].[USP_UpsertSCOStatus]
(
     @LeadFormId UNIQUEIDENTIFIER,
     @ScoId UNIQUEIDENTIFIER,
     @Comments NVARCHAR(MAX) = NULL,
     @IsScoAccepted BIT = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

         DECLARE @Currentdate DATETIME = GETDATE()
         
         IF (@HavePermission = '1')
         BEGIN
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM LeadContactSubmissions WHERE Id=@LeadFormId)

            UPDATE [SCOGenerations]
						   SET UpdatedDateTime = @Currentdate,
                               [Comments] = @Comments,
                               [IsScoAccepted] = @IsScoAccepted
							   WHERE LeadSubmissionId = @LeadFormId

            UPDATE LeadContactSubmissions SET StatusId=(SELECT Id FROM LeadStages WHERE [Name]= (CASE WHEN @IsScoAccepted=1 THEN 'SCO Accepted' ELSE 'SCO Rejected' END) AND CompanyId=@CompanyId)
            WHERE Id=@LeadFormId

            --IF(@IsScoAccepted=1)
            --BEGIN
            --    UPDATE Client SET AvailableCreditLimit =  AvailableCreditLimit - (SELECT QuantityInMT*RateGST FROM LeadContactSubmissions WHERE Id=@LeadFormId)
            --    WHERE Id=(SELECT ClientId FROM SCOGenerations WHERE LeadSubmissionId=@LeadFormId)
            --END
            IF(@IsScoAccepted=0)
            BEGIN
               UPDATE [SCOGenerations]
						   SET InActiveDateTime=@Currentdate,
                               [IsScoAccepted] = @IsScoAccepted
							   WHERE LeadSubmissionId = @LeadFormId

                DECLARE @ClientId UNIQUEIDENTIFIER = (SELECT ClientId From LeadContactSubmissions WHERE Id = @LeadFormId)
                DECLARE @UserId UNIQUEIDENTIFIER = (SELECT UserId From Client WHERE Id = @ClientId)
                --DECLARE @ScoId UNIQUEIDENTIFIER = (SELECT Id From SCOGenerations WHERE LeadSubmissionId = @LeadFormId)
                DECLARE @OldCreditLimt Int = (SELECT CreditLimit FROM Client WHERE Id=@ClientId)
                DECLARE @OldAvailableCreditLimit Int = (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId)

                DECLARE @Amount INT = (SELECT (LCS.QuantityInMT*LCS.RateGST)
                FROM LeadContactSubmissions LCS 
                INNER JOIN Client C ON C.Id = LCS.ClientId
                WHERE C.Id=LCS.ClientId AND LCS.Id=@LeadFormId)

                UPDATE Client SET AvailableCreditLimit= C.AvailableCreditLimit+(LCS.QuantityInMT*LCS.RateGST)
                FROM LeadContactSubmissions LCS 
                INNER JOIN Client C ON C.Id = LCS.ClientId
                WHERE C.Id=LCS.ClientId AND LCS.Id=@LeadFormId

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
                                                      'Credit-SCO Rejected',
                                                      @OldCreditLimt,
                                                      (SELECT CreditLimit FROM Client WHERE Id=@ClientId),
                                                      @OldAvailableCreditLimit,
                                                      (SELECT AvailableCreditLimit FROM Client WHERE Id=@ClientId),
                                                      @Amount,
                                                      @ScoId,
                                                      @UserId,
													  GETDATE(),
                                                      @CompanyId

            END

			SELECT @LeadFormId

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