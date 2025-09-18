
-------------------------------------------------------------------------------
-- Author       K Surya
-- Created      '2020-01-27 00:00:00.000'
-- Purpose      To Save or Update ResignationStatus
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertResignationStatus] @ResignationStatusId= 'a1e3c1fc-e6d0-459b-a0b3-3b6438933c72',@StatusName='Active 1' , @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308' 			  
---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertResignationStatus]
(
   @ResignationStatusId UNIQUEIDENTIFIER = NULL,
   @StatusName NVARCHAR(250) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@StatusName IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'StatusName')

		END
		ELSE
		BEGIN


		DECLARE @ResignationStatusIdCount INT = (SELECT COUNT(1) FROM ResignationStatus  WHERE Id = @ResignationStatusId)

		DECLARE @ResignationStatusCount INT = (SELECT COUNT(1) FROM ResignationStatus WHERE [StatusName] = @StatusName AND (@ResignationStatusId IS NULL OR @ResignationStatusId <> Id))
       
	    IF(@ResignationStatusIdCount = 0 AND @ResignationStatusId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'ResignationStatus')

        END
		IF (@ResignationStatusCount > 0)
		BEGIN
			print ('error1')
			RAISERROR(50001,11,1,'ResignationStatus')

		END
        ELSE        
		  BEGIN
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @ResignationStatusId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                           FROM [ResignationStatus] WHERE Id = @ResignationStatusId) = @TimeStamp
			         									THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@ResignationStatusId IS NULL)
							BEGIN

							SET @ResignationStatusId = NEWID()

							INSERT INTO [dbo].[ResignationStatus](
                                                              [Id],
						                                      [StatusName],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @ResignationStatusId,
						                                      @StatusName,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [ResignationStatus]
							      SET [StatusName] = @StatusName,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @ResignationStatusId
							END
			              SELECT Id FROM [dbo].[ResignationStatus] WHERE Id = @ResignationStatusId
			                       
			           END
			           ELSE
			           	RAISERROR (50008,11, 1)
			         
			         END
			         ELSE
			         BEGIN
			         		RAISERROR (@HavePermission,11, 1)
			         END
           END
		END
		
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO