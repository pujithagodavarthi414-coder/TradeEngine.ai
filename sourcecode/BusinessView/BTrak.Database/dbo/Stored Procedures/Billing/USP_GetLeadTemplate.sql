CREATE PROCEDURE [dbo].[USP_GetLeadTemplate]
	@TemplateId UNIQUEIDENTIFIER = NULL,
	@FormName NVARCHAR(250) = NULL,
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	   DECLARE @HavePermission NVARCHAR(250)  = '1'
       IF (@HavePermission = '1')
        BEGIN
		    IF (@TemplateId = '00000000-0000-0000-0000-000000000000') SET @TemplateId = NULL
	
	        IF(@FormName = '') SET @FormName = NULL

			IF(@IsArchived IS NULL) SET @IsArchived = 0

			     SELECT LT.Id AS TemplateId,
				        LT.FormName,
						LT.FormJson,
						LT.CreatedDateTime,
						LT.[TimeStamp],
						LT.CreatedByUserId,
						CASE WHEN LT.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived,
						LT.UpdatedDateTime,
						LT.UpdatedByUserId,
						U.FirstName + ' ' + U.SurName AS CreatedBy
				       FROM [dbo].[LeadTemplates]LT
					   INNER JOIN [dbo].[User]U ON U.Id = LT.CreatedByUserId
					   WHERE (@TemplateId IS NULL OR LT.Id = @TemplateId)
					   AND (@FormName IS NULL OR LT.FormName = @FormName)
					   AND (@SearchText IS NULL OR LT.FormName LIKE '%' + @SearchText + '%')
					   AND (@IsArchived IS NULL OR ((@IsArchived  = 0 AND LT.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND LT.InActiveDateTime IS NOT NULL)))
					   AND LT.CompanyId = @CompanyId
		END
		ELSE
		BEGIN
		   RAISERROR (@HavePermission,11, 1)
		END
	END TRY  
	BEGIN CATCH 
		
		 RAISERROR ('Unexpected error searching for lead templates.',11, 1)

	END CATCH

END