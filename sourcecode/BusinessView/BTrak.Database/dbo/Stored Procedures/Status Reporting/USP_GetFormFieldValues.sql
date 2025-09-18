--EXEC [USP_GetFormFieldValues]@OperationsPerformedBy = '62722219-FE37-4B8E-B9FD-B70B05FEE17C',@FormName = 'Duty Form Final ',@KeyName = 'vessel'

CREATE PROCEDURE [dbo].[USP_GetFormFieldValues]
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
		    
		    IF(@KeyName IS NOT NULL) SET @KeyName = '$.' + @KeyName
            
			DECLARE @SqlQuery NVARCHAR(MAX) = ''
			
            SET @SqlQuery =  'SELECT JSON_VALUE(GFS.FormJson, '''+@KeyName+'''  ) FieldValue
             FROM GenericFormSubmitted GFS 
                  INNER JOIN GenericForm GF ON GF.Id = GFS.FormId AND GFS.InActiveDateTime IS NULL AND GF.InActiveDateTime IS NULL
             	  INNER JOIN FormType FT ON FT.Id = GF.FormTypeId
                  LEFT JOIN CustomApplication CA ON CA.Id = GFS.CustomApplicationId AND CA.InActiveDateTime IS NULL
             	 WHERE CompanyId = @CompanyId
             	     AND (@FormName IS NULL OR FormName = @FormName)
					 AND (@CustomApplicationName IS NULL OR CustomApplicationName = @CustomApplicationName)
					 AND (@FormId IS NULL OR GFS.FormId = @FormId)
					 AND (@CustomApplicationId IS NULL OR GFS.CustomApplicationId = @CustomApplicationId)'

             	EXEC SP_EXECUTESQL @SqlQuery,
		N'@FormId UNIQUEIDENTIFIER,
		  @FormName NVARCHAR(250),
		  @CustomApplicationName NVARCHAR(250),
		  @CustomApplicationId UNIQUEIDENTIFIER,
		  @CompanyId UNIQUEIDENTIFIER',
		  @FormId,
		  @FormName,
		  @CustomApplicationName,
		  @CustomApplicationId,
		  @CompanyId

     END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END     