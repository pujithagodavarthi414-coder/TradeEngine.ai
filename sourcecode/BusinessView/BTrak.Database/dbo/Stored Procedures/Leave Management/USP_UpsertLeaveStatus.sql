-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To Save or update leave status
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------------------
--EXEC USP_UpsertLeaveStatus @LeaveStatusName = 'Test',@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertLeaveStatus
(
 @LeaveStatusId UNIQUEIDENTIFIER = NULL,
 @LeaveStatusName  NVARCHAR(800) = NULL,
 @IsArchived BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @LeaveStatusColour NVARCHAR(50) = NULL
)
AS
BEGIN
   
      SET NOCOUNT ON
	  BEGIN TRY 
	  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		IF(@LeaveStatusName  = '') SET @LeaveStatusName  = NULL
		
		IF(@LeaveStatusId = '00000000-0000-0000-0000-000000000000') SET @LeaveStatusId = NULL    

		IF (@LeaveStatusName  IS NULL)
		BEGIN
		   
		   RAISERROR(50011,16,2,'LeaveStatusName')

		END
		ELSE
		BEGIN

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
       
        IF (@HavePermission = '1')
        BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @LeaveStatusIdCount INT = (SELECT COUNT(1) FROM LeaveStatus WHERE Id = @LeaveStatusId AND CompanyId = @CompanyId) 

		   DECLARE @LeaveStatusNameCount INT = (SELECT COUNT(1) FROM  LeaveStatus WHERE LeaveStatusName = @LeaveStatusName AND (@LeaveStatusId IS NULL OR Id <> @LeaveStatusId ) AND CompanyId = @CompanyId) 

		   IF(@LeaveStatusIdCount = 0 AND @LeaveStatusId IS NOT NULL)
		   BEGIN
		    
			  RAISERROR(50002,16,1,'LeaveStatus')

		   END
		   ELSE IF(@LeaveStatusNameCount > 0)
		   BEGIN

		      RAISERROR(50001,16,1,'LeaveStatus')

		   END
		   ELSE
		   BEGIN

		     DECLARE @IsLatest BIT = (CASE WHEN @LeaveStatusId IS NULL THEN 1 ELSE 
			                          CASE WHEN (SELECT [TimeStamp] FROM LeaveStatus WHERE Id = @LeaveStatusId) = @TimeStamp THEN 1 ELSE 0 END END )

		   IF (@IsLatest = 1)
		   BEGIN
		     
			 DECLARE @CurrentDate DATETIME = GETDATE()

			 IF(@LeaveStatusId IS NULL)
			 BEGIN

			 SET @LeaveStatusId = NEWID()
			 INSERT INTO LeaveStatus( Id,
	                                  CompanyId,
	                                  LeaveStatusName,
	                                  CreatedDateTime,
	                                  CreatedByUserId,
                                      InActiveDateTime,
									  LeaveStatusColour
						            )
						      SELECT @LeaveStatusId,
						             @CompanyId,
						    		 @LeaveStatusName ,
						    		 @CurrentDate,
						    		 @OperationsPerformedBy,
						    		 CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
									 @LeaveStatusColour

			END
			ELSE
			BEGIN

			UPDATE LeaveStatus
								SET   CompanyId					=  			  @CompanyId,
	                                  LeaveStatusName			=  			  @LeaveStatusName ,
	                                  UpdatedDateTime			=  			  @CurrentDate,
	                                  UpdatedByUserId			=  			  @OperationsPerformedBy,
                                      InActiveDateTime			=  			  CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
									  IsApproved				=  			  IsApproved,
									  IsRejected				=  			  IsRejected,
									  IsWaitingForApproval		=  			  IsWaitingForApproval,
									  LeaveStatusColour			=			  ISNULL(@LeaveStatusColour,LeaveStatusColour)
									WHERE ID = @LeaveStatusId

				END
				SELECT Id FROM LeaveStatus WHERE Id = @LeaveStatusId

			END
			ELSE
			   
			   RAISERROR(50008,16,1)

		   END
		    
		   END

		   ELSE
		     RAISERROR(@HavePermission,11,1)

		   END

	  END TRY

	BEGIN CATCH
	   THROW
	END CATCH
END 
GO

