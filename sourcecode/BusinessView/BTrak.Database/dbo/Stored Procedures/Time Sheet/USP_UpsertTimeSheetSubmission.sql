-----------------------------------------------------------------------------------------------------------------------
--EXEC USP_UpsertTimeSheetSubmission @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@TimeSheetFrequencyId = '5BA47E73-8FC7-43F3-8A6D-39628E93F847', @ActiveFrom='2020-02-24'
-----------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [USP_UpsertTimeSheetSubmission]
(
    @TimeSheetSubmissionId UNIQUEIDENTIFIER = NULL,
    @TimeSheetFrequencyId UNIQUEIDENTIFIER,
    @ActiveFrom DATETIME ,
    @ActiveTo DATETIME = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
            
             IF(@OperationsPerformedBy ='00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy=NULL
​
             DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))  
​
             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
​
             DECLARE @TimeSheetSubmissionsCount INT = (SELECT COUNT(1) FROM TimeSheetSubmission WHERE (ActiveFrom >= @ActiveFrom) AND CompanyId = @CompanyId)
                                                       --((@ActiveTo IS NOT NULL AND ((ActiveFrom BETWEEN @ActiveFrom AND @ActiveTo) OR (ActiveTo BETWEEN @ActiveFrom AND @ActiveTo)))))
​
​
             DECLARE @TimeSheetButtonCount INT = (SELECT COUNT(1) FROM TimeSheetSubmission WHERE Id = @TimeSheetSubmissionId AND InActiveDateTime IS NULL)
​
             IF(@TimeSheetSubmissionsCount > 0)
             BEGIN
                 RAISERROR(50002,16,1,'TimeSheetSubmission')
             END
             ELSE IF(@ActiveFrom IS NULL)
             BEGIN
                RAISERROR(50011,16,1,'ActiveFrom')
             END
             ELSE IF(@TimeSheetFrequencyId IS NULL)
             BEGIN
                RAISERROR(50011,16,1,'TimeSheetFrequency')
             END
             ELSE
             BEGIN
                    
                    IF(@HavePermission = '1')
                    BEGIN
                            DECLARE @IsLatest BIT = (CASE WHEN @TimeSheetSubmissionId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM TimeSheetSubmission WHERE Id = @TimeSheetSubmissionId ) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
                    IF(@IsLatest = 1)
                    BEGIN
                        IF(@TimeSheetSubmissionId IS NULL)
                        BEGIN

							SET @TimeSheetSubmissionId = NEWID()

                            UPDATE TimeSheetSubmission SET ActiveTo = DATEADD(DD,-1,@ActiveFrom) WHERE ActiveTo IS NULL AND CompanyId = @CompanyId

                            INSERT INTO TimeSheetSubmission(
                                                            Id,
                                                            ActiveFrom,
                                                            CreatedDateTime,
                                                            CreatedByUserId,
                                                            CompanyId,
                                                            TimeSheetFrequency
                                                            )
                                                    SELECT  @TimeSheetSubmissionId,
                                                            @ActiveFrom,
                                                            GETDATE(),
                                                            @OperationsPerformedBy,
                                                            @CompanyId,
                                                            @TimeSheetFrequencyId
                        END
                        ELSE
                        BEGIN
                            UPDATE TimeSheetSubmission SET ActiveFrom = @ActiveFrom,
                                                           UpdatedByUserId = @OperationsPerformedBy,
                                                           UpdatedDateTime = GETDATE(),
                                                           CompanyId = @CompanyId,
                                                           TimeSheetFrequency = @TimeSheetFrequencyId
                                                           WHERE Id = @TimeSheetSubmissionId
                        END​
						SELECT @TimeSheetSubmissionId
                    END
                    ELSE
                        
                        RAISERROR(50008,11,1)
                    END
             END
    END TRY
    BEGIN CATCH 
        THROW
    END CATCH
​
END
GO