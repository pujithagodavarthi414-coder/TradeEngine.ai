-----------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTimeSheetSubmissionPunchCard] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
--@StatusId = '56D5896A-9098-4D82-9BDF-532F4460D582', @ApproverId ='0B2921A9-E930-4013-9047-670B5352F308',@Date = '2020-02-27 00:00:00.000',
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
    @TimeSheetSubmissionId UNIQUEIDENTIFIER = NULL
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
                                                                       FROM TimeSheetPunchCard WHERE Id = @TimeSheetPunchCardId ) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
                    
                        IF(@TimeSheetPunchCardId IS NULL)
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
                                                            TimeSheetSubmissionId
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
                                                            @TimeSheetSubmissionId
                        END
                        ELSE
                        BEGIN
                            UPDATE TimeSheetPunchCard SET [Date] = @Date,
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
                                                           [TimeSheetSubmissionId] = @TimeSheetSubmissionId
                                                           WHERE TimeSheetSubmissionId = @TimeSheetPunchCardId
                        END​
						SELECT @Id
                   
                    END
             END
    END TRY
    BEGIN CATCH 
        THROW
    END CATCH
​
END
GO