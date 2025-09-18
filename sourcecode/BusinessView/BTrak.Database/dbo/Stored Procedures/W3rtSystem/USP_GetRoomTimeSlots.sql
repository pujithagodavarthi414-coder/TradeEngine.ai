-------------------------------------------------------------------------------
-- Author       nikhitha yamsani 
-- Created      '2020-01-22 00:00:00.000'00
-- Purpose      To Get All Room TimeSlots 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetRoomTimeSlots]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' 

CREATE PROCEDURE [dbo].[USP_GetRoomTimeSlots]
(
  @Id UNIQUEIDENTIFIER = NULL,
  @RoomId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @IsActive BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
       
	  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
         
          
          IF(@Id = '00000000-0000-0000-0000-000000000000') SET @Id = NULL
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
          
		 SELECT T.Id AS Id,
				  T.RoomId,
                  LEFT(CAST(T.StartTime AS VARCHAR),5) AS StartTime,
				  LEFT(CAST(T.EndTime AS VARCHAR),5) AS EndTime,
				  T.[DayOfWeek] ,
				  CASE WHEN [DayOfWeek] LIke 'Sunday' THEN 1 
				   WHEN [DayOfWeek] LIke 'Monday' THEN 2 
				   WHEN [DayOfWeek] LIke 'tuesday' THEN 3 
				   WHEN [DayOfWeek] LIke 'wednesday' THEN 4 
				   WHEN [DayOfWeek] LIke 'thursday' THEN 5 
				   WHEN [DayOfWeek] LIke 'Friday' THEN 6 
				   WHEN [DayOfWeek] LIke 'Saturday' THEN 7 END DayOrder,
                  T.CreatedDateTime,
                  T.CreatedByUserId,
                  T.[Timestamp],
                  CASE WHEN T.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
           FROM  [dbo].[RoomTimeSlot] T WITH (NOLOCK)
           WHERE @Id IS NULL OR T.Id = @Id
		   ORDER BY DayOrder ASC
          
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