CREATE PROCEDURE [dbo].[USP_GetContractSubmissionDetails]
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

			      SELECT CLS.ClientId,
                   CLS.FormData,
                   CLS.FormJson,
                   CLS.CreatedDateTime,
                   U.FirstName +' '+ ISNULL(U.SurName,'') FullName,
                   CLS.CreatedDateTime
                   FROM [ClientContractSubmission] AS CLS
                    JOIN Client C ON C.Id = CLS.ClientId
                   LEFT JOIN [User] U ON C.UserId = U.Id
                   WHERE CLS.CompanyId = @CompanyId AND C.InactiveDateTime IS NULL
                    AND (@SearchText IS NULL OR (U.FirstName+' '+ISNULL(U.SurName,'')) LIKE @SearchText
                    OR (REPLACE(CONVERT(NVARCHAR,CLS.CreatedDateTime,106),' ','-')) LIKE @SearchText)
                   ORDER BY U.FirstName +' '+ ISNULL(U.SurName,'') , CLS.CreatedDateTime Desc
       
		END
		ELSE
		BEGIN
		   RAISERROR (@HavePermission,11, 1)
		END
	END TRY  
	BEGIN CATCH 
		
		 RAISERROR ('Unexpected error searching for purchased templates.',11, 1)

	END CATCH

END