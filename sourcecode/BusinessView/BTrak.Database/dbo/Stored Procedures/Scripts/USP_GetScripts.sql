CREATE PROCEDURE [dbo].[USP_GetScripts]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@Name NVARCHAR(250) = NULL,
	@IsLatest BIT = NULL,
	@Version NVARCHAR(250) = NULL,
	@ScriptId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@ScriptId = '00000000-0000-0000-0000-000000000000') SET @ScriptId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT S.Id AS ScriptId,
		   	      S.CompanyId,
				  S.[Name] AS ScriptName,
				  S.[Version],
				  S.[Description],			
		   	      S.[Url] AS ScriptUrl,
		   	      S.CreatedDateTime ,
		   	      S.CreatedByUserId,
				  U.FirstName +' '+ U.Surname AS CreatedByUserName
           FROM [Scripts] AS S	
		   JOIN [User] U ON U.Id = S.CreatedByUserId AND U.CompanyId = @CompanyId	     
           WHERE S.CompanyId = @CompanyId
		   	    AND (@ScriptId IS NULL OR S.Id = @ScriptId)
				AND (@Name IS NULL OR S.[Name] = @Name)
				AND (@Version IS NULL OR S.[Version] = @Version)
				AND (@IsLatest IS NULL OR S.IsLatest = @IsLatest)
           ORDER BY S.[Name] ASC

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