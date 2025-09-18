CREATE PROCEDURE [dbo].[USP_GetAllUsersForAuthentication]
(
	@OperationsPerformedBY UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
		DECLARE @HavePermission NVARCHAR(250)  = '1'

		IF (@HavePermission = '1')
        BEGIN

			SELECT U.Id AS UserId
				   ,C.Id AS CompanyId
				   ,UC.Id AS UserCompanyId
				   ,U.UserName AS Email
				   ,U.FirstName
				   ,U.SurName AS LastName
				   ,U.[Password]
				   ,U.FirstName +' '+ISNULL(U.SurName,'') as FullName
				   ,U.IsActive
				   ,U.MobileNo
				   ,U.ProfileImage
			FROM [User] AS U
			INNER JOIN [UserCompany] AS UC ON UC.UserId = U.Id
			INNER JOIN [Company] AS C ON C.Id = UC.CompanyId

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
