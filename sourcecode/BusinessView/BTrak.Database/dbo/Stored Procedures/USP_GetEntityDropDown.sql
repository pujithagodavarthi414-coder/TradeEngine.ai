-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-01-01 00:00:00.000'
-- Purpose      To Get the Entities By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEntityDropDown] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SearchText = 'Snovasys'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEntityDropDown]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @IsEmployeeList BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
          
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
          IF(@SearchText = '') SET @SearchText = NULL
		  
          IF(@IsEmployeeList IS NULL) SET @IsEmployeeList = 0

          DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE InactiveDateTime IS NULL AND UserId = (@OperationsPerformedBy))

          DECLARE @HaveEntityUpsertPermission INT = 0

          IF(@IsEmployeeList = 1)
          BEGIN
            
            SET @HaveEntityUpsertPermission  = ISNULL((SELECT COUNT(1) FROM UserRole UR 
                                                     INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId 
                                                     INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                                AND R.InactiveDateTime IS NULL
                                                                AND R.CompanyId = @CompanyId
                                                                AND UR.UserId = @OperationsPerformedBy
                                                                AND UR.InactiveDateTime IS NULL
                                                                AND RF.InActiveDateTime IS NULL
                                                                 AND RF.FeatureId = N'117299CA-8FC4-4EE0-83DD-EAAA0B10505F'),0) --Add or Edit company structure

          END

          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

            SELECT E.Id
                  ,E.EntityName AS [Name]
           FROM  [dbo].[Entity] E WITH (NOLOCK)
           WHERE E.CompanyId = @CompanyId
                 AND E.InactiveDateTime IS NULL
                 AND (@SearchText IS NULL
                     OR (E.EntityName LIKE @SearchText)
                    )
                 AND ((@HaveEntityUpsertPermission > 0) OR 
                        (E.Id IN (SELECT EntityId FROM [dbo].[Ufn_GetEntitiesHierarchy](@EmployeeId,NULL)))
                      )
           ORDER BY E.EntityName 

	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END
GO
