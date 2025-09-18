CREATE PROCEDURE [dbo].[USP_GetPurchaseConfiguration]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsArchived BIT = NULL,
	 @IsDraft BIT = NULL,
	 @ConsiderRole BIT = NULL,
	 @OfUserId UNIQUEIDENTIFIER = NULL
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
            
              SELECT  C.Id AS PurchaseId,
                      C.[Name] AS PurchaseName,
					   C.Id AS FormId,
                      C.[Name] AS FormName,
					    C.Id AS TemplateId,
                      C.[Name] AS FormName,
					  C.SelectedRoles,
					  RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
				                                FROM [Role] R JOIN (SELECT * FROM [dbo].[Ufn_StringSplit](C.SelectedRoles,',')) T ON T.[Value] = R.Id AND R.InactiveDateTime IS NULL
				                                ORDER BY R.RoleName ASC			  			  
				                                 FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
					  C.FormJson,
					  C.IsDraft,
                      C.CreatedDateTime,
                      C.CreatedByUserId,
                      C.[TimeStamp],
					  U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedBy,
					  U.ProfileImage AS CreatedByImage,
					  CASE WHEN C.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM [ContractPurchase] C
				 JOIN [User] U ON U.Id = C.CreatedByUserId AND C.InActiveDatetime IS NULL
			WHERE C.CompanyId = @CompanyId
				AND ((@IsDraft = 0 AND ISNULL(C.IsDraft,0) = 0) OR @IsDraft = 1)
				AND (@ConsiderRole = 0 OR (@ConsiderRole = 1 AND  (SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](C.SelectedRoles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OfUserId)))  > 0))
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InactiveDateTime IS NULL))
            ORDER BY C.CreatedDatetime DESC
 
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