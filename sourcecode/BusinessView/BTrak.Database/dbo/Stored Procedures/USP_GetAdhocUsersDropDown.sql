-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-10-18 00:00:00.000'
-- Purpose      To Get the Users By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetAdhocUsersDropDown] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @SearchText = 'Srihari U'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAdhocUsersDropDown]
(
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @IsForDropDown BIT = NULL,
  @SearchText NVARCHAR(250) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))) 
	IF (@HavePermission = '1')
    BEGIN
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
          
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
		  IF(@IsForDropDown IS NULL) SET @IsForDropDown = 0

		  DECLARE @ViewAdhocFeatureId UNIQUEIDENTIFIER,@AddAdhocFeatureId UNIQUEIDENTIFIER
		  
		  DECLARE @HaveViewAdhocPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = '02CCA450-E08F-4871-9DA0-E6DA4285C382' AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)
		 
		  DECLARE @HaveAddAdhocPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = '36AD0274-2E7E-406D-87D0-3514075709A7' AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)

          IF(@SearchText = '') SET @SearchText = NULL

          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

		  IF((@HaveViewAdhocPermission = 1 AND @IsForDropDown = 1) OR (@HaveAddAdhocPermission = 1 AND @IsForDropDown = 0))
		  BEGIN

			 SELECT U.Id AS Id,
			         U.FirstName + ' ' + ISNULL(U.SurName,'') as FullName,
					   U.ProfileImage
			 FROM  [dbo].[User] U WITH (NOLOCK)
			 LEFT JOIN [dbo].[Employee]E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			 WHERE U.CompanyId = @CompanyId
			       AND U.InactiveDateTime IS NULL
			       AND (@SearchText IS NULL
			           OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
			          )
			 ORDER BY  U.FirstName + ' ' + ISNULL(U.SurName,'') 
			    
		  END
		  ELSE
		  BEGIN
				
			 SELECT U.Id AS Id,
			         U.FirstName + ' ' + ISNULL(U.SurName,'') as FullName,
					   U.ProfileImage
			 FROM  [dbo].[User] U WITH (NOLOCK)
			       INNER JOIN [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) RM ON RM.ChildId = U.Id
			 LEFT JOIN [dbo].[Employee]E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			 WHERE U.CompanyId = @CompanyId
			       AND U.InactiveDateTime IS NULL
			       AND (@SearchText IS NULL
			           OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
			          )
			 ORDER BY  U.FirstName + ' ' + ISNULL(U.SurName,'')

		  END   
       END   
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO