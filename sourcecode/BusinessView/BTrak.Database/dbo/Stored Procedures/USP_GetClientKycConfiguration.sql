-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetClientKycConfiguration] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientKycConfiguration]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsArchived BIT = NULL,
	 @IsDraft BIT = NULL,
	 @ConsiderRole BIT = NULL,
	 @OfUserId UNIQUEIDENTIFIER = NULL,
	 @ClientTypeId UNIQUEIDENTIFIER = NULL,
	 @LegalEntityTypeId UNIQUEIDENTIFIER = NULL,
	 @RoleId UNIQUEIDENTIFIER = NULL,
	 @ClientKycId UNIQUEIDENTIFIER = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
		 IF (@IsDraft IS NULL) SET @IsDraft = 0

		 IF (@ConsiderRole IS NULL) SET @ConsiderRole = 0

         IF (@HavePermission = '1')
         BEGIN
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            DECLARE @BearerToken NVARCHAR(500) = (SELECT AuthToken from UserAuthToken WHERE UserId=@OperationsPerformedBy)
              SELECT  CK.Id AS ClientKycId,
                      CK.[Name] AS ClientKycName,
					  CK.SelectedRoles,
					  --CK.SelectedLegalEntities,
					  RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
				                                 FROM [Role] R JOIN (SELECT * FROM [dbo].[Ufn_StringSplit](CK.SelectedRoles,',')) T ON T.[Value] = R.Id AND R.InactiveDateTime IS NULL
				                                 ORDER BY R.RoleName ASC			  			  
				                                  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				   --LegalEntityNames = (STUFF((SELECT ',' + L.LegalEntityName [text()]
				   --                              FROM LegalEntity L JOIN (SELECT * FROM [dbo].[Ufn_StringSplit](CK.SelectedLegalEntities,',')) T ON T.[Value] = L.Id AND L.InactiveDateTime IS NULL
				   --                              ORDER BY L.LegalEntityName ASC			  			  
				   --                               FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
					  REPLACE(REPLACE(CK.FormJson,'##UserId##',@OperationsPerformedBy),'##CompanyId##',@CompanyId) AS FormJson,
					  --REPLACE(,'##ClientId##',C.Id)
					  CK.IsDraft,
                      CK.CreatedDateTime,
                      CK.CreatedByUserId,
                      CK.[TimeStamp],
					  U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedBy,
					  U.ProfileImage AS CreatedByImage,
					  --C.ClientTypeName,
					  L.LegalEntityName,
					  --C.Id AS ClientTypeId,
					  L.Id AS LegalEntityTypeId,
					  CASE WHEN CK.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
					  CK.FormBgColor,
                      TotalCount = COUNT(1) OVER()
            FROM [ClientKycConfiguration] CK
				  --JOIN [ClientType] C ON C.Id = CK.ClientTypeId AND C.InActiveDatetime IS NULL
				  LEFT JOIN [LegalEntity] L ON L.Id = CK.LegalEntityTypeId AND L.InActiveDatetime IS NULL
				 JOIN [User] U ON U.Id = CK.CreatedByUserId AND U.InActiveDatetime IS NULL
			WHERE CK.CompanyId = @CompanyId AND CK.InActiveDatetime IS NULL 
			--AND CK.ClientTypeId IN (SELECT ClientTypeId FROM ClientTypeRoles WHERE InActiveDatetime IS NULL 
			--AND RoleId IN (SELECT RoleId FROM [UserRole] WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL))
				--AND (@ClientTypeId IS NULL OR CK.ClientTypeId = @ClientTypeId) AND (@ClientKycId IS NULL OR CK.Id = @ClientKycId)
				AND (@LegalEntityTypeId IS NULL OR (@LegalEntityTypeId IN (SELECT * FROM STRING_SPLIT(CK.SelectedLegalEntities,','))))
				AND (@RoleId IS NULL OR (@RoleId IN (SELECT * FROM STRING_SPLIT(CK.SelectedRoles,','))))
				AND ((@IsDraft = 0 AND ISNULL(CK.IsDraft,0) = 0) OR @IsDraft = 1)
				--AND (@ConsiderRole = 0 OR (@ConsiderRole = 1 AND  (SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](CK.SelectedRoles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OfUserId)))  > 0))
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CK.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CK.InactiveDateTime IS NULL))
				--AND (@ConsiderRole = 0 OR (@ConsiderRole = 1 AND  (SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](Ck.SelectedRoles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OfUserId)))  > 0))
            ORDER BY CK.CreatedDatetime DESC
 
         END
         ELSE
         BEGIN
         
                 RAISERROR (@HavePermission,11, 1)
                 
         END
    END TRY
    BEGIN CATCH
        
        THROW
 
    END CATCH 
 END
GO

