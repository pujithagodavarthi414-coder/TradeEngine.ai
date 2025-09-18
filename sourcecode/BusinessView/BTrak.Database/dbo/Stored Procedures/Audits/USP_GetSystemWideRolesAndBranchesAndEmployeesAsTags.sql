CREATE PROCEDURE [dbo].[USP_GetSystemWideRolesAndBranchesAndEmployeesAsTags]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @SearchText NVARCHAR(MAX) = NULL,
 @SelectedIds  NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
		
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF(@HavePermission = '1')
        BEGIN

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL)

		;WITH Tree AS
		 (
		     SELECT B_Parent.Id AS BusinessUnitId
		     FROM BusinessUnit B_Parent
		        INNER JOIN BusinessUnitEmployeeConfiguration BUEC ON BUEC.BusinessUnitId = B_Parent.Id
		 			  AND (BUEC.ActiveFrom IS NOT NULL AND BUEC.ActiveFrom <= GETDATE() 
		 			        AND (BUEC.ActiveTo IS NULL OR BUEC.ActiveTo >= GETDATE()))
					  AND BUEC.EmployeeId = @EmployeeId
		     WHERE B_Parent.InActiveDateTime IS NULL 
		 		AND B_Parent.CompanyId = @CompanyId
		 		--AND B_Parent.ParentBusinessUnitId IS NULL
		     UNION ALL
		     SELECT B_Child.Id AS BusinessUnitId
		     FROM BusinessUnit B_Child INNER JOIN Tree ON Tree.BusinessUnitId = B_Child.[ParentBusinessUnitId]
		     WHERE B_Child.InActiveDateTime IS NULL 
		 		AND B_Child.CompanyId = @CompanyId
		 )
		 SELECT  T.BusinessUnitId
		         ,B.BusinessUnitName
			 INTO #BusinessUnit
		 	 FROM Tree T
		      INNER JOIN BusinessUnit B ON B.Id = T.BusinessUnitId AND B.InActiveDateTime IS NULL
		 		      AND B.CompanyId = @CompanyId
		GROUP BY T.BusinessUnitId,B.BusinessUnitName --,B.[ParentBusinessUnitId]

        IF(@SearchText IS NULL) SET @SearchText = ''

		IF(@SelectedIds = 'null') SET @SelectedIds = NULL

        SET @SearchText = '%' + @SearchText + '%'

        SELECT Id AS TagId
              ,RoleName AS TagName
               FROM [Role] R
               LEFT JOIN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@SelectedIds,',')) T ON T.[Value] = R.Id
               WHERE CompanyId = @CompanyId 
                 AND InactiveDateTime IS NULL
                 AND (@SelectedIds IS NULL OR T.[Value] IS NULL)
                 AND RoleName LIKE @SearchText
               GROUP BY Id,RoleName

        UNION

        SELECT Id AS TagId
              ,BranchName AS TagName 
               FROM Branch B
               LEFT JOIN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@SelectedIds,',')) T ON T.[Value] = B.Id
               WHERE CompanyId = @CompanyId 
                 AND InActiveDateTime IS NULL
                 AND (@SelectedIds IS NULL OR T.[Value] IS NULL)
                 AND BranchName LIKE @SearchText
        GROUP BY Id,BranchName

        UNION

        SELECT U.Id AS TagId
              ,U.FirstName + IIF(U.SurName IS NULL,'',' ' + U.SurName) AS TagName 
               FROM [User] U JOIN Employee E ON E.UserId = U.Id AND U.CompanyId = @CompanyId
               LEFT JOIN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@SelectedIds,',')) T ON T.[Value] = U.Id
                AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
				WHERE (@SelectedIds IS NULL OR T.[Value] IS NULL)
                AND U.FirstName + IIF(U.SurName IS NULL,'',' ' + U.SurName) LIKE @SearchText
               GROUP BY U.Id,U.FirstName + IIF(U.SurName IS NULL,'',' ' + U.SurName)

        UNION

        SELECT A.Id AS TagId
              ,(A.AssetName + '-' + A.AssetNumber) AS TagName
            FROM [Asset] A
            INNER JOIN Branch AS B ON B.Id = A.BranchId AND B.InactiveDateTime IS NULL AND B.CompanyId = @CompanyId
            INNER JOIN CompanyModule CM ON CM.CompanyId = B.CompanyId AND CM.InActiveDateTime IS NULL AND CM.ModuleId = '26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904' -- Asset module Id
            LEFT JOIN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@SelectedIds,',')) T ON T.[Value] = A.Id
				WHERE (@SelectedIds IS NULL OR T.[Value] IS NULL)
                AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL)
                AND A.InactiveDateTime IS NULL
                AND ((A.AssetName + '-' + A.AssetNumber) LIKE @SearchText)
               GROUP BY A.Id,A.AssetName + '-' + A.AssetNumber

        UNION

        SELECT CAT.Id AS TagId
              ,CAT.TagValue AS TagName
              FROM [CustomApplicationTag] CAT
              INNER JOIN [User] U ON U.Id = CAT.CreatedByUserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.CompanyId = @CompanyId
              --INNER JOIN [GenericFormKey] GFK ON GFK.Id = CAT.GenericFormKeyId AND CAT.InActiveDateTime IS NULL AND GFK.InActiveDateTime IS NULL
              LEFT JOIN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@SelectedIds,',')) T ON T.[Value] = CAT.Id
                WHERE (@SelectedIds IS NULL OR T.[Value] IS NULL)
                AND CAT.InActiveDateTime IS NULL
                AND (CAT.TagValue LIKE @SearchText)
               GROUP BY CAT.Id,CAT.TagValue

		UNION
		SELECT BU.BusinessUnitId
		       ,BU.BusinessUnitName
		FROM #BusinessUnit AS BU
              LEFT JOIN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@SelectedIds,',')) T ON T.[Value] = BU.BusinessUnitId
		 WHERE (@SelectedIds IS NULL OR T.[Value] IS NULL)
         AND (BU.BusinessUnitName LIKE @SearchText)
        GROUP BY BU.BusinessUnitId,BU.BusinessUnitName

        END
        ELSE
            RAISERROR(@HavePermission,11,1)
    
    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END
GO