-----------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2020-11-30 00:00:00.000'
-- Purpose      To Get Users celebrating their birthday today
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUsersCelebratingBirthday] @Date = '2020-11-30 09:50:10.437'
------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUsersCelebratingBirthday]
(
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@Date DATETIME
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') FullName,
				   U.UserName AS Email,
				   U.Id AS UserId,
				   U.CompanyId
	        FROM Employee E 
			INNER JOIN [User] U ON U.Id = E.UserId AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND U.IsActive = 1
			WHERE DATEPART(MONTH,DateofBirth) = DATEPART(MONTH,@Date) AND DATEPART(DAY,DateofBirth) = DATEPART(DAY,@Date) 
			AND (@CompanyId IS NULL OR (@CompanyId = U.CompanyId))
 
	END TRY
	BEGIN CATCH

	THROW

END CATCH
END