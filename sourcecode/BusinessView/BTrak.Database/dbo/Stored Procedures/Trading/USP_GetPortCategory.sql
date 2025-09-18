CREATE PROCEDURE [dbo].[USP_GetPortCategory]
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
       	   
           SELECT PC.Id,
		   	      PC.CompanyId,
				  PC.[Name],	
		   	      PC.InActiveDateTime,
		   	      PC.CreatedDateTime,
		   	      PC.CreatedByUserId,
		   	      PC.[TimeStamp],
				  (CASE WHEN PC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(*) OVER()
           FROM [dbo].[PortCategory] AS PC
           WHERE PC.CompanyId = @CompanyId
		        AND (@SearchText   IS NULL OR (PC.[Name] LIKE  '%'+ @SearchText +'%'  ))				
		   	    AND (@Id IS NULL OR PC.Id = @Id)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND PC.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PC.InActiveDateTime IS NULL))
		   	    
           ORDER BY PC.[Name] ASC

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