CREATE PROCEDURE [dbo].[USP_GetProbationConfigurations]
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
 
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
		 IF (@IsDraft IS NULL) SET @IsDraft = 0

		 IF (@ConsiderRole IS NULL) SET @ConsiderRole = 0

         IF (@HavePermission = '1')
         BEGIN
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT  PC.Id AS ConfigurationId,
                      PC.[Name] AS ConfigurationName,
					  PC.SelectedRoles,
					  RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
				                                 FROM [Role] R JOIN (SELECT * FROM [dbo].[Ufn_StringSplit](PC.SelectedRoles,',')) T ON T.[Value] = R.Id AND R.InactiveDateTime IS NULL
				                                 ORDER BY R.RoleName ASC			  			  
				                                  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
					  PC.FormJson,
					  PC.IsDraft,
                      PC.CreatedDateTime,
                      PC.CreatedByUserId,
                      PC.[TimeStamp],
					  U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedBy,
					  U.ProfileImage AS CreatedByImage,
					  CASE WHEN PC.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM ProbationConfiguration PC
				 JOIN [User] U ON U.Id = PC.CreatedByUserId AND PC.InActiveDatetime IS NULL
			WHERE PC.CompanyId = @CompanyId
				AND ((@IsDraft = 0 AND ISNULL(PC.IsDraft,0) = 0) OR @IsDraft = 1)
				AND (@ConsiderRole = 0 OR (@ConsiderRole = 1 AND  (SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](PC.SelectedRoles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OfUserId)))  > 0))
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND PC.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PC.InactiveDateTime IS NULL))
            ORDER BY PC.CreatedDatetime DESC
 
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
