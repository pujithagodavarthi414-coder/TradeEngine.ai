--EXEC [dbo].[USP_GetCompanyIdBySiteAddress] 'snovasys.btrak.io'
CREATE PROCEDURE [dbo].[USP_GetCompanyIdBySiteAddress]
(
	@SiteAddress nvarchar(250)
)

AS
BEGIN

	SELECT C.Id FROM [dbo].[Company] C WITH (NOLOCK) WHERE C.SiteAddress LIKE '%'+@SiteAddress+'%'

END