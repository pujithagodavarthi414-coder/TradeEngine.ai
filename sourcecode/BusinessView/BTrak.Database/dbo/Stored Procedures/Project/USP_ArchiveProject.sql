-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-23 00:00:00.000'
-- Purpose      To Archive Project
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_ArchiveProject] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ProjectId ='53C96173-0651-48BD-88A9-7FC79E836CCE',@IsArchive=1
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ArchiveProject]
(
  @ProjectId  UNIQUEIDENTIFIER = NULL,
  @IsArchive  BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
       SET NOCOUNT ON
	   BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF (@HavePermission = '1')
          BEGIN

		          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		          DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

				  EXEC [USP_InsertProjectAuditHistory] @ProjectId = @ProjectId,
				                                       @IsArchived = @IsArchive,
                                                       @OperationsPerformedBy = @OperationsPerformedBy
	              
				       IF(@IsArchive = 1)
					   BEGIN
	                    UPDATE [dbo].[Project]
	                    SET InactiveDateTime = @Currentdate	
						,[UpdatedDateTime] = @Currentdate
							,[UpdatedByUserId] = @OperationsPerformedBy						
	                    WHERE Id = @ProjectId

						 UPDATE [dbo].[Channel]
	                    SET [IsDeleted]= @IsArchive,
						    [InActiveDateTime] = @Currentdate
							,[UpdatedDateTime] = @Currentdate
							,[UpdatedByUserId] = @OperationsPerformedBy					
	                    WHERE ProjectId = @ProjectId

						END
	                   ELSE
					   BEGIN
					    UPDATE [dbo].[Project]
	                    SET InactiveDateTime = NULL
						,[UpdatedDateTime] = @Currentdate
							,[UpdatedByUserId] = @OperationsPerformedBy							
	                    WHERE Id = @ProjectId
						END
	            SELECT Id FROM [dbo].[Project] where Id = @ProjectId

		  END
		  ELSE 
          BEGIN
          
             RAISERROR (@HavePermission,11, 1)
          
          END
		END TRY  
	    BEGIN CATCH 
		
		   EXEC USP_GetErrorInformation

	   END CATCH

END
GO
