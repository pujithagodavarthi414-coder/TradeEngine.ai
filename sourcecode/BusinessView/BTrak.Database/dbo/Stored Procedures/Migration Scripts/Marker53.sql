CREATE PROCEDURE [dbo].[Marker53]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

INSERT INTO [dbo].CustomHtmlApp([Id],[CustomHtmlAppName],[HtmlCode],[CreatedByUserId],[CreatedDateTime],[CompanyId],[Description],[FileUrls],[Version])
                         VALUES(NEWID(),'Workflow debugger','<div id="widget-scroll-x" style="position: absolute; height: calc(100% - 42px);width:100%">
<iframe src="https://snovasys.snovasys.io:8443/camunda/app/welcome/default/" title="Workflow debugger " style="min-width:500px;width:100%;height:100%"  allow="camera;microphone"></iframe>
</div>',@UserId,GETDATE(),@CompanyId,'Workflow debugger',NULL,(SELECT CONVERT(VARCHAR(50), GETDATE(), 102) + '.0'))
                              ,(NEWID(),'Meet','<div style="position: absolute; min-height: calc(100% - (45px + 24px)); height:100%;width:100%">
<iframe src="https://meet.snovasys.io/b/" title="Workflow debugger " style="width:100%;height:100%"  allow="camera;microphone"></iframe>
</div>',@UserId,GETDATE(),@CompanyId,'This is meet app.',NULL,(SELECT CONVERT(VARCHAR(50), GETDATE(), 102) + '.0'))
                              
INSERT INTO [dbo].CustomHtmlAppRoleConfiguration(
                            [Id],
                            [CustomHtmlAppId],
                            [RoleId],
                            [CreatedDateTime],
                            [CreatedByUserId])
                     SELECT NEWID(),
                            CHA.Id
                            ,R.Id
                            ,GETDATE()
                            ,@UserId
                     FROM CustomHtmlApp CHA 
                          INNER JOIN [Role] R ON 1 = 1
                        WHERE CHA.CompanyId = @CompanyId AND R.CompanyId =@CompanyId
                        AND CHA.CustomHtmlAppName IN ('Workflow debugger','Meet')

END
GO