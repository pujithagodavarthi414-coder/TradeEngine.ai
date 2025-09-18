-------------------------------------------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetApproverTimeSheetSubmissions] @OperationsPerformedBy = '4BE274A1-7719-4656-9130-0CE22D32CFC2'
-------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetApproverTimeSheetSubmissions]
(
	@UserId UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
	@Dateto DATETIME = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS 
BEGIN
 SET NOCOUNT ON
    BEGIN TRY
	    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  ='1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN 
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				
				SELECT
					    IIF(AETS.[Date]IS NULL, TSPC.[Date],AETS.[Date])[Date],
						IIF(AETS.[Date]IS NULL, TSPC.StartTime,AETS.StartTime)StartTime,
						IIF(AETS.[Date]IS NULL ,TSPC.EndTime,AETS.EndTime)EndTime,
						IIF(AETS.[Date]IS NULL , TSPC.Breakmins,AETS.Breakmins)Breakmins,
						TSPC.UserId,
						IIF(AETS.[Date]IS NULL , IIF(TSPC.EndTime IS NULL , NULL , DATEDIFF(MINUTE,TSPC.StartTime,TSPC.EndTime)) - TSPC.Breakmins,
									IIF(AETS.EndTime IS NULL , NULL , DATEDIFF(MINUTE,AETS.StartTime,AETS.EndTime)) - AETS.Breakmins) SpentTime,
						CONCAT(U.FirstName,' ',ISNULL(U.SurName,'')) UserName,
						U.ProfileImage,
					    TSPC.TimeSheetSubmissionId,
						TSST.[Name],
						IIF(AETS.[Date]IS NULL , TSPC.Summary, AETS.Summary) Summary,
						IIF(AETS.[Date]IS NULL , TSPC.IsOnLeave , AETS.IsOnLeave) IsOnLeave 
				 FROM TimeSheetPunchCard TSPC
					  JOIN [User] U ON U.Id = TSPC.UserId AND  U.IsActive = 1 AND U.InActiveDateTime IS NULL
					  LEFT JOIN [TimeSheetSubmission] TSS ON TSS.Id = TSPC.TimeSheetSubmissionId
					  JOIN [TimeSheetSubmissionType] TSST ON TSST.Id = TSS.TimeSheetFrequency
					  LEFT JOIN [ApproverEditTimeSheet] AETS ON AETS.UserId = U.Id AND AETS.[Date] = TSPC.[Date]
					  JOIN [Status] S ON S.Id = TSPC.StatusId AND S.StatusName = 'Waiting for Approval'
				 WHERE TSPC.ApproverId = @OperationsPerformedBy AND 
				 (@DateFrom IS NULL OR TSPC.[Date] >= @DateFrom) AND
				 (@UserId IS NULL OR TSPC.UserId = @UserId) AND
				 (@DateTo IS NULL OR TSPC.[Date] <= @DateTo)
				 ORDER BY TSPC.UserId , TSPC.[Date] DESC 
		 END
		 ELSE

			RAISERROR(@HavePermission,11,1)
	 END TRY
    BEGIN CATCH 
        THROW
    END CATCH
END
GO