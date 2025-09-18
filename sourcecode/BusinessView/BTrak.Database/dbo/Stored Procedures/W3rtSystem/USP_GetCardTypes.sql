-------------------------------------------------------------------------------
-- Author       kandapu sushmitha 
-- Created      '2020-01-04 00:00:00.000'
-- Purpose      To Get cardtype 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetCardTypes]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetCardTypes]
(
  @CardTypeId UNIQUEIDENTIFIER = NULL,
  @CardTypeName NVARCHAR(250) = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @SearchText NVARCHAR(250) = NULL,
  @IsActive BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
    
	IF (@HavePermission = '1')
        BEGIN
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		  IF(@CardTypeId = '00000000-0000-0000-0000-000000000000') SET @CardTypeId = NULL
          
		  IF(@SearchText = '') SET @SearchText = NULL
          SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
            SELECT CT.Id AS CardTypeId,
                  CT.CardTypeName ,
                  CT.CreatedDateTime,
                  CT.CreatedByUserId,
                  CT.UpdatedDateTime,
                  CT.UpdatedByUserId,
                  CT.[Timestamp]
           FROM  [dbo].[CardType] CT WITH (NOLOCK)
           WHERE (@CardTypeId IS NULL OR CT.Id = @CardTypeId)
                 AND (@SearchText IS NULL OR CT.CardTypeName LIKE @SearchText)
                                 
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
