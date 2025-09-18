-----------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTimeSheetFrequencies]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971' , @SearchText = ''
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetTimeSheetFrequencies]
(
	@SearchText NVARCHAR(50) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
             IF(@SearchText = '' OR @SearchText = 'null') SET @SearchText = NULL
		   
		   SET @SearchText  = '%'+ @SearchText +'%'
		   
           SELECT Id AS TimeSheetFrequencyId,
				  [Name] TimeSheetFrequencyName
           FROM TimeSheetSubmissionType T		        
           WHERE 
		        (@SearchText IS NULL 
			        OR (T.[Name] LIKE @SearchText)
					OR (T.[Name] LIKE @SearchText))
                AND ID <> '71F414D2-36B9-4146-B8EB-DE0A59089BDB'
           ORDER BY T.CreatedDateTime ASC
 
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
 Go