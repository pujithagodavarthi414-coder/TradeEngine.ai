CREATE PROCEDURE [dbo].[USP_GetMasterQuestionTypes]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @MasterQuestionTypeId UNIQUEIDENTIFIER = NULL,
   @SearchText NVARCHAR(250) = NULL
 )
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

           IF(@SearchText = '') SET @SearchText = NULL

		   SELECT MQT.Id AS MasterQuestionTypeId,
                  MQT.MasterQuestionTypeName
		   FROM MasterQuestionType MQT 
           WHERE (@SearchText IS NULL OR MQT.MasterQuestionTypeName LIKE '%'+ @SearchText +'%')
		   ORDER BY MasterQuestionTypeName ASC
       	   
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
