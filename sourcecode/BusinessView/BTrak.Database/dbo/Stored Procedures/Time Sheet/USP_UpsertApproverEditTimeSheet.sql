--EXEC [dbo].[USP_UpsertApproverEditTimeSheet] @OperationsPerformedBy = '4BE274A1-7719-4656-9130-0CE22D32CFC2',
--@TimeSheetPunchCardId='7A89A360-FF03-423A-80DB-45E738F8DC1D',@UserId='4BE274A1-7719-4656-9130-0CE22D32CFC2',@Breakmins = '40'
--,@StatusId = '06eb9fc0-2679-453d-939a-55fda8026a7f', @ApproverId ='64d09f1a-7f57-4928-bc27-4a1169ecbdd7',@Date = '2020-04-21 00:00:00.000'
-----------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertApproverEditTimeSheet]
(
    @TimeSheetPunchCardId UNIQUEIDENTIFIER = NULL,
    @ApproverId UNIQUEIDENTIFIER = NULL,
    @Date DATETIME ,
	@StartTime DATETIME = NULL,
    @EndTime DATETIME =NULL,
    @Breakmins INT = NULL,
    @StatusId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @Summary NVARCHAR(500) = NULL,
    @UserId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @TimeSheetSubmissionId UNIQUEIDENTIFIER = NULL,
    @IsOnLeave BIT = NULL
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

             DECLARE @Id UNIQUEIDENTIFIER 
​
             IF(@Date IS NULL)
             BEGIN
                RAISERROR(50011,16,1,'Date')
             END             
             ELSE
             BEGIN
                    
                    IF(@HavePermission = '1')
                    BEGIN
                            DECLARE @IsLatest BIT = (CASE WHEN @TimeSheetPunchCardId IS NULL 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM ApproverEditTimeSheet WHERE TimeSheetPunchCardId = @TimeSheetPunchCardId ) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
                    

                        IF NOT EXISTS(SELECT 1 FROM ApproverEditTimeSheet WHERE @TimeSheetPunchCardId = TimeSheetPunchCardId)
                        BEGIN

						SET @Id = NEWID()

                            INSERT INTO ApproverEditTimeSheet(
                                                            Id,
                                                            TimeSheetPunchCardId,
                                                            [Date],
															[StartTime],
															[EndTime],
															[Breakmins],
															[StatusId],
															[ApproverId],
															[UserId],
                                                            CreatedDateTime,
                                                            CreatedByUserId,
                                                            CompanyId, 
                                                            Summary,
                                                            TimeSheetSubmissionId,
                                                            IsOnLeave
                                                            )
                                                    SELECT  @Id,
                                                            @TimeSheetPunchCardId,
															@Date,
															@StartTime,
															@EndTime,
															@Breakmins,
															@StatusId,
															@ApproverId,
															ISNULL(@UserId,@OperationsPerformedBy),
                                                            GETDATE(),
                                                            @OperationsPerformedBy,
                                                            @CompanyId,
                                                            @Summary,
                                                            @TimeSheetSubmissionId,
                                                            @IsOnLeave
                        END
                        ELSE
                        BEGIN
                            UPDATE ApproverEditTimeSheet SET [Date] = @Date,
                                                           [UpdatedByUserId] = @OperationsPerformedBy,
                                                           [UpdatedDateTime] = GETDATE(),
                                                           [CompanyId] = @CompanyId,
                                                           [StartTime] = @StartTime,
														   [EndTime] = @EndTime,
														   [ApproverId] =@ApproverId,
														   [UserId] = ISNULL(@UserId , @OperationsPerformedBy),
														   [Breakmins] = @Breakmins,
														   [StatusId] = @StatusId,
                                                           [Summary] = @Summary,
                                                           [IsOnLeave] = @IsOnLeave,
                                                           [TimeSheetSubmissionId] = @TimeSheetSubmissionId
                                                           WHERE TimeSheetPunchCardId = @TimeSheetPunchCardId
                        END​
						SELECT Id FROM ApproverEditTimeSheet WHERE TimeSheetPunchCardId = @TimeSheetPunchCardId
                   
                    END
             END
    END TRY
    BEGIN CATCH 
        THROW
    END CATCH
​
END
GO