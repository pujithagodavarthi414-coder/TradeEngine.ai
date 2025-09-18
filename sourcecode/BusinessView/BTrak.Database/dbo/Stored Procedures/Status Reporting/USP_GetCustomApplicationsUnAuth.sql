CREATE PROCEDURE [dbo].[USP_GetCustomApplicationsUnAuth]
(
    @CustomApplicationId UNIQUEIDENTIFIER = NULL
	,@CustomApplicationName NVARCHAR(250) = NULL
	,@GenericFormId UNIQUEIDENTIFIER = NULL
	,@GenericFormName NVARCHAR(250) = NULL
	,@PageNumber INT = 1
	,@PageSize INT = 10
	,@SearchText  NVARCHAR(250) = NULL
	,@IsArchived BIT = 0
)
AS
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250)  = '1'
		
		IF (@HavePermission = '1')
	    BEGIN
    
		   IF(@SearchText = '')SET @SearchText = NULL


		   IF(@IsArchived IS NULL) SET @IsArchived = 0

		  DECLARE @JSONVALUE NVARCHAR(MAX) = (SELECT  * FROM (
		   SELECT CA.Id AS CustomApplicationId
		          ,CA.CustomApplicationName
				  ,CAF.GenericFormId AS FormId
				  ,CA.PublicMessage
				  ,CA.IsApproveNeeded
				  ,CA.Allowannonymous
				  ,CA.IsPdfRequired
				  ,CA.IsRedirectToEmails
				  ,CA.[Description]
				  ,CA.IsPublished
				  ,CAF.PublicUrl
				  ,CA.[CreatedDateTime]
				  ,CA.[TimeStamp]
				  ,CA.WorkflowIds
			 	  ,@IsArchived IsArchived
				  ,TotalCount = COUNT(1) OVER()
				
		     FROM CustomApplication CA
			      INNER JOIN [CustomApplicationForms] CAF ON CAF.CustomApplicationId = CA.Id
			 WHERE CA.Allowannonymous = 1
			       AND (@CustomApplicationId IS NULL OR CA.Id = @CustomApplicationId)
				   AND (@CustomApplicationName IS NULL OR CA.CustomApplicationName = @CustomApplicationName)
				   AND (@GenericFormId IS NULL OR CAF.GenericFormId = @GenericFormId)
				   AND (@SearchText IS NULL OR CA.CustomApplicationName = @SearchText)
				   AND ((@IsArchived = 1 AND CA.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CA.InActiveDateTime IS NULL))
			 ORDER BY CA.CustomApplicationName

				   OFFSET ((@PageNumber - 1) * @PageSize) ROWS

				   FETCH NEXT @PageSize ROWS ONLY
				   ) T 
		  FOR JSON PATH) 

		 SELECT @JSONVALUE

		END
		ELSE
		BEGIN
			
			RAISERROR(@HavePermission,11,1)

		END
		

END TRY
BEGIN CATCH
	
	THROW

END CATCH
END