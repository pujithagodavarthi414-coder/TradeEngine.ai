CREATE PROCEDURE [dbo].[USP_GetGenericFormsByTypeId_New]
(
	@FormTypeId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@FormName NVARCHAR(250) = NULL
)

AS
BEGIN

 SET NOCOUNT ON

	 BEGIN TRY

	  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF (@HavePermission = '1')
		  BEGIN

	    IF(@FormTypeId = '00000000-0000-0000-0000-000000000000') SET @FormTypeId = NULL

		IF(@FormName = '') SET @FormName = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

         SELECT GF.[Id] AS Id,
		        GF.FormTypeId,
				GF.FormName,
				GF.FormJson,
				GF.CreatedByUserId,
				GF.CreatedDateTime,
				GF.UpdatedByUserId,
				GF.UpdatedDateTime,
				GF.InActiveDateTime AS ArchivedDateTime,
			    TotalCount = COUNT(1) OVER()

        FROM [dbo].[GenericForm] GF WITH (NOLOCK) 
		     INNER JOIN [FormType] FT ON FT.Id = GF.FormTypeId   
	    WHERE FT.CompanyId = @CompanyId
		      AND (@FormTypeId IS NULL OR GF.FormTypeId = @FormTypeId)
			  AND (@FormName IS NULL OR GF.FormName = @FormName)
			  AND GF.InActiveDateTime IS NULL
	END

	END TRY  
	BEGIN CATCH 
		
		 THROW

	END CATCH

END