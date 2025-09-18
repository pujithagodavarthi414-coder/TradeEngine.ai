-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmplopyeeTimeSheetSubmissionPunchCard] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@Date = '2020-03-03 00:00:00.000'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmplopyeeTimeSheetSubmissionPunchCard]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER, 
	 @UserId UNIQUEIDENTIFIER = NULL,
	 @Date DATETIME 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               

		 IF EXISTS(SELECT 1 FROM TimeSheetPunchCard WHERE UserId = ISNULL(@UserId,@OperationsPerformedBy) AND [Date] = CONVERT(DATE,@Date))
		 BEGIN

		 IF(@UserId IS NOT NULL AND EXISTS(SELECT 1 FROM ApproverEditTimeSheet WHERE UserId = @UserId AND [Date] = CONVERT(DATE,@Date)))
			BEGIN
			 SELECT TS.TimeSheetPunchCardId TimeSheetPunchCardId,
				  TS.[Date],
				  CONVERT(datetime2, TS.[StartTime], 1) [StartTime],
				  CONVERT(datetime2, TS.[EndTime], 1) [EndTime],
				  TS.[Breakmins],
				  TS.[StatusId],
				  S.[StatusName],
				  TS.ApproverId,
				  CONCAT(U.FirstName,' ',ISNULL(U.SurName,'')) ApproverName,
				  TS.UserId,
				  CONCAT(U1.FirstName,' ',ISNULL(U1.SurName,'')) UserName,
				  TS.[TimeStamp],
				  TS.IsOnLeave,
				  TS.Summary
			 FROM ApproverEditTimeSheet TS 
					LEFT JOIN [User] U1 ON U1.Id = TS.UserId AND U1.IsActive = 1 AND U1.InActiveDateTime IS NULL
					LEFT JOIN [Status] S ON S.Id = TS.StatusId AND TS.InActiveDateTime IS NULL
			        LEFT JOIN [User] U ON U.Id = TS.ApproverId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
			 WHERE TS.[Date] = CONVERT(DATE,@Date) AND TS.CompanyId = @CompanyId AND 
				  (@UserId IS NOT NULL AND TS.UserId = @UserId)
			
		 END
			 ELSE
			 BEGIN
			   select TS.Id TimeSheetPunchCardId,
					  TS.[Date],
					  CONVERT(datetime2, TS.[StartTime], 1) [StartTime],
					  CONVERT(datetime2, TS.[EndTime], 1) [EndTime],
					  TS.[Breakmins],
					  TS.[StatusId],
					  S.[StatusName],
					  TS.ApproverId,
					  CONCAT(U.FirstName,' ',ISNULL(U.SurName,'')) ApproverName,
					  TS.UserId,
					  CONCAT(U1.FirstName,' ',ISNULL(U1.SurName,'')) UserName,
					  TS.[TimeStamp],
					  TS.Summary,
					  TS.IsOnLeave
				 FROM TimeSheetPunchCard TS 
						LEFT JOIN [User] U1 ON U1.Id = TS.UserId AND U1.IsActive = 1 AND U1.InActiveDateTime IS NULL
						LEFT JOIN [Status] S ON S.Id = TS.StatusId AND TS.InActiveDateTime IS NULL
						LEFT JOIN [User] U ON U.Id = TS.ApproverId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
				 WHERE TS.[Date] = CONVERT(DATE,@Date) AND TS.CompanyId = @CompanyId AND 
					  ((@UserId IS NOT NULL AND TS.UserId = @UserId) OR
					  (@UserId IS NULL AND TS.UserId = @OperationsPerformedBy))
			  END
			 END
			 ELSE
		     BEGIN
				SELECT TS.[Date],
						CONVERT(datetime2, TS.[InTime] , 1) [StartTime],
						CONVERT(datetime2, TS.[OutTime] , 1) [EndTime],
					   SUM(ISNULL(DATEDIFF(MINUTE,TS.LunchBreakStartTime,TS.LunchBreakEndTime),0) 
					       + ISNULL(UserBreak.UserBreak,0)) Breakmins,
					   TS.UserId,
					    CONCAT(U.FirstName,' ',ISNULL(U.SurName,''))  UserName
				  FROM [User] U 
				  LEFT JOIN TimeSheet TS ON U.Id = TS.UserId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL AND TS.[Date] = CONVERT(DATE,@Date)
				  LEFT JOIN (SELECT UserId,[Date],SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)) AS UserBreak
							 FROM UserBreak
							 WHERE UserId = @OperationsPerformedBy AND [Date] = CONVERT(DATE,@Date)
							 GROUP BY UserId,[Date]) UserBreak ON UserBreak.UserId = TS.UserId AND TS.[Date] = UserBreak.[Date]
				 WHERE ((@UserId IS NOT NULL AND U.Id = @UserId) OR
				  (@UserId IS NULL AND U.Id = @OperationsPerformedBy))
				 GROUP BY TS.[DATE],TS.[InTime],TS.[OutTime],TS.[UserId],U.FirstName,U.SurName
		 END

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