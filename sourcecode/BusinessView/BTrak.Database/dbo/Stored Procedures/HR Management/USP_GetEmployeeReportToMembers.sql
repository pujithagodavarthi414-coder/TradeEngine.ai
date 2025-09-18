CREATE PROCEDURE [dbo].[USP_GetEmployeeReportToMembers]
	@UserId UNIQUEIDENTIFIER = NULL
AS
	select GERM.UserId AS Id,
		   U.FirstName + ' ' + ISNULL(U.SurName,'') AS FullName,
		   U.UserName AS Email,
		   U.ProfileImage 
	from [Ufn_GetEmployeeReportToMembers](@UserId) AS GERM
	JOIN [User] U ON U.Id = GERM.UserId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
