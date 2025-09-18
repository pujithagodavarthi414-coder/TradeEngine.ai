CREATE PROCEDURE [dbo].[USP_GetJobOpeningStatus]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER,
    @Status NVARCHAR(50) = NULL,
	@Order INT = NULL,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@SortDirection NVARCHAR(50) = NULL,
	@SortBy NVARCHAR(50) = NULL,
	@JobOpeningStatusId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@SortBy IS NULL OR @SortBy = '') SET @SortBy =  'order'
		   
		   IF(@SortDirection IS NULL OR @SortDirection = '') SET @SortDirection = 'ASC'

		   IF(@JobOpeningStatusId = '00000000-0000-0000-0000-000000000000') SET @JobOpeningStatusId = NULL	
		   
           --DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT JOS.Id AS JobOpeningStatusId,
		   	      JOS.CompanyId,
				  JOS.[Status],
		   	      JOS.[Order],
				  JOS.[StatusColour],
		   	      JOS.InActiveDateTime,
		   	      JOS.CreatedDateTime ,
		   	      JOS.CreatedByUserId,
		   	      JOS.[TimeStamp],
				  (CASE WHEN JOS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM JobOpeningStatus AS JOS		        
           WHERE JOS.CompanyId = @CompanyId
				AND (@Status IS NULL OR JOS.[Status] = @Status)
		        AND (@SearchText IS NULL OR (JOS.[Status] LIKE  @SearchText) OR (JOS.[Order] LIKE  @SearchText))
		   	    AND (@JobOpeningStatusId IS NULL OR JOS.Id = @JobOpeningStatusId)
				AND (((@IsArchived IS NULL OR @IsArchived = 0) AND JOS.InActiveDateTime IS NULL)
				     OR (@IsArchived = 1 AND JOS.InActiveDateTime IS NOT NULL))	
           ORDER BY 
				CASE WHEN @SortDirection = 'ASC' THEN
					CASE WHEN @SortBy = 'order' THEN CAST(JOS.[Order] AS SQL_VARIANT)
							WHEN @SortBy = 'status' THEN CAST(JOS.[Status] AS SQL_VARIANT)
				END
				END ASC,
				CASE WHEN @SortDirection = 'DESC' THEN
					CASE WHEN @SortBy = 'order' THEN CAST(JOS.[Order] AS SQL_VARIANT)
							WHEN @SortBy = 'status' THEN CAST(JOS.[Status] AS SQL_VARIANT)
					END
				END DESC

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