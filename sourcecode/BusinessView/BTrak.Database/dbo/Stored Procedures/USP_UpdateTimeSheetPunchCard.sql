-----------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpdateTimeSheetPunchCard] @OperationsPerformedBy = '64D09F1A-7F57-4928-BC27-4A1169ECBDD7',@FromDate='2020-03-09 00:00:00.000' ,
--@StatusId = '8B1281C1-FBB8-415D-AC10-64860CC151D8', @ApproverId ='FD793BE7-7118-492C-A55F-5577240A75AE' ,@ToDate = '2020-03-12 00:00:00.000'
-----------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateTimeSheetPunchCard]
(
    @ApproverId UNIQUEIDENTIFIER = NULL,
    @FromDate DATETIME ,
    @ToDate DATETIME ,
    @StatusId UNIQUEIDENTIFIER ,
    @UserId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@RejectedReason NVARCHAR(MAX) = NULL,
	@IsRejected BIT = NULL
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
             IF(@FromDate IS NULL)
             BEGIN
                RAISERROR(50011,16,1,'FromDate')
             END             
             ELSE IF(@ToDate IS NULL)
             BEGIN
                RAISERROR(50011,16,1,'ToDate')
             END
			 ELSE
             BEGIN
                    IF(@HavePermission = '1')
                    BEGIN
					 
                     IF(@ApproverId IS NOT NULL)
                     BEGIN
							
                       DECLARE @DateTime DATETIME = GETDATE()

                        UPDATE TimeSheetPunchCard SET 
                                                 [UpdatedByUserId] = @OperationsPerformedBy,
                                                 [UpdatedDateTime] = @DateTime,
												 [ApproverId] =@ApproverId,
												 [StatusId] = @StatusId,
												 [RejectedReason] = @RejectedReason,
												 [IsRejected] = @IsRejected
                                                 WHERE UserId = ISNULL(@UserId , @OperationsPerformedBy) AND @CompanyId = CompanyId
												 AND [Date] BETWEEN @FromDate AND @ToDate
						
						 SELECT 1
                    END
                     ELSE
                     BEGIN
                    
                        UPDATE TimeSheetPunchCard  SET
                                                [UpdatedByUserId] = @OperationsPerformedBy,
                                                [UpdatedDateTime] = @DateTime,
												[ApproverId] =@ApproverId,
												[StatusId] = @StatusId,
												[RejectedReason] = @RejectedReason,
												[IsRejected] = @IsRejected,
                                                [StartTime] = IIF(AET.[Date] IS NULL, T1.StartTime,AET.StartTime),
                                                [EndTime] = IIF(AET.[Date] IS NULL, T1.[EndTime],AET.EndTime),
                                                Breakmins = IIF(AET.[Date] IS NULL ,T1.Breakmins,AET.Breakmins),
                                                Summary = IIF(AET.[Date] IS NULL , T1.Summary,AET.Summary),
                                                IsOnLeave = IIF(AET.[Date] IS NULL,T1.IsOnLeave , AET.IsOnLeave)
                                                FROM TimeSheetPunchCard T1 
												LEFT JOIN ApproverEditTimeSheet AET 
												ON T1.UserId = AET.UserId AND T1.[Date] = AET.[Date]  
												WHERE T1.UserId = ISNULL(@UserId , @OperationsPerformedBy) AND @CompanyId = T1.CompanyId
												AND T1.[Date] BETWEEN @FromDate AND @ToDate 

                        DELETE FROM ApproverEditTimeSheet WHERE [Date] BETWEEN @FromDate AND @ToDate
						IF EXISTS (SELECT *fROM Status WHERE StatusName = 'Approved' and CompanyId = @CompanyId and Id = @StatusId)
							DECLARE @EMPLOYEEID UNIQUEIDENTIFIER, @EMPLOYEEIDJSON NVARCHAR(MAX) 

							SELECT @EMPLOYEEID = E.Id
							FROM [User] U
							INNER JOIN Employee E ON E.UserId = U.Id
							where U.Id = @UserId

							EXEC  [dbo].[USP_GetEmployeeRosterRatesWithTimeSheetData] @FromDate, @ToDate, @EMPLOYEEID, @OperationsPerformedBy
							EXEC [dbo].[USP_GetPermanentEmployeePayments] @OperationsPerformedBy, @FromDate, @ToDate, 1, @EMPLOYEEID
                        END

						SELECT 1
                    END​
					ELSE
					BEGIN
	    				 RAISERROR (@HavePermission,11, 1)
					END
                END
    END TRY
    BEGIN CATCH 
        THROW
    END CATCH
​
END