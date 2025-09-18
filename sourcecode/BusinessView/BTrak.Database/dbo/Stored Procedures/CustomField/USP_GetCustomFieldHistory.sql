CREATE PROCEDURE [dbo].[USP_GetCustomFieldHistory]
	@CustomFieldId UNIQUEIDENTIFIER = NULL,
	@ReferenceId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@ReferenceTypeId UNIQUEIDENTIFIER = NULL
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	      
		  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		  
		  IF (@HavePermission = '1')
           BEGIN
		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			   IF(@CustomFieldId = '00000000-0000-0000-0000-000000000000') SET  @CustomFieldId = NULL

	           IF(@ReferenceId = '00000000-0000-0000-0000-000000000000') SET  @ReferenceId = NULL

			              SELECT CFH.Id AS CustomFieldHistoryId,
						         CFH.CustomFieldId,
								 CFH.ReferenceId,
								 CFH.OldValue,
								 CFH.NewValue,
								 CFH.[Description],
								 CFH.CreatedDateTime,
								 CFH.CreatedByUserId,
								 CF.FormJson,
								 CF.FieldName,
								 U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
				                 U.ProfileImage
							 FROM [dbo].[CustomFieldHistory]CFH
							 INNER JOIN [dbo].[User]U ON CFH.CreatedByUserId = U.Id
							 LEFT JOIN [dbo].[CustomField]CF ON CF.Id = CFH.CustomFieldId
						WHERE (@CustomFieldId IS NULL OR CFH.CustomFieldId = @CustomFieldId)
						  AND (@ReferenceId IS NULL OR CFH.ReferenceId = @ReferenceId)
						  AND (@ReferenceTypeId IS NULL OR CF.ReferenceTypeId = @ReferenceTypeId)
						  AND U.CompanyId = @CompanyId
						ORDER BY CFH.CreatedDateTime DESC
		   
		   END
		   ELSE
           RAISERROR (@HavePermission,11, 1)
	 END TRY  
	 BEGIN CATCH 
		
		  THROW

	END CATCH

END
GO