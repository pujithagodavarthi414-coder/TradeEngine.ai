-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-05-15 00:00:00.000'
-- Purpose      To Get Todays Reminders
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetTodaysReminders] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTodaysReminders]
AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
              SELECT R.Id AS ReminderId,
					 R.RemindOn,
					 R.OfUser,
					 U.FirstName + ' ' + ISNULL(U.SurName,'') AS OfUserName,
					 R.NotificationType,
					 R.ReferenceTypeId,
					 R.ReferenceId,
					 R.AdditionalInfo,
					 R.CompanyId,
					 R.[Status],
					 (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support') AS NotifiedBy,
					 R.CreatedDateTime,
					 R.CreatedByUserId,
					 C.SiteAddress,
					 CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS CreatedByUserName,
					 CU.UserName AS CreatedByEmail
            FROM Reminder R 
				LEFT JOIN [User] U ON U.Id = R.OfUser 
				LEFT JOIN Company C ON C.Id = R.CompanyId 
				INNER JOIN [User] CU ON CU.Id =R.CreatedByUserId AND CU.InActiveDateTime IS NULL
				WHERE R.InactiveDateTime IS NULL AND R.[status] = 'New' AND CONVERT(VARCHAR(10), R.RemindOn, 105) = CONVERT(VARCHAR(10), GETDATE(), 105)
 
    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
GO
