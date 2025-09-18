------------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-28 00:00:00.000'
-- Purpose      To Save or Update the LeaveType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertLeaveType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@LeaveTypeName='Test', @IsArchived = 1
----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertLeaveType]
(
  @LeaveTypeId UNIQUEIDENTIFIER = NULL,
  @LeaveTypeName NVARCHAR(800) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @LeaveShortName NVARCHAR(800) = NULL,
  @MasterLeaveTypeId UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL,
  @IsIncludeHolidays BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @LeaveTypeColor NVARCHAR(250) = NULL
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
				
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@LeaveTypeName = '') SET @LeaveTypeName = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		    
		    DECLARE @LeaveTypeIdCount INT = (SELECT COUNT(1) FROM LeaveType WHERE Id = @LeaveTypeId AND CompanyId = @CompanyId)
		    
		    DECLARE @LeaveTypeNameCount INT = (SELECT COUNT(1) FROM LeaveType WHERE LeaveTypeName = @LeaveTypeName AND CompanyId = @CompanyId AND (@LeaveTypeId IS NULL OR Id <> @LeaveTypeId) )
		    
			DECLARE @LeaveTypeShortNameCount INT = (SELECT COUNT(1) FROM LeaveType WHERE LeaveShortName = @LeaveShortName AND CompanyId = @CompanyId AND (@LeaveTypeId IS NULL OR Id <> @LeaveTypeId) )
		    
			DECLARE @LeavesCount INT = (SELECT COUNT(1) FROM LeaveApplication WHERE InActiveDateTime IS NULL AND LeaveTypeId = @LeaveTypeId)

			IF(@LeaveTypeName IS NULL)
			BEGIN
			   
			   RAISERROR(50011,16, 2, 'LeaveTypeName')

			END

			ELSE IF(@LeaveTypeIdCount = 0 AND @LeaveTypeId IS NOT NULL)
		    BEGIN
		    
		    	RAISERROR(50002,16, 1,'LeaveType')
		    
		    END
		    
		    ELSE IF(@LeaveTypeNameCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'LeaveType')
		    
		    END
			ELSE IF(@LeaveTypeShortNameCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'LeaveTypeShort')
		    
		    END
            ELSE IF (@MasterLeaveTypeId IS NULL)
			BEGIN

				RAISERROR(50011,16,1,'MasterLeaveType')

			END
			ELSE IF(@LeavesCount > 0 AND @IsArchived = 1)
			BEGIN

				RAISERROR('ThisLeaveTypeCanNotBeArchivedAsThereAreLeaves',11,1)

			END
		    ELSE
		    BEGIN
		        
				DECLARE @IsLatest BIT = (CASE WHEN @LeaveTypeId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM LeaveType WHERE Id = @LeaveTypeId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()

					IF (@LeaveTypeId IS NULL)
					BEGIN

					SET @LeaveTypeId = NEWID()
					INSERT INTO [dbo].[LeaveType](
			 		            Id,
			 		            LeaveTypeName,
								LeaveShortName,
								MasterLeaveTypeId,
			 		            CompanyId,
			 		            CreatedDateTime,
			 		            CreatedByUserId,
								[InActiveDateTime],
								[IsIncludeHolidays],
								[LeaveTypeColor]
			 					)
			 		     SELECT @LeaveTypeId,
			 		            @LeaveTypeName,
								@LeaveShortName,
								@MasterLeaveTypeId,
			 		            @CompanyId,
			 		            @Currentdate,
			 		            @OperationsPerformedBy,
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								@IsIncludeHolidays,
								@LeaveTypeColor

					   END
					   ELSE
					   BEGIN

					   UPDATE [dbo].[LeaveType]
							SET LeaveTypeName			 =		  @LeaveTypeName,
			 		            CompanyId				 =  	  @CompanyId,
								LeaveShortName           =        @LeaveShortName,
								MasterLeaveTypeId        =        @MasterLeaveTypeId,
			 		            UpdatedDateTime			 =  	  @Currentdate,
			 		            UpdatedByUserId			 =  	  @OperationsPerformedBy,
								[IsIncludeHolidays]      =        @IsIncludeHolidays,
								[LeaveTypeColor]        =        @LeaveTypeColor,
								[InActiveDateTime]		 =  	  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							WHERE Id = @LeaveTypeId

					END
					SELECT Id FROM [dbo].[LeaveType] WHERE Id = @LeaveTypeId

				END	

				ELSE

			  		RAISERROR (50008,11, 1)
			 		
			END
	   
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