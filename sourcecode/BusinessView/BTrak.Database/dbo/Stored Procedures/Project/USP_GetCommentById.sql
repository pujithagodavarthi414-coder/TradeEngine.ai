-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To Get the Comments By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--   EXEC [dbo].[USP_GetCommentById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCommentById]
(
    @CommentId  UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy  UNIQUEIDENTIFIER 
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF(@CommentId = '00000000-0000-0000-0000-000000000000') SET @CommentId = NULL
	      
		  SELECT C.Id AS CommentId,
				 C.CommentedByUserId,
				 C.ReceiverId,
				 C.Comment,
                 C.CreatedDateTime,
                 C.CreatedByUserId,
                 C.UpdatedDateTime,
                 C.UpdatedByUserId,
				 C.ParentCommentId,
				 C.Adminflag,
				 C.CompanyId
		  FROM  [dbo].[Comment]C WITH (NOLOCK)
		  WHERE  (C.Id = @CommentId OR @CommentId IS NULL) AND C.CompanyId = @CompanyId
		        
	 END TRY  
	 BEGIN CATCH 
		
		 EXEC USP_GetErrorInformation
		
	END CATCH
END

