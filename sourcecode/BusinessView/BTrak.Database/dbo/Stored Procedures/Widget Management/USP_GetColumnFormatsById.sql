
  --exec  [dbo].[USP_GetColumnFormatsById] 'c01993e5-5d51-4f82-9eed-3b130bd42b81' ,'c01993e5-5d51-4f82-9eed-3b130bd42b81'
  
Create PROCEDURE [dbo].[USP_GetColumnFormatsById]     
(    
@OperationsPerformedBy UNIQUEIDENTIFIER ,  
 @ColumnFormatTypeId UNIQUEIDENTIFIER = NULL  
)  
AS    
BEGIN    
    SET NOCOUNT ON    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    BEGIN TRY    
            DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))    
                
            IF (@HavePermission = '1')    
            BEGIN    
    
         SELECT Id AS ColumnFormatTypeId, ColumnFormatType,ParentId,ChildId FROM ColumnFormatType    
          WHERE Id = @ColumnFormatTypeId  
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