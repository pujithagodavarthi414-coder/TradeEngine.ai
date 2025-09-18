-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To Save or update the Comments
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertComment] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@CommentedByUserId='127133F1-4427-4149-9DD6-B02E0E036971',@Comment='Test'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertComment]
(
    @CommentId UNIQUEIDENTIFIER = NULL,
	@CommentedByUserId UNIQUEIDENTIFIER = NULL,
	@ReceiverId UNIQUEIDENTIFIER = NULL,
	@AdminFlag BIT = NULL,
	@Comment NVARCHAR(MAX) = NULL,
	@ParentCommentId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeZone NVARCHAR(250) = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
        IF (@HavePermission = '1')
        BEGIN

		 DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
					  
		SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
        DECLARE @Currentdate DATETIMEOFFSET =   dbo.Ufn_GetCurrentTime(@Offset)  
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF (@CommentId IS NOT NULL)
		BEGIN

		      UPDATE [dbo].[Comment]
		      SET [CommentedByUserId]= @CommentedByUserId,
			      [ReceiverId]= @ReceiverId,
			      [Comment]= @Comment,
			      [ParentCommentId] = @ParentCommentId,
			      [Adminflag] = @AdminFlag,
			      [CompanyId]= @CompanyId,
				  [UpdatedDateTime] = @Currentdate,
				  [UpdatedByUserId] = @OperationsPerformedBy
		      WHERE Id = @CommentId

		END
		ELSE
		BEGIN

			   SELECT @CommentId = NEWID()

		       INSERT INTO [dbo].[Comment](
			               [Id],
			   			   [CommentedByUserId],
			   			   [ReceiverId],
			   			   [Comment],
			   			   [ParentCommentId],
			   			   [Adminflag],
			   			   [CompanyId],
			   			   [CreatedDateTime],
			   			   [CreatedByUserId],
						   [CreatedDateTimeZoneId])
			        SELECT @CommentId,
			   			   @CommentedByUserId,
			   			   @ReceiverId,
			   			   @Comment,
			   			   @ParentCommentId,
			   			   @AdminFlag,
			   			   @CompanyId,
			   			   @Currentdate,
			   			   @OperationsPerformedBy,
						   @TimeZoneId
			
		END
		
		SELECT Id FROM [dbo].[Comment] WHERE Id = @CommentId

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
