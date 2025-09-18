CREATE PROCEDURE [dbo].[Marker123]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    UPDATE [dbo].[SoftLabelConfigurations] 
    SET TestReportLabel = 'Test report'
        ,TestReportsLabel = 'Test reports'
        ,UpdatedByUserId = @UserId
        ,UpdatedDateTime = GETDATE()
    WHERE CompanyId = @CompanyId

	UPDATE [Widget] SET [Description] = 'Project, Goal, Work item, Deadline, Employee,Test suite, Test run,Version,Test report,
	Estimated time, Estimation and it plurals can be customised to match the 
	company naming conventions.' WHERE [WidgetName] = 'Soft label configuration' AND CompanyId = @CompanyId
END
GO