-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-07 00:00:00.000'
-- Purpose      To Get The Genericforms by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetGenericForms_New]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=0
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetGenericForms_New]
(
    @GenericFormId UNIQUEIDENTIFIER = NULL,
	@FormTypeId UNIQUEIDENTIFIER = NULL,
	@FormName NVARCHAR(250) = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER,
    @IsArchived BIT,
    @Pagesize INT = 10,
    @Pagenumber INT= 1,
	@CompanyModuleId UNIQUEIDENTIFIER = NULL,
	@FormIdsXml XML = NULL
)
AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	      DECLARE @HavePermission NVARCHAR(250) =  '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF (@HavePermission = '1')
		  BEGIN

	       IF(@GenericFormId = '00000000-0000-0000-0000-000000000000') SET @GenericFormId = NULL

	       IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		   
		   DECLARE @BearerToken NVARCHAR(500) = (SELECT AuthToken from UserAuthToken WHERE UserId=@OperationsPerformedBy)

	       IF(@FormTypeId = '00000000-0000-0000-0000-000000000000') SET @FormTypeId = NULL

	       IF(@SearchText = '') 
		   BEGIN

		      SET @SearchText = NULL

		   END
		   ELSE
		   BEGIN

		      SET @SearchText = '%'+ @SearchText +'%'

		   END

		    CREATE TABLE #FormIds
        (
           Id UNIQUEIDENTIFIER
        )

        IF(@FormIdsXml IS NOT NULL)
        BEGIN
              SET @GenericFormId = NULL

              INSERT INTO #FormIds(Id)
              SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
              FROM @FormIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
        END
			  
	       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

           SELECT GF.[Id] AS Id,
                  GF.[FormTypeId],
                  GF.[DataSourceId],
                  FT.[FormTypeName],
                  GF.[FormName],
				  GF.[WorkflowTrigger],
				  GF.FormJson,
				  FA.IsAbleToLogin,
				  FA.IsAbleToPay,
				  FA.IsAbleToCall,
				  FA.IsAbleToComment,
				  GF.CompanyModuleId,
				  (SELECT STUFF(( SELECT ',' +  CONVERT(VARCHAR(MAX),RoleId) FROM [FormAccessibilityRoleMapping] FAR WHERE FAR.FormId = GF.Id AND MapType = 'COMMENT' AND InActiveDateTime IS NULL AND RoleId IS NOT NULL FOR XML PATH('')),1,1,'')   CommentRoles )[CommentRoles],
				  (SELECT STUFF(( SELECT ',' +  CONVERT(VARCHAR(MAX),RoleId) FROM [FormAccessibilityRoleMapping] FAR WHERE FAR.FormId = GF.Id AND MapType = 'CALL' AND InActiveDateTime IS NULL AND RoleId IS NOT NULL FOR XML PATH('')),1,1,'')   CallRoles )[CallRoles],
				  (SELECT STUFF(( SELECT ',' +  CONVERT(VARCHAR(MAX),RoleId) FROM [FormAccessibilityRoleMapping] FAR WHERE FAR.FormId = GF.Id AND MapType = 'PAY' AND InActiveDateTime IS NULL AND RoleId IS NOT NULL FOR XML PATH('')),1,1,'')   PayRoles )[PayRoles],
				  GF.[CreatedDateTime], 
				  GF.[CreatedByUserId],
				  GF.[UpdatedDateTime],
				  GF.[UpdatedByUserId],
				  GF.InActiveDateTime AS ArchivedDateTime,
				  CustomApplications =  (STUFF((SELECT ',' + CA.CustomApplicationName [text()]
			  				  FROM CustomApplicationForms CAF
			  						LEFT JOIN CustomApplication CA ON CA.Id = CAF.CustomApplicationId
			   				  WHERE  CAF.GenericFormId = GF.Id
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				  GF.[TimeStamp],
				  CASE WHEN GF.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				  TotalCount = COUNT(1) OVER()
           FROM [dbo].[GenericForm] GF WITH (NOLOCK)
		        LEFT JOIN FormType FT ON (FT.Id = GF.FormTypeId)
				LEFT JOIN FormAccessibility FA ON FA.FormId = GF.Id
				
           WHERE 
		     --FT.CompanyId = @CompanyId
		        -- AND 
				 (@GenericFormId IS NULL OR (GF.Id = @GenericFormId))
		         AND (@FormTypeId IS NULL OR GF.FormTypeId = @FormTypeId)
				 AND (@CompanyModuleId IS NULL OR GF.CompanyModuleId = @CompanyModuleId)
		         AND (@IsArchived IS NULL 
				      OR (@IsArchived = 1 AND GF.InActiveDateTime IS NOT NULL) 
		              OR (@IsArchived = 0 AND GF.InActiveDateTime IS NULL))
				 AND (@FormName IS NULL OR GF.FormName = @FormName)
				 AND (@FormIdsXml IS NULL OR ( GF.Id IN (SELECT Id FROM #FormIds)))
		         AND (@SearchText IS NULL 
		              OR GF.FormName LIKE @SearchText
		              OR FT.FormTypeName LIKE @SearchText
		              OR GF.CreatedDateTime LIKE @SearchText
		              OR GF.UpdatedDateTime LIKE @SearchText
		              OR GF.InActiveDateTime LIKE @SearchText)
				
				 ORDER BY GF.CreatedDateTime DESC
				
		END

		ELSE
		   
		   RAISERROR(@HavePermission,11,1)

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END