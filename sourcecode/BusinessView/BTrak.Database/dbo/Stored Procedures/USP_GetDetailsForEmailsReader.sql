CREATE PROCEDURE [dbo].[USP_GetDetailsForEmailsReader] 
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        BEGIN
            SELECT CompanyName,C.Id AS CompanyId, U.UserName AS UserMail, U.Id AS UserId,UAT.AuthToken AS AuthToken,
                   (
                       SELECT IIF([Value] = 'Excel sheet uploader mail', NULL, [Value])
                       FROM CompanySettings
                       WHERE [Key] = 'Excel sheet uploader mail'
                             AND CompanyId = C.Id
                   ) AS Email,
                   (
                       SELECT IIF([Value] = 'Excel sheet uploader password', NULL, [Value])
                       FROM CompanySettings
                       WHERE [Key] = 'Excel sheet uploader mail password'
                             AND CompanyId = C.Id
                   ) AS [Password],
                   (
                       SELECT IIF([Value] = 'Excel sheet uploader subject', NULL, [Value])
                       FROM CompanySettings
                       WHERE [Key] = 'Excel sheet uploader mail subject'
                             AND CompanyId = C.Id
                   ) AS [Subject]
            FROM [Company]  AS C 
			INNER JOIN [UserCompany] UC ON UC.CompanyId = C.Id
			INNER JOIN [User] U on U.Id = UC.UserId
			INNER JOIN [UserAuthToken] UAT ON UAT.UserId = U.Id
			INNER JOIN [UserRole] UR on UR.UserId = U.Id
			INNER JOIN [Role] R on R.Id = UR.RoleId 
			AND R.RoleName ='Super Admin'
			WHERE c.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
			ORDER BY U.CreatedDateTime ASC

        END

    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END