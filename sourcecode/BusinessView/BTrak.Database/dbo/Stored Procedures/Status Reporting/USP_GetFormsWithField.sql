--EXEC [USP_GetFormsWithField]  @OperationsPerformedBy = '62722219-FE37-4B8E-B9FD-B70B05FEE17C',@KeyName = 'vessel'

CREATE PROCEDURE [dbo].[USP_GetFormsWithField]
(
	@FormId UNIQUEIDENTIFIER = NULL,
	@CustomApplicationId UNIQUEIDENTIFIER = NULL,
	@KeyName NVARCHAR(250) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@CustomApplicationName NVARCHAR(250) = NULL,
	@FormName NVARCHAR(250) = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			IF(@CustomApplicationName = '') SET @CustomApplicationName = NULL

			IF(@FormName = '') SET @FormName = NULL
			
		    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			SELECT GF.Id,GF.FormName
			  FROM GenericForm GF INNER JOIN GenericFormKey GFK ON GFK.GenericFormId = GF.Id AND GF.InActiveDateTime IS NULL AND GFK.InActiveDateTime IS NULL
			                       INNER JOIN FormType FT ON FT.Id = GF.FormTypeId AND FT.InActiveDateTime IS NULL
								   WHERE FT.CompanyId = @CompanyId 
								       AND GFK.[Key] = @KeyName
									   AND (@FormId IS NULL OR GF.Id <> @FormId)
									   AND (@FormName IS NULL OR GF.FormName <> @FormName)
							GROUP BY GF.Id,GF.FormName

     END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END     