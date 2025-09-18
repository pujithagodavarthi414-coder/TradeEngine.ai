CREATE PROCEDURE [dbo].[Marker304]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[SoftLabelConfigurations] AS Target
    USING ( VALUES
     (NEWID(), GETDATE(), @UserId, @CompanyId, N'Report', N'Reports')
		)		
    AS Source ([Id], [CreatedDateTime], [CreatedByUserId], [CompanyId], [ReportLabel], [ReportsLabel])
    ON Target.CompanyId = Source.CompanyId
		WHEN MATCHED THEN 
		UPDATE SET
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId]       = Source.[CompanyId],
               [ReportLabel]     = Source.[ReportLabel],
			   [ReportsLabel]    = Source.[ReportsLabel];


MERGE INTO [dbo].[SoftLabelConfigurations] AS Target
    USING ( VALUES
     (NEWID(), GETDATE(), @UserId, @CompanyId, N'Audit', N'Audits', N'Conduct', N'Conducts', N'Action', N'Actions',N'Audit report', N'Audit reports', N'Timeline', N'Audit activity', N'Audit analytics')
		)		
    AS Source ([Id], [CreatedDateTime], [CreatedByUserId], [CompanyId],[AuditLabel],[AuditsLabel],[ConductLabel],[conductsLabel],[ActionLabel],[ActionsLabel],[AuditReportLabel],[AuditReportsLabel],[TimelineLabel],[AuditActivityLabel],[AuditAnalyticsLabel])
    ON Target.CompanyId = Source.CompanyId
		WHEN MATCHED THEN 
		UPDATE SET
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId]       = Source.[CompanyId],
               [AuditLabel] = Source.[AuditLabel],
               [AuditsLabel] = Source.[AuditsLabel],
               [ConductLabel] = Source.[ConductLabel],
               [ConductsLabel] = Source.[ConductsLabel],
                [ActionLabel] = Source.[ActionLabel],
               [ActionsLabel] = Source.[ActionsLabel],
               [AuditReportLabel] = Source.[AuditReportLabel],
               [AuditReportsLabel] = Source.[AuditReportsLabel],
               [TimelineLabel] = Source.[TimelineLabel],
               [AuditActivityLabel] = Source.[AuditActivityLabel],
               [AuditAnalyticsLabel] = Source.[AuditAnalyticsLabel];

END
GO