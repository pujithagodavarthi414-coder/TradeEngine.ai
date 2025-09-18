-------------------------------------------------------------------------------
-- Author       kandapu sushmitha 
-- Created      '2020-01-06 00:00:00.000'00
-- Purpose      To Get All TimeSlots 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetAllTimeSlots]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' 
CREATE PROCEDURE [dbo].[USP_GetAllTimeSlots]
(
  @TimeSlotId UNIQUEIDENTIFIER = NULL,
  @TimeSlot Time = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
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
         
          
          IF(@TimeSlotId = '00000000-0000-0000-0000-000000000000') SET @TimeSlotId = NULL
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
          
		 SELECT T.Id AS TimeSlotId,
                  T.FromTime  ,
				  T.ToTime ,
                  T.CreatedDateTime,
                  T.CreatedByUserId,
                  T.[Timestamp],
                  CASE WHEN T.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM  [dbo].[TimeSlot] T WITH (NOLOCK)
           WHERE @TimeSlotId IS NULL OR T.Id = @TimeSlotId
          
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
