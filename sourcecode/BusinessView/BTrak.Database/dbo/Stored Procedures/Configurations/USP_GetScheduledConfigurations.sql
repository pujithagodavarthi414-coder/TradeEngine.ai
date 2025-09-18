--EXEC [dbo].[USP_GetScheduledConfigurations]
CREATE PROCEDURE [dbo].[USP_GetScheduledConfigurations]
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY

		CREATE TABLE #ConfigurationDetails (
		TemplateName VARCHAR(2000)
		,CompanyId UNIQUEIDENTIFIER
		,Roles NVARCHAR(MAX)
		,Mails NVARCHAR(MAX)
		,Users NVARCHAR(MAX)
		,SiteURL [NVARCHAR](1000) NULL 
		)
		
		INSERT INTO #ConfigurationDetails(CompanyId,TemplateName,Roles,Mails,SiteURL)
		SELECT  TC.CompanyId,HT.TemplateName,TC.Roles,TC.Mails,C.[SiteAddress]
		FROM TemplateConfiguration TC
			 INNER JOIN HtmlTemplates HT ON HT.Id = TC.HtmlTemplateId
			 INNER JOIN Company C On C.Id = TC.CompanyId AND C.InActiveDateTime IS NULL
		WHERE TC.InActiveDateTime IS NULL AND HT.InActiveDateTime IS NULL
			  AND TC.Roles IS NOT NULL OR TC.Mails IS NOT NULL
		
		UPDATE #ConfigurationDetails SET Users = (SELECT * 
												  FROM (
													SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS UserName,UserName AS Email,U.Id AS UserId 
													FROM [User] U 
													WHERE U.CompanyId = CD.CompanyId 
													      AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
													AND U.UserName IN (SELECT Id FROM dbo.UfnSplit(CD.Mails))
													UNION
													SELECT NULL AS UserName,Id AS Email,NULL AS UserId
													FROM dbo.UfnSplit(CD.Mails)
													WHERE Id NOT IN (SELECT UserName FROM [User] WHERE CompanyId = CD.CompanyId)
													) T FOR JSON PATH
													)
		FROM #ConfigurationDetails CD
		WHERE Mails IS NOT NULL
		
		UPDATE #ConfigurationDetails SET Users = (SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') AS UserName,UserName AS Email,U.Id AS UserId 
		                                          FROM [User] U
												  WHERE U.CompanyId = CD.CompanyId 
												        AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
												  AND U.Id IN (SELECT UserId FROM UserRole WHERE InactiveDateTime IS NULL 
												                AND RoleId IN (SELECT Id FROM dbo.UfnSplit(CD.Roles))) 
												  FOR JSON PATH
												  )
		FROM #ConfigurationDetails CD
		WHERE Roles IS NOT NULL
		
		SELECT TemplateName,CompanyId,Users AS UsersJson,SiteURL
		FROM #ConfigurationDetails

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH
END
GO