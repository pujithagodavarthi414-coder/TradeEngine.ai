-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-03-19 00:00:00.000'
-- Purpose      To Save Notification
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetAllApplicableMenuItems] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'

CREATE PROCEDURE [dbo].[USP_GetAllApplicableMenuItems] (@OperationsPerformedBy UNIQUEIDENTIFIER, @MenuCategory NVARCHAR(MAX) = NULL)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
            SET @OperationsPerformedBy = NULL
        DECLARE @CompanyId UNIQUEIDENTIFIER = (
                                                  SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)
                                              )

        IF (@OperationsPerformedBy IS NOT NULL)
        BEGIN
	
	   DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)  
									  
	   DECLARE @IsEnergySector BIT = IIF((SELECT IndustryId FROM Company WHERE Id = @CompanyId) = 'BBBB8092-EBCC-43FF-A039-5E3BD2FACE51', 1, 0)

            CREATE TABLE #MenuItems
            (
                MenuItemId UNIQUEIDENTIFIER,
                [ParentMenuItemId] UNIQUEIDENTIFIER
            )

            INSERT INTO #MenuItems
            SELECT MI.[Id] AS MenuItemId,
                   MI.[ParentMenuItemId]
            FROM [MenuItem] AS MI WITH (NOLOCK)
                INNER JOIN [MenuCategory] MC
                    ON MC.Id = MI.MenuCategoryId
                       AND MC.InActiveDateTime IS NULL
                INNER JOIN Feature F WITH (NOLOCK)
                    ON F.MenuItemId = MI.Id
                       AND F.InActiveDateTime IS NULL
                INNER JOIN RoleFeature RF WITH (NOLOCK)
                    ON RF.FeatureId = F.Id
                       AND RF.InActiveDateTime IS NULL
                --INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL
                INNER JOIN [FeatureModule] FM
                    ON FM.FeatureId = F.Id
                       AND FM.InActiveDateTime IS NULL
                       AND F.InActiveDateTime IS NULL
                INNER JOIN [CompanyModule] CM
                    ON CM.ModuleId = FM.ModuleId
                       AND CM.CompanyId = @CompanyId
                       AND CM.InActiveDateTime IS NULL
				INNER JOIN Module M ON M.Id = CM.ModuleId  AND ((CM.IsActive = 1 OR M.IsSystemModule = 1) OR @IsSupport = 1)
            WHERE RF.RoleId IN (
                                   SELECT RoleId
                                   FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)
                               )
                  --AND (R.CompanyId = @CompanyId)
                  AND (
                          (
                              @CompanyId = '4AFEB444-E826-4F95-AC41-2175E36A0C16'
                              AND (
                                      IsSystemLevel = 0
                                      OR IsSystemLevel = 1
                                  )
                          )
                          OR (
                                 @CompanyId <> '4AFEB444-E826-4F95-AC41-2175E36A0C16'
                                 AND IsSystemLevel = 0
                             )
                      )
                  AND MI.Id NOT IN ( '68164900-1943-4CEC-8A6D-DC0DE194C5D6', '974F7BCE-C3B0-45D3-AB65-B0B6C4CD7FA1',
                                     '7E174395-8F84-4930-8394-2CECD6AE7CEE', '5FE009B5-83D1-40A6-8B29-7AC939087916',
                                     'F6F891BE-EF7D-4AAD-B537-E080E15039DF', '1E02C356-57E3-4C30-85F6-6DC50A873B17',
                                     '3FA32FA4-C63E-4565-AEC1-A0FFBD6EF317', '9094C735-76AB-49DD-BC7E-57A3FB137A7C',
                                     'C5D5412E-D175-492A-8D78-E0C766A39AFD', '5608103B-B7F4-4621-85CD-DCBC8E693B9B',
                                     '93C062DB-4B83-4477-9B44-2197ECFAA070', '9C40E52D-42E3-4868-AD98-37ECAA466459',
                                     '108CF941-2CD4-45D9-9FC3-EDE94DEF73CE'
                                   )
				AND (MI.IsActive IS NULL OR MI.IsActive=1) AND (@MenuCategory IS NULL OR MC.[Name] = @MenuCategory)
				AND (@IsEnergySector = 0 OR MI.Id <> 'B30DC3F6-1411-4A09-88F1-13FEFE3B1275')
            GROUP BY MI.[Id],
                     MI.[ParentMenuItemId],
                     MI.[Name],
                     MC.[Name]

            INSERT INTO #MenuItems
            SELECT MIInner.[Id] AS MenuItemId,
                   MIInner.[ParentMenuItemId]
            FROM #MenuItems MI
                LEFT JOIN [MenuItem] MIInner WITH (NOLOCK)
                    ON MI.[ParentMenuItemId] = MIInner.Id
                       AND MIInner.Id NOT IN (
                                                 SELECT MenuItemId FROM #MenuItems
                                             )
                INNER JOIN [MenuCategory] MC
                    ON MC.Id = MIInner.MenuCategoryId
            WHERE MC.InactiveDateTime IS NULL
            GROUP BY MIInner.[Id],
                     MIInner.[ParentMenuItemId],
                     MIInner.[Name],
                     MC.[Name]
     

                SELECT VMI.[Id],
                       VMI.MenuCategory,
                       VMI.ProcessedOrderNumber,
                       VMI.ParentMenu,
                       VMI.Menu,
                       VMI.[Type],
                       VMI.ToolTip,
                       VMI.[State],
                       VMI.Icon,
                       VMI.ParentMenuItemId
                FROM #MenuItems MI
                    INNER JOIN V_AllMenuItems VMI
                        ON MI.MenuItemId = VMI.Id
                ORDER BY OrderNumber
           
        END
    END TRY
    BEGIN CATCH

        EXEC [dbo].[USP_GetErrorInformation]
    END CATCH
END