CREATE PROCEDURE [dbo].[USP_GetConsignerList]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@Id UNIQUEIDENTIFIER = NULL,	
	@SearchText    NVARCHAR(250) = NULL,
	@UserId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT= NULL	
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText   = '') SET @SearchText   = NULL
		   
		   IF(@Id = '00000000-0000-0000-0000-000000000000') SET @Id = NULL		
		   
		   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000' OR @OperationsPerformedBy IS NULL) SET @OperationsPerformedBy = @UserId		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT C.Id,
		   	      C.CompanyId,
				  C.[Name],	
		   	      C.InActiveDateTime,
		   	      C.CreatedDateTime,
		   	      C.CreatedByUserId,
		   	      C.[TimeStamp],
				  (CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(*) OVER()
           FROM [Consigner] AS C		        
           WHERE C.CompanyId = @CompanyId
		        AND (@SearchText   IS NULL OR (C.[Name] LIKE  '%'+ @SearchText +'%'  ))				
		   	    AND (@Id IS NULL OR C.Id = @Id)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))
		   	    
           ORDER BY C.[Name] ASC

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