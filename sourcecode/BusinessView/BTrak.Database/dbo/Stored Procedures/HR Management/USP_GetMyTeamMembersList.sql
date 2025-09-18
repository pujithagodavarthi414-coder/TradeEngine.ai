-------------------------------------------------------------------------------
-- Author    Ranadheer Rana Velaga
-- Created   '2019-06-06 00:00:00.000'
-- Purpose   To get team members list
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------------
--EXEC USP_GetMyTeamMembersList @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------------

CREATE PROCEDURE USP_GetMyTeamMembersList
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @SearchText NVARCHAR(500) = NULL,
 @IsAllUsers BIT = NULL,
 @IsArchived BIT = NULL,
 @IsForTracker BIT = NULL
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
     
      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	  IF(@SearchText = '') SET @SearchText = NULL
		   
	  SET @SearchText  = '%'+ @SearchText +'%'

	  IF(@IsAllUsers IS NULL) SET @IsAllUsers = 0

	  IF(@IsForTracker IS NULL) SET @IsForTracker = 0

	  DECLARE @CanAccessAllEmployee INT = (SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE F.Id = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5' AND U.Id = @OperationsPerformedBy)

     IF(@HavePermission = '1')
     BEGIN
       DECLARE @CompanyId UNIQUEIDENTIFIER =  (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

	   IF((@IsForTracker = 0 OR (@IsForTracker = 1 AND @CanAccessAllEmployee = 0)) AND @IsAllUsers = 0)
			BEGIN
       SELECT U.Id TeamMemberId,
			  U.FirstName +' '+ISNULL(U.SurName,'') AS TeamMemberName,
			  U.UserName EmailId,
			  U.ProfileImage ProfileImage,
			  U.IsActive, 
			  EB.BranchId AS BranchId, 
			  RoleIds = (STUFF((SELECT ',' + LOWER(CAST(UR.RoleId AS NVARCHAR(MAX))) [text()]
				  FROM  UserRole UR
				  WHERE UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))	
              FROM [User] U
			  INNER JOIN Employee E ON E.UserId = U.Id
			  INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
					AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
			  --INNER JOIN UserRole UR ON UR.UserId = U.Id
              INNER JOIN (SELECT ChildId AS Child 
                          FROM Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)
                          GROUP BY ChildId
                          ) T ON T.Child = U.Id  AND U.InActiveDateTime IS NULL
			  WHERE U.CompanyId = @CompanyId  AND (@SearchText IS NULL 
			        OR (U.FirstName LIKE @SearchText)
					OR (U.SurName LIKE @SearchText))
                    AND (@IsArchived IS NULL 
                          OR (@IsArchived = 0 AND U.InActiveDateTime IS NULL AND U.IsActive = 1)
                          OR (@IsArchived = 1 AND U.InActiveDateTime IS NOT NULL AND U.IsActive = 0)
                        )
		ORDER BY U.FirstName +' '+ISNULL(U.SurName,'')
			END
		IF((@IsForTracker = 1 AND @CanAccessAllEmployee > 0) OR @IsAllUsers = 1)
			BEGIN
				SELECT  E.UserId AS TeamMemberId,
						U.FirstName +' '+ISNULL(U.SurName,'') AS TeamMemberName,
						U.UserName EmailId,
						U.ProfileImage ProfileImage ,
						U.IsActive,
						EB.BranchId AS BranchId, 
						RoleIds = (STUFF((SELECT ',' + LOWER(CAST(UR.RoleId AS NVARCHAR(MAX))) [text()]
						FROM  UserRole UR
						WHERE UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
						FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))	
						FROM Employee E
						INNER JOIN [User] U ON U.Id = E.UserId
						INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
							AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
						WHERE U.CompanyId = @CompanyId  AND (@SearchText IS NULL 
							OR (U.FirstName LIKE @SearchText)
							OR (U.SurName LIKE @SearchText))
							AND(U.UserName <> '348djbfsd7f8wr2@sdfj239842349.com' OR (@IsSupport = 1))
                            AND (@IsArchived IS NULL 
                          OR (@IsArchived = 0 AND U.InActiveDateTime IS NULL AND U.IsActive = 1)
                          OR (@IsArchived = 1 AND U.InActiveDateTime IS NOT NULL AND U.IsActive = 0))
						  AND (EB.EmployeeId IN (SELECT EmployeeId
						   FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)))
						ORDER BY U.FirstName +' '+ISNULL(U.SurName,'')
			END

      END
      ELSE
         
         RAISERROR (@HavePermission,11,1)
      
      END TRY
      BEGIN CATCH
         THROW
      END CATCH
END
GO
