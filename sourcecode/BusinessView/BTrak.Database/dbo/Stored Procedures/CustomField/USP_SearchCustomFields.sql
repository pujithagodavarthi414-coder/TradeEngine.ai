CREATE PROCEDURE [dbo].[USP_SearchCustomFields]
(
    @CustomFieldId UNIQUEIDENTIFIER = NULL,
	@ReferenceId UNIQUEIDENTIFIER = NULL,
	@ReferenceTypeId UNIQUEIDENTIFIER = NULL,
	@ModuleTypeId INT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)

AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		 
		 IF (@HavePermission = '1')
        BEGIN
	           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

		          SELECT CF.Id AS CustomFieldId,
			             CF.FieldName AS FormName,
				         CF.FormJson,
				         CF.FormKeys,
				         CF.ReferenceId,
				         CF.ReferenceTypeId,
				         CF.ModuleTypeId,
						 CF.CreatedDateTime AS FormCreatedDateTime,
						 CASE WHEN CFF.Id IS NOT NULL THEN CFF.FormDataJson END FormDataJson,
						 CFF.Id AS CustomDataFormFieldId,
						 CFF.CreatedByUserId AS SubmittedByUserId,
						 U.FirstName + ' ' + ISNULL(U.SurName,'') AS SubmittedByUser,
						 U.ProfileImage,
						 CFF.CreatedDateTime,
						 CFF.TimeStamp AS CustomFieldTimeStamp,
						 CF.TimeStamp
			             FROM [dbo].[CustomField]CF
							LEFT JOIN [dbo].[CustomFormFieldMapping]CFF ON CFF.FormId = CF.Id AND (@ReferenceId IS NULL OR CFF.FormReferenceId = @ReferenceId)
				            LEFT JOIN [dbo].[User]U ON CFF.CreatedByUserId = U.Id
				            WHERE (@CustomFieldId IS NULL OR CF.Id = @CustomFieldId)
							AND (@ModuleTypeId IS NULL OR CF.ModuleTypeId = @ModuleTypeId)
							AND (@ReferenceTypeId IS NULL OR CF.ReferenceTypeId = @ReferenceTypeId)
							AND (@ReferenceId IS NULL OR ((@ReferenceId IS NOT NULL AND @ModuleTypeId <> 4 AND @ModuleTypeId <> 2  AND @ModuleTypeId <> 6  AND @ModuleTypeId <> 7 AND @ModuleTypeId <> 78 AND  CF.ReferenceId = @ReferenceId) OR (@ModuleTypeId = 4 OR @ModuleTypeId = 78 OR  @ModuleTypeId = 79 OR @ModuleTypeId = 2 OR @ModuleTypeId = 6 OR @ModuleTypeId = 7)))
				            AND CF.InactiveDateTime IS NULL
							AND CF.CompanyId = @CompanyId
							ORDER BY CFF.CreatedDateTime DESC
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
