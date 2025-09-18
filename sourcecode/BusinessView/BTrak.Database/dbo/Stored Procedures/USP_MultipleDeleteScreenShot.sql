-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-10-30 00:00:00.000'
-- Purpose      To Delete Multiple Screenshot which were captured by Activity Tracker By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_MultipleDeleteScreenShot] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@ScreenshotId = '<ListItems>
-- <ListRecords>
-- <ListItem>
-- <ListItemId>25FB6DBB-06EE-40CB-87BF-F82ABC444A62</ListItemId>
-- </ListItem>
-- </ListRecords>
-- </ListItems>',@Reason='1234'
CREATE PROCEDURE [dbo].[USP_MultipleDeleteScreenShot](
@ScreenshotId XML = NULL,
@Reason NVARCHAR(800) = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON
		BEGIN TRY
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF(@OperationsPerformedBy IS NULL)
			BEGIN

				RAISERROR(50011,11,2,'OperationsPerformedBy')

			END
			ELSE
			BEGIN
			  	
				DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
						 
				 IF (@HavePermission = '1')
				 BEGIN		
				 	 	
					DECLARE @ScreenshotIdList TABLE
					(

					 Id UNIQUEIDENTIFIER PRIMARY KEY

					)

					IF(@ScreenshotId IS NOT NULL)
					BEGIN
						INSERT INTO @ScreenshotIdList (Id)
						SELECT	x.value('ListItemId[1]','UNIQUEIDENTIFIER')
						FROM  @ScreenshotId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)
					END

					UPDATE ActivityScreenShot SET InActiveDateTime = GETDATE(),
												  UpdatedByUserId = @OperationsPerformedBy,
												  UpdatedDateTime = GETDATE(),
												  IsArchived = 1,
												  Reason = @Reason
												  WHERE Id IN (SELECT * FROM @ScreenshotIdList)

					SELECT 'DeletedSuccessfully'
				 END
				 ELSE
				 BEGIN
				   
				   		RAISERROR (@HavePermission,11, 1)
				 END
		    END
		END TRY		
		BEGIN CATCH
        
		    THROW

	    END CATCH
END
