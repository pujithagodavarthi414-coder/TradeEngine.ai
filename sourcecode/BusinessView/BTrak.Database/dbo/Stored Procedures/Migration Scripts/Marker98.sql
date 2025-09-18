CREATE PROCEDURE [dbo].[Marker98]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

DECLARE @IndustryID UNIQUEIDENTIFIER = (SELECT Id From Industry where IndustryName LIKE 'Remote Working Software')
UPDATE  Widget SET InActiveDateTime= GETDATE() where WidgetName LIKE '%Employee rate sheet%' 
AND CompanyId IN (SELECT Id FROM Company WHERE IsRemoteAccess=1 AND IndustryId = @IndustryID AND Id=@CompanyId)

--UPDATE BoardType SET BoardTypeUIId = (SELECT Id FROM BoardTypeUi WHERE BoardTypeUiName LIKE '%KanBan view%')
--WHERE BoardTypeName LIKE 'Kanban Bugs' 

END
GO