------------------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetUsersWhoDidnotFinishedPreviousDay] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUsersWhoDidnotFinishedPreviousDay]
(
@Date DATE = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	
	 IF (@HavePermission = '1')
	 BEGIN
       IF(@Date IS NULL)
       SET @Date = GETUTCDATE()

       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

       SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS [Employee name]
       FROM  [User] U WITH(NOLOCK)
            LEFT JOIN [TimeSheet] TS  ON TS.UserId = U.Id AND TS.OutTime IS NULL AND U.InActiveDateTime IS NULL
            LEFT JOIN LeaveApplication LA ON LA.UserId = U.Id AND LA.InActiveDateTime IS NULL
            LEFT JOIN LeaveApplicationStatus LAS ON LAS.LeaveApplicationId = LA.Id AND LAS.InActiveDateTime IS NULL
            LEFT JOIN LeaveStatus LS ON LS.Id = LAS.LeaveStatusId AND (U.Id NOT IN (LA.UserId) AND LS.IsApproved = 1)
       WHERE (@Date IS NULL OR TS.[Date] =  DATEADD(DAY,-1,CONVERT(DATE,@Date))) AND U.CompanyId = @CompanyId
       GROUP BY U.FirstName + ' ' + ISNULL(U.SurName,'')

   END
   END TRY
   BEGIN CATCH

       THROW

   END CATCH

END
GO