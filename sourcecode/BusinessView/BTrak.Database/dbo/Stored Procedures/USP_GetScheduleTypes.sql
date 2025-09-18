----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-10-15 00:00:00.000'
-- Purpose      To Get All Schedule Types by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC  [dbo].[USP_GetScheduleTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ScheduleTypeId = '20A81281-7070-4BAD-BC9A-82E09C015859'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetScheduleTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
    @ScheduleTypeId UNIQUEIDENTIFIER = NULL,  
    @SearchText NVARCHAR(250) = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

           IF(@SearchText   = '') SET @SearchText   = NULL

		   SET @SearchText = '%'+ @SearchText +'%';              
           IF(@ScheduleTypeId = '00000000-0000-0000-0000-000000000000') SET @ScheduleTypeId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT ST.OriginalId AS ScheduleTypeId,
                  ST.ScheduleType,   
                  ST.CreatedDateTime ,
                  ST.CreatedByUserId,
				  ST.InActiveDateTime,
                  ST.[TimeStamp],   
                  TotalCount = COUNT(1) OVER()
           FROM ScheduleType AS ST
           WHERE (ST.AsAtInactiveDateTime IS NULL)                   
                AND (@SearchText   IS NULL OR (ST.ScheduleType LIKE @SearchText ))                
                AND (@ScheduleTypeId IS NULL OR ST.OriginalId = @ScheduleTypeId)
                                
           ORDER BY ST.ScheduleType ASC
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