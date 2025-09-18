  
CREATE PROCEDURE [dbo].[USP_GetColumnFormatTypesById]     
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
          WHERE ParentId = @ColumnFormatTypeId  ORDER BY ColumnFormatType ASC    
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