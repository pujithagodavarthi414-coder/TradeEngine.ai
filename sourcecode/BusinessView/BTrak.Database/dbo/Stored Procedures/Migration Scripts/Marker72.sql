CREATE PROCEDURE [dbo].[Marker72]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
	(NEWID(),'Assets count','SELECT AssetName AS [Asset name],B.BranchName AS [Branch name],COUNT(1) [Assets count] FROM Asset A
                             INNER JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id AND AAE.AssignedDateTo IS NULL
	                         INNER JOIN Branch B ON A.BranchId = B.Id AND CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	             GROUP BY AssetName,BranchId,B.BranchName',@CompanyId)
	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

END
GO